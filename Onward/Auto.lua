-- Auto accept / turn-in. Accepts only what the active guide asks for (unless autoAcceptAll),
-- turns in any finished quest, never picks between rewards. Hold Shift at the NPC to pause.
local _, W = ...
local A = {}
W.Auto = A

local wanted = {}   -- questIDs the active guide accepts

W:On("WF_GUIDE_CHANGED", function(_, guide)
    wipe(wanted)
    if not guide then return end
    for _, s in ipairs(guide.steps) do
        if s.verb == "accept" then wanted[s.quest] = true end
    end
end)

local function paused() return IsShiftKeyDown() end

local function wantAccept(q)
    if not W.db.autoAccept or paused() or not q or q == 0 then return false end
    return W.db.autoAcceptAll or wanted[q] or false
end

local function wantTurnIn()
    return W.db.autoTurnIn and not paused()
end

W:On("QUEST_DETAIL", function()
    local q = GetQuestID()
    if wantAccept(q) then AcceptQuest() end
end)

W:On("QUEST_PROGRESS", function()
    if wantTurnIn() and IsQuestCompletable() then CompleteQuest() end
end)

W:On("QUEST_COMPLETE", function()
    if not wantTurnIn() then return end
    local choices = GetNumQuestChoices() or 0
    if choices <= 1 then
        GetQuestReward(1)
    else
        W.Print("pick a reward to finish this quest")
    end
end)

-- Modern gossip window (most NPCs)
W:On("GOSSIP_SHOW", function()
    if paused() then return end
    if W.db.autoTurnIn then
        for _, info in ipairs(C_GossipInfo.GetActiveQuests() or {}) do
            if info.isComplete and info.questID then
                C_GossipInfo.SelectActiveQuest(info.questID)
                return
            end
        end
    end
    for _, info in ipairs(C_GossipInfo.GetAvailableQuests() or {}) do
        if wantAccept(info.questID) then
            C_GossipInfo.SelectAvailableQuest(info.questID)
            return
        end
    end
end)

-- Old-style quest greeting (NPCs that offer several quests without gossip)
W:On("QUEST_GREETING", function()
    if paused() then return end
    if W.db.autoTurnIn then
        for i = 1, (GetNumActiveQuests() or 0) do
            local _, isComplete = GetActiveTitle(i)
            if isComplete then SelectActiveQuest(i) return end
        end
    end
    for i = 1, (GetNumAvailableQuests() or 0) do
        local q = GetAvailableQuestInfo and select(5, GetAvailableQuestInfo(i))
        if wantAccept(q) then SelectAvailableQuest(i) return end
    end
end)
