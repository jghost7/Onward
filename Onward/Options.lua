-- Options window (/ow options, the gear on the panel, right-click the arrow) and an entry in
-- Blizzard's Settings > AddOns. Custom controls, so the look matches the panel and nothing
-- depends on Blizzard templates that change between clients.
local _, W = ...
local O = {}
W.Options = O

local S = W.Skin
local ACCENT = S.ACCENT   -- shared with the theme: recoloured live
local controls = {}

local function changed() W:Fire("WF_SETTINGS_CHANGED") W:Fire("WF_UPDATED") end

-- r may be the ACCENT table: the text then follows the theme's accent
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
        GameTooltip:SetText(text, 1, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    owner:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

---------------------------------------------------------------------------
-- window
---------------------------------------------------------------------------
local win = CreateFrame("Frame", "OnwardOptions", UIParent)
win:SetSize(640, 780)
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

do
    S.Glass(win, { alpha = 0.88, corner = 14, titleBar = 40 })
    local title = fs(win, 16, ACCENT)
    title:SetPoint("TOPLEFT", 18, -16)
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
end

local cols = { 20, 336 }
local cursor = { -52, -52 }

local function section(col, text)
    local y = cursor[col] - (cursor[col] < -60 and 14 or 0)
    local h = fs(win, 12, ACCENT)
    h:SetPoint("TOPLEFT", cols[col], y)
    h:SetText(text:upper())
    local line = win:CreateTexture(nil, "ARTWORK")
    line:SetColorTexture(1, 1, 1, 0.07)
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", cols[col], y - 18)
    line:SetWidth(284)
    cursor[col] = y - 28
end

local function check(col, key, label, tip, onChange)
    local b = CreateFrame("Button", nil, win)
    b:SetSize(284, 22)
    b:SetPoint("TOPLEFT", cols[col], cursor[col])
    -- toggle box (square in flat, rounded in glass); filled with the accent and a check when on
    local box = CreateFrame("Frame", nil, b)
    box:SetSize(16, 16)
    box:SetPoint("LEFT", 0, 0)
    local well = W.Skin.Nine(box, "ARTWORK", 0, W.Skin.MEDIA .. "glass_body", 64, 16, 5, 0)
    well:SetColor(1, 1, 1, 0.10)
    local fillF = CreateFrame("Frame", nil, box)
    fillF:SetAllPoints()
    local fillBg = W.Skin.Nine(fillF, "ARTWORK", 1, W.Skin.MEDIA .. "glass_body", 64, 16, 5, 0)
    S.Accent(fillBg, "nine")
    local tick = fillF:CreateTexture(nil, "OVERLAY")
    tick:SetTexture(W.Skin.MEDIA .. "arrive")
    tick:SetSize(18, 18)
    tick:SetPoint("CENTER")
    tick:SetVertexColor(0.05, 0.06, 0.07, 1)
    local fill = fillF
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
    cursor[col] = cursor[col] - 24
end

local function slider(col, key, label, lo, hi, step, fmt, onChange)
    local t = fs(win, 12)
    t:SetPoint("TOPLEFT", cols[col], cursor[col] - 2)
    t:SetText(label)
    local val = fs(win, 12, 0.62, 0.65, 0.70)
    val:SetPoint("TOPRIGHT", win, "TOPLEFT", cols[col] + 284, cursor[col] - 2)
    local s = CreateFrame("Slider", nil, win)
    s:SetOrientation("HORIZONTAL")
    s:SetSize(284, 14)
    s:SetPoint("TOPLEFT", cols[col], cursor[col] - 20)
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
    cursor[col] = cursor[col] - 44
end

-- segmented choice: label above, one button per value, the selected one filled with the accent
local function choice(col, key, label, items, tip, onChange)
    local t = fs(win, 12)
    t:SetPoint("TOPLEFT", cols[col], cursor[col] - 2)
    t:SetText(label)
    local w = math.floor(284 / #items) - 2
    local btns = {}
    for i, it in ipairs(items) do
        local b = CreateFrame("Button", nil, win)
        b:SetSize(w, 22)
        b:SetPoint("TOPLEFT", cols[col] + (i - 1) * (w + 3), cursor[col] - 20)
        b.bg = W.Skin.Nine(b, "BACKGROUND", 0, W.Skin.MEDIA .. "glass_body", 64, 16, 7, 0)
        b.text = fs(b, 11)
        b.text:SetPoint("CENTER")
        b.text:SetText(it.label)
        b:SetScript("OnClick", function()
            W.db[key] = it.value
            if onChange then onChange(it.value) end      -- first: a theme change sets the new accent
            for _, r in ipairs(controls) do r() end
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
    cursor[col] = cursor[col] - 50
end

local function button(col, label, onClick, width, xoff)
    local b = CreateFrame("Button", nil, win)
    b:SetSize(width or 284, 24)
    b:SetPoint("TOPLEFT", cols[col] + (xoff or 0), cursor[col])
    local bg = W.Skin.Nine(b, "BACKGROUND", 0, W.Skin.MEDIA .. "glass_body", 64, 16, 7, 0)
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
-- content
---------------------------------------------------------------------------
section(1, "Questing")
choice(1, "questMode", "Which quests to do", {
    { value = "all", label = "All", tip = "Every quest in the zone." },
    { value = "efficient", label = "Efficient", tip = "Skip clear time sinks: quests under half the zone's typical XP per minute, unless they unlock a worthwhile follow-up. Keeps at least 85% of the zone's XP." },
    { value = "fastest", label = "Fastest", tip = "Best XP per hour: also skip below-average quests. Keeps at least 60% of the zone's XP, so expect to move on to the next zone sooner." },
}, nil, function() W.Guide:Reload() end)
choice(1, "groupQuests", "Elite and dungeon quests", {
    { value = "show", label = "Show", tip = "Keep them in the guides, marked \"Elite\" or \"Dungeon\" on the panel." },
    { value = "hide", label = "Hide", tip = "Leave them out, with any follow-ups that need them, for solo play." },
}, nil, function() W.Guide:Reload() end)
check(1, "autoAccept", "Auto-accept guide quests", "Accept the quests the active guide picks up. Hold Shift at an NPC to pause.")
check(1, "autoAcceptAll", "Auto-accept every quest", "Accept any quest offered, guide or not.")
check(1, "autoTurnIn", "Auto turn-in", "Hand in finished quests. Never chooses between several rewards.")

section(1, "Navigation")
check(1, "arrow", "Show nav arrow", "Rotating arrow with distance and arrival time.")
check(1, "arrowLocked", "Lock arrow", "Stops dragging and lets clicks pass through the arrow.")
slider(1, "arrowScale", "Arrow size", 0.6, 1.8, 0.05, "%.2f")
slider(1, "arrowTextScale", "Arrow text size", 0.7, 1.6, 0.05, "%.2f")
choice(1, "routeMode", "Route on the world map", {
    { value = "off", label = "Off" },
    { value = "current", label = "Current", tip = "A dotted line from you to the current step, via flight masters when flying is faster." },
    { value = "next", label = "Next 3", tip = "The current step, then the next three stops, numbered in order." },
})
check(1, "waypoints", "Map pin on the current step", "Blizzard's own map pin and on-screen marker.")
check(1, "tomtom", "TomTom waypoint (if installed)")
check(1, "targetButton", "Quest mob target button", "A crosshair on kill and loot steps: click it, or bind a key under Key Bindings > AddOns > Onward, to target the nearest living quest mob.")
check(1, "targetMark", "Mark the target with a skull", "Puts a skull over the mob the target button picks, so it stands out in a crowd.")
check(1, "itemButton", "Quest item button", "On steps where the quest has you use an item, a button that uses it, beside the target button. Bind a key under Key Bindings > AddOns > Onward.", function() W.Item:Sync() end)
check(1, "targetDetached", "Buttons in a dock", "Moves the target and quest item buttons off the step card into a dock of action-button-sized buttons you can place anywhere, e.g. above your action bars, with your key bindings shown. Right-drag the target button to move it.", function() W.UI:Render() W.Target:Sync() end)

section(1, "Travel")
check(1, "trailBack", "Lead back the way you came", "When you head back to a quest giver you walked away from, the arrow follows your own path (around cliffs, over bridges) instead of a straight line.")
check(1, "hearthAdvice", "Suggest your hearthstone", "When your hearthstone is ready and hearthing beats running or flying to the next step, the arrow says so. Onward learns where you're bound when you set it, or when you're in that town.")
check(1, "travelAdvice", "Suggest flights", "When a learned flight path beats running, the arrow points to the flight master.")
check(1, "autoTaxi", "Pick the flight automatically", "At the flight master, take the flight the guide or suggestion wants. Hold Shift when you talk to the flight master to pick your own destination.")

section(2, "Panel")
choice(2, "theme", "Look", {
    { value = "onward", label = "Onward", tip = "The logo's colours: deep teal glass with a gold edge and gold highlights." },
    { value = "glass", label = "Glass", tip = "Blue-slate glass with green highlights." },
    { value = "flat", label = "Ellesmere", tip = "Neutral dark glass with green highlights and a plain font. With EllesmereUI installed it uses your EllesmereUI accent colour, panel colour and font." },
}, nil, function() S.Refresh() end)
slider(2, "showNext", "Upcoming steps shown", 0, 8, 1, "%d")
slider(2, "scale", "Panel size", 0.7, 1.5, 0.05, "%.2f")
slider(2, "bgAlpha", "Background opacity", 0, 1, 0.05, "%.2f")
choice(2, "headerArt", "Header art", {
    { value = "shot", label = "Zone shot", tip = "A faded picture of the guide's zone behind the title. Zones without one show the map." },
    { value = "map", label = "Map", tip = "A faded strip of the guide's zone map behind the title." },
    { value = "off", label = "Off" },
}, nil, function() W.UI:Render() end)
check(2, "showObjectives", "Show quest objectives")
check(2, "showParty", "Show party progress")
check(2, "dropStats", "Show drop rates", "Under \"collect\" objectives: how many of your kills dropped the item, the expected rate (Wowhead's, through Questie) and whether you're luckier or unluckier than that.")
check(2, "locked", "Lock panel")
check(2, "fadeInCombat", "Fade panel in combat")

section(2, "Party")
check(2, "partySync", "Share progress with party", "Sends your current step and quest state to party members running Onward. Questie users show up either way.")
check(2, "partyToasts", "Party pop-ups", "Short notice when someone finishes or turns in a quest.")
check(2, "partyChat", "Announce in party chat", "Also say \"done: <quest>\" in party chat, for people without the addon.")

section(2, "Tools")
local guidesBtn = button(2, "Choose guide", function() W:Fire("WF_SHOW_PICKER") end, 138)
local recBtn = button(2, "Record route", function() W.Recorder:Command(W.cdb.recording and "stop" or "start") O:Refresh() end, 138, 146)
cursor[2] = cursor[2] - 30
button(2, "Show recording", function() W.Recorder:Command("show") end, 138)
button(2, "Reset positions", function()
    W.db.point, W.db.arrowPoint = nil, nil
    W:Fire("WF_RESET_POSITION")
end, 138, 146)
cursor[2] = cursor[2] - 30
controls[#controls + 1] = function() recBtn.label:SetText(W.cdb.recording and "Stop recording" or "Record route") end

O.cursor = cursor   -- lowest point used in each column (tests check it fits the window)
function O:Refresh() for _, r in ipairs(controls) do r() end end
function O:Toggle()
    if win:IsShown() then win:Hide() else O:Refresh() win:Show() end
end

W:On("WF_SHOW_OPTIONS", function() O:Toggle() end)

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
