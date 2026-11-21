-- Quest state: one cached snapshot of the quest log, rebuilt only when the log changes.
-- Every other module reads from here instead of calling C_QuestLog in a loop.
local _, W = ...
local QS = {}
W.QuestState = QS

local log = {}        -- [questID] = { title, ready, objectives = { {text, finished, have, need} } }
local order = {}      -- questIDs in quest-log order
local dirty = true

local function rebuild()
    wipe(log)
    wipe(order)
    local n = C_QuestLog.GetNumQuestLogEntries() or 0
    for i = 1, n do
        local info = C_QuestLog.GetInfo(i)
        if info and not info.isHeader and not info.isHidden and info.questID and info.questID > 0 then
            local q = info.questID
            local objs = {}
            local raw = C_QuestLog.GetQuestObjectives(q)
            if raw then
                for k, o in ipairs(raw) do
                    objs[k] = { text = o.text, finished = o.finished, have = o.numFulfilled, need = o.numRequired, type = o.type }
                end
            end
            local ready = (C_QuestLog.ReadyForTurnIn and C_QuestLog.ReadyForTurnIn(q)) or C_QuestLog.IsComplete(q) or false
            log[q] = { title = info.title, level = info.level, ready = ready, objectives = objs, failed = C_QuestLog.IsFailed and C_QuestLog.IsFailed(q) }
            order[#order + 1] = q
        end
    end
    dirty = false
end

local function ensure()
    if dirty then rebuild() end
end

function QS:Invalidate() dirty = true end

function QS:IsDone(q)
    return C_QuestLog.IsQuestFlaggedCompleted(q) and true or false
end

function QS:IsOnQuest(q)
    ensure()
    return log[q] ~= nil
end

function QS:IsReady(q)
    ensure()
    local e = log[q]
    return e and e.ready or false
end

function QS:IsFailed(q)
    ensure()
    local e = log[q]
    return e and e.failed or false
end

function QS:Objective(q, idx)
    ensure()
    local e = log[q]
    return e and e.objectives[idx]
end

-- Match an objective by name substring (case-insensitive), immune to Questie vs Blizzard index order
function QS:ObjectiveByName(q, name)
    if not name or name == "" then return end
    ensure()
    local e = log[q]
    if not (e and e.objectives) then return end
    local needle = name:lower()
    for _, o in ipairs(e.objectives) do
        if o.text and o.text:lower():find(needle, 1, true) then return o end
    end
end

function QS:Get(q)
    ensure()
    return log[q]
end

function QS:Order()
    ensure()
    return order
end

-- The quest's own description from your quest log (the story text, which often says where to
-- go), or nil when it isn't in your log. Selecting a quest is how the API hands it over, so the
-- previous selection is put back. Cached per quest.
local descCache, objTextCache = {}, {}
function QS:Description(q)
    if descCache[q] then return descCache[q] end
    if not (C_QuestLog.GetLogIndexForQuestID and C_QuestLog.SetSelectedQuest and GetQuestLogQuestText) then return end
    local idx = C_QuestLog.GetLogIndexForQuestID(q)
    if not idx then return end
    local prev = C_QuestLog.GetSelectedQuest and C_QuestLog.GetSelectedQuest()
    local ok, desc = pcall(function()
        C_QuestLog.SetSelectedQuest(q)
        local d, o = GetQuestLogQuestText(idx)
        objTextCache[q] = W.Safe(o)
        return d
    end)
    if prev then pcall(C_QuestLog.SetSelectedQuest, prev) end
    desc = ok and W.Safe(desc) or nil
    if desc and desc ~= "" then descCache[q] = desc return desc end
end

-- the quest's short objective text ("Collect Wood Bundles ... then fletch them into 20 Spears.")
function QS:ObjectiveText(q)
    if objTextCache[q] == nil then QS:Description(q) end
    return objTextCache[q]
end

function QS:Title(q)
    ensure()
    if log[q] then return log[q].title end
    local t = C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(q)
    if t then return t end
    if C_QuestLog.RequestLoadQuestByID then C_QuestLog.RequestLoadQuestByID(q) end
    return W.QuestieBridge:QuestName(q)
end

---------------------------------------------------------------------------
-- Change detection -> WF_QUEST_STATE(questID, state) for party sync / UI.
-- states: "accepted", "progress", "ready", "turnedin", "removed"
---------------------------------------------------------------------------
local lastReady = {}
-- A quest is announced as finished only when we watched it go from unfinished to finished.
-- After a login or /reload nothing is remembered, so every finished quest already in your log
-- used to look freshly finished: each one was announced again (party toasts, and a "done" line
-- in party chat per quest). A quest first seen already finished is noted, not announced.
local seen = {}

local function snapshotReady()
    ensure()
    for q, e in pairs(log) do
        local known = seen[q]
        seen[q] = true
        if e.ready and not lastReady[q] then
            lastReady[q] = true
            if known then W:Fire("WF_QUEST_STATE", q, "ready") end
        elseif not e.ready and lastReady[q] then
            lastReady[q] = nil
        end
    end
end

W:On("QUEST_LOG_UPDATE", function()
    dirty = true
    W:RequestRefresh()
end)

W:On("UNIT_QUEST_LOG_CHANGED", function(_, unit)
    if unit == "player" then dirty = true W:RequestRefresh() end
end)

W:On("QUEST_ACCEPTED", function(_, a, b)
    dirty = true
    -- Modern clients fire (questID); Classic Era fires (questLogIndex, questID)
    local questID = (type(b) == "number" and b > 25) and b or a
    if questID then W:Fire("WF_QUEST_STATE", questID, "accepted") end
    W:RequestRefresh()
end)

W:On("QUEST_TURNED_IN", function(_, questID)
    dirty = true
    if questID then
        lastReady[questID] = nil
        W:Fire("WF_QUEST_STATE", questID, "turnedin")
    end
    W:RequestRefresh()
end)

W:On("QUEST_REMOVED", function(_, questID)
    dirty = true
    if questID and not C_QuestLog.IsQuestFlaggedCompleted(questID) then
        lastReady[questID] = nil
        seen[questID] = nil
        W:Fire("WF_QUEST_STATE", questID, "removed")
    end
    W:RequestRefresh()
end)

-- runs first on every refresh so later handlers see fresh data
W:On("WF_REFRESH", function()
    snapshotReady()
end)
