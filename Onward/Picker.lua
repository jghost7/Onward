-- Guide picker (OnwardPicker): Leveling & Professions tabs, live search filter, section headers,
-- visible scrollbar, and guide preview tooltips.
local _, W = ...
local UI = W.UI
local G, S = W.Guide, W.Skin

local MEDIA = S.MEDIA
local PAD = 14
local C = {
    text   = { 0.93, 0.94, 0.96 },
    sub    = { 0.62, 0.65, 0.70 },
    dim    = { 0.45, 0.48, 0.52 },
    accent = S.ACCENT,
}
local function rgb(t, a) return t[1], t[2], t[3], a or t[4] or 1 end

local function fs(parent, size, color)
    local t = parent:CreateFontString(nil, "OVERLAY")
    S.Font(t, size, "body")
    t:SetShadowColor(0, 0, 0, 0.6)
    t:SetShadowOffset(1, -1)
    if color == C.accent then S.Accent(t, "text") else t:SetTextColor(rgb(color)) end
    t:SetJustifyH("LEFT")
    t:SetWordWrap(false)
    return t
end

local pickerTab = "zones"   -- zones | professions
local pickerOffset = 0
local searchText = ""

local picker = CreateFrame("Frame", "OnwardPicker", UIParent)
picker:SetSize(324, 396)
picker:SetFrameStrata("DIALOG")
picker:SetClampedToScreen(true)
picker:EnableMouse(true)
picker:EnableMouseWheel(true)
picker:Hide()
if UISpecialFrames then table.insert(UISpecialFrames, "OnwardPicker") end
S.Glass(picker, { alpha = 0.90, corner = 12 })

-- tabs in title strip
local function makeTab(label, key, anchor, x, minW)
    local b = CreateFrame("Button", nil, picker)
    b:SetSize(minW, 22)
    b:SetFrameLevel(picker:GetFrameLevel() + 10)
    b.minW = minW
    b.key = key
    b.text = fs(b, 13, C.sub)
    b.text:SetPoint("LEFT")
    b.text:SetText(label)
    b.bar = b:CreateTexture(nil, "ARTWORK")
    S.Accent(b.bar, "color")
    b.bar:SetHeight(2)
    b.bar:SetPoint("BOTTOMLEFT", 0, -2)
    b.bar:SetPoint("BOTTOMRIGHT", -4, -2)
    b.bar:Hide()
    b:SetScript("OnEnter", function(self) if self.key ~= pickerTab then self.text:SetTextColor(rgb(C.text)) end end)
    b:SetScript("OnLeave", function(self) if self.key ~= pickerTab then self.text:SetTextColor(rgb(C.sub)) end end)
    b:SetScript("OnClick", function()
        if pickerTab ~= key then pickerOffset = 0 end
        pickerTab = key
        UI:RenderPicker()
    end)
    b:SetPoint("TOPLEFT", anchor or picker, anchor and "TOPRIGHT" or "TOPLEFT", x, anchor and 0 or -9)
    UI.pickerTabs = UI.pickerTabs or {}
    UI.pickerTabs[key] = b
    return b
end
picker.tabZones = makeTab("Leveling", "zones", nil, PAD, 66)
picker.tabProf = makeTab("Professions", "professions", picker.tabZones, 10, 92)

local closeBtn = CreateFrame("Button", nil, picker)
closeBtn:SetSize(22, 22)
closeBtn:SetPoint("TOPRIGHT", -6, -6)
local closeLbl = fs(closeBtn, 14, C.sub)
closeLbl:SetPoint("CENTER")
closeLbl:SetText("x")
closeBtn:SetScript("OnEnter", function() closeLbl:SetTextColor(rgb(C.text)) end)
closeBtn:SetScript("OnLeave", function() closeLbl:SetTextColor(rgb(C.sub)) end)
closeBtn:SetScript("OnClick", function() picker:Hide() end)

-- search filter box
local searchWrap = CreateFrame("Frame", nil, picker)
searchWrap:SetHeight(24)
searchWrap:SetPoint("TOPLEFT", PAD, -36)
searchWrap:SetPoint("TOPRIGHT", -PAD, -36)
local searchBg = S.Nine(searchWrap, "BACKGROUND", 0, MEDIA .. "glass_body", 64, 16, 6, 0)
searchBg:SetColor(1, 1, 1, 0.07)

local searchBox = CreateFrame("EditBox", nil, searchWrap)
searchBox:SetAutoFocus(false)
searchBox:SetPoint("LEFT", 8, 0)
searchBox:SetPoint("RIGHT", -24, 0)
searchBox:SetHeight(20)
S.Font(searchBox, 12, "body")
searchBox:SetTextColor(rgb(C.text))
searchBox:SetText("")

local placeholder = fs(searchWrap, 11, C.dim)
placeholder:SetPoint("LEFT", 8, 0)
placeholder:SetText("Filter guides by zone or level...")

local clearBtn = CreateFrame("Button", nil, searchWrap)
clearBtn:SetSize(18, 18)
clearBtn:SetPoint("RIGHT", -3, 0)
local clearLbl = fs(clearBtn, 12, C.dim)
clearLbl:SetPoint("CENTER")
clearLbl:SetText("x")
clearBtn:Hide()
clearBtn:SetScript("OnEnter", function() clearLbl:SetTextColor(rgb(C.text)) end)
clearBtn:SetScript("OnLeave", function() clearLbl:SetTextColor(rgb(C.dim)) end)
clearBtn:SetScript("OnClick", function()
    searchBox:SetText("")
    searchText = ""
    pickerOffset = 0
    placeholder:Show()
    clearBtn:Hide()
    UI:RenderPicker()
end)

searchBox:SetScript("OnTextChanged", function(self)
    local txt = self:GetText() or ""
    if txt ~= searchText then
        searchText = txt
        pickerOffset = 0
        placeholder:SetShown(txt == "")
        clearBtn:SetShown(txt ~= "")
        UI:RenderPicker()
    end
end)
searchBox:SetScript("OnEscapePressed", function(self)
    if (self:GetText() or "") ~= "" then
        self:SetText("")
        searchText = ""
        pickerOffset = 0
        placeholder:Show()
        clearBtn:Hide()
        UI:RenderPicker()
    else
        self:ClearFocus()
        picker:Hide()
    end
end)

local scrollbar = W.Popups and W.Popups.MakeScrollbar(picker, -68, 12)
local pickerRows = {}
local VISIBLE = 14
local ROW_H = 22

UI.picker = picker
UI.pickerSearch = searchBox

local function guideFits(def)
    if def.smart then return pickerTab == "zones" end
    if (def.kind == "profession") ~= (pickerTab == "professions") then return false end
    if not G:FactionMatches(def) then return false end
    if def.class then
        local _, cls = UnitClass("player")
        if cls and not ("," .. def.class:upper() .. ","):find("," .. cls:upper() .. ",", 1, true) then return false end
    end
    return true
end

local function matchesSearch(def, needle)
    if needle == "" then return true end
    local t = (def.title or ""):lower()
    if t:find(needle, 1, true) then return true end
    local z = (def.zone or ""):lower()
    if z:find(needle, 1, true) then return true end
    if def.levels then
        local lv = ("%d-%d"):format(def.levels[1], def.levels[2])
        if lv:find(needle, 1, true) then return true end
        local num = tonumber(needle)
        if num and num >= def.levels[1] and num <= def.levels[2] then return true end
    end
    return false
end

local SECTION_NAME = {
    [0] = "RECOMMENDED",
    [1] = "IN PROGRESS",
    [2] = "YOUR LEVEL",
    [3] = "YOUR LEVEL",
    [4] = "OTHER ZONES",
    [5] = "OTHER ZONES",
    [6] = "COMPLETED",
}

function UI:RenderPicker()
    for _, t in ipairs({ picker.tabZones, picker.tabProf }) do
        t:SetWidth(math.max(t.minW, (t.text:GetStringWidth() or 0) + 10))
        local on = t.key == pickerTab
        if on then S.Accent(t.text, "text") else t.text:SetTextColor(rgb(C.sub)) end
        t.bar:SetShown(on)
    end
    local lvl = UnitLevel("player") or 1
    local zone = GetZoneText and GetZoneText() or ""
    local needle = (searchText or ""):lower():match("^%s*(.-)%s*$")
    local pct = {}
    local rec = pickerTab == "zones" and G:Recommend()

    local function rank(def)
        local p = pct[def.id]
        if def == rec then return 0 end
        if def.kind == "profession" then return p and 1 or 2 end
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
        if guideFits(def) and matchesSearch(def, needle) then
            pct[def.id] = G:ProgressFor(def)
            fits[#fits + 1] = { def = def, r = rank(def), i = i }
        end
    end
    table.sort(fits, function(a, b) if a.r ~= b.r then return a.r < b.r end return a.i < b.i end)

    -- UI.pickerList keeps pure guide definitions (tests inspect this directly)
    local guideList = {}
    local smart = pickerTab == "zones" and G:Get("smart")
    if smart and matchesSearch(smart, needle) then guideList[#guideList + 1] = smart end
    for _, e in ipairs(fits) do guideList[#guideList + 1] = e.def end
    UI.pickerList = guideList

    -- display rows: optional section headers when browsing Leveling without a filter
    local entries = {}
    if smart and matchesSearch(smart, needle) then
        entries[#entries + 1] = { kind = "guide", def = smart }
    end
    local lastSec
    local useSections = (pickerTab == "zones" and needle == "")
    for _, e in ipairs(fits) do
        if useSections then
            local sec = SECTION_NAME[e.r]
            if sec and sec ~= lastSec then
                lastSec = sec
                entries[#entries + 1] = { kind = "header", text = sec }
            end
        end
        entries[#entries + 1] = { kind = "guide", def = e.def }
    end

    pickerOffset = math.max(0, math.min(pickerOffset, math.max(0, #entries - VISIBLE)))
    if scrollbar then scrollbar:Update(pickerOffset, VISIBLE, #entries) end

    for _, r in ipairs(pickerRows) do r:Hide() end
    for i = 1, math.min(VISIBLE, #entries) do
        local entry = entries[i + pickerOffset]
        local r = pickerRows[i]
        if not r then
            r = CreateFrame("Button", nil, picker)
            r:SetHeight(ROW_H - 1)
            r.hl = S.Nine(r, "HIGHLIGHT", 0, MEDIA .. "glass_body", 64, 16, 6, 0)
            r.hl:SetColor(1, 1, 1, 0.08)
            r.line = r:CreateTexture(nil, "ARTWORK")
            r.line:SetColorTexture(1, 1, 1, 0.06)
            r.line:SetHeight(1)
            r.line:SetPoint("BOTTOMLEFT", 6, 1)
            r.line:SetPoint("BOTTOMRIGHT", -4, 1)
            r.line:Hide()
            r.text = fs(r, 12, C.text)
            r.text:SetPoint("LEFT", 6, 0)
            r.lv = fs(r, 11, C.dim)
            r.lv:SetPoint("RIGHT", -6, 0)
            r.lv:SetJustifyH("RIGHT")
            r.text:SetPoint("RIGHT", r.lv, "LEFT", -6, 0)
            r:SetScript("OnClick", function(self)
                if not self.id then return end
                W.cdb.pickedSmart = self.id == "smart" or nil
                G:Activate(self.id)
                picker:Hide()
            end)
            r:SetScript("OnEnter", function(self)
                local d = self.def
                if not d then return end
                GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                GameTooltip:AddLine(d.title or d.id)
                if d.smart then
                    GameTooltip:AddLine("Automatically orders the quests currently in your quest log.", 0.82, 0.84, 0.88, true)
                elseif d.kind == "profession" then
                    local rk = W.Prof and W.Prof:Rank(d.skill)
                    GameTooltip:AddLine(rk and ("Current skill: %d / 300"):format(rk) or "Profession not yet learned.", 0.82, 0.84, 0.88)
                else
                    if d.levels then GameTooltip:AddLine(("Levels %d–%d"):format(d.levels[1], d.levels[2]), 0.82, 0.84, 0.88) end
                    local p = self.pct
                    if p then
                        GameTooltip:AddLine(("Progress: %d%%"):format(math.floor(p * 100 + 0.5)), S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
                    end
                end
                GameTooltip:AddLine("Click to activate this guide.", 0.62, 0.65, 0.70)
                GameTooltip:Show()
            end)
            r:SetScript("OnLeave", function() GameTooltip:Hide() end)
            pickerRows[i] = r
        end

        if entry.kind == "header" then
            r.id, r.def, r.pct = nil, nil, nil
            r.hl:SetShown(false)
            r.line:Show()
            r.text:SetText(entry.text)
            r.text:SetTextColor(rgb(C.dim))
            r.lv:SetText("")
        else
            local def = entry.def
            r.id, r.def, r.pct = def.id, def, pct[def.id]
            r.hl:SetShown(true)
            r.line:Hide()
            local isActive = G:Active() and G:Active().id == def.id
            local prof = def.kind == "profession"
            local inRange = def.smart or prof or (lvl >= def.levels[1] and lvl <= def.levels[2])
            r.text:SetText((isActive and "|c" .. S.AccentHex() .. "> |r" or "") .. def.title)
            local p = pct[def.id]
            if prof then
                local rk = W.Prof and W.Prof:Rank(def.skill)
                r.text:SetTextColor(rgb(rk and C.text or C.sub))
                r.lv:SetText(rk and ("|c" .. S.AccentHex() .. "%d|r/300"):format(rk) or "")
            else
                r.text:SetTextColor(rgb(inRange and C.text or C.sub))
                local done = ""
                if p and p >= 1 then done = "  |cff66d973done|r"
                elseif p and p > 0 then done = ("  |c" .. S.AccentHex() .. "%d%%|r"):format(math.floor(p * 100)) end
                if def == rec then
                    r.text:SetTextColor(rgb(C.accent))
                    r.lv:SetText("|c" .. S.AccentHex() .. "recommended|r" .. done)
                else
                    r.lv:SetText((def.smart and "any" or (def.levels[1] .. "-" .. def.levels[2])) .. done)
                end
            end
        end
        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", PAD - 6, -68 - (i - 1) * ROW_H)
        r:SetPoint("RIGHT", -PAD - 2, 0)
        r:Show()
    end
end

picker:SetScript("OnMouseWheel", function(_, d)
    pickerOffset = pickerOffset - d
    UI:RenderPicker()
end)

function UI:ShowPicker(tabKey)
    if tabKey and tabKey ~= pickerTab then pickerOffset = 0 end
    pickerTab = tabKey or pickerTab
    if not picker:IsShown() then UI:TogglePicker() else UI:RenderPicker() end
end

function UI:TogglePicker()
    if picker:IsShown() then picker:Hide() return end
    picker:ClearAllPoints()
    if UI.panel and UI.panel:IsShown() then
        picker:SetPoint("TOPRIGHT", UI.panel, "TOPLEFT", -6, 0)
    else
        picker:SetPoint("CENTER")
    end
    UI:RenderPicker()
    picker:Show()
end

W:On("WF_SHOW_PICKER", function(_, tabKey) if tabKey then UI:ShowPicker(tabKey) else UI:TogglePicker() end end)
W:On("WF_UPDATED", function() if picker:IsShown() then UI:RenderPicker() end end)
