-- Shared glass popups and quick menus: Items to Bring, Loose Quests, and lightweight context menus.
-- Keeps the panel footer consistent with Cleanup.lua instead of dumping lists to chat.
local _, W = ...
local P = {}
W.Popups = P

local S = W.Skin
local QS = W.QuestState
local ACCENT = S.ACCENT

local function makeFS(parent, size, r, g, b)
    local t = parent:CreateFontString(nil, "OVERLAY")
    S.Font(t, size, "body")
    if r == ACCENT then S.Accent(t, "text") else t:SetTextColor(r or 0.93, g or 0.94, b or 0.96) end
    t:SetShadowColor(0, 0, 0, 0.6)
    t:SetShadowOffset(1, -1)
    t:SetJustifyH("LEFT")
    return t
end

local function glassBtn(parent, w, h, label, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(w, h)
    local bg = S.Nine(b, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
    bg:SetColor(1, 1, 1, 0.09)
    local t = makeFS(b, 11, 0.88, 0.90, 0.93)
    t:SetPoint("CENTER")
    t:SetJustifyH("CENTER")
    t:SetText(label)
    b.bg, b.label = bg, t
    b:SetScript("OnEnter", function()
        bg:SetColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.28)
        t:SetTextColor(1, 1, 1)
    end)
    b:SetScript("OnLeave", function()
        bg:SetColor(1, 1, 1, 0.09)
        t:SetTextColor(0.88, 0.90, 0.93)
    end)
    b:SetScript("OnClick", onClick)
    return b
end

local function makeScrollbar(parent, topY, bottomY)
    local track = parent:CreateTexture(nil, "ARTWORK")
    track:SetColorTexture(1, 1, 1, 0.06)
    track:SetWidth(4)
    track:SetPoint("TOPRIGHT", -6, topY)
    track:SetPoint("BOTTOMRIGHT", -6, bottomY)
    local thumb = parent:CreateTexture(nil, "OVERLAY")
    S.Accent(thumb, "color", 0.55)
    thumb:SetWidth(4)
    thumb:Hide()
    track:Hide()
    return {
        track = track,
        thumb = thumb,
        Update = function(self, offset, visible, total)
            if total <= visible then
                track:Hide()
                thumb:Hide()
                return
            end
            track:Show()
            thumb:Show()
            local h = math.max(1, (parent:GetHeight() or 300) + topY - bottomY)
            local th = math.max(20, math.floor(h * (visible / total)))
            local maxOff = math.max(1, total - visible)
            local yOff = math.floor((h - th) * (offset / maxOff))
            thumb:ClearAllPoints()
            thumb:SetPoint("TOPRIGHT", track, "TOPRIGHT", 0, -yOff)
            thumb:SetHeight(th)
        end,
    }
end
P.MakeScrollbar = makeScrollbar

---------------------------------------------------------------------------
-- Lightweight glass context menu (arrow right-click, panel quick menu)
---------------------------------------------------------------------------
local menu, catcher, menuRows, menuSeps = nil, nil, {}, {}

local function ensureMenu()
    if menu then return menu end
    catcher = CreateFrame("Button", "OnwardMenuCatcher", UIParent)
    catcher:SetAllPoints(UIParent)
    catcher:SetFrameStrata("FULLSCREEN_DIALOG")
    catcher:EnableMouse(true)
    catcher:Hide()
    catcher:SetScript("OnClick", function() P:HideMenu() end)

    menu = CreateFrame("Frame", "OnwardMenu", UIParent)
    menu:SetFrameStrata("FULLSCREEN_DIALOG")
    menu:SetFrameLevel(catcher:GetFrameLevel() + 10)
    menu:SetClampedToScreen(true)
    menu:EnableMouse(true)
    menu:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, "OnwardMenu") end
    S.Glass(menu, { alpha = 0.94, corner = 8 })
    menu:SetScript("OnHide", function() if catcher then catcher:Hide() end end)
    P.menu = menu
    return menu
end

function P:HideMenu()
    if menu then menu:Hide() end
    if catcher then catcher:Hide() end
end

-- items: { { label, onClick, checked, disabled, sep }, ... }
function P:ShowMenu(anchor, items)
    local m = ensureMenu()
    for _, r in ipairs(menuRows) do r:Hide() end
    for _, sp in ipairs(menuSeps) do sp:Hide() end
    P.menuItems = items or {}

    local y, w, ri, si = 6, 168, 0, 0
    for _, it in ipairs(items or {}) do
        if it.sep then
            si = si + 1
            local sp = menuSeps[si]
            if not sp then
                sp = m:CreateTexture(nil, "ARTWORK")
                sp:SetColorTexture(1, 1, 1, 0.08)
                sp:SetHeight(1)
                menuSeps[si] = sp
            end
            sp:ClearAllPoints()
            sp:SetPoint("TOPLEFT", 10, -(y + 3))
            sp:SetPoint("TOPRIGHT", -10, -(y + 3))
            sp:Show()
            y = y + 7
        else
            ri = ri + 1
            local r = menuRows[ri]
            if not r then
                r = CreateFrame("Button", nil, m)
                r:SetHeight(22)
                local hl = S.Nine(r, "HIGHLIGHT", 0, S.MEDIA .. "glass_body", 64, 16, 5, 0)
                hl:SetColor(1, 1, 1, 0.09)
                r.mark = makeFS(r, 11, ACCENT)
                r.mark:SetPoint("LEFT", 8, 0)
                r.text = makeFS(r, 12)
                r.text:SetPoint("LEFT", 20, 0)
                r.text:SetPoint("RIGHT", -10, 0)
                r.text:SetWordWrap(false)
                menuRows[ri] = r
            end
            r.item = it
            r.mark:SetText(it.checked and "•" or "")
            r.text:SetText(it.label or "")
            if it.disabled then
                r.text:SetTextColor(0.45, 0.48, 0.52)
            elseif it.accent then
                r.text:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])
            else
                r.text:SetTextColor(0.93, 0.94, 0.96)
            end
            r:SetScript("OnClick", function()
                if it.disabled then return end
                P:HideMenu()
                if it.onClick then it.onClick() end
            end)
            w = math.max(w, math.min(250, (r.text:GetStringWidth() or 120) + 34))
            r:ClearAllPoints()
            r:SetPoint("TOPLEFT", 4, -y)
            r:SetPoint("RIGHT", -4, 0)
            r:Show()
            y = y + 22
        end
    end
    m:SetSize(w, y + 6)
    m:ClearAllPoints()
    if anchor and anchor.GetCenter then
        m:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -4)
    else
        m:SetPoint("CENTER")
    end
    catcher:Show()
    m:Show()
    return m
end

---------------------------------------------------------------------------
-- Shared popup frame builder for Needs & Loose lists
---------------------------------------------------------------------------
local function buildListWindow(name, width, height, heading, subtitle)
    local win = CreateFrame("Frame", name, UIParent)
    win:SetSize(width, height)
    win:SetPoint("CENTER")
    win:SetFrameStrata("DIALOG")
    win:SetClampedToScreen(true)
    win:SetMovable(true)
    win:EnableMouse(true)
    win:EnableMouseWheel(true)
    win:RegisterForDrag("LeftButton")
    win:SetScript("OnDragStart", win.StartMoving)
    win:SetScript("OnDragStop", win.StopMovingOrSizing)
    win:Hide()
    if UISpecialFrames then table.insert(UISpecialFrames, name) end
    S.Glass(win, { alpha = 0.92, corner = 12 })

    local title = makeFS(win, 15, ACCENT)
    title:SetPoint("TOPLEFT", 16, -12)
    title:SetText(heading)

    local sub = makeFS(win, 11, 0.62, 0.65, 0.70)
    sub:SetPoint("TOPLEFT", 16, -34)
    sub:SetPoint("RIGHT", -16, 0)
    sub:SetText(subtitle)

    local div = win:CreateTexture(nil, "ARTWORK")
    div:SetColorTexture(1, 1, 1, 0.07)
    div:SetHeight(1)
    div:SetPoint("TOPLEFT", 14, -56)
    div:SetPoint("TOPRIGHT", -14, -56)

    local close = CreateFrame("Button", nil, win)
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", -8, -7)
    local x = makeFS(close, 15, 0.62, 0.65, 0.70)
    x:SetPoint("CENTER")
    x:SetText("x")
    close:SetScript("OnClick", function() win:Hide() end)
    close:SetScript("OnEnter", function() x:SetTextColor(1, 1, 1) end)
    close:SetScript("OnLeave", function() x:SetTextColor(0.62, 0.65, 0.70) end)

    local empty = makeFS(win, 12, 0.62, 0.65, 0.70)
    empty:SetPoint("CENTER", 0, -10)
    empty:SetJustifyH("CENTER")
    empty:Hide()
    win.empty = empty
    return win
end

---------------------------------------------------------------------------
-- Items to Bring popup (OnwardNeeds)
---------------------------------------------------------------------------
local needsWin, needsRows, needsData, needsOffset, needsScroll = nil, {}, {}, 0, nil
local NEEDS_VISIBLE, NEEDS_ROW_H = 7, 38

local function questTitle(q)
    return (QS and QS:Title(q)) or ("quest " .. tostring(q))
end

local function renderNeeds()
    if not needsWin then return end
    local list = needsData or {}
    needsOffset = math.max(0, math.min(needsOffset, math.max(0, #list - NEEDS_VISIBLE)))
    for _, r in ipairs(needsRows) do r:Hide() end
    needsWin.empty:SetShown(#list == 0)
    needsWin.empty:SetText("Nothing extra to buy or craft for this guide.")
    needsScroll:Update(needsOffset, NEEDS_VISIBLE, #list)

    for i = 1, math.min(NEEDS_VISIBLE, #list) do
        local it = list[i + needsOffset]
        local r = needsRows[i]
        if not r then
            r = CreateFrame("Frame", nil, needsWin)
            r:SetHeight(NEEDS_ROW_H - 4)
            r.bg = S.Nine(r, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
            r.bg:SetColor(1, 1, 1, 0.04)
            r.count = makeFS(r, 11, ACCENT)
            r.count:SetPoint("TOPRIGHT", -8, -5)
            r.count:SetJustifyH("RIGHT")
            r.name = makeFS(r, 12, 0.93, 0.94, 0.96)
            r.name:SetPoint("TOPLEFT", 8, -4)
            r.name:SetPoint("RIGHT", r.count, "LEFT", -8, 0)
            r.name:SetWordWrap(false)
            r.note = makeFS(r, 10, 0.62, 0.65, 0.70)
            r.note:SetPoint("TOPLEFT", 8, -19)
            r.note:SetPoint("RIGHT", -8, 0)
            r.note:SetWordWrap(false)
            needsRows[i] = r
        end
        local have = it.have or 0
        local need = it.n or 1
        local done = have >= need
        r.name:SetText(it.name .. ((it.bank or 0) > 0 and ("  |cff888888(%d in bank)|r"):format(it.bank) or ""))
        r.count:SetText(("%d/%d"):format(have, need))
        if done then
            r.count:SetTextColor(0.40, 0.85, 0.45)
        elseif have > 0 then
            r.count:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])
        else
            r.count:SetTextColor(0.85, 0.87, 0.90)
        end
        r.note:SetText(("%s  ·  For %s"):format(it.where or "Town / AH", questTitle(it.quest)))
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 14, -64 - (i - 1) * NEEDS_ROW_H)
        r:SetPoint("RIGHT", -16, 0)
        r:Show()
    end
end

function P:ShowNeeds(items)
    if not needsWin then
        needsWin = buildListWindow("OnwardNeeds", 410, 382, "Items to bring",
            "Quests in this guide ask for these, and nothing in the zone drops them.")
        needsScroll = makeScrollbar(needsWin, -64, 48)
        needsWin:SetScript("OnMouseWheel", function(_, d)
            needsOffset = needsOffset - d
            renderNeeds()
        end)
        local copyBtn = glassBtn(needsWin, 112, 24, "Copy checklist", function()
            local out = {}
            for _, it in ipairs(needsData or {}) do
                local title, note = W.UI and W.UI.NeedLine and W.UI.NeedLine(it)
                out[#out + 1] = title and (title .. " — " .. note) or tostring(it.name)
            end
            if W.UI and W.UI.ShowText then W.UI.ShowText("Items to bring", table.concat(out, "\n")) end
        end)
        copyBtn:SetPoint("BOTTOMLEFT", 14, 14)

        local chatBtn = glassBtn(needsWin, 102, 24, "Print to chat", function()
            for _, it in ipairs(needsData or {}) do
                local title, note = W.UI and W.UI.NeedLine and W.UI.NeedLine(it)
                if title then W.Print(title .. ": " .. note) end
            end
        end)
        chatBtn:SetPoint("LEFT", copyBtn, "RIGHT", 8, 0)

        local closeBtn = glassBtn(needsWin, 74, 24, "Close", function() needsWin:Hide() end)
        closeBtn:SetPoint("BOTTOMRIGHT", -14, 14)
        P.needsWin, P.needsRows = needsWin, needsRows
    end
    needsData = items or (W.Guide and W.Guide:Needs()) or {}
    needsOffset = 0
    renderNeeds()
    needsWin:Show()
    return needsWin
end

---------------------------------------------------------------------------
-- Loose / Drop Quests popup (OnwardLoose)
---------------------------------------------------------------------------
local looseWin, looseRows, looseData, looseOffset, looseScroll = nil, {}, {}, 0, nil
local LOOSE_VISIBLE, LOOSE_ROW_H = 7, 42

local function renderLoose()
    if not looseWin then return end
    local list = looseData or {}
    looseOffset = math.max(0, math.min(looseOffset, math.max(0, #list - LOOSE_VISIBLE)))
    for _, r in ipairs(looseRows) do r:Hide() end
    looseWin.empty:SetShown(#list == 0)
    looseWin.empty:SetText("No unplaced or drop-started quests remaining in this zone.")
    looseScroll:Update(looseOffset, LOOSE_VISIBLE, #list)

    for i = 1, math.min(LOOSE_VISIBLE, #list) do
        local s = list[i + looseOffset]
        local r = looseRows[i]
        if not r then
            r = CreateFrame("Frame", nil, looseWin)
            r:SetHeight(LOOSE_ROW_H - 4)
            r.bg = S.Nine(r, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
            r.bg:SetColor(1, 1, 1, 0.04)
            r.mapBtn = glassBtn(r, 46, 20, "Map", nil)
            r.mapBtn:SetPoint("RIGHT", -6, 0)
            r.name = makeFS(r, 12, 0.93, 0.94, 0.96)
            r.name:SetPoint("TOPLEFT", 8, -4)
            r.name:SetPoint("RIGHT", r.mapBtn, "LEFT", -6, 0)
            r.name:SetWordWrap(false)
            r.note = makeFS(r, 10, 0.62, 0.65, 0.70)
            r.note:SetPoint("TOPLEFT", 8, -19)
            r.note:SetPoint("RIGHT", r.mapBtn, "LEFT", -6, 0)
            r.note:SetWordWrap(false)
            looseRows[i] = r
        end
        r.name:SetText(questTitle(s.quest))
        r.note:SetText(s.note or "No pickup spot on record.")
        local hasAt = s.at and s.at.map and s.at.x and s.at.y
        r.mapBtn:SetShown(hasAt and true or false)
        if hasAt then
            r.mapBtn:SetScript("OnClick", function()
                if C_Map and C_Map.SetUserWaypoint and UiMapPoint then
                    pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(s.at.map, s.at.x / 100, s.at.y / 100))
                end
                if OpenWorldMap then OpenWorldMap(s.at.map)
                elseif ToggleWorldMap then ToggleWorldMap() end
            end)
        end
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 14, -64 - (i - 1) * LOOSE_ROW_H)
        r:SetPoint("RIGHT", -16, 0)
        r:Show()
    end
end

function P:ShowLoose(steps)
    if not looseWin then
        looseWin = buildListWindow("OnwardLoose", 420, 408, "Quests to find in this zone",
            "These start from drops or unplaced givers. Pick one up and Onward tracks it from there.")
        looseScroll = makeScrollbar(looseWin, -64, 48)
        looseWin:SetScript("OnMouseWheel", function(_, d)
            looseOffset = looseOffset - d
            renderLoose()
        end)
        local chatBtn = glassBtn(looseWin, 102, 24, "Print to chat", function()
            for _, s in ipairs(looseData or {}) do
                W.Print(questTitle(s.quest) .. ": " .. (s.note or "No pickup spot on record."))
            end
        end)
        chatBtn:SetPoint("BOTTOMLEFT", 14, 14)

        local closeBtn = glassBtn(looseWin, 74, 24, "Close", function() looseWin:Hide() end)
        closeBtn:SetPoint("BOTTOMRIGHT", -14, 14)
        P.looseWin, P.looseRows = looseWin, looseRows
    end
    looseData = steps or (W.Guide and W.Guide:Loose()) or {}
    looseOffset = 0
    renderLoose()
    looseWin:Show()
    return looseWin
end

---------------------------------------------------------------------------
-- Skipped steps popup (OnwardSkipped): jump straight back to any skipped unfinished step
---------------------------------------------------------------------------
local skipWin, skipRows, skipData, skipOffset, skipScroll = nil, {}, {}, 0, nil
local SKIP_VISIBLE, SKIP_ROW_H = 7, 38

local function renderSkipped()
    if not skipWin then return end
    skipData = (W.Guide and W.Guide:SkippedSteps()) or {}
    skipOffset = math.max(0, math.min(skipOffset, math.max(0, #skipData - SKIP_VISIBLE)))
    for _, r in ipairs(skipRows) do r:Hide() end
    skipWin.empty:SetShown(#skipData == 0)
    skipWin.empty:SetText("No unfinished skipped steps in this guide.")
    skipScroll:Update(skipOffset, SKIP_VISIBLE, #skipData)

    for i = 1, math.min(SKIP_VISIBLE, #skipData) do
        local st = skipData[i + skipOffset]
        local r = skipRows[i]
        if not r then
            r = CreateFrame("Frame", nil, skipWin)
            r:SetHeight(SKIP_ROW_H - 4)
            r.bg = S.Nine(r, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
            r.bg:SetColor(1, 1, 1, 0.04)
            r.goBtn = glassBtn(r, 64, 20, "Go back", nil)
            r.goBtn:SetPoint("RIGHT", -6, 0)
            r.name = makeFS(r, 12, 0.93, 0.94, 0.96)
            r.name:SetPoint("TOPLEFT", 8, -4)
            r.name:SetPoint("RIGHT", r.goBtn, "LEFT", -6, 0)
            r.name:SetWordWrap(false)
            r.sub = makeFS(r, 10, 0.62, 0.65, 0.70)
            r.sub:SetPoint("TOPLEFT", 8, -19)
            r.sub:SetPoint("RIGHT", r.goBtn, "LEFT", -6, 0)
            r.sub:SetWordWrap(false)
            skipRows[i] = r
        end
        r.step = st
        r.name:SetText((W.UI and W.UI.StepText and W.UI.StepText(st)) or st.verb)
        local subStr = ("Step %d"):format(st.index or 0)
        if st.npc then subStr = subStr .. "  ·  " .. st.npc end
        if st.quest and QS and QS:IsOnQuest(st.quest) then subStr = subStr .. "  ·  in quest log" end
        r.sub:SetText(subStr)
        r.goBtn:SetScript("OnClick", function()
            if W.Guide then W.Guide:UnmarkDone(st) end
            renderSkipped()
            if #skipData == 0 then skipWin:Hide() end
        end)
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", 14, -64 - (i - 1) * SKIP_ROW_H)
        r:SetPoint("RIGHT", -16, 0)
        r:Show()
    end
end

function P:ShowSkipped()
    if not skipWin then
        skipWin = buildListWindow("OnwardSkipped", 410, 382, "Skipped steps",
            "Unfinished steps you skipped in this guide. Click Go back to resume any of them.")
        skipScroll = makeScrollbar(skipWin, -64, 48)
        skipWin:SetScript("OnMouseWheel", function(_, d)
            skipOffset = skipOffset - d
            renderSkipped()
        end)
        local allBtn = glassBtn(skipWin, 104, 24, "Restore all", function()
            if W.Guide then W.Guide:RestoreAllSkipped() end
            skipWin:Hide()
        end)
        allBtn:SetPoint("BOTTOMLEFT", 14, 14)

        local closeBtn = glassBtn(skipWin, 74, 24, "Close", function() skipWin:Hide() end)
        closeBtn:SetPoint("BOTTOMRIGHT", -14, 14)
        P.skipWin, P.skipRows = skipWin, skipRows
        W:On("WF_UPDATED", function() if skipWin:IsShown() then renderSkipped() end end)
    end
    skipOffset = 0
    renderSkipped()
    skipWin:Show()
    return skipWin
end
