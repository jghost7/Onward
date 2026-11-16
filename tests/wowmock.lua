-- Minimal WoW API mock: enough of the client for Onward's files to load and run headless.
-- State lives in MOCK; tests drive it and fire events with MOCK.fire(event, ...).
MOCK = {
    now = 0, timers = {}, frames = {}, sent = {}, chat = {}, calls = {}, errors = {},
    log = {},          -- questID -> { title, objectives = {{text, finished, numFulfilled, numRequired}}, ready }
    logOrder = {},
    done = {},         -- questID -> true (turned in)
    pos = { map = 1423, x = 0.1, y = 0.1 },
    level = 35, shift = false, questId = 0, inGroup = false,
    party = {},        -- { {name=, class=} }
    waypoint = nil, supertrack = nil,
}

local function rec(name, ...) table.insert(MOCK.calls, { name, ... }) end

-- generic UI object: any unknown method is a no-op
local Obj = {}
Obj.__index = function(t, k)
    local v = rawget(Obj, k)
    if v then return v end
    return function() end
end
function Obj.new(kind) return setmetatable({ kind = kind, shown = true, scripts = {}, h = 0, text = "" }, Obj) end
function Obj:Show() self.shown = true if self.scripts.OnShow then self.scripts.OnShow(self) end end
function Obj:Hide() self.shown = false if self.scripts.OnHide then self.scripts.OnHide(self) end end
function Obj:SetShown(v) if v then self:Show() else self:Hide() end end
function Obj:IsShown() return self.shown end
function Obj:SetScript(k, fn) self.scripts[k] = fn end
function Obj:GetScript(k) return self.scripts[k] end
function Obj:RegisterEvent(e) MOCK.events = MOCK.events or {} MOCK.events[e] = MOCK.events[e] or {} table.insert(MOCK.events[e], self) end
function Obj:CreateTexture() return Obj.new("Texture") end
MOCK.strings = {}
function Obj:CreateFontString() local s = Obj.new("FontString") table.insert(MOCK.strings, s) return s end
function Obj:SetText(t) self.text = t or "" end
function Obj:SetTextColor(r, g, b) self.textColor = { r, g, b } end
function Obj:SetFont(path, size) self.font, self.fontSize = path, size end
function Obj:SetTexture(t) self.texture = t end
function Obj:GetText() return self.text end
function Obj:GetStringHeight() return 12 end
function Obj:GetStringWidth() return #(self.text or "") * 6 end
function Obj:SetHeight(h) self.h = h end
function Obj:GetHeight() return self.h end
function Obj:SetSize(w, h) self.w, self.h = w, h end
function Obj:GetPoint() return "CENTER", nil, "CENTER", 0, 0 end
function Obj:SetRotation(r) self.rotation = r end
function Obj:GetFrameLevel() return 1 end
function Obj:SetVertexColor(r, g, b) self.color = { r, g, b } end
function Obj:SetScript(k, fn) self.scripts[k] = fn end
function Obj:SetAttribute(k, v) local a = rawget(self, "attrs") or {} rawset(self, "attrs", a) a[k] = v end
function Obj:GetAttribute(k) local a = rawget(self, "attrs") return a and a[k] end
function Obj:GetRight() return 300 end
function Obj:GetTop() return 500 end
function Obj:GetEffectiveScale() return 1 end
function Obj:GetValue() return self.value or 0 end
function Obj:SetValue(v) self.value = v if self.scripts.OnValueChanged then self.scripts.OnValueChanged(self, v) end end

function CreateFrame(kind, name)
    local o = Obj.new(kind)
    if name then _G[name] = o end
    table.insert(MOCK.frames, o)
    return o
end
UIParent = Obj.new("Frame")
GameTooltip = Obj.new("GameTooltip")

function MOCK.fire(event, ...)
    for _, f in ipairs((MOCK.events or {})[event] or {}) do
        local h = f.scripts.OnEvent
        if h then h(f, event, ...) end
    end
end

-- timers
local function addTimer(delay, fn, interval)
    local t = { at = MOCK.now + delay, fn = fn, interval = interval }
    t.Cancel = function(self) self.cancelled = true end
    table.insert(MOCK.timers, t)
    return t
end
C_Timer = {
    After = function(d, fn) addTimer(d, fn) end,
    NewTimer = function(d, fn) return addTimer(d, fn) end,
    NewTicker = function(d, fn) return addTimer(d, fn, d) end,
}
function MOCK.advance(sec)
    local target = MOCK.now + (sec or 0)
    while true do
        table.sort(MOCK.timers, function(a, b) return a.at < b.at end)
        local t = MOCK.timers[1]
        if not t or t.at > target then break end
        table.remove(MOCK.timers, 1)
        MOCK.now = t.at
        if not t.cancelled then
            t.fn(t)
            if t.interval and not t.cancelled then t.at = MOCK.now + t.interval table.insert(MOCK.timers, t) end
        end
    end
    MOCK.now = target
end

-- quest log
function MOCK.addQuest(q, title, objectives)
    MOCK.log[q] = { title = title, objectives = objectives or { { text = "Thing 0/1", finished = false, numFulfilled = 0, numRequired = 1 } } }
    table.insert(MOCK.logOrder, q)
end
function MOCK.finish(q)
    for _, o in ipairs(MOCK.log[q].objectives) do o.finished = true o.numFulfilled = o.numRequired end
end
function MOCK.turnIn(q)
    MOCK.log[q] = nil
    for i, v in ipairs(MOCK.logOrder) do if v == q then table.remove(MOCK.logOrder, i) break end end
    MOCK.done[q] = true
end
local function ready(q)
    local e = MOCK.log[q]
    if not e then return false end
    for _, o in ipairs(e.objectives) do if not o.finished then return false end end
    return true
end
C_QuestLog = {
    GetNumQuestLogEntries = function() return #MOCK.logOrder end,
    GetInfo = function(i)
        local q = MOCK.logOrder[i]
        if not q then return end
        return { questID = q, title = MOCK.log[q].title, isHeader = false, isHidden = false, level = 35 }
    end,
    GetQuestObjectives = function(q) return MOCK.log[q] and MOCK.log[q].objectives end,
    ReadyForTurnIn = ready,
    IsComplete = ready,
    IsFailed = function() return false end,
    IsOnQuest = function(q) return MOCK.log[q] ~= nil end,
    IsQuestFlaggedCompleted = function(q) return MOCK.done[q] or false end,
    GetTitleForQuestID = function(q) return MOCK.log[q] and MOCK.log[q].title end,
    RequestLoadQuestByID = function() end,
    GetDistanceSqToQuest = function(q) return q * 10 end,
}
C_GossipInfo = {
    GetActiveQuests = function() return MOCK.gossipActive or {} end,
    GetAvailableQuests = function() return MOCK.gossipAvailable or {} end,
    SelectActiveQuest = function(q) rec("SelectActiveQuest", q) end,
    SelectAvailableQuest = function(q) rec("SelectAvailableQuest", q) end,
}
C_Map = {
    GetBestMapForUnit = function() return MOCK.bestMap or MOCK.pos.map end,
    GetPlayerMapPosition = function(map) if map == MOCK.pos.map then return { x = MOCK.pos.x, y = MOCK.pos.y } end end,
    GetMapWorldSize = function() return 1000, 1000 end,
    CanSetUserWaypointOnMap = function() return true end,
    SetUserWaypoint = function(p) MOCK.waypoint = p end,
    ClearUserWaypoint = function() MOCK.waypoint = nil end,
}
UiMapPoint = { CreateFromCoordinates = function(m, x, y) return { map = m, x = x, y = y } end }
function CreateVector2D(x, y) return { x = x, y = y } end
-- every mock map is 1000x1000 yd on continent 1; map 1424 sits directly east of 1423 (offset 1000 yd)
MOCK.mapOffset = { [1423] = 0, [1424] = 1000, [1415] = 0 }
-- world: x grows north (map y down), y grows west (map x right)
C_Map.GetWorldPosFromMapPos = function(map, v)
    local off = MOCK.mapOffset[map]
    if not off then return nil end
    return 1, { x = (1 - v.y) * 1000, y = (1 - v.x) * 1000 - off }
end
C_Map.GetMapInfo = function(m) return { name = "Map" .. m, parentMapID = (MOCK.parents or {})[m] } end
-- inverse of GetWorldPosFromMapPos; overrideMap picks the map to express it on
C_Map.GetMapPosFromWorldPos = function(cont, v, overrideMap)
    local off = MOCK.mapOffset[overrideMap]
    if not off then return nil end
    return overrideMap, { x = 1 - (v.y + off) / 1000, y = 1 - v.x / 1000 }
end
MOCK.facing = 0
function GetPlayerFacing() return MOCK.facing end
function GetUnitSpeed() return 7 end
function UnitOnTaxi() return MOCK.onTaxi or false end
Enum = { FlightPathState = { Current = 0, Reachable = 1, Unreachable = 2 } }
MOCK.taxi = {}   -- { {name, position={x,y} (map 1415 = same frame as 1423), state, slotIndex} }
C_TaxiMap = {
    GetTaxiNodesForMap = function() return MOCK.taxi end,
    GetAllTaxiNodes = function() return MOCK.taxi end,
}
function GetTaxiMapID() return 1415 end
function TakeTaxiNode(i) table.insert(MOCK.calls, { "TakeTaxiNode", i }) end
ERR_NEWTAXIPATH = "New flight path discovered!"
C_SuperTrack = {
    SetSuperTrackedUserWaypoint = function() end,
    SetSuperTrackedQuestID = function(q) MOCK.supertrack = q end,
}
C_ChatInfo = {
    RegisterAddonMessagePrefix = function() end,
    SendAddonMessage = function(p, m, ch) table.insert(MOCK.sent, { p, m, ch }) end,
    InChatMessagingLockdown = function() return MOCK.lockdown or false end,
    SendChatMessage = function(m, ch) table.insert(MOCK.chat, { m, ch }) end,
}
C_Texture = { GetAtlasInfo = function() return nil end }

-- unit / misc
-- loot window: MOCK.loot = { { link = "|Hitem:123|h[Name]|h" or nil, sources = { guid, qty, ... } }, ... }
function Obj:HookScript(k, fn)
    local old = self.scripts[k]
    self.scripts[k] = old and function(...) old(...) fn(...) end or fn
end
function Obj:GetWidth() return self.w or 0 end
function Obj:GetHeight() return self.h or 0 end
function hooksecurefunc(t, name, fn)
    local old = t[name]
    t[name] = function(...) local r = old and old(...) fn(...) return r end
end
-- world map: a 1000x1000 canvas showing map 1423
WorldMapFrame = Obj.new("Frame")
WorldMapFrame.shown = false
WorldMapFrame.ScrollContainer = Obj.new("Frame")
WorldMapFrame.ScrollContainer.Child = Obj.new("Frame")
WorldMapFrame.ScrollContainer.Child:SetSize(1000, 1000)
function WorldMapFrame.ScrollContainer:GetCanvasScale() return 1 end
function WorldMapFrame:GetMapID() return MOCK.mapShown or 1423 end
function WorldMapFrame:OnMapChanged() end

-- EllesmereUI's public skinning API: registration is kept so tests can run the callback
EllesmereUI = { RegisterSkin = function(name, fn) MOCK.euiSkin = { name = name, fn = fn } end }

MOCK.loot = {}
function GetNumLootItems() return #MOCK.loot end
function GetLootSlotLink(i) return MOCK.loot[i] and MOCK.loot[i].link end
function GetLootSourceInfo(i) return unpack(MOCK.loot[i] and MOCK.loot[i].sources or {}) end
-- units by token ("target", "nameplate3"): { name, guid, dead, tapDenied, threat, combat };
-- MOCK.targetGuid / MOCK.targetDead are shorthands for a target without an entry
MOCK.units = {}
local function U(u) return MOCK.units[u] end
function UnitGUID(u)
    if U(u) then return U(u).guid end
    if u == "target" then return MOCK.targetGuid end
end
function UnitIsDead(u)
    if U(u) then return U(u).dead or false end
    return MOCK.targetDead or false
end
function UnitIsTapDenied(u) return U(u) and U(u).tapDenied or false end
function UnitCanAttack(_, u) return U(u) ~= nil end
function UnitThreatSituation(_, u) return U(u) and U(u).threat end
function UnitAffectingCombat(u) if u == "player" then return MOCK.combat or false end return U(u) and U(u).combat or false end
function UnitIsUnit(a, b)
    local x, y = U(a), U(b)
    return x ~= nil and x == y
end
function MOCK.corpse(npc, n) return ("Creature-0-1-2-3-%d-%08X"):format(npc, n) end
function InCombatLockdown() return MOCK.combat or false end
function GetCVarBool() return false end
function UnitLevel() return MOCK.level end
function UnitFactionGroup() return "Alliance" end
function UnitClass(u) if u == "player" then return "Warrior", "WARRIOR" end local p = MOCK.party[tonumber(u:match("%d+") or 0)] return p and p.class, p and p.class end
function UnitRace() local r = MOCK.race or { "Human", "Human", 1 } return r[1], r[2], r[3] end
function UnitName(u)
    if u == "player" then return "Josh" end
    local i = u:match("^party(%d)")
    if i and MOCK.party[tonumber(i)] then return MOCK.party[tonumber(i)].name end
    if u == "npc" then return MOCK.npc end
    if MOCK.units[u] then return MOCK.units[u].name end
end
function UnitExists(u) return UnitName(u) ~= nil or (u == "target" and MOCK.targetGuid ~= nil) end
function IsInGroup() return MOCK.inGroup end
function IsInRaid() return false end
function GetNumGroupMembers() return MOCK.inGroup and (#MOCK.party + 1) or 0 end
function GetNormalizedRealmName() return "Realm" end
function Ambiguate(n) return (n:gsub("%-.*$", "")) end
function IsShiftKeyDown() return MOCK.shift end
function GetQuestID() return MOCK.questId end
function AcceptQuest() rec("AcceptQuest", MOCK.questId) end
function IsQuestCompletable() return true end
function CompleteQuest() rec("CompleteQuest") end
function GetNumQuestChoices() return MOCK.choices or 0 end
function GetQuestReward(i) rec("GetQuestReward", i) end
function GetRealZoneText() return "Riverglades" end
function GetZoneText() return "Riverglades" end
function ToggleWorldMap() end
function time() return 1700000000 + math.floor(MOCK.now) end
function GetTime() return MOCK.now end
function wipe(t) for k in pairs(t) do t[k] = nil end return t end
function strsplit(sep, s)
    local out = {}
    for piece in (s .. sep):gmatch("(.-)" .. sep:gsub("%p", "%%%0")) do out[#out + 1] = piece end
    return unpack(out)
end
function geterrorhandler() return function(e) table.insert(MOCK.errors, e) end end
-- professions: MOCK.profs = { {name, rank, max, skillLine} }, bags, trade skill window
MOCK.profs, MOCK.bags, MOCK.recipes, MOCK.tradeLine = {}, {}, {}, nil
function GetProfessions()
    local out = {}
    for i = 1, #MOCK.profs do out[i] = i end
    return unpack(out)
end
function GetProfessionInfo(i)
    local p = MOCK.profs[i]
    if p then return p[1], 0, p[2], p[3], 0, 0, p[4] end
end
C_Item = { GetItemCount = function(id) return MOCK.bags[id] or 0 end, GetItemNameByID = function() return nil end }
C_TradeSkillUI = {
    GetBaseProfessionInfo = function() return { professionID = MOCK.tradeLine } end,
    GetAllRecipeIDs = function() local ids = {} for id in pairs(MOCK.recipes) do ids[#ids + 1] = id end return ids end,
    GetRecipeInfo = function(id) local r = MOCK.recipes[id] if r then return { recipeID = id, name = r.name, learned = r.learned, relativeDifficulty = r.diff, numAvailable = r.avail or 0 } end end,
}
function IsPlayerSpell() return false end
SlashCmdList = {}
RAID_CLASS_COLORS = setmetatable({}, { __index = function() return { colorStr = "ffffffff" } end })
STANDARD_TEXT_FONT = "Fonts\\FRIZQT__.TTF"
MOCK.printed = {}
function print(...)
    local t = {}
    for i = 1, select("#", ...) do t[#t + 1] = tostring((select(i, ...))) end
    table.insert(MOCK.printed, table.concat(t, " "))
end
