-- Options window (/ow options, gear on panel, Arrow quick menu -> Settings) and Blizzard Settings entry.
-- Tabbed layout (Questing / Navigation / Appearance / Party & Tools) so settings stay scannable
-- with plenty of vertical headroom.
local _, W = ...
local O = {}
W.Options = O

local S = W.Skin
local ACCENT = S.ACCENT
local controls = {}

local function changed() W:Fire("WF_SETTINGS_CHANGED") W:Fire("WF_UPDATED") end

local function fs(parent, size, r, g, b)
    local t = parent:CreateFontString(nil, "OVERLAY")
    S.Font(t, size + 1, "body")
    if r == ACCENT then S.Accent(t, "text") else t:SetTextColor(r or 0.93, g or 0.94, b or 0.96) end
    t:SetShadowColor(0, 0, 0, 0.6)
    t:SetShadowOffset(1, -1)
    t:SetJustifyH("LEFT")
    return t
end

local function tooltip(owner, text)
    if not text then return end
    owner:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(type(text) == "function" and text() or text, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    owner:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

---------------------------------------------------------------------------
-- Window & Tab Bar
---------------------------------------------------------------------------
local WIN_W, WIN_H = 620, 520
local win = CreateFrame("Frame", "OnwardOptions", UIParent)
win:SetSize(WIN_W, WIN_H)
win:SetPoint("CENTER")
win:SetFrameStrata("DIALOG")
win:SetClampedToScreen(true)
win:SetMovable(true)
win:EnableMouse(true)
win:RegisterForDrag("LeftButton")
win:SetScript("OnDragStart", win.StartMoving)
win:SetScript("OnDragStop", win.StopMovingOrSizing)
win:Hide()
if UISpecialFrames then table.insert(UISpecialFrames, "OnwardOptions") end
O.window = win

do
    S.Glass(win, { alpha = 0.90, corner = 14 })
    local title = fs(win, 16, ACCENT)
    title:SetPoint("TOPLEFT", 18, -14)
    title:SetText("Onward")
    local ver = fs(win, 11, 0.45, 0.48, 0.52)
    ver:SetPoint("LEFT", title, "RIGHT", 8, -1)
    ver:SetText("v" .. W.version)
    local close = CreateFrame("Button", nil, win)
    close:SetSize(24, 24)
    close:SetPoint("TOPRIGHT", -8, -8)
    local x = fs(close, 16, 0.62, 0.65, 0.70)
    x:SetPoint("CENTER")
    x:SetText("x")
    close:SetScript("OnClick", function() win:Hide() end)
    close:SetScript("OnEnter", function() x:SetTextColor(1, 1, 1) end)
    close:SetScript("OnLeave", function() x:SetTextColor(0.62, 0.65, 0.70) end)

    local sep = win:CreateTexture(nil, "ARTWORK")
    sep:SetColorTexture(1, 1, 1, 0.08)
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", 16, -74)
    sep:SetPoint("TOPRIGHT", -16, -74)
end

local TAB_DEFS = {
    { key = "questing",   label = "Questing" },
    { key = "navigation", label = "Navigation" },
    { key = "appearance", label = "Appearance" },
    { key = "party",      label = "Party & Tools" },
}
local tabs, tabButtons = {}, {}
local activeTab = "questing"
local cols = { 20, 322 }
local COL_W = 278

local function selectTab(key)
    if not tabs[key] then return end
    activeTab = key
    for k, page in pairs(tabs) do
        page:SetShown(k == key)
    end
    for k, b in pairs(tabButtons) do
        local on = k == key
        b.bar:SetShown(on)
        if on then
            b.bg:SetColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.16)
            b.text:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3])
        else
            b.bg:SetColor(1, 1, 1, 0.04)
            b.text:SetTextColor(0.68, 0.71, 0.76)
        end
    end
end
O.SelectTab = selectTab
O.tabs, O.tabButtons = tabs, tabButtons

do
    local tabW = math.floor((WIN_W - 36 - 18) / #TAB_DEFS)
    for i, def in ipairs(TAB_DEFS) do
        local b = CreateFrame("Button", nil, win)
        b:SetSize(tabW, 26)
        b:SetPoint("TOPLEFT", 18 + (i - 1) * (tabW + 6), -42)
        b.bg = S.Nine(b, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 6, 0)
        b.bg:SetColor(1, 1, 1, 0.04)
        b.bar = b:CreateTexture(nil, "OVERLAY")
        S.Accent(b.bar, "color")
        b.bar:SetHeight(2)
        b.bar:SetPoint("BOTTOMLEFT", 6, 0)
        b.bar:SetPoint("BOTTOMRIGHT", -6, 0)
        b.bar:Hide()
        b.text = fs(b, 12, 0.68, 0.71, 0.76)
        b.text:SetPoint("CENTER")
        b.text:SetJustifyH("CENTER")
        b.text:SetText(def.label)
        b:SetScript("OnEnter", function(self)
            if activeTab ~= def.key then self.text:SetTextColor(0.93, 0.94, 0.96) end
        end)
        b:SetScript("OnLeave", function(self)
            if activeTab ~= def.key then self.text:SetTextColor(0.68, 0.71, 0.76) end
        end)
        b:SetScript("OnClick", function() selectTab(def.key) end)
        tabButtons[def.key] = b

        local page = CreateFrame("Frame", nil, win)
        page:SetPoint("TOPLEFT", 0, -76)
        page:SetPoint("BOTTOMRIGHT", 0, 12)
        page.cursor = { -10, -10 }
        page:Hide()
        tabs[def.key] = page
    end
end

-- Helper factory scoped to the currently building tab page
local curPage
local function useTab(key) curPage = tabs[key] end

local function section(col, text)
    local c = curPage.cursor
    local y = c[col] - (c[col] < -16 and 12 or 0)
    local h = fs(curPage, 11, ACCENT)
    h:SetPoint("TOPLEFT", cols[col], y)
    h:SetText(text:upper())
    local line = curPage:CreateTexture(nil, "ARTWORK")
    line:SetColorTexture(1, 1, 1, 0.07)
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", cols[col], y - 17)
    line:SetWidth(COL_W)
    c[col] = y - 26
end

local function check(col, key, label, tip, onChange)
    local c = curPage.cursor
    local b = CreateFrame("Button", nil, curPage)
    b:SetSize(COL_W, 22)
    b:SetPoint("TOPLEFT", cols[col], c[col])
    local box = CreateFrame("Frame", nil, b)
    box:SetSize(16, 16)
    box:SetPoint("LEFT", 0, 0)
    local well = S.Nine(box, "ARTWORK", 0, S.MEDIA .. "glass_body", 64, 16, 5, 0)
    well:SetColor(1, 1, 1, 0.10)
    local fill = CreateFrame("Frame", nil, box)
    fill:SetAllPoints()
    local fillBg = S.Nine(fill, "ARTWORK", 1, S.MEDIA .. "glass_body", 64, 16, 5, 0)
    S.Accent(fillBg, "nine")
    local tick = fill:CreateTexture(nil, "OVERLAY")
    tick:SetTexture(S.MEDIA .. "arrive")
    tick:SetSize(18, 18)
    tick:SetPoint("CENTER")
    tick:SetVertexColor(0.05, 0.06, 0.07, 1)
    local t = fs(b, 12)
    t:SetPoint("LEFT", box, "RIGHT", 9, 0)
    t:SetText(label)
    local function refresh() fill:SetShown(W.db[key] and true or false) end
    b:SetScript("OnClick", function()
        W.db[key] = not W.db[key]
        refresh()
        if onChange then onChange(W.db[key]) end
        changed()
    end)
    tooltip(b, tip)
    controls[#controls + 1] = refresh
    c[col] = c[col] - 24
end

local function slider(col, key, label, lo, hi, step, fmt, onChange)
    local c = curPage.cursor
    local t = fs(curPage, 12)
    t:SetPoint("TOPLEFT", cols[col], c[col] - 2)
    t:SetText(label)
    local val = fs(curPage, 12, 0.62, 0.65, 0.70)
    val:SetPoint("TOPRIGHT", curPage, "TOPLEFT", cols[col] + COL_W, c[col] - 2)
    local s = CreateFrame("Slider", nil, curPage)
    s:SetOrientation("HORIZONTAL")
    s:SetSize(COL_W, 14)
    s:SetPoint("TOPLEFT", cols[col], c[col] - 20)
    s:SetMinMaxValues(lo, hi)
    s:SetValueStep(step)
    if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
    local track = s:CreateTexture(nil, "BACKGROUND")
    track:SetColorTexture(1, 1, 1, 0.10)
    track:SetHeight(4)
    track:SetPoint("LEFT") track:SetPoint("RIGHT")
    local thumb = s:CreateTexture(nil, "OVERLAY")
    S.Accent(thumb, "color")
    thumb:SetSize(10, 14)
    s:SetThumbTexture(thumb)
    local busy = false
    s:SetScript("OnValueChanged", function(_, v)
        v = math.floor(v / step + 0.5) * step
        val:SetText(fmt:format(v))
        if busy then return end
        W.db[key] = v
        if onChange then onChange(v) end
        changed()
    end)
    s:EnableMouseWheel(true)
    s:SetScript("OnMouseWheel", function(self, d) self:SetValue(self:GetValue() + d * step) end)
    controls[#controls + 1] = function()
        busy = true
        s:SetValue(W.db[key] or lo)
        val:SetText(fmt:format(W.db[key] or lo))
        busy = false
    end
    c[col] = c[col] - 44
end

-- segmented choice; when swatches=true, draws each theme's glass + accent preview dot
local function choice(col, key, label, items, tip, onChange, swatches)
    local c = curPage.cursor
    local t = fs(curPage, 12)
    t:SetPoint("TOPLEFT", cols[col], c[col] - 2)
    t:SetText(label)
    local perRow = math.min(#items, swatches and 2 or 4)
    local w = math.floor((COL_W - (perRow - 1) * 4) / perRow)
    local h = swatches and 24 or 22
    local btns = {}
    for i, it in ipairs(items) do
        local b = CreateFrame("Button", nil, curPage)
        b:SetSize(w, h)
        local r, cx = math.floor((i - 1) / perRow), (i - 1) % perRow
        b:SetPoint("TOPLEFT", cols[col] + cx * (w + 4), c[col] - 20 - r * (h + 4))
        b.bg = S.Nine(b, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 7, 0)
        b.text = fs(b, 11)
        if swatches then
            local tint, acc = S.ThemeColors(it.value)
            b.dotBg = b:CreateTexture(nil, "ARTWORK")
            b.dotBg:SetTexture(S.MEDIA .. "circle")
            b.dotBg:SetSize(12, 12)
            b.dotBg:SetPoint("LEFT", 7, 0)
            b.dotBg:SetVertexColor(tint[1] + 0.12, tint[2] + 0.12, tint[3] + 0.12, 1)
            b.dot = b:CreateTexture(nil, "OVERLAY")
            b.dot:SetTexture(S.MEDIA .. "circle")
            b.dot:SetSize(7, 7)
            b.dot:SetPoint("CENTER", b.dotBg)
            b.dot:SetVertexColor(acc[1], acc[2], acc[3], 1)
            b.text:SetPoint("LEFT", b.dotBg, "RIGHT", 6, 0)
        else
            b.text:SetPoint("CENTER")
        end
        b.text:SetText(it.label)
        b:SetScript("OnClick", function()
            W.db[key] = it.value
            if onChange then onChange(it.value) end
            for _, fn in ipairs(controls) do fn() end
            selectTab(activeTab)
            changed()
        end)
        tooltip(b, it.tip or tip)
        btns[i] = b
    end
    controls[#controls + 1] = function()
        for i, b in ipairs(btns) do
            local on = W.db[key] == items[i].value
            if on then b.bg:SetColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.85) else b.bg:SetColor(1, 1, 1, 0.08) end
            b.text:SetTextColor(on and 0.05 or 0.93, on and 0.06 or 0.94, on and 0.07 or 0.96)
        end
    end
    c[col] = c[col] - (26 + (h + 4) * math.ceil(#items / perRow))
end

local ROWS, ROW_H = 10, 20
local function autoFontPath() return S.fontOverride or S.FONT_BODY end
local function fontPicker(col, label, tip)
    local c = curPage.cursor
    local t = fs(curPage, 12)
    t:SetPoint("TOPLEFT", cols[col], c[col] - 2)
    t:SetText(label)
    local box = CreateFrame("Button", nil, curPage)
    box:SetSize(COL_W, 22)
    box:SetPoint("TOPLEFT", cols[col], c[col] - 20)
    local bg = S.Nine(box, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 7, 0)
    bg:SetColor(1, 1, 1, 0.08)
    local value = box:CreateFontString(nil, "OVERLAY")
    value:SetPoint("LEFT", 9, 0)
    value:SetPoint("RIGHT", -22, 0)
    value:SetJustifyH("LEFT")
    value:SetTextColor(0.93, 0.94, 0.96)
    local chev = fs(box, 11, 0.62, 0.65, 0.70)
    chev:SetPoint("RIGHT", -9, 0)
    chev:SetText("v")
    box:SetScript("OnEnter", function(self)
        bg:SetColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.28)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tip, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    box:SetScript("OnLeave", function() bg:SetColor(1, 1, 1, 0.08) GameTooltip:Hide() end)

    local list = CreateFrame("Frame", nil, win)
    list:SetFrameStrata("FULLSCREEN_DIALOG")
    list:SetWidth(COL_W)
    list:SetPoint("TOPLEFT", box, "BOTTOMLEFT", 0, -2)
    list:EnableMouse(true)
    list:EnableMouseWheel(true)
    list:Hide()
    local lbg = S.Nine(list, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 7, 0)
    lbg:SetColor(0.035, 0.04, 0.05, 0.97)
    local entries, offset, rows = {}, 0, {}

    local function current()
        local name = W.db.font or "auto"
        if name ~= "auto" and not S.ChosenFont() then name = "auto" end
        return name
    end
    local function paint()
        local cur = current()
        for i, r in ipairs(rows) do
            local e = entries[i + offset]
            r:SetShown(e ~= nil)
            if e then
                r.e = e
                r.text:SetFont(e.path or autoFontPath(), 13, "")
                r.text:SetText(e.label)
                local on = e.name == cur
                if on then r.text:SetTextColor(ACCENT[1], ACCENT[2], ACCENT[3]) else r.text:SetTextColor(0.93, 0.94, 0.96) end
            end
        end
    end
    for i = 1, ROWS do
        local r = CreateFrame("Button", nil, list)
        r:SetSize(COL_W - 8, ROW_H)
        r:SetPoint("TOPLEFT", 4, -4 - (i - 1) * ROW_H)
        local hl = r:CreateTexture(nil, "BACKGROUND")
        hl:SetAllPoints()
        hl:SetColorTexture(1, 1, 1, 0.07)
        hl:Hide()
        r.text = r:CreateFontString(nil, "OVERLAY")
        r.text:SetPoint("LEFT", 6, 0)
        r.text:SetPoint("RIGHT", -6, 0)
        r.text:SetJustifyH("LEFT")
        r.text:SetTextColor(0.93, 0.94, 0.96)
        r:SetScript("OnEnter", function() hl:Show() end)
        r:SetScript("OnLeave", function() hl:Hide() end)
        r:SetScript("OnClick", function(self)
            W.db.font = self.e.name
            list:Hide()
            S.Refresh()
            for _, f in ipairs(controls) do f() end
            changed()
        end)
        rows[i] = r
    end
    list:SetScript("OnMouseWheel", function(_, d)
        offset = math.max(0, math.min(#entries - ROWS, offset - d))
        paint()
    end)
    local function open()
        entries = { { name = "auto", label = "Automatic" } }
        for _, f in ipairs(S.FontChoices()) do entries[#entries + 1] = { name = f.name, label = f.name, path = f.path } end
        local n = math.min(ROWS, #entries)
        list:SetHeight(n * ROW_H + 8)
        offset = 0
        for i, e in ipairs(entries) do
            if e.name == current() then offset = math.max(0, math.min(#entries - ROWS, i - 3)) end
        end
        paint()
        list:Show()
    end
    box:SetScript("OnClick", function() if list:IsShown() then list:Hide() else open() end end)
    win:HookScript("OnHide", function() list:Hide() end)
    curPage:HookScript("OnHide", function() list:Hide() end)

    controls[#controls + 1] = function()
        local name = current()
        value:SetFont(S.ChosenFont() or autoFontPath(), 12, "")
        value:SetText(name == "auto" and "Automatic" or name)
    end
    O.fontList = { open = open, list = list, rows = rows, value = value, entries = function() return entries end }
    c[col] = c[col] - 48
end

local function button(col, label, onClick, width, xoff)
    local c = curPage.cursor
    local b = CreateFrame("Button", nil, curPage)
    b:SetSize(width or COL_W, 24)
    b:SetPoint("TOPLEFT", cols[col] + (xoff or 0), c[col])
    local bg = S.Nine(b, "BACKGROUND", 0, S.MEDIA .. "glass_body", 64, 16, 7, 0)
    bg:SetColor(1, 1, 1, 0.08)
    local t = fs(b, 12)
    t:SetPoint("CENTER")
    t:SetText(label)
    b.label = t
    b:SetScript("OnEnter", function() bg:SetColor(ACCENT[1], ACCENT[2], ACCENT[3], 0.28) end)
    b:SetScript("OnLeave", function() bg:SetColor(1, 1, 1, 0.08) end)
    b:SetScript("OnClick", onClick)
    return b
end

---------------------------------------------------------------------------
-- Tab 1: Questing
---------------------------------------------------------------------------
useTab("questing")
section(1, "Quest Selection")
choice(1, "questMode", "Which quests to do", {
    { value = "all", label = "All", tip = "Every quest in the zone." },
    { value = "efficient", label = "Efficient", tip = "Skip clear time sinks: quests under half the zone's typical XP per minute, unless they unlock a worthwhile follow-up. Keeps at least 85% of the zone's XP." },
    { value = "fastest", label = "Fastest", tip = "Best XP per hour: also skip below-average quests. Keeps at least 60% of the zone's XP, so expect to move on to the next zone sooner." },
}, nil, function() W.Guide:Reload() end)
choice(1, "groupQuests", "Elite and dungeon quests", {
    { value = "show", label = "Show", tip = "Keep them in the guides, marked \"Elite\" or \"Dungeon\" on the panel." },
    { value = "hide", label = "Hide", tip = "Leave them out, with any follow-ups that need them, for solo play." },
}, nil, function() W.Guide:Reload() end)
section(1, "Quest Automation")
check(1, "autoAccept", "Auto-accept guide quests", "Accept the quests the active guide picks up. Hold Shift at an NPC to pause.")
check(1, "autoAcceptAll", "Auto-accept every quest", "Accept any quest offered, guide or not.")
check(1, "autoTurnIn", "Auto turn-in", "Hand in finished quests. Never chooses between several rewards.")
check(1, "highlightBestReward", "Highlight highest-value reward", "When a quest turn-in offers multiple reward choices, highlights the item that sells for the most vendor gold and shows its sell price.")

section(2, "Tracking & Bag Hygiene")
check(2, "passing", "List quests on your way", "Show quests in your log whose mobs are right along your current path.")
check(2, "dropStats", "Show drop rates", "Under \"collect\" objectives: how many of your kills dropped the item, the expected rate (Wowhead's, through Questie), and luck comparison.")
check(2, "bagCleanup", "Flag old quest items in bags", "Shows a link on the panel when your bags hold quest items whose entire quest chain is finished. Voluntary only: nothing is ever deleted automatically.")

section(2, "Quick Actions")
button(2, "Clean quest items", function() W:Fire("WF_SHOW_CLEANUP") end)
curPage.cursor[2] = curPage.cursor[2] - 32
button(2, "Pick a guide", function() W:Fire("WF_SHOW_PICKER", "zones") end, 136)
button(2, "Professions", function() W:Fire("WF_SHOW_PICKER", "professions") end, 136, 142)
curPage.cursor[2] = curPage.cursor[2] - 32

---------------------------------------------------------------------------
-- Tab 2: Navigation
---------------------------------------------------------------------------
useTab("navigation")
section(1, "Nav Arrow & Map")
check(1, "arrow", "Show nav arrow", "Rotating arrow with distance and arrival time.")
check(1, "arrowLocked", "Lock arrow", "Stops dragging and lets clicks pass through the arrow.")
slider(1, "arrowScale", "Arrow size", 0.6, 1.8, 0.05, "%.2f")
slider(1, "arrowTextScale", "Arrow text size", 0.7, 1.6, 0.05, "%.2f")
choice(1, "routeMode", "Route on the world map", {
    { value = "off", label = "Off" },
    { value = "current", label = "Current", tip = "A dotted line from you to the current step, via flight masters when flying is faster." },
    { value = "next", label = "Next stops", tip = "The current step, then upcoming stops numbered in order with hover tooltips." },
})
slider(1, "routeStops", "Route stops ahead", 1, 6, 1, "%d")
check(1, "waypoints", "Blizzard map pin", "Blizzard's own map pin and on-screen marker.")
check(1, "tomtom", "TomTom waypoint (if installed)")

section(2, "Travel")
check(2, "trailBack", "Lead back the way you came", "When returning to a quest giver, follow your own path around cliffs and bridges instead of a straight line.")
check(2, "hearthAdvice", "Suggest your hearthstone", "Suggest hearthing when it is off cooldown and faster than running or flying.")
check(2, "travelAdvice", "Suggest flights", "Point to the nearest flight master when flying beats running.")
check(2, "autoTaxi", "Pick flight automatically", "Take the suggested flight at the flight master. Hold Shift to pick manually.")

section(2, "Action Buttons")
check(2, "targetButton", "Target mob / NPC button", "Targets the nearest living quest mob (or the NPC to talk to). Bindable under Key Bindings > AddOns > Onward.")
check(2, "targetMark", "Mark targeted mob / NPC", "Puts a skull over the targeted mob and a star over the targeted NPC.")
check(2, "itemButton", "Quest item button", "Uses the quest's item beside the target button. Bindable under Key Bindings.", function() W.Item:Sync() end)
check(2, "targetDetached", "Detach buttons into dock", "Moves target and quest item buttons off the card into a movable action-button dock with keybind labels.", function() W.UI:Render() W.Target:Sync() end)

---------------------------------------------------------------------------
-- Tab 3: Appearance
---------------------------------------------------------------------------
local function lookTip(text)
    if S.ChosenFont() then return text .. " Text uses the font you picked under Font." end
    if S.UsingEllesmere() then return text .. " Text uses your EllesmereUI font." end
    return text .. (text:find("plain font") and "" or " Titles in the game's headline font.")
end

useTab("appearance")
section(1, "Theme & Typography")
choice(1, "theme", "Look", {
    { value = "onward", label = "Onward", tip = function() return lookTip("Deep teal glass with a gold edge and gold highlights.") end },
    { value = "glass", label = "Glass", tip = function() return lookTip("Blue-slate glass with green highlights.") end },
    { value = "flat", label = "Ellesmere", tip = function()
        if S.UsingEllesmere() then return lookTip("Dark glass in your EllesmereUI colours.") end
        return "Neutral dark glass with green highlights and one plain font. Uses EllesmereUI colours when installed."
    end },
    { value = "twilight", label = "Twilight", tip = function() return lookTip("Violet glass with teal highlights.") end },
    { value = "alliance", label = "Alliance", tip = function() return lookTip("Navy glass with a blue edge and gold highlights.") end },
    { value = "horde", label = "Horde", tip = function() return lookTip("Dark blood-iron glass with a bronze edge and ember-red highlights.") end },
    { value = "feywood", label = "Feywood", tip = function() return lookTip("Deep moss glass with a violet edge and fae-green highlights.") end },
    { value = "neon", label = "Neon", tip = function() return lookTip("Deep purple glass with a teal edge and hot-pink highlights.") end },
}, nil, function() S.Refresh() end, true)
fontPicker(1, "Font", "Font for all Onward text. Automatic uses EllesmereUI's font when installed, otherwise each look's default. Includes SharedMedia fonts.")
choice(1, "headerArt", "Header art", {
    { value = "off", label = "Off", tip = "Clean glass header with no background art." },
    { value = "shot", label = "Zone art", tip = "Faded zone artwork behind the header, falling back to map tiles." },
    { value = "map", label = "Map strip", tip = "Faded strip of the zone's map behind the header." },
}, nil, function() if W.UI then W.UI.HEADER_ART = nil end end)

section(2, "Panel Layout")
slider(2, "showNext", "Upcoming steps shown", 0, 8, 1, "%d")
slider(2, "scale", "Panel size", 0.7, 1.5, 0.05, "%.2f")
slider(2, "bgAlpha", "Background opacity", 0, 1, 0.05, "%.2f")
check(2, "showObjectives", "Show quest objectives")
check(2, "showParty", "Show party progress")
check(2, "animations", "Animations", "Subtle one-shot animations for progress, step turns, and arrival. Automatically disabled in combat.", function() if not W.db.animations then W.Anim.StopAll() end end)
check(2, "locked", "Lock panel")
check(2, "fadeInCombat", "Fade panel in combat")

---------------------------------------------------------------------------
-- Tab 4: Party & Tools
---------------------------------------------------------------------------
useTab("party")
section(1, "Party Sync")
check(1, "partySync", "Share progress with party", "Sends your current step and quest state to party members running Onward. Questie users show up either way.")
check(1, "partyToasts", "Party pop-ups", "Short notice when someone finishes or turns in a quest.")
check(1, "partyChat", "Announce in party chat", "Also say \"done: <quest>\" in party chat, for people without the addon.")

section(2, "Tools & Maintenance")
button(2, "Choose guide", function() W:Fire("WF_SHOW_PICKER", "zones") end, 136)
button(2, "Professions", function() W:Fire("WF_SHOW_PICKER", "professions") end, 136, 142)
curPage.cursor[2] = curPage.cursor[2] - 32
button(2, "Clean quest items", function() W:Fire("WF_SHOW_CLEANUP") end)
curPage.cursor[2] = curPage.cursor[2] - 32
button(2, "Copy step report", function()
    if W.UI and W.UI.ShowText then
        W.UI.ShowText("Step report (Ctrl+C, then paste at github.com/jghost7/Onward/issues)", W.Guide:Report(""))
    end
end)
curPage.cursor[2] = curPage.cursor[2] - 32
button(2, "Reset positions", function()
    W.db.point, W.db.arrowPoint, W.db.targetPoint = nil, nil, nil
    W:Fire("WF_RESET_POSITION")
end)
curPage.cursor[2] = curPage.cursor[2] - 32

-- expose deepest column depth across all tabs so tests verify every tab fits comfortably inside the window
local deepest = { 0, 0 }
for _, page in pairs(tabs) do
    deepest[1] = math.min(deepest[1], page.cursor[1])
    deepest[2] = math.min(deepest[2], page.cursor[2])
end
O.cursor = deepest
O.pageHeight = WIN_H - 88   -- usable interior height of each tab page

function O:Refresh()
    for _, r in ipairs(controls) do r() end
    selectTab(activeTab)
end
function O:Toggle()
    if win:IsShown() then win:Hide() else O:Refresh() win:Show() end
end

selectTab("questing")
W:On("WF_SHOW_OPTIONS", function() O:Toggle() end)
W:On("WF_THEME_CHANGED", function() selectTab(activeTab) end)

---------------------------------------------------------------------------
-- Blizzard Settings > AddOns entry
---------------------------------------------------------------------------
W:On("WF_INIT", function()
    if not (Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory) then return end
    local canvas = CreateFrame("Frame")
    local t = fs(canvas, 16, ACCENT)
    t:SetPoint("TOPLEFT", 16, -16)
    t:SetText("Onward")
    local d = fs(canvas, 12, 0.8, 0.8, 0.8)
    d:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -10)
    d:SetText("Leveling guide, nav arrow, flights and party sync. All settings live in Onward's own window.")
    local b = CreateFrame("Button", nil, canvas, "UIPanelButtonTemplate")
    b:SetSize(200, 26)
    b:SetPoint("TOPLEFT", d, "BOTTOMLEFT", 0, -14)
    b:SetText("Open Onward options")
    b:SetScript("OnClick", function()
        if SettingsPanel and SettingsPanel:IsShown() then HideUIPanel(SettingsPanel) end
        O:Refresh()
        win:Show()
    end)
    pcall(function()
        local cat = Settings.RegisterCanvasLayoutCategory(canvas, "Onward")
        Settings.RegisterAddOnCategory(cat)
    end)
end)
