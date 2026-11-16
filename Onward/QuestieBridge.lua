-- Optional bridge to Questie (GPL-3.0). Everything here is guarded: if Questie is missing,
-- not ready yet, or changes its internals, each call returns nil and Onward falls back to
-- Blizzard's own quest POIs.
--
-- Uses: Questie.API (public), QuestieDB.GetQuest / GetNPC / QueryObjectSingle,
--       ZoneDB:GetUiMapIdByAreaId, QuestieComms.remoteQuestLogs (party progress).
local _, W = ...
local QB = {}
W.QuestieBridge = QB

local ready = false
local QDB, ZoneDB, Comms

local function import(name)
    local ok, mod = pcall(QuestieLoader.ImportModule, QuestieLoader, name)
    if ok then return mod end
end

local function setup()
    if not (Questie and Questie.API and QuestieLoader) then return end
    QDB, ZoneDB, Comms = import("QuestieDB"), import("ZoneDB"), import("QuestieComms")
    ready = true
    W.Debug("Questie bridge ready")
    W:RequestRefresh()
end

W:On("WF_INIT", function()
    if Questie and Questie.API and Questie.API.RegisterOnReady then
        Questie.API.RegisterOnReady(setup)
        -- Questie's own quest-update hook is a cheap extra trigger for refreshes.
        if Questie.API.RegisterForQuestUpdates then
            Questie.API.RegisterForQuestUpdates(function() W:RequestRefresh() end)
        end
    end
end)

function QB:IsReady() return ready end

local function call(fn, ...)
    if not ready then return nil end
    local ok, a, b, c, d = pcall(fn, ...)
    if ok then return a, b, c, d end
end

function QB:QuestName(q)
    return call(function()
        local quest = QDB.GetQuest(q)
        return quest and quest.name
    end)
end

-- Player position on the map they are looking at in the world.
local function playerPos()
    local map = C_Map.GetBestMapForUnit("player")
    if not map then return end
    local pos = C_Map.GetPlayerMapPosition(map, "player")
    if not pos then return map end
    return map, pos.x * 100, pos.y * 100
end

-- spawns = { [areaId] = { {x, y}, ... } } (0-100 coords). Pick the spawn on the player's
-- current map closest to them; otherwise the first spawn anywhere.
local function nearestSpawn(spawns)
    if type(spawns) ~= "table" then return end
    local pMap, px, py = playerPos()
    local best, bestD, fallback
    for areaId, list in pairs(spawns) do
        local uiMap = ZoneDB:GetUiMapIdByAreaId(areaId)
        if uiMap and type(list) == "table" then
            for _, c in ipairs(list) do
                if c[1] and c[1] >= 0 then
                    if not fallback then fallback = { uiMap, c[1], c[2] } end
                    if uiMap == pMap and px then
                        local d = (c[1] - px) ^ 2 + (c[2] - py) ^ 2
                        if not bestD or d < bestD then best, bestD = { uiMap, c[1], c[2] }, d end
                    end
                end
            end
        end
    end
    return best or fallback
end

local function locate(kind, ids)
    if type(ids) ~= "table" then return end
    for _, id in ipairs(ids) do
        if kind == "npc" then
            local npc = QDB:GetNPC(id)
            if npc then
                local p = nearestSpawn(npc.spawns)
                if p then return { map = p[1], x = p[2], y = p[3], name = npc.name } end
            end
        else
            local spawns = QDB.QueryObjectSingle(id, "spawns")
            local p = nearestSpawn(spawns)
            if p then return { map = p[1], x = p[2], y = p[3], name = QDB.QueryObjectSingle(id, "name") } end
        end
    end
end

-- Where to pick the quest up: { map, x, y, name } or nil
function QB:StartLocation(q)
    return call(function()
        local quest = QDB.GetQuest(q)
        if not quest or not quest.Starts then return end
        return locate("npc", quest.Starts.NPC) or locate("object", quest.Starts.GameObject)
    end)
end

-- Where to hand it in
function QB:EndLocation(q)
    return call(function()
        local quest = QDB.GetQuest(q)
        if not quest or not quest.Finisher then return end
        return locate("npc", quest.Finisher.NPC) or locate("object", quest.Finisher.GameObject)
    end)
end

function QB:QuestLevel(q)
    return call(function()
        local quest = QDB.GetQuest(q)
        return quest and quest.level, quest and quest.requiredLevel
    end)
end

-- Where a quest's unfinished objectives can be done: every spawn of the mobs to kill, the
-- objects to use, and the mobs / objects that drop its items, as { {map, x, y, name}, ... }
-- (capped). `done` = { [objectiveIndex] = true } skips finished objectives.
local MAX_SPOTS = 400
function QB:ObjectiveSpots(q, done)
    return call(function()
        local quest = QDB.GetQuest(q)
        if not quest or type(quest.ObjectiveData) ~= "table" then return end
        local out = {}
        local function add(spawns, name)
            if type(spawns) ~= "table" then return end
            for areaId, list in pairs(spawns) do
                local uiMap = ZoneDB:GetUiMapIdByAreaId(areaId)
                if uiMap and type(list) == "table" then
                    for _, c in ipairs(list) do
                        if #out >= MAX_SPOTS then return end
                        if c[1] and c[1] >= 0 then out[#out + 1] = { map = uiMap, x = c[1], y = c[2], name = name } end
                    end
                end
            end
        end
        local function npc(id)
            local n = QDB:GetNPC(id)
            if n then add(n.spawns, n.name) end
        end
        local function obj(id)
            add(QDB.QueryObjectSingle(id, "spawns"), QDB.QueryObjectSingle(id, "name"))
        end
        for i, o in ipairs(quest.ObjectiveData) do
            if not (done and done[i]) then
                if o.Type == "monster" and o.Id then npc(o.Id)
                elseif o.Type == "object" and o.Id then obj(o.Id)
                elseif o.Type == "item" and o.Id and QDB.QueryItemSingle then
                    for _, n in pairs(QDB.QueryItemSingle(o.Id, "npcDrops") or {}) do npc(n) end
                    for _, n in pairs(QDB.QueryItemSingle(o.Id, "objectDrops") or {}) do obj(n) end
                elseif o.Type == "killcredit" and type(o.IdList) == "table" then
                    for _, n in ipairs(o.IdList) do npc(n) end
                end
            end
        end
        return #out > 0 and out or nil
    end)
end

-- A quest's item objectives: { { id = itemId, name = itemName }, ... } or nil
function QB:ItemObjectives(q)
    return call(function()
        local quest = QDB.GetQuest(q)
        if not quest or type(quest.ObjectiveData) ~= "table" then return end
        local out = {}
        for _, o in ipairs(quest.ObjectiveData) do
            if o.Type == "item" and o.Id then
                local name = QDB.QueryItemSingle and QDB.QueryItemSingle(o.Id, "name")
                out[#out + 1] = { id = o.Id, name = name }
            end
        end
        return out
    end)
end

function QB:NpcName(npcId)
    return call(function()
        local npc = QDB:GetNPC(npcId)
        return npc and npc.name
    end)
end

-- NPC ids Questie lists as dropping an item: { [npcId] = true } or nil
function QB:ItemDropNpcs(itemId)
    return call(function()
        local list = QDB.QueryItemSingle and QDB.QueryItemSingle(itemId, "npcDrops")
        if type(list) ~= "table" then return end
        local set = {}
        for _, n in pairs(list) do set[n] = true end
        return set
    end)
end

-- Questie's drop chance for an item from one NPC: percent (0-100) and its source
-- ("wowhead", "cmangos", "mangos3" or "questie" for Questie's own corrections), or nil.
-- On Forever, Questie loads its Classic tables, so the Forever-only zones mostly have none.
function QB:DropRate(itemId, npcId)
    return call(function()
        local r = QDB.GetItemDroprate and QDB.GetItemDroprate(itemId, npcId)
        if type(r) == "table" and tonumber(r[1]) then return tonumber(r[1]), r[2] end
    end)
end

-- Party progress from Questie's own sync (works for every party member running Questie,
-- whether or not they have Onward). Returns { [playerName] = { done = bool, have = n, need = n } }
function QB:PartyProgress(q)
    return call(function()
        local logs = Comms and Comms.remoteQuestLogs and Comms.remoteQuestLogs[q]
        if not logs then return end
        local out = {}
        for name, objectives in pairs(logs) do
            local have, need, done = 0, 0, true
            for _, o in pairs(objectives) do
                have = have + (tonumber(o.fulfilled) or 0)
                need = need + (tonumber(o.required) or 0)
                if not o.finished then done = false end
            end
            out[name] = { done = done, have = have, need = need }
        end
        return out
    end)
end
