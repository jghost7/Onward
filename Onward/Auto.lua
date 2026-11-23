-- Auto accept / turn-in. Accepts only upcoming quests the active guide asks for (unless
-- autoAcceptAll), turns in any finished quest, never picks between rewards. Hold Shift to pause.
local _, W = ...
local A = {}
W.Auto = A

local ACCEPT_WINDOW = 15   -- only auto-accept quests within the next N active steps (not 100 steps ahead)
local RECENT_TTL = 1.5     -- seconds to ignore stale gossip/greeting rows for a quest we just accepted/turned in

local recentAccept = {}    -- [questID] = timestamp
local recentTurnIn = {}    -- [questID] = timestamp

local function now() return GetTime and GetTime() or 0 end
local function markRecent(tbl, q)
    if q and q > 0 then tbl[q] = now() end
end
local function isRecent(tbl, q)
    local t = q and tbl[q]
    if not t then return false end
    if now() - t > RECENT_TTL then
        tbl[q] = nil
        return false
    end
    return true
end

local function paused() return IsShiftKeyDown() end

local function followsRecentTurnIn(step)
    if step.pre then
        for _, p in ipairs(step.pre) do
            if isRecent(recentTurnIn, p) then return true end
        end
    end
    if step.preAny then
        for _, p in ipairs(step.preAny) do
            if isRecent(recentTurnIn, p) then return true end
        end
    end
    return false
end

local function wantAccept(q, skipRecent)
    if not W.db.autoAccept or paused() or not q or q == 0 then return false end
    if skipRecent and isRecent(recentAccept, q) then return false end
    if W.db.autoAcceptAll then return true end
    local G = W.Guide
    local g = G and G:Active()
    local a = g and g.acceptOf and g.acceptOf[q]
    if not a then return false end
    if G:IsSkipped(a) or G:IsLater(a) or G:IsComplete(a) then return false end
    local cur = G:Current()
    if G:IsBehind(a) and cur ~= a then return false end
    -- Immediate follow-up to a quest we just turned in: never wait on debounced WF_REFRESH or HeldReason
    if followsRecentTurnIn(a) then return true end
    local startIdx = (cur and cur.index) or 1
    -- Uncompleted, unskipped accept earlier than cursor (e.g. hub NPCs visited out of order)
    if a.index < startIdx then return true end
    -- Scan forward without filtering on HeldReason: the NPC is literally offering this quest right now
    local seen = 0
    for i = startIdx, #g.steps do
        local s = g.steps[i]
        if s == a then return true end
        if not (G:IsComplete(s) or G:IsSkipped(s) or G:IsLater(s) or G:IsBlocked(s)) then
            seen = seen + 1
            if seen >= ACCEPT_WINDOW then break end
        end
    end
    return false
end

local function findQuestByTitle(title)
    if not title or title == "" then return nil end
    local G, QS = W.Guide, W.QuestState
    local g = G and G:Active()
    if not (g and g.acceptOf and QS) then return nil end
    for q in pairs(g.acceptOf) do
        if QS:Title(q) == title then return q end
    end
end

local function wantTurnIn()
    return W.db.autoTurnIn and not paused()
end

W:On("QUEST_ACCEPTED", function(_, a, b)
    local q = (type(b) == "number") and b or a
    markRecent(recentAccept, q)
end)

W:On("QUEST_TURNED_IN", function(_, q)
    markRecent(recentTurnIn, q)
end)

W:On("QUEST_DETAIL", function()
    A:ClearRewardHighlight()
    local q = GetQuestID()
    if wantAccept(q) then
        markRecent(recentAccept, q)
        if QuestGetAutoAccept and QuestGetAutoAccept() and AcknowledgeAutoAcceptQuest then
            AcknowledgeAutoAcceptQuest()
        else
            AcceptQuest()
        end
    end
end)

W:On("QUEST_PROGRESS", function()
    A:ClearRewardHighlight()
    if wantTurnIn() and IsQuestCompletable() then CompleteQuest() end
end)

W:On("QUEST_COMPLETE", function()
    A:ScheduleRewardHighlight()
    if not wantTurnIn() then return end
    local choices = GetNumQuestChoices() or 0
    if choices <= 1 then
        local q = GetQuestID and GetQuestID()
        markRecent(recentTurnIn, q)
        GetQuestReward(1)
    else
        W.Print("pick a reward to finish this quest")
    end
end)

---------------------------------------------------------------------------
-- Multi-choice quest turn-in: highlight the reward with the highest vendor sell value
---------------------------------------------------------------------------
local S = W.Skin
local rewardHighlights = {}
local pendingRewardInfo = false

local function formatCopper(copper)
    local g = math.floor(copper / 10000)
    local s = math.floor((copper % 10000) / 100)
    local c = copper % 100
    local parts = {}
    if g > 0 then parts[#parts + 1] = ("|cffffd100%dg|r"):format(g) end
    if s > 0 or g > 0 then parts[#parts + 1] = ("|cffd0d4dc%ds|r"):format(s) end
    if g == 0 and (c > 0 or s == 0) then parts[#parts + 1] = ("|cffeda55f%dc|r"):format(c) end
    return table.concat(parts, " ")
end
A.FormatCopper = formatCopper

local function getItemSellPrice(link)
    if not link then return nil end
    local getInfo = (C_Item and C_Item.GetItemInfo) or GetItemInfo
    if not getInfo then return nil end
    local _, _, _, _, _, _, _, _, _, _, sellPrice = getInfo(link)
    sellPrice = W.Safe(sellPrice)
    if sellPrice == nil and C_Item and C_Item.RequestLoadItemDataByID then
        local id = tonumber(tostring(link):match("item:(%d+)"))
        if id then pcall(C_Item.RequestLoadItemDataByID, id) end
    end
    return sellPrice
end

local function findDialogueUIChoiceButton(index)
    local dui = _G.DUIQuestFrame
    if not (dui and dui:IsShown() and dui.itemButtonPool) then return nil end
    local pool = dui.itemButtonPool
    local found
    if pool.ProcessActiveObjects then
        pool:ProcessActiveObjects(function(btn)
            if not found and btn and btn:IsShown() and btn.type == "choice" and btn.index == index then
                found = btn
            end
        end)
    elseif pool.activeObjects then
        for _, btn in ipairs(pool.activeObjects) do
            if btn and btn:IsShown() and btn.type == "choice" and btn.index == index then
                return btn
            end
        end
    end
    return found
end

local function isRewardPanelShown()
    local dui = _G.DUIQuestFrame
    if dui and dui:IsShown() then return true end
    local rp = _G.QuestFrameRewardPanel
    if rp and rp:IsShown() then return true end
    return not dui and not rp
end

local function findChoiceButton(index)
    local duiBtn = findDialogueUIChoiceButton(index)
    if duiBtn then return duiBtn end
    local rf = _G.QuestInfoRewardsFrame
    if rf and rf.RewardButtons then
        for _, btn in ipairs(rf.RewardButtons) do
            if btn and btn:IsShown() and btn.type == "choice" and btn.GetID and btn:GetID() == index then
                return btn
            end
        end
    end
    for _, name in ipairs({ "QuestInfoRewardsFrameQuestInfoItem" .. index, "QuestInfoItem" .. index }) do
        local btn = _G[name]
        if btn and btn:IsShown() and (btn.type == "choice" or btn.type == nil)
            and (not btn.GetID or btn:GetID() == index) then
            return btn
        end
    end
end

local function getOverlay(idx)
    local ov = rewardHighlights[idx]
    if not ov then
        ov = CreateFrame("Frame", nil, UIParent)
        ov:EnableMouse(false)
        ov.wash = S.Nine(ov, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
        ov.wash:SetColor(1.00, 0.82, 0.25, 0.14)
        ov.border = S.Nine(ov, "BORDER", 0, S.MEDIA .. "outline", 16, 6, 6, 0)
        ov.border:SetColor(1.00, 0.82, 0.25, 0.95)

        ov.pill = CreateFrame("Frame", nil, ov)
        ov.pill:SetHeight(16)
        ov.pill:SetPoint("TOPRIGHT", ov, "TOPRIGHT", -4, 6)
        ov.pillBg = S.Nine(ov.pill, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 5, 0)
        ov.pillBg:SetColor(0.05, 0.06, 0.08, 0.94)
        ov.pillRim = S.Nine(ov.pill, "BORDER", 0, S.MEDIA .. "outline", 16, 6, 5, 0)
        ov.pillRim:SetColor(1.00, 0.82, 0.25, 0.90)

        ov.text = ov.pill:CreateFontString(nil, "OVERLAY")
        S.Font(ov.text, 10, "body")
        ov.text:SetPoint("CENTER", 0, 0)
        ov.text:SetShadowColor(0, 0, 0, 0.9)
        ov.text:SetShadowOffset(1, -1)
        ov:Hide()
        rewardHighlights[idx] = ov
    end
    return ov
end

function A:ClearRewardHighlight()
    pendingRewardInfo = false
    for _, ov in ipairs(rewardHighlights) do
        ov:Hide()
        ov:SetParent(UIParent)
    end
end

-- Returns bestIndices (table of choice indices tied for highest non-zero sell value), bestCopper, pending
function A:BestRewardChoices()
    local choices = GetNumQuestChoices and (GetNumQuestChoices() or 0) or 0
    if choices <= 1 then return {}, 0, false end
    local bestVal, winners, pending = 0, {}, false
    for i = 1, choices do
        local link = GetQuestItemLink and W.Safe(GetQuestItemLink("choice", i))
        local count = 1
        if GetQuestItemInfo then
            local _, _, num = GetQuestItemInfo("choice", i)
            num = W.Safe(num)
            if num and num > 1 then count = num end
        end
        local price = getItemSellPrice(link)
        if price == nil and link then
            pending = true
        elseif price and price > 0 then
            local total = price * count
            if total > bestVal then
                bestVal = total
                winners = { i }
            elseif total == bestVal then
                winners[#winners + 1] = i
            end
        end
    end
    return winners, bestVal, pending
end

function A:HighlightBestReward()
    A:ClearRewardHighlight()
    if W.db and W.db.highlightBestReward == false then return end
    local winners, bestVal, pending = A:BestRewardChoices()
    pendingRewardInfo = pending
    if #winners == 0 or bestVal <= 0 then return end
    local label = formatCopper(bestVal)
    local shown = 0
    for _, idx in ipairs(winners) do
        local btn = findChoiceButton(idx)
        if btn then
            shown = shown + 1
            local ov = getOverlay(shown)
            ov:SetParent(btn)
            ov:SetFrameStrata(btn:GetFrameStrata() or "HIGH")
            ov:SetFrameLevel((btn:GetFrameLevel() or 1) + 6)
            ov:ClearAllPoints()
            ov:SetPoint("TOPLEFT", btn, "TOPLEFT", -2, 2)
            ov:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 2, -2)
            ov.pill:SetFrameLevel(ov:GetFrameLevel() + 2)
            ov.text:SetText(label)
            ov.pill:SetWidth(math.max(38, (ov.text:GetStringWidth() or 30) + 12))
            ov.choiceIndex = idx
            ov.sellValue = bestVal
            ov:Show()
        end
    end
    return winners, bestVal, shown
end
A.rewardHighlights = rewardHighlights

function A:ScheduleRewardHighlight()
    local winners, bestVal, shown = A:HighlightBestReward()
    if C_Timer and C_Timer.After then
        local function retry()
            if isRewardPanelShown() and (GetNumQuestChoices and (GetNumQuestChoices() or 0) or 0) > 1 then
                A:HighlightBestReward()
            end
        end
        C_Timer.After(0, retry)
        if pendingRewardInfo or not (winners and bestVal and bestVal > 0 and shown and shown > 0) then
            C_Timer.After(0.25, retry)
        end
    end
end

W:On("QUEST_FINISHED", function() A:ClearRewardHighlight() end)
W:On("GET_ITEM_INFO_RECEIVED", function()
    if not pendingRewardInfo then return end
    if isRewardPanelShown() then
        A:HighlightBestReward()
    end
end)
W:On("WF_INIT", function()
    if hooksecurefunc and _G.QuestInfo_Display then
        hooksecurefunc(_G, "QuestInfo_Display", function()
            local rp = _G.QuestFrameRewardPanel
            if rp and rp:IsShown() and (GetNumQuestChoices and (GetNumQuestChoices() or 0) or 0) > 1 then
                A:HighlightBestReward()
            end
        end)
    end
    local dui = _G.DUIQuestFrame
    if dui then
        if hooksecurefunc and dui.RequestSellPrice then
            hooksecurefunc(dui, "RequestSellPrice", function()
                if dui:IsShown() and (GetNumQuestChoices and (GetNumQuestChoices() or 0) or 0) > 1 then
                    A:HighlightBestReward()
                end
            end)
        end
        if dui.HookScript then
            dui:HookScript("OnHide", function() A:ClearRewardHighlight() end)
        end
    end
end)

-- Modern gossip window (most NPCs)
W:On("GOSSIP_SHOW", function()
    A:ClearRewardHighlight()
    if paused() then return end
    if W.db.autoTurnIn then
        for _, info in ipairs(C_GossipInfo.GetActiveQuests() or {}) do
            if info.isComplete and info.questID and not isRecent(recentTurnIn, info.questID) then
                C_GossipInfo.SelectActiveQuest(info.questID)
                return
            end
        end
    end
    for _, info in ipairs(C_GossipInfo.GetAvailableQuests() or {}) do
        if wantAccept(info.questID, true) then
            C_GossipInfo.SelectAvailableQuest(info.questID)
            return
        end
    end
end)

-- Old-style quest greeting (NPCs that offer several quests without gossip)
W:On("QUEST_GREETING", function()
    A:ClearRewardHighlight()
    if paused() then return end
    if W.db.autoTurnIn then
        for i = 1, (GetNumActiveQuests() or 0) do
            local _, isComplete = GetActiveTitle(i)
            local q = GetActiveQuestID and GetActiveQuestID(i)
            if isComplete and not isRecent(recentTurnIn, q) then SelectActiveQuest(i) return end
        end
    end
    for i = 1, (GetNumAvailableQuests() or 0) do
        local q = GetAvailableQuestInfo and select(5, GetAvailableQuestInfo(i))
        if (not q or q == 0) and GetAvailableTitle then
            q = findQuestByTitle(GetAvailableTitle(i))
        end
        if wantAccept(q, true) then SelectAvailableQuest(i) return end
    end
end)
