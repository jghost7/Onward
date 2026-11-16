-- Panel UI: one compact card for the current step, party status under it, upcoming steps dimmed.
-- Everything redraws only on WF_UPDATED / WF_PARTY_UPDATED (both debounced upstream).
local _, W = ...
local UI = {}
W.UI = UI

local G, QS, P, WP = W.Guide, W.QuestState, W.Party, W.Waypoint

local S = W.Skin
local WIDTH = 310
local PAD = 14
local FONT = S.FONT_BODY          -- body text: clean, slightly condensed
local HEAD = S.FONT_HEAD          -- the current step's headline

local C = {
    bg      = { 0.055, 0.063, 0.078, 0.92 },
    line    = { 1, 1, 1, 0.07 },
    accent  = S.ACCENT,                  -- the theme's accent (shared table, recoloured live)
    text    = { 0.93, 0.94, 0.96 },
    sub     = { 0.62, 0.65, 0.70 },
    dim     = { 0.45, 0.48, 0.52 },
    accept  = { 1.00, 0.82, 0.25 },
    turnin  = { 0.40, 0.85, 0.45 },
    quest   = { 0.45, 0.70, 1.00 },
    travel  = { 0.75, 0.60, 1.00 },
    warn    = { 1.00, 0.45, 0.40 },
}

local MEDIA = "Interface\\AddOns\\Onward\\media\\"
local VERB_STYLE = {
    accept   = { color = C.accept, icon = "accept" },
    turnin   = { color = C.turnin, icon = "turnin" },
    complete = { color = C.quest,  icon = "complete" },
    ["goto"] = { color = C.travel, icon = "goto" },
    fly      = { color = C.travel, icon = "fly" },
    level    = { color = C.accent, icon = "level" },
    note     = { color = C.sub,    icon = "note" },
    train    = { color = C.accept, icon = "level" },
    craft    = { color = C.quest,  icon = "complete" },
    gather   = { color = C.turnin, icon = "goto" },
}

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------
local function rgb(t, a) return t[1], t[2], t[3], a or t[4] or 1 end

local function fs(parent, size, color, flags, font)
    local f = parent:CreateFontString(nil, "OVERLAY")
    S.Font(f, size, font == HEAD and "head" or "body", flags)
    f:SetShadowColor(0, 0, 0, 0.6)
    f:SetShadowOffset(1, -1)
    if color == C.accent then S.Accent(f, "text") else f:SetTextColor(rgb(color)) end
    f:SetJustifyH("LEFT")
    f:SetWordWrap(true)
    return f
end

local function iconButton(parent, icon, tip, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(18, 18)
    local t = b:CreateTexture(nil, "ARTWORK")
    t:SetTexture(MEDIA .. icon)
    t:SetSize(14, 14)
    t:SetPoint("CENTER")
    t:SetVertexColor(rgb(C.sub))
    b.icon = t
    b.tint = C.sub
    S.Hover(b, 22)
    b:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(rgb(C.text))
        if tip then GameTooltip:SetOwner(self, "ANCHOR_TOP") GameTooltip:SetText(tip) GameTooltip:Show() end
    end)
    b:SetScript("OnLeave", function(self) self.icon:SetVertexColor(rgb(self.tint)) GameTooltip:Hide() end)
    b:SetScript("OnClick", onClick)
    function b:SetTint(c) self.tint = c self.icon:SetVertexColor(rgb(c)) end
    return b
end

local function textButton(parent, label, tip, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(18, 18)
    local t = fs(b, 13, C.sub)
    t:SetPoint("CENTER")
    t:SetText(label)
    b.label = t
    b:SetScript("OnEnter", function(self)
        self.label:SetTextColor(rgb(C.text))
        if tip then GameTooltip:SetOwner(self, "ANCHOR_TOP") GameTooltip:SetText(tip) GameTooltip:Show() end
    end)
    b:SetScript("OnLeave", function(self) self.label:SetTextColor(rgb(C.sub)) GameTooltip:Hide() end)
    b:SetScript("OnClick", onClick)
    return b
end

local function questTitle(q)
    return QS:Title(q) or ("quest " .. q)
end

local GROUP_TEXT = {
    elite = "|cffff8040Elite: bring a group|r",
    dungeon = "|cffff8040Dungeon quest|r",
    chain = "|cffff8040Needs an elite quest first|r",
}
function UI.GroupText(kind)
    return GROUP_TEXT[kind] or GROUP_TEXT.elite
end

function UI.StepText(step)
    local v = step.verb
    if v == "accept" then return "Accept " .. questTitle(step.quest)
    elseif v == "turnin" then return "Turn in " .. questTitle(step.quest)
    elseif v == "complete" then
        local t = questTitle(step.quest)
        if step.obj then
            local o = QS:Objective(step.quest, step.obj)
            if o and o.text then return t .. ": " .. o.text end
        end
        return t
    elseif v == "goto" then return step.note or ("Go to %.1f, %.1f"):format(step.at.x, step.at.y)
    elseif v == "fly" then return "Fly to " .. (step.npc or step.note or "the next flight point")
    elseif v == "level" then return ("Reach level %d"):format(step.level or 0)
    elseif v == "note" then return step.text or "Note"
    elseif G.PROF_VERB[v] and W.Prof then return W.Prof:StepText(step)
    end
    return v
end

---------------------------------------------------------------------------
-- Frame
---------------------------------------------------------------------------
local f = CreateFrame("Frame", "OnwardPanel", UIParent)
f:SetSize(WIDTH, 120)
f:SetClampedToScreen(true)
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetFrameStrata("MEDIUM")
f:Hide()

S.Glass(f, { alpha = 0.72, titleBar = 30 })

f:SetScript("OnDragStart", function(self) if not W.db.locked then self:StartMoving() end end)
-- Keep the panel anchored by its top-left corner, so a taller card (more objectives, mats) grows
-- downward instead of out from the middle. The game re-anchors a dragged frame to whichever edge
-- or centre is nearest, so re-anchor it here and save that.
local function pinTop()
    local left, top = f:GetLeft(), f:GetTop()
    if not (left and top) then return end
    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
    W.db.point = { "TOPLEFT", "BOTTOMLEFT", left, top }
end
UI.PinTop = pinTop
f:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    pinTop()
    W:Fire("WF_PANEL_MOVED")
end)
UI.panel = f

-- header
local title = fs(f, 12, C.accent)
title:SetPoint("TOPLEFT", PAD, -11)
title:SetWordWrap(false)
local count = fs(f, 11, C.dim)

local btnCollapse = iconButton(f, "collapse", "Collapse / expand", function() W.db.collapsed = not W.db.collapsed UI:Render() end)
btnCollapse:SetPoint("TOPRIGHT", -8, -7)
local btnGear = iconButton(f, "gear", "Options", function() W:Fire("WF_SHOW_OPTIONS") end)
btnGear:SetPoint("RIGHT", btnCollapse, "LEFT", -1, 0)
local btnArrow = iconButton(f, "nav", "Nav arrow on / off", function() W.Arrow:Toggle() end)
btnArrow:SetPoint("RIGHT", btnGear, "LEFT", -1, 0)
local btnMenu = iconButton(f, "list", "Guides", function() UI:TogglePicker() end)
btnMenu:SetPoint("RIGHT", btnArrow, "LEFT", -1, 0)
local btnNext = iconButton(f, "next", "Skip step", function() G:Skip(1) end)
btnNext:SetPoint("RIGHT", btnMenu, "LEFT", -1, 0)
local btnPrev = iconButton(f, "prev", "Back one step", function() G:Skip(-1) end)
btnPrev:SetPoint("RIGHT", btnNext, "LEFT", -1, 0)
count:SetPoint("RIGHT", btnPrev, "LEFT", -6, 0)
title:SetPoint("RIGHT", count, "LEFT", -6, 0)

-- progress bar: a hairline track with the accent fill, right under the title strip
-- (glass adds a soft glow to the fill; flat keeps it a clean rule)
local BAR_W = WIDTH - 2 * PAD
local barBg = f:CreateTexture(nil, "ARTWORK")
barBg:SetColorTexture(1, 1, 1, 0.07)
barBg:SetPoint("TOPLEFT", PAD, -32)
barBg:SetSize(BAR_W, 2)
local bar = f:CreateTexture(nil, "ARTWORK", nil, 1)
S.Accent(bar, "color")
bar:SetPoint("TOPLEFT", barBg) bar:SetHeight(2)
local barGlow = f:CreateTexture(nil, "ARTWORK", nil, 0)
barGlow:SetTexture(MEDIA .. "glass_shadow")
barGlow:SetPoint("TOPLEFT", bar, "TOPLEFT", -6, 6)
barGlow:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 6, -6)
S.Accent(barGlow, "vertex", 0.35)
if barGlow.SetBlendMode then barGlow:SetBlendMode("ADD") end
local function themeBar() barGlow:SetShown(not S.Square()) end
themeBar()
W:On("WF_THEME_CHANGED", themeBar)

-- current step card (clickable: notes complete on click, others open the map);
-- sits on a slightly brighter inset so the current step reads first
local card = CreateFrame("Button", nil, f)
card:SetPoint("TOPLEFT", PAD, -46)
card:SetPoint("RIGHT", -PAD, 0)
do
    local inset = S.Nine(card, "BACKGROUND", -4, MEDIA .. "glass_body", 64, 16, 10, 8)
    inset:SetColor(1, 1, 1, 0.045)
    local rim = S.Nine(card, "BACKGROUND", -3, MEDIA .. "glass_rim", 64, 16, 10, 8)
    rim:SetColor(1, 1, 1, 0.06)
end
card:RegisterForClicks("LeftButtonUp", "RightButtonUp")
local badge = card:CreateTexture(nil, "ARTWORK")
badge:SetSize(20, 20)
badge:SetPoint("TOPLEFT", 0, 1)
S.Badge(badge)
local badgeIcon = card:CreateTexture(nil, "OVERLAY")
badgeIcon:SetSize(12, 12)
badgeIcon:SetPoint("CENTER", badge)
badgeIcon:SetVertexColor(rgb(C.bg, 1))
local mainText = fs(card, 14, C.text, nil, HEAD)
mainText:SetPoint("TOPLEFT", badge, "TOPRIGHT", 8, 0)
mainText:SetPoint("RIGHT")
local subText = fs(card, 12, C.sub)
subText:SetPoint("TOPLEFT", mainText, "BOTTOMLEFT", 0, -3)
subText:SetPoint("RIGHT")
UI.card = card
-- room for the target button (Target.lua) in the card's top-right corner
local cardInset = 0
function UI.SetCardInset(px)
    if px == cardInset then return end
    cardInset = px
    mainText:SetPoint("RIGHT", card, "RIGHT", -px, 0)
    UI:Render()
end

-- pools for objective lines, party chips and upcoming rows
local objLines, partyChips, rows = {}, {}, {}

local function objLine(i)
    if not objLines[i] then
        local l = fs(card, 12, C.sub)
        l:SetPoint("RIGHT")
        objLines[i] = l
    end
    return objLines[i]
end

local function partyChip(i)
    if not partyChips[i] then
        local c = fs(f, 11, C.sub)
        c:SetWordWrap(false)
        partyChips[i] = c
    end
    return partyChips[i]
end

local function row(i)
    if not rows[i] then
        local r = CreateFrame("Frame", nil, f)
        r:SetHeight(16)
        r.dot = r:CreateTexture(nil, "ARTWORK")
        r.dot:SetSize(11, 11)
        r.dot:SetPoint("LEFT", 6, 0)
        r.text = fs(r, 12, C.dim)
        r.text:SetWordWrap(false)
        r.text:SetPoint("LEFT", 20, 0)
        r.text:SetPoint("RIGHT")
        rows[i] = r
    end
    return rows[i]
end

local missedBtn = CreateFrame("Button", nil, f)
missedBtn:SetHeight(14)
missedBtn.text = fs(missedBtn, 11, C.dim)
missedBtn.text:SetPoint("LEFT")
missedBtn.text:SetWordWrap(false)
missedBtn:Hide()
missedBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Missed earlier in this guide")
    for i, q in ipairs(self.quests or {}) do
        if i > 12 then GameTooltip:AddLine(("...and %d more"):format(#self.quests - 12), 0.6, 0.6, 0.6) break end
        GameTooltip:AddLine(questTitle(q), 0.8, 0.8, 0.8)
    end
    GameTooltip:AddLine("Click (or the back button) to go back for them.", S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
    GameTooltip:Show()
end)
missedBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
missedBtn:SetScript("OnClick", function() G:GoBackToMissed() end)

-- a better-fitting guide than the one you're on (G:Suggestion): click to switch, right-click to hide
local suggestBtn = CreateFrame("Button", nil, f)
suggestBtn:SetHeight(14)
suggestBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
suggestBtn.text = fs(suggestBtn, 11, C.accent)
suggestBtn.text:SetPoint("LEFT")
suggestBtn.text:SetPoint("RIGHT")
suggestBtn.text:SetJustifyH("LEFT")
suggestBtn.text:SetWordWrap(false)
suggestBtn:Hide()
suggestBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Suggested guide")
    GameTooltip:AddLine(self.why or "", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Click: switch to it.  Right-click: hide this suggestion.", S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
    GameTooltip:Show()
end)
suggestBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
suggestBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        W.cdb.hiddenSuggestion = self.id
    else
        W.cdb.pickedSmart = nil
        G:Activate(self.id)
    end
    G:ClearSuggestion()
    UI:Render()
end)
UI.suggestBtn = suggestBtn

-- turn-ins the guide moved past because the quest isn't finished (G:Waiting): a dim line while
-- they wait, a green clickable one once a quest is ready to hand in
local function unfinished(q)
    local e = QS:Get(q)
    for _, o in ipairs(e and e.objectives or {}) do
        if not o.finished and o.text and o.text ~= "" then return o.text end
    end
end
local waitBtn = CreateFrame("Button", nil, f)
waitBtn:SetHeight(14)
waitBtn.text = fs(waitBtn, 11, C.dim)
waitBtn.text:SetPoint("LEFT")
waitBtn.text:SetPoint("RIGHT")
waitBtn.text:SetWordWrap(false)
waitBtn:Hide()
waitBtn:SetScript("OnEnter", function(self)
    local w = self.data
    if not w then return end
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    if #w.ready > 0 then
        GameTooltip:AddLine("Ready to turn in")
        for _, s in ipairs(w.ready) do GameTooltip:AddLine(questTitle(s.quest), 0.40, 0.85, 0.45) end
        GameTooltip:AddLine("Click to go back and hand it in.", S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
    end
    if #w.waiting > 0 then
        GameTooltip:AddLine("Not finished yet, so not turned in")
        for _, s in ipairs(w.waiting) do
            local left = unfinished(s.quest)
            GameTooltip:AddDoubleLine(questTitle(s.quest), left or "", 0.8, 0.8, 0.8, 1, 0.45, 0.4)
        end
        GameTooltip:AddLine("Finish them and they come back here as ready.", 0.6, 0.6, 0.6, true)
    end
    GameTooltip:Show()
end)
waitBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
waitBtn:SetScript("OnClick", function(self)
    local w = self.data
    if w and w.ready[1] then G:GoToStep(w.ready[1]) end
end)

-- one clickable accent line under the card: the busy-area prompt, or quests left for later
local function lineButton(color)
    local bt = CreateFrame("Button", nil, f)
    bt:SetHeight(14)
    bt.text = fs(bt, 11, color)
    bt.text:SetPoint("LEFT")
    bt.text:SetPoint("RIGHT")
    bt.text:SetJustifyH("LEFT")
    bt.text:SetWordWrap(false)
    bt:Hide()
    bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return bt
end

local busyBtn = lineButton(C.warn)
busyBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Busy here")
    GameTooltip:AddLine(("%d of the %d quest mobs in sight are tagged by other players."):format(self.tagged or 0, self.total or 0), 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Click: come back to this quest later. The guide moves on and brings you back to it.", S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
    GameTooltip:Show()
end)
busyBtn:SetScript("OnClick", function(self) if self.quest then G:Later(self.quest) end end)
UI.busyBtn = busyBtn

local laterBtn = lineButton(C.sub)
laterBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Left for later")
    for _, q in ipairs(self.quests or {}) do GameTooltip:AddLine(questTitle(q), 0.8, 0.8, 0.8) end
    GameTooltip:AddLine("Click: do " .. (self.quest and questTitle(self.quest) or "it") .. " now. The guide also comes back to these before moving on.",
        S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
    GameTooltip:Show()
end)
laterBtn:SetScript("OnClick", function(self) if self.quest then G:ResumeLater(self.quest) end end)
UI.laterBtn = laterBtn

-- busy-area check every 2 s while a kill/loot step is shown; redraws only when the answer changes
local busySig
C_Timer.NewTicker(2, function()
    local step = card.step
    local sig = ""
    if type(step) == "table" and step.verb == "complete" and W.Target and f:IsShown() then
        local busy, tagged, total = W.Target:Busy()
        sig = busy and (step.quest .. ":" .. tagged .. "/" .. total) or ""
    end
    local near = G:LaterNearby() or ""
    sig = sig .. "|" .. near
    if sig ~= busySig then busySig = sig UI:Render() end
end)

local divider = f:CreateTexture(nil, "ARTWORK")
divider:SetColorTexture(rgb(C.line))
divider:SetHeight(1)

local function setBadge(step)
    local st = VERB_STYLE[step.verb] or VERB_STYLE.note
    badge:SetVertexColor(rgb(st.color))
    badgeIcon:SetTexture(MEDIA .. st.icon)
    badgeIcon:Show()
end

local function locationLine(step)
    local parts = {}
    local cur = WP:Current()
    if cur and cur.step == step then
        if cur.name then parts[#parts + 1] = cur.name end
        local here = C_Map.GetBestMapForUnit("player")
        if cur.map ~= here then
            local info = C_Map.GetMapInfo and C_Map.GetMapInfo(cur.map)
            parts[#parts + 1] = (info and info.name or "another zone") .. (" %.0f, %.0f"):format(cur.x, cur.y)
        else
            parts[#parts + 1] = ("%.1f, %.1f"):format(cur.x, cur.y)
        end
        local d = W.Travel.Distance(cur.map, cur.x, cur.y)
        if d then parts[#parts + 1] = ("%d yd"):format(d) end
    elseif step.npc then
        parts[#parts + 1] = step.npc
    end
    if step.note and step.verb ~= "goto" then parts[#parts + 1] = step.note end
    if step.group then parts[#parts + 1] = UI.GroupText(step.group) end
    if step.item then
        local name = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(step.item)
        parts[#parts + 1] = "use " .. (name or ("item " .. step.item))
    end
    return table.concat(parts, "  ·  ")
end

local STATE_TEXT = {
    turnedin = { "done", C.turnin },
    ready    = { "ready", C.turnin },
    accepted = { nil, C.quest },
    missing  = { "not on it", C.warn },
    unknown  = { "", C.dim },
}

---------------------------------------------------------------------------
-- Render
---------------------------------------------------------------------------
local shownTogether = {}   -- steps listed on the card as "also here" (left out of upcoming)
function UI:Render()
    if not f:IsShown() then return end
    shownTogether = {}
    local g = G:Active()
    local done, total = G:Progress()
    title:SetText(g and g.title or "Onward")
    count:SetText(total > 0 and (done .. "/" .. total) or "")
    bar:SetWidth(math.max(1, BAR_W * (total > 0 and done / total or 0)))
    btnCollapse.icon:SetTexture(MEDIA .. (W.db.collapsed and "expand" or "collapse"))
    btnArrow:SetTint(W.db.arrow and C.accent or C.sub)
    f.glass:SetOpacity(W.db.bgAlpha or 0.72)

    local list = G:Upcoming(W.db.showNext + 4)   -- extra so grouped steps don't shorten the list
    local step = list[1]
    local y = 46

    for _, l in ipairs(objLines) do l:Hide() end
    for _, c in ipairs(partyChips) do c:Hide() end
    for _, r in ipairs(rows) do r:Hide() end
    divider:Hide()
    missedBtn:Hide()
    suggestBtn:Hide()
    busyBtn:Hide()
    laterBtn:Hide()

    if not step then
        badge:SetVertexColor(rgb(C.accent))
        badgeIcon:SetTexture(MEDIA .. "list")
        -- nothing to do: offer the recommended guide (a new character's first quest is in it)
        local rec, why = G:Recommend()
        card.recommend = rec and rec.id
        mainText:SetText(g and g.id == "smart" and "Quest log is empty" or "Guide complete")
        subText:SetText(rec and ("Click to start %s (%s)."):format(rec.title, G:ReasonText(why))
            or "Open the guide list to pick the next one.")
        subText:Show()
        card:SetHeight(mainText:GetStringHeight() + subText:GetStringHeight() + 4)
        f:SetHeight(y + card:GetHeight() + PAD)
        card.step = nil
        return
    end
    card.step = step

    -- current step
    setBadge(step)
    local text = UI.StepText(step)
    if G:IsMissing(step) then text = text .. "  |cffff7366(not in quest log)|r" end
    mainText:SetText(text)
    local sub = locationLine(step)
    if step.verb == "note" then sub = (sub ~= "" and (sub .. "  ·  ") or "") .. "click when done" end
    subText:SetText(sub)
    subText:SetShown(sub ~= "")
    local h = mainText:GetStringHeight() + (sub ~= "" and (subText:GetStringHeight() + 3) or 0)

    if W.db.collapsed then
        card:SetHeight(math.max(18, h))
        f:SetHeight(y + card:GetHeight() + PAD)
        return
    end

    -- objectives for complete steps, then the other kill/loot quests worked in the same area
    -- (G:Group): each as a "also here" title line with its objectives under it
    local anchor = sub ~= "" and subText or mainText
    local n = 0
    local function line(text, color, gap)
        n = n + 1
        local l = objLine(n)
        l:ClearAllPoints()
        l:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(gap or 3))
        l:SetPoint("RIGHT", card, "RIGHT")
        l:SetTextColor(rgb(color))
        l:SetText(text)
        l:Show()
        anchor = l
        h = h + l:GetStringHeight() + (gap or 3)
    end
    local function objectives(s)
        local e = W.db.showObjectives and QS:Get(s.quest)
        if not e then return end
        for i, o in ipairs(e.objectives) do
            if not s.obj or s.obj == i then
                line((o.finished and "|cff66d973+|r " or "- ") .. (o.text or ""), o.finished and C.dim or C.sub)
                local drop = W.Drops and W.Drops:Line(o, s.quest)
                if drop then line("    " .. drop, C.dim, 1) end
            end
        end
    end
    if step.verb == "complete" and step.quest then
        objectives(step)
        local group = G:Group()
        shownTogether = {}
        for i = 2, #group do
            local s = group[i]
            shownTogether[s] = true
            line("|cff73b3ffAlso here:|r " .. questTitle(s.quest), C.text, 7)
            objectives(s)
        end
    else
        shownTogether = {}
        if G.PROF_VERB[step.verb] and W.Prof then
            -- skill, crafts left, recipe to learn, mats against your bags, the game's best pick now
            for _, l in ipairs(W.Prof:CardLines(step)) do line(l[1], C[l[2] or "sub"] or C.sub) end
        end
    end
    card:SetHeight(math.max(18, h))
    y = y + card:GetHeight() + 16

    -- party status for this step's quest
    local party = W.db.showParty and step.quest and P:StatusFor(step.quest) or {}
    if #party > 0 then
        local x = PAD
        for i, m in ipairs(party) do
            local c = partyChip(i)
            local cc = m.class and RAID_CLASS_COLORS and RAID_CLASS_COLORS[m.class]
            local st = STATE_TEXT[m.state] or STATE_TEXT.unknown
            local status = st[1]
            if m.state == "accepted" and m.need and m.need > 0 then status = m.have .. "/" .. m.need end
            local name = cc and ("|c" .. cc.colorStr .. m.name .. "|r") or m.name
            local hex = ("|cff%02x%02x%02x"):format(st[2][1] * 255, st[2][2] * 255, st[2][3] * 255)
            c:SetText(name .. ((status and status ~= "") and (" " .. hex .. status .. "|r") or ""))
            c:ClearAllPoints()
            if x + c:GetStringWidth() > WIDTH - PAD and x > PAD then
                x = PAD
                y = y + 15
            end
            c:SetPoint("TOPLEFT", x, -y)
            c:Show()
            x = x + c:GetStringWidth() + 12
        end
        y = y + 18
    end

    -- an overrun area: offer to come back to this quest later
    if step.verb == "complete" and step.quest and W.Target and not W.db.collapsed then
        local busy, tagged, total = W.Target:Busy()
        if busy then
            busyBtn.quest, busyBtn.tagged, busyBtn.total = step.quest, tagged, total
            busyBtn.text:SetText(("Busy: %d of %d here are tagged by others  ·  |c%scome back later|r"):format(tagged, total, S.AccentHex()))
            busyBtn:ClearAllPoints()
            busyBtn:SetPoint("TOPLEFT", PAD, -y)
            busyBtn:SetPoint("RIGHT", -PAD, 0)
            busyBtn:Show()
            y = y + 16
        end
    end

    -- quests left for later: back near one of them, or the list
    local later = G:LaterList()
    if #later > 0 and not W.db.collapsed then
        local near = G:LaterNearby()
        laterBtn.quests, laterBtn.quest = later, near or later[1]
        if near then
            laterBtn.text:SetText(("|c%sBack near %s|r (left for later)  ·  click to do it now"):format(S.AccentHex(), questTitle(near)))
        else
            laterBtn.text:SetText(("Left for later: %s%s"):format(questTitle(later[1]), #later > 1 and (" +" .. (#later - 1)) or ""))
        end
        laterBtn:ClearAllPoints()
        laterBtn:SetPoint("TOPLEFT", PAD, -y)
        laterBtn:SetPoint("RIGHT", -PAD, 0)
        laterBtn:Show()
        y = y + 16
    end

    -- a guide that fits you better than this one
    local sug, sugWhy = G:Suggestion()
    if sug then
        suggestBtn.id, suggestBtn.why = sug.id, "Fits better: " .. G:ReasonText(sugWhy) .. "."
        suggestBtn.text:SetText("Suggested: " .. sug.title .. "  ·  click to switch")
        suggestBtn:ClearAllPoints()
        suggestBtn:SetPoint("TOPLEFT", PAD, -y)
        suggestBtn:SetPoint("RIGHT", -PAD, 0)
        suggestBtn:Show()
        y = y + 16
    end

    -- quests skipped past earlier in this guide (never accepted, not forced on you)
    local missed = G:Missed()
    if #missed > 0 and not W.db.collapsed then
        missedBtn.quests = missed
        missedBtn.text:SetText(("%d earlier quest%s missed"):format(#missed, #missed == 1 and "" or "s"))
        missedBtn:ClearAllPoints()
        missedBtn:SetPoint("TOPLEFT", PAD, -y)
        missedBtn:SetPoint("RIGHT", -PAD, 0)
        missedBtn:Show()
        y = y + 16
    else
        missedBtn:Hide()
    end

    -- turn-ins held back because their quest isn't finished, or now ready to hand in
    local w = G:Waiting()
    if (#w.ready > 0 or #w.waiting > 0) and not W.db.collapsed then
        waitBtn.data = w
        local text
        if #w.ready > 0 then
            text = ("|cff66d973Ready to turn in:|r %s%s  |c" .. S.AccentHex() .. "(click)|r"):format(questTitle(w.ready[1].quest),
                #w.ready > 1 and (" +" .. (#w.ready - 1)) or "")
        elseif #w.waiting == 1 then
            local left = unfinished(w.waiting[1].quest)
            text = ("Turn-in waiting: %s%s"):format(questTitle(w.waiting[1].quest), left and ("  |cffff7366(" .. left .. ")|r") or "")
        else
            text = ("%d turn-ins waiting on unfinished quests"):format(#w.waiting)
        end
        waitBtn.text:SetText(text)
        waitBtn:ClearAllPoints()
        waitBtn:SetPoint("TOPLEFT", PAD, -y)
        waitBtn:SetPoint("RIGHT", -PAD, 0)
        waitBtn:Show()
        y = y + 16
    else
        waitBtn:Hide()
    end

    -- upcoming (steps already shown on the card as "also here" are left out)
    local rest = {}
    for i = 2, #list do
        if #rest >= W.db.showNext then break end
        if not shownTogether[list[i]] then rest[#rest + 1] = list[i] end
    end
    if #rest > 0 then
        divider:ClearAllPoints()
        divider:SetPoint("TOPLEFT", PAD, -y)
        divider:SetPoint("TOPRIGHT", -PAD, -y)
        divider:Show()
        y = y + 6
        for i = 1, #rest do
            local s = rest[i]
            local r = row(i)
            local st = VERB_STYLE[s.verb] or VERB_STYLE.note
            r.dot:SetTexture(MEDIA .. st.icon)
            r.dot:SetVertexColor(rgb(st.color, 0.85))
            r.text:SetText(UI.StepText(s))
            r:ClearAllPoints()
            r:SetPoint("TOPLEFT", PAD, -y)
            r:SetPoint("RIGHT", -PAD, 0)
            r:Show()
            y = y + 17
        end
    end
    f:SetHeight(y + PAD)
end

card:SetScript("OnClick", function(self, button)
    local step = self.step
    if not step then
        if self.recommend then W.cdb.pickedSmart = nil G:StartRecommended() else UI:ShowPicker("zones") end
        return
    end
    if button == "RightButton" and IsShiftKeyDown() and step.quest then
        G:Later(step.quest)
    elseif button == "RightButton" or step.verb == "note" then
        G:MarkDone(step)
    elseif step.quest and C_QuestLog.IsOnQuest(step.quest) and QuestMapFrame_OpenToQuestDetails then
        QuestMapFrame_OpenToQuestDetails(step.quest)
    else
        ToggleWorldMap()
    end
end)
card:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    if not self.step then
        GameTooltip:AddLine(self.recommend and "Click: start the recommended guide" or "Click: open the guide list")
        GameTooltip:Show()
        return
    end
    GameTooltip:AddLine("Left-click: open on map")
    GameTooltip:AddLine("Right-click: mark this step done", 0.7, 0.7, 0.7)
    if self.step.quest then GameTooltip:AddLine("Shift-right-click: come back to this quest later", 0.7, 0.7, 0.7) end
    GameTooltip:Show()
end)
card:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- live distance: 1s refresh of the sub line only, only while a pinned step is shown
local distTicker
local function syncDistanceTicker()
    local need = f:IsShown() and WP:Current() ~= nil
    if need and not distTicker then
        distTicker = C_Timer.NewTicker(1, function()
            local step = card.step
            if step then
                local s = locationLine(step)
                if step.verb == "note" then s = (s ~= "" and (s .. "  ·  ") or "") .. "click when done" end
                subText:SetText(s)
            end
        end)
    elseif not need and distTicker then
        distTicker:Cancel()
        distTicker = nil
    end
end
f:SetScript("OnShow", function() UI:Render() syncDistanceTicker() end)
f:SetScript("OnHide", syncDistanceTicker)

---------------------------------------------------------------------------
-- Toasts (party events)
---------------------------------------------------------------------------
local toast = CreateFrame("Frame", nil, f)
toast:SetSize(WIDTH, 30)
toast:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 8)
S.Glass(toast, { alpha = 0.8, corner = 10 })
-- flat theme: an accent stripe down the left edge marks it as a notice
local toastStripe = toast:CreateTexture(nil, "ARTWORK")
toastStripe:SetPoint("TOPLEFT", 1, -1)
toastStripe:SetPoint("BOTTOMLEFT", 1, 1)
toastStripe:SetWidth(2)
S.Accent(toastStripe, "color")
local function themeToast() toastStripe:SetShown(S.Square()) end
themeToast()
W:On("WF_THEME_CHANGED", themeToast)
local toastText = fs(toast, 12, C.text)
toastText:SetPoint("LEFT", PAD, 0)
toastText:SetPoint("RIGHT", -PAD, 0)
toastText:SetWordWrap(false)
toast:Hide()
local toastTimer

function UI:Toast(msg)
    toastText:SetText(msg)
    toast:Show()
    if toastTimer then toastTimer:Cancel() end
    toastTimer = C_Timer.NewTimer(6, function() toast:Hide() end)
end

W:On("WF_TURNIN_WAITING", function(_, step)
    local left = unfinished(step.quest)
    UI:Toast(("Can't turn in |cffffd040%s|r yet%s. Moving on; it comes back when it's done.")
        :format(questTitle(step.quest), left and (" (" .. left .. ")") or ""))
end)
W:On("WF_TURNIN_READY", function(_, steps)
    if #steps == 1 then
        UI:Toast(("|cff66d973%s|r is finished. Click \"Ready to turn in\" to go hand it in."):format(questTitle(steps[1].quest)))
    else
        UI:Toast(("|cff66d973%d quests|r you moved past are ready to turn in."):format(#steps))
    end
end)

local TOAST_VERB = { ready = "finished", turnedin = "turned in", accepted = "picked up" }
W:On("WF_PARTY_EVENT", function(_, name, q, state)
    if not TOAST_VERB[state] or not W.db.partyToasts then return end
    -- only interesting if it's a quest we're on or our guide uses
    if not (QS:IsOnQuest(q) or state ~= "accepted") then return end
    UI:Toast(("|c" .. S.AccentHex() .. "%s|r %s %s"):format(name, TOAST_VERB[state], questTitle(q)))
end)

---------------------------------------------------------------------------
-- Guide picker
---------------------------------------------------------------------------
-- declared before the tab buttons below: their click handlers must see this local, not a global
local pickerTab = "zones"   -- zones | professions
local picker = CreateFrame("Frame", "OnwardPicker", UIParent)
picker:SetSize(300, 330)
picker:SetFrameStrata("DIALOG")
picker:SetClampedToScreen(true)
picker:EnableMouse(true)
picker:Hide()
do
    S.Glass(picker, { alpha = 0.86, titleBar = 36 })
    -- two tabs in the title strip: leveling (zone) guides and profession guides
    -- The font may not be loaded when this runs (text width reads 0), so the click area gets a
    -- fixed minimum width here and is re-measured on every RenderPicker.
    local function tab(label, key, anchor, x, minW)
        local b = CreateFrame("Button", nil, picker)
        b:SetSize(minW, 22)
        b:SetFrameLevel(picker:GetFrameLevel() + 10)
        b.minW = minW
        b.text = fs(b, 13, C.sub)
        b.text:SetPoint("LEFT")
        b.text:SetText(label)
        b:SetScript("OnEnter", function(self) if self.key ~= pickerTab then self.text:SetTextColor(rgb(C.text)) end end)
        b:SetScript("OnLeave", function(self) if self.key ~= pickerTab then self.text:SetTextColor(rgb(C.sub)) end end)
        b:SetPoint("TOPLEFT", anchor or picker, anchor and "TOPRIGHT" or "TOPLEFT", x, anchor and 0 or -9)
        b:SetScript("OnClick", function() pickerTab = key UI:RenderPicker() end)
        b.key = key
        UI.pickerTabs = UI.pickerTabs or {}
        UI.pickerTabs[key] = b
        return b
    end
    picker.tabZones = tab("Leveling", "zones", nil, PAD, 64)
    picker.tabProf = tab("Professions", "professions", picker.tabZones, 8, 90)
    local close = textButton(picker, "x", nil, function() picker:Hide() end)
    close:SetPoint("TOPRIGHT", -4, -4)
end
function UI:ShowPicker(tabKey)
    pickerTab = tabKey or pickerTab
    if not picker:IsShown() then UI:TogglePicker() else UI:RenderPicker() end
end
local pickerRows = {}
local pickerOffset = 0

local function guideFits(def)
    if def.smart then return pickerTab == "zones" end
    if (def.kind == "profession") ~= (pickerTab == "professions") then return false end
    local f = UnitFactionGroup("player")
    if def.faction and def.faction ~= "" and f and def.faction:sub(1, 1):upper() ~= f:sub(1, 1) then return false end
    return true
end

function UI:RenderPicker()
    for _, t in ipairs({ picker.tabZones, picker.tabProf }) do
        t:SetWidth(math.max(t.minW, (t.text:GetStringWidth() or 0) + 8))
        if t.key == pickerTab then S.Accent(t.text, "text") else t.text:SetTextColor(rgb(C.sub)) end
    end
    local lvl = UnitLevel("player") or 1
    local zone = GetZoneText and GetZoneText() or ""
    -- order: auto guide; guides you've started and not finished (in range); this zone in range;
    -- other in-range guides; the rest by level; finished guides last
    local pct = {}
    local rec = pickerTab == "zones" and G:Recommend()
    local function rank(def)
        local p = pct[def.id]
        if def == rec then return 0 end
        if def.kind == "profession" then return p and 1 or 2 end   -- ones you have first
        local inRange = lvl >= def.levels[1] - 2 and lvl <= def.levels[2]
        if p and p >= 1 then return 6 end
        if p and p > 0 and inRange then return 1 end
        if def.zone == zone and inRange then return 2 end
        if inRange then return 3 end
        if def.zone == zone then return 4 end
        return 5
    end
    local fits = {}
    for i, def in ipairs(G:All()) do
        if guideFits(def) then
            pct[def.id] = G:ProgressFor(def)
            fits[#fits + 1] = { def = def, r = rank(def), i = i }
        end
    end
    table.sort(fits, function(a, b) if a.r ~= b.r then return a.r < b.r end return a.i < b.i end)
    local list = pickerTab == "zones" and { G:Get("smart") } or {}
    for _, e in ipairs(fits) do list[#list + 1] = e.def end
    UI.pickerList = list
    local visible = 13
    pickerOffset = math.max(0, math.min(pickerOffset, #list - visible))
    for _, r in ipairs(pickerRows) do r:Hide() end
    for i = 1, math.min(visible, #list) do
        local def = list[i + pickerOffset]
        local r = pickerRows[i]
        if not r then
            r = CreateFrame("Button", nil, picker)
            r:SetHeight(20)
            r.hl = S.Nine(r, "HIGHLIGHT", 0, MEDIA .. "glass_body", 64, 16, 8, 0)
            r.hl:SetColor(1, 1, 1, 0.07)
            r.text = fs(r, 12, C.text)
            r.text:SetWordWrap(false)
            r.text:SetPoint("LEFT", 6, 0)
            r.lv = fs(r, 11, C.dim)
            r.lv:SetPoint("RIGHT", -4, 0)
            r.text:SetPoint("RIGHT", r.lv, "LEFT", -6, 0)
            r:SetScript("OnClick", function(self)
                W.cdb.pickedSmart = self.id == "smart" or nil   -- chosen on purpose: never swapped out
                G:Activate(self.id)
                picker:Hide()
            end)
            pickerRows[i] = r
        end
        r.id = def.id
        local isActive = G:Active() and G:Active().id == def.id
        local prof = def.kind == "profession"
        local inRange = def.smart or prof or (lvl >= def.levels[1] and lvl <= def.levels[2])
        r.text:SetText((isActive and "|c" .. S.AccentHex() .. "> |r" or "") .. def.title)
        local p = pct[def.id]
        if prof then
            -- your skill in it, or nothing when you haven't learned it
            local rk = W.Prof and W.Prof:Rank(def.skill)
            r.text:SetTextColor(rgb(rk and C.text or C.sub))
            r.lv:SetText(rk and ("|c" .. S.AccentHex() .. "%d|r/300"):format(rk) or "")
        else
            r.text:SetTextColor(rgb(inRange and C.text or C.sub))
            local done = ""
            if p and p >= 1 then done = "  |cff66d973done|r"
            elseif p and p > 0 then done = ("  |c" .. S.AccentHex() .. "%d%%|r"):format(math.floor(p * 100)) end
            if def == rec then
                -- the title already shows the level range: make room for the label instead
                r.text:SetTextColor(rgb(C.accent))
                r.lv:SetText("|c" .. S.AccentHex() .. "recommended|r" .. done)
            else
                r.lv:SetText((def.smart and "any" or (def.levels[1] .. "-" .. def.levels[2])) .. done)
            end
        end
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", PAD - 6, -38 - (i - 1) * 21)
        r:SetPoint("RIGHT", -PAD + 4, 0)
        r:Show()
    end
end

picker:EnableMouseWheel(true)
picker:SetScript("OnMouseWheel", function(_, d) pickerOffset = pickerOffset - d UI:RenderPicker() end)

function UI:TogglePicker()
    if picker:IsShown() then picker:Hide() return end
    picker:ClearAllPoints()
    if f:IsShown() then picker:SetPoint("TOPRIGHT", f, "TOPLEFT", -6, 0) else picker:SetPoint("CENTER") end
    UI:RenderPicker()
    picker:Show()
end

---------------------------------------------------------------------------
-- Copy window (recorder output)
---------------------------------------------------------------------------
local copy
function UI.ShowText(heading, text)
    if not copy then
        copy = CreateFrame("Frame", "OnwardCopy", UIParent)
        copy:SetSize(560, 420)
        copy:SetPoint("CENTER")
        copy:SetFrameStrata("DIALOG")
        copy:EnableMouse(true)
        S.Glass(copy, { alpha = 0.9, titleBar = 36 })
        copy.head = fs(copy, 13, C.accent)
        copy.head:SetPoint("TOPLEFT", PAD, -12)
        local close = textButton(copy, "x", nil, function() copy:Hide() end)
        close:SetPoint("TOPRIGHT", -4, -4)
        local sf = CreateFrame("ScrollFrame", nil, copy, "UIPanelScrollFrameTemplate")
        sf:SetPoint("TOPLEFT", PAD, -32)
        sf:SetPoint("BOTTOMRIGHT", -30, PAD)
        local eb = CreateFrame("EditBox", nil, sf)
        eb:SetMultiLine(true)
        eb:SetAutoFocus(false)
        S.Font(eb, 12, "body")
        eb:SetWidth(500)
        eb:SetScript("OnEscapePressed", function() copy:Hide() end)
        sf:SetScrollChild(eb)
        copy.eb = eb
    end
    copy.head:SetText(heading .. "   |cff888888(Ctrl+A, Ctrl+C)|r")
    copy.eb:SetText(text)
    copy:Show()
    copy.eb:SetFocus()
    copy.eb:HighlightText()
end

---------------------------------------------------------------------------
-- Wiring
---------------------------------------------------------------------------
local function place()
    f:ClearAllPoints()
    local p = W.db.point
    if p then f:SetPoint(p[1], UIParent, p[2], p[3], p[4]) else f:SetPoint("RIGHT", UIParent, "RIGHT", -40, 120) end
    f:SetScale(W.db.scale or 1)
    -- older saves (and the default) are centre / right anchored: convert once laid out
    if not p or p[1] ~= "TOPLEFT" then C_Timer.After(0, pinTop) end
end

W:On("WF_INIT", function()
    place()
    if not W.cdb.hidden then f:Show() end
end)
W:On("WF_RESET_POSITION", place)
W:On("WF_TOGGLE_PANEL", function()
    f:SetShown(not f:IsShown())
    W.cdb.hidden = not f:IsShown()
end)
W:On("WF_SHOW_PICKER", function(_, tabKey) if tabKey then UI:ShowPicker(tabKey) else UI:TogglePicker() end end)
W:On("WF_UPDATED", function() UI:Render() syncDistanceTicker() if picker:IsShown() then UI:RenderPicker() end end)
W:On("WF_PARTY_UPDATED", function() UI:Render() end)
W:On("WF_SETTINGS_CHANGED", function()
    f:SetScale(W.db.scale or 1)
    f:EnableMouse(true)
    UI:Render()
end)
W:On("PLAYER_REGEN_DISABLED", function() if W.db.fadeInCombat then f:SetAlpha(0.3) end end)
W:On("PLAYER_REGEN_ENABLED", function() f:SetAlpha(1) end)
W:On("WF_STEP_CHANGED", function() C_Timer.After(0, syncDistanceTicker) end)
