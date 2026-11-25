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

local function npcFriendly(npc)
    local ft = npc and npc.friendlyToFaction
    if type(ft) ~= "string" or ft == "" then return true end
    local f = W.PlayerFaction and W.PlayerFaction() or (UnitFactionGroup and UnitFactionGroup("player"))
    if not f or f == "" then return true end
    return ft:upper():find(f:sub(1, 1):upper(), 1, true) ~= nil
end
QB.NpcFriendly = npcFriendly

local function locate(kind, ids)
    if type(ids) ~= "table" then return end
    local fallback
    for _, id in ipairs(ids) do
        if kind == "npc" then
            local npc = QDB:GetNPC(id)
            if npc then
                local p = nearestSpawn(npc.spawns)
                if p then
                    local loc = { map = p[1], x = p[2], y = p[3], name = npc.name }
                    if npcFriendly(npc) then return loc end
                    if not fallback then fallback = loc end
                end
            end
        else
            local spawns = QDB.QueryObjectSingle(id, "spawns")
            local p = nearestSpawn(spawns)
            if p then return { map = p[1], x = p[2], y = p[3], name = QDB.QueryObjectSingle(id, "name") } end
        end
    end
    return fallback
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

-- Does any creature drop this item? true / false (only objects or vendors have it, e.g. a chest
-- on the sea floor), or nil when Questie isn't there or knows no source at all
function QB:ItemFromMobs(itemId)
    return call(function()
        if not QDB.QueryItemSingle then return end
        local npcs = QDB.QueryItemSingle(itemId, "npcDrops")
        if type(npcs) == "table" and next(npcs) then return true end
        local objs = QDB.QueryItemSingle(itemId, "objectDrops")
        local vendors = QDB.QueryItemSingle(itemId, "vendors")
        if (type(objs) == "table" and next(objs)) or (type(vendors) == "table" and next(vendors)) then return false end
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

-- Quest IDs Questie knows are linked to this item (startQuest + relatedQuests) for the player's
-- faction (or neutral), used as a live cross-check before offering an item for bag cleanup.
function QB:ItemRelatedQuests(itemId)
    return call(function()
        if not QDB.QueryItemSingle then return end
        local out, seen = {}, {}
        local fac = UnitFactionGroup and UnitFactionGroup("player")
        local bit = fac == "Horde" and 178 or 77
        local function add(q)
            if not q or q == 0 or seen[q] then return end
            seen[q] = true
            local quest = QDB.GetQuest(q)
            local races = quest and quest.requiredRaces
            -- include neutral quests and quests matching player's faction (conservative: unknown races included)
            if not races or races == 0 or bit32 == nil or bit32.band(races, bit) ~= 0 then
                out[#out + 1] = q
            end
        end
        add(QDB.QueryItemSingle(itemId, "startQuest"))
        for _, q in pairs(QDB.QueryItemSingle(itemId, "relatedQuests") or {}) do add(q) end
        return #out > 0 and out or nil
    end)
end

-- Count spawns for an NPC/object table (total and on a preferred uiMap) so the most common local
-- mobs/objects surface first in objective context hints and the target button.
local function countSpawns(spawns, preferMap)
    local total, here = 0, 0
    if type(spawns) ~= "table" then return 0, 0 end
    for areaId, list in pairs(spawns) do
        if type(list) == "table" then
            local n = #list
            total = total + n
            if preferMap and ZoneDB and ZoneDB:GetUiMapIdByAreaId(areaId) == preferMap then
                here = here + n
            end
        end
    end
    return here, total
end

local function rankedNames(ids, kind, preferMap)
    if type(ids) ~= "table" then return {} end
    local byName = {}
    for _, id in pairs(ids) do
        local name, spawns
        if kind == "npc" then
            local npc = QDB:GetNPC(id)
            name, spawns = npc and npc.name, npc and npc.spawns
        else
            name = QDB.QueryObjectSingle and QDB.QueryObjectSingle(id, "name")
            spawns = QDB.QueryObjectSingle and QDB.QueryObjectSingle(id, "spawns")
        end
        if type(name) == "string" and name ~= "" then
            local here, total = countSpawns(spawns, preferMap)
            local prev = byName[name]
            if not prev or here > prev.here or (here == prev.here and total > prev.total) then
                byName[name] = { name = name, here = here, total = total }
            end
        end
    end
    local rows = {}
    for _, r in pairs(byName) do rows[#rows + 1] = r end
    table.sort(rows, function(a, b)
        if a.here ~= b.here then return a.here > b.here end
        if a.total ~= b.total then return a.total > b.total end
        return a.name < b.name
    end)
    local out = {}
    for i, r in ipairs(rows) do out[i] = r.name end
    return out
end

-- Per-objective source info for a quest: { kind = "item"|"object"|"killcredit"|"monster",
-- label = string, mobs = {names}, objs = {names}, vendors = {names} }
local sourceCache, sourceCacheMap = {}, nil
local function questSources(q)
    local pMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    if pMap ~= sourceCacheMap then
        wipe(sourceCache)
        sourceCacheMap = pMap
    end
    local cached = sourceCache[q]
    if cached ~= nil then return cached or nil end
    local res = call(function()
        local quest = QDB.GetQuest(q)
        if not quest or type(quest.ObjectiveData) ~= "table" then return end
        local list = {}
        for idx, o in ipairs(quest.ObjectiveData) do
            if o.Type == "item" and o.Id and QDB.QueryItemSingle then
                local name = QDB.QueryItemSingle(o.Id, "name")
                local mobs = rankedNames(QDB.QueryItemSingle(o.Id, "npcDrops"), "npc", pMap)
                local objs = rankedNames(QDB.QueryItemSingle(o.Id, "objectDrops"), "object", pMap)
                local vendors = (#mobs == 0 and #objs == 0) and rankedNames(QDB.QueryItemSingle(o.Id, "vendors"), "npc", pMap) or {}
                list[#list + 1] = { idx = idx, kind = "item", label = name, mobs = mobs, objs = objs, vendors = vendors }
            elseif o.Type == "object" and o.Id then
                local name = QDB.QueryObjectSingle and QDB.QueryObjectSingle(o.Id, "name")
                list[#list + 1] = { idx = idx, kind = "object", label = o.Text or name, mobs = {}, objs = name and { name } or {}, vendors = {} }
            elseif o.Type == "killcredit" and type(o.IdList) == "table" then
                local mobs = rankedNames(o.IdList, "npc", pMap)
                list[#list + 1] = { idx = idx, kind = "killcredit", label = o.Text, mobs = mobs, objs = {}, vendors = {} }
            elseif o.Type == "monster" and o.Id then
                local npc = QDB:GetNPC(o.Id)
                local name = npc and npc.name
                list[#list + 1] = { idx = idx, kind = "monster", label = o.Text or name, mobs = name and { name } or {}, objs = {}, vendors = {} }
            end
        end
        return #list > 0 and list or nil
    end)
    sourceCache[q] = res or false
    return res
end

-- Match one quest log objective (by its clean name and optional WoW type) to its Questie source row.
function QB:ObjectiveSource(q, objName, objType)
    local list = questSources(q)
    if not list then return nil end
    local needle = objName and objName:lower() or ""
    if needle ~= "" then
        for _, row in ipairs(list) do
            if row.label and row.label:lower() == needle then return row end
        end
        for _, row in ipairs(list) do
            local l = row.label and row.label:lower()
            if l and (needle:find(l, 1, true) or l:find(needle, 1, true)) then return row end
        end
    end
    -- single-entry fallback when the objective kind matches unambiguously
    local match, count = nil, 0
    for _, row in ipairs(list) do
        local sameKind = (not objType)
            or (objType == "item" and row.kind == "item")
            or (objType == "object" and row.kind == "object")
            or (objType == "monster" and (row.kind == "monster" or row.kind == "killcredit"))
        if sameKind then match, count = row, count + 1 end
    end
    if count == 1 then return match end
end

-- Prioritized mob names to target for unfinished objectives of quest `q` (fallback when the guide
-- step has no |mobs tag, e.g. out-of-zone objectives or the smart quest-log guide).
function QB:QuestMobs(q, doneNames, limit)
    local list = questSources(q)
    if not list then return {} end
    limit = limit or 6
    local out, seen = {}, {}
    for _, row in ipairs(list) do
        local finished = row.label and doneNames and doneNames[row.label:lower()]
        if not finished and row.mobs then
            for _, name in ipairs(row.mobs) do
                if not seen[name] then
                    seen[name] = true
                    out[#out + 1] = name
                    if #out >= limit then return out end
                end
            end
        end
    end
    return out
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
