-- Recorder: play a zone once with /sq rec start, and every accept, objective finish, turn-in and
-- level-up is written down as a guide step with map coordinates and the NPC you talked to.
-- /sq rec show opens the result as guide text ready to paste into Guides/<zone>.lua.
-- Recordings also persist in SloppyQuestingDB.recordings (WTF\Account\...\SavedVariables\SloppyQuesting.lua).
local _, W = ...
local R = {}
W.Recorder = R

local session          -- W.cdb.recording while active
local lastNpc          -- name of the NPC whose quest window was last open
local objDone = {}     -- [q..":"..i] = true, so each objective is recorded once
local seeded = false   -- false until the first pass has noted objectives finished before recording

local function pos()
    local map = C_Map.GetBestMapForUnit("player")
    if not map then return end
    local p = C_Map.GetPlayerMapPosition(map, "player")
    if not p then return map end
    return map, math.floor(p.x * 1000 + 0.5) / 10, math.floor(p.y * 1000 + 0.5) / 10
end

local function add(verb, q, extra)
    if not session then return end
    local map, x, y = pos()
    local e = { verb = verb, quest = q, map = map, x = x, y = y, t = time(), level = UnitLevel("player") }
    if extra then for k, v in pairs(extra) do e[k] = v end end
    table.insert(session.steps, e)
    W.Debug("rec", verb, q or "", map or "", x or "", y or "")
end

local function npcName()
    -- the quest/gossip target; may be a secret value on Midnight-era clients
    return W.Safe(UnitName("npc")) or W.Safe(UnitName("target"))
end

function R:Start(name)
    local zoneName = (GetRealZoneText and GetRealZoneText()) or "zone"
    W.cdb.recording = { name = (name ~= "" and name) or zoneName, started = time(), faction = UnitFactionGroup("player"),
        class = select(2, UnitClass("player")), steps = {} }
    session = W.cdb.recording
    wipe(objDone)
    seeded = false
    W:RequestRefresh()
    W.Print("recording", session.name, "- play normally; /sq rec stop when done")
end

function R:Stop()
    if not session then W.Print("not recording") return end
    SloppyQuestingDB.recordings = SloppyQuestingDB.recordings or {}
    table.insert(SloppyQuestingDB.recordings, session)
    W.Print(("saved %d steps for %s. /sq rec show to see the guide text"):format(#session.steps, session.name))
    W.cdb.recording = nil
    session = nil
end

-- Turn a recording into guide text.
function R:ToGuide(rec)
    local lines = {}
    local function L(s) lines[#lines + 1] = s end
    local id = rec.name:lower():gsub("[^%w]+", "-")
    L(("SloppyQuesting:RegisterGuide{"))
    L(("  id = %q, title = %q, faction = %q,"):format(id, rec.name, rec.faction or ""))
    L(("  levels = { %d, %d },"):format(rec.steps[1] and rec.steps[1].level or 1, rec.steps[#rec.steps] and rec.steps[#rec.steps].level or 60))
    L("  steps = [[")
    for _, e in ipairs(rec.steps) do
        local at = e.x and (" |at %d %.1f,%.1f"):format(e.map, e.x, e.y) or ""
        local npc = e.npc and (" |npc " .. e.npc) or ""
        local title = e.title and ("  -- " .. e.title) or ""
        if e.verb == "accept" or e.verb == "turnin" then
            L(("%s %d%s%s%s"):format(e.verb, e.quest, npc, at, title))
        elseif e.verb == "complete" then
            L(("complete %d%s%s%s"):format(e.quest, e.obj and (" " .. e.obj) or "", at, title))
        elseif e.verb == "level" then
            L(("level %d"):format(e.level))
        elseif e.verb == "fly" and e.x and e.from then
            L(("fly %d %.1f,%.1f |from %d %.1f,%.1f"):format(e.map, e.x, e.y, e.from[1], e.from[2], e.from[3]))
        elseif e.verb == "goto" then
            L(("goto %d %.1f,%.1f%s"):format(e.map, e.x, e.y, e.text and (" |note " .. e.text) or ""))
        end
    end
    L("]]}")
    return table.concat(lines, "\n")
end

function R:Command(arg)
    local cmd, rest = (arg or ""):match("^(%S*)%s*(.-)$")
    cmd = cmd:lower()
    if cmd == "start" then
        R:Start(rest)
    elseif cmd == "stop" then
        R:Stop()
    elseif cmd == "mark" then
        -- manual waypoint: /sq rec mark Take the boat
        add("goto", nil, { text = rest ~= "" and rest or nil })
        W.Print("marked")
    elseif cmd == "show" then
        local recs = SloppyQuestingDB.recordings
        local rec = session or (recs and recs[#recs])
        if not rec then W.Print("no recordings yet") return end
        W.UI.ShowText("Recorded guide: " .. rec.name, R:ToGuide(rec))
    else
        W.Print("/sq rec start [name] | stop | mark [note] | show")
    end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
W:On("WF_INIT", function()
    session = W.cdb.recording   -- resume after /reload
end)

for _, ev in ipairs({ "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE", "GOSSIP_SHOW", "QUEST_GREETING" }) do
    W:On(ev, function() if session then lastNpc = npcName() end end)
end

W:On("QUEST_ACCEPTED", function(_, q)
    if not session or not q then return end
    add("accept", q, { npc = lastNpc, title = C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(q) })
end)

W:On("QUEST_TURNED_IN", function(_, q)
    if not session or not q then return end
    add("turnin", q, { npc = lastNpc, title = C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(q) })
end)

-- objective completions: record where the last objective of each was finished
-- The first pass after start (or /reload) only notes what is already finished.
W:On("WF_REFRESH", function()
    if not session then seeded = false return end
    local QS = W.QuestState
    for _, q in ipairs(QS:Order()) do
        local e = QS:Get(q)
        for i, o in ipairs(e.objectives) do
            local k = q .. ":" .. i
            if o.finished and not objDone[k] then
                objDone[k] = true
                if not seeded then
                    -- already done before recording started
                elseif #e.objectives > 1 and not e.ready then
                    add("complete", q, { obj = i, title = e.title })
                elseif e.ready then
                    add("complete", q, { title = e.title })
                end
            end
        end
    end
    seeded = true
end)

-- flights: remember where you took off, write a fly step where you land
local flyFrom
W:On("PLAYER_CONTROL_LOST", function()
    if not session then return end
    C_Timer.After(0.5, function()
        if UnitOnTaxi("player") then
            local map, x, y = pos()
            if x then flyFrom = { map, x, y } end
        end
    end)
end)
W:On("PLAYER_CONTROL_GAINED", function()
    if session and flyFrom and not UnitOnTaxi("player") then
        add("fly", nil, { from = flyFrom })
        flyFrom = nil
    end
end)

W:On("PLAYER_LEVEL_UP", function(_, level)
    if session then add("level", nil, { level = level }) end
end)
