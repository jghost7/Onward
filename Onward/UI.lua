-- Panel UI: one compact card for the current step, party status under it, upcoming steps dimmed.
-- Everything redraws only on WF_UPDATED / WF_PARTY_UPDATED (both debounced upstream).
local _, W = ...
local UI = {}
UI.HEADER_ART = "off"   -- art behind the panel header: off for now (the Header art option is gone)
W.UI = UI

local G, QS, P, WP = W.Guide, W.QuestState, W.Party, W.Waypoint

local S = W.Skin
local A = W.Anim
local WIDTH = 310
local PAD = 14
local FONT = S.FONT_BODY          -- body text: clean, slightly condensed
local HEAD = S.FONT_HEAD          -- the current step's headline

local C = {
    bg      = { 0.055, 0.063, 0.078, 0.92 },
    line    = { 1, 1, 1, 0.07 },
    accent  = S.ACCENT,                  -- the theme's accent (shared table, recoloured live)
    text    = { 0.93, 0.94, 0.96 },
    hint    = { 0.87, 0.81, 0.62 },          -- quest hints: warm parchment, apart from objectives
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
    home     = { color = C.accent, icon = "arrive" },
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
    elseif v == "fly" then
        -- the place (the flight point's in-game name), not the flight master; the zone as a fallback
        local zone, who = W.Travel.SplitFlightNpc(step.npc)
        local place = step.at and W.Travel:PlaceAt(step.at.map, step.at.x, step.at.y)
        return "Fly to " .. (place or zone or who or step.note or "the next flight point")
    elseif v == "level" then return ("Reach level %d"):format(step.level or 0)
    elseif v == "home" then return "Set your hearthstone here"
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
-- the glint that runs along the bar as it grows (Anim)
local barGlint = f:CreateTexture(nil, "ARTWORK", nil, 2)
barGlint:SetTexture(MEDIA .. "glow")
if barGlint.SetBlendMode then barGlint:SetBlendMode("ADD") end
barGlint:SetSize(26, 12)
barGlint:Hide()

-- header art (Options > Panel): a picture of the guide's zone, or a faded strip of its map, masked
-- so it fades out under the title and toward the card; a little variety per guide
local ART_TOP, ART_H = 1, 44    -- behind the title row; colourless, faint, and masked away from the title
local artTiles = {}
local artMask = f.CreateMaskTexture and f:CreateMaskTexture()
for i = 1, 2 do
    local t = f:CreateTexture(nil, "BACKGROUND", nil, -3)
    t:SetHeight(ART_H)
    if t.SetDesaturation then t:SetDesaturation(1) end   -- grey only: it must never compete with the text
    t:Hide()
    artTiles[i] = t
end
artTiles[1]:SetPoint("TOPLEFT", 4, -ART_TOP)
artTiles[1]:SetPoint("RIGHT", f, "TOP", 0, 0)
artTiles[2]:SetPoint("TOPLEFT", artTiles[1], "TOPRIGHT")
artTiles[2]:SetPoint("RIGHT", f, "RIGHT", -4, 0)
if artMask then
    artMask:SetTexture(MEDIA .. "zone_mask", "CLAMPTOBLACKADDITIONAL", "CLAMPTOBLACKADDITIONAL")
    artMask:SetPoint("TOPLEFT", artTiles[1])
    artMask:SetPoint("BOTTOMRIGHT", artTiles[2])
    for _, t in ipairs(artTiles) do if t.AddMaskTexture then t:AddMaskTexture(artMask) end end
end
local ART_ALPHA = artMask and 0.16 or 0.07   -- without a mask the edges are hard, so fainter still

-- the guide's own map: the one most of its steps are on (the smart guide: where you are)
local guideMap = {}
local function mapFor(g)
    if not g then return end
    if g.id == "smart" or g.kind == "profession" then return C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player") end
    if guideMap[g.id] == nil then
        local n, best, bestN, named = {}, false, 0, nil
        for _, s in ipairs(g.steps or {}) do
            local m = s.at and s.at.map
            if m then
                n[m] = (n[m] or 0) + 1
                if n[m] > bestN then best, bestN = m, n[m] end
                -- the map named like the guide's zone wins (Alterac's steps are mostly in Hillsbrad)
                if not named and g.zone and C_Map.GetMapInfo then
                    local info = C_Map.GetMapInfo(m)
                    if info and info.name == g.zone then named = m end
                end
            end
        end
        guideMap[g.id] = named or best
    end
    return guideMap[g.id] or nil
end

-- two map tiles from the middle of the zone, the middle band of each
local artFor = {}
function UI.ZoneArt(map)
    if not map then return end
    if not artFor[map] then   -- only found art is cached: map data can arrive late
        local ok, layers = pcall(C_Map.GetMapArtLayers or function() end, map)
        local ok2, tex = pcall(C_Map.GetMapArtLayerTextures or function() end, map, 1)
        local L = ok and type(layers) == "table" and layers[1]
        if L and ok2 and type(tex) == "table" and #tex > 1 and (L.tileWidth or 0) > 0 then
            local cols = math.ceil(L.layerWidth / L.tileWidth)
            local rows = math.ceil(L.layerHeight / L.tileHeight)
            local r = math.floor((rows - 1) / 2)
            local c = math.max(0, math.floor(cols / 2) - 1)
            local a, b = tex[r * cols + c + 1], tex[r * cols + c + 2]
            if a and b then artFor[map] = { a, b } end
        end
    end
    return artFor[map]
end

-- a picture of the zone itself (Onward/ZoneShots.lua): a screenshot (tools/make_zone_art.py, shown
-- faded) or a generated ink painting (tools/gen_zone_art.py: pale ink on black, drawn additively so
-- the black adds nothing and only the brushwork shows); one 512x64 strip over the whole header
local shotTex = f:CreateTexture(nil, "BACKGROUND", nil, -3)
shotTex:SetPoint("TOPLEFT", artTiles[1])
shotTex:SetPoint("BOTTOMRIGHT", artTiles[2])
if shotTex.SetDesaturation then shotTex:SetDesaturation(1) end
if artMask and shotTex.AddMaskTexture then shotTex:AddMaskTexture(artMask) end
shotTex:Hide()
local SHOT_ALPHA = artMask and 0.20 or 0.08
local INK_ALPHA = 0.22   -- added light: faint grey brushwork, about as present as the map strip

local artShown
local function renderArt(g)
    local mode = UI.HEADER_ART   -- off for now (too faint to earn its place); "shot" / "map" bring it back
    local map = mode ~= "off" and mapFor(g) or nil
    local kind = mode == "shot" and map and W.ZoneShots and W.ZoneShots[map]
    if kind == true then kind = "shot" end
    local shot = kind and (MEDIA .. "zones\\" .. map .. (kind == "ink" and "_ink" or "")) or nil
    local tiles = not shot and UI.ZoneArt(map) or nil
    local key = shot or (tiles and (tiles[1] .. ":" .. tiles[2])) or ""
    if key == artShown then return key ~= "" end
    artShown = key
    if shot then
        shotTex:SetTexture(shot)
        if shotTex.SetBlendMode then shotTex:SetBlendMode(kind == "ink" and "ADD" or "BLEND") end
        shotTex.baseA = kind == "ink" and INK_ALPHA or SHOT_ALPHA
        shotTex:SetVertexColor(1, 1, 1, shotTex.baseA)
        shotTex:Show()
    else
        shotTex:Hide()
    end
    for i, t in ipairs(artTiles) do
        if tiles then
            t:SetTexture(tiles[i])
            t:SetTexCoord(0, 1, 0.36, 0.64)
            t.baseA = ART_ALPHA
            t:SetVertexColor(1, 1, 1, ART_ALPHA)
            t:Show()
        else
            t:Hide()
        end
    end
    return key ~= ""
end
UI.artTiles, UI.shotTex = artTiles, shotTex

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
-- what kind of step, in small capitals above the title (KILL, LOOT, TURN IN ...)
local verbText = fs(card, 10, C.accent)
verbText:SetPoint("TOPLEFT", 0, 0)
verbText:SetPoint("RIGHT")
verbText:SetWordWrap(false)
local mainText = fs(card, 15, C.text, nil, HEAD)
mainText:SetPoint("TOPLEFT", verbText, "BOTTOMLEFT", 0, -2)
mainText:SetPoint("RIGHT")
local subText = fs(card, 11, C.sub)
UI.subText = subText
subText:SetPoint("TOPLEFT", mainText, "BOTTOMLEFT", 0, -3)
subText:SetPoint("RIGHT")
UI.card, UI.mainText, UI.verbText = card, mainText, verbText

-- the "ready to turn in" sheen: one soft band sweeps across the card (clipped to it) while the
-- step-kind label glows and settles (Anim)
local cardFx = CreateFrame("Frame", nil, card)
cardFx:SetPoint("TOPLEFT", -6, 6)
cardFx:SetPoint("BOTTOMRIGHT", 6, -6)
if cardFx.SetClipsChildren then cardFx:SetClipsChildren(true) end
cardFx:SetFrameLevel(card:GetFrameLevel() + 6)
local sweep = cardFx:CreateTexture(nil, "OVERLAY")
sweep:SetTexture(MEDIA .. "sweep")
if sweep.SetBlendMode then sweep:SetBlendMode("ADD") end
if sweep.SetRotation then sweep:SetRotation(math.rad(-18)) end
sweep:Hide()
local verbGlow = card:CreateTexture(nil, "BACKGROUND", nil, -2)
verbGlow:SetTexture(MEDIA .. "glass_shadow")
if verbGlow.SetBlendMode then verbGlow:SetBlendMode("ADD") end
verbGlow:SetPoint("TOPLEFT", verbText, "TOPLEFT", -12, 9)
verbGlow:SetPoint("BOTTOMRIGHT", verbText, "BOTTOMRIGHT", 12, -9)
verbGlow:Hide()
UI.sweep = sweep
function UI.PlayReady()
    local w, h = tonumber(cardFx:GetWidth()) or 280, tonumber(cardFx:GetHeight()) or 80
    local Ac = S.ACCENT
    sweep:SetSize(64, h * 1.8)
    sweep:SetVertexColor(Ac[1], Ac[2], Ac[3], 1)
    verbGlow:SetVertexColor(Ac[1], Ac[2], Ac[3], 1)
    return A.Play("ready", 1.2, function(t)
        local st = math.min(1, t / 0.75)                       -- the sweep takes the first 0.9s
        local e = st < 0.5 and 2 * st * st or 1 - (-2 * st + 2) ^ 2 / 2   -- ease in-out
        sweep:ClearAllPoints()
        sweep:SetPoint("CENTER", cardFx, "LEFT", -40 + (w + 80) * e, 0)
        sweep:SetAlpha(0.32 * A.Bump(st))
        sweep:SetShown(t < 1)
        verbGlow:SetAlpha(0.55 * A.Bump(t))
        verbGlow:SetShown(t < 1)
    end)
end
-- kept for older callers: the buttons now sit in the action strip, not over the title
function UI.SetCardInset() end

-- action strip under the title: the target and quest item buttons (secure, placed over it by
-- Target.lua / Item.lua)
local STRIP_H = 28
local strip = CreateFrame("Frame", nil, card)
strip:SetHeight(STRIP_H)
strip:Hide()
UI.strip = strip
local function outlineButton(parent, label, tip, onClick)
    local b = CreateFrame("Button", nil, parent)
    b:SetHeight(24)
    local bg = S.Nine(b, "BACKGROUND", 0, MEDIA .. "glass_rim", 64, 16, 6, 0)
    bg:SetColor(1, 1, 1, 0.16)
    b.text = fs(b, 11, C.sub)
    b.text:SetPoint("CENTER")
    b.text:SetText(label)
    b:SetWidth(math.max(48, (b.text:GetStringWidth() or 0) + 20))
    S.Hover(b, 24)
    b:SetScript("OnEnter", function(self)
        self.text:SetTextColor(rgb(C.text))
        if tip then GameTooltip:SetOwner(self, "ANCHOR_TOP") GameTooltip:AddLine(tip, 1, 1, 1, true) GameTooltip:Show() end
    end)
    b:SetScript("OnLeave", function(self) self.text:SetTextColor(rgb(C.sub)) GameTooltip:Hide() end)
    b:SetScript("OnClick", onClick)
    return b
end
-- A kill/loot step with several camps: "Area 1 of 3 · <place> · next area". Click moves the
-- arrow, the pin and the map route to the next camp and keeps them there.
local areaBtn = CreateFrame("Button", nil, card)
areaBtn:SetHeight(14)
areaBtn.text = fs(areaBtn, 11, C.sub)
areaBtn.text:SetPoint("LEFT")
areaBtn.text:SetPoint("RIGHT")
areaBtn.text:SetWordWrap(false)
areaBtn:Hide()
areaBtn:SetScript("OnClick", function() WP:NextArea() end)
areaBtn:SetScript("OnEnter", function(self)
    local list, chosen, pinned = WP:Areas(card.step)
    if not list then return end
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("This can be done in " .. #list .. " places")
    for _, a in ipairs(list) do
        local d = W.Travel.Distance(a.map, a.x, a.y)
        local where = (a.name or "Area " .. a.index) .. ("  %.0f, %.0f"):format(a.x, a.y)
        local right = (a.n and (a.n .. " spawns") or "") .. (d and ("  ·  %d yd"):format(d) or "")
        local on = a == chosen
        GameTooltip:AddDoubleLine((on and "> " or "   ") .. where, right, on and 1 or 0.8, on and 1 or 0.8, on and 1 or 0.8, 0.6, 0.6, 0.6)
    end
    GameTooltip:AddLine(pinned and "You picked this one. Click: the next area." or "The nearest is picked for you. Click: the next area, and stay on it.",
        S.ACCENT[1], S.ACCENT[2], S.ACCENT[3], true)
    GameTooltip:Show()
end)
areaBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
UI.areaBtn = areaBtn   -- Render reaches it through UI: that function is at Lua's limit of 60 upvalues

-- "Later" sits on the card's top-right corner, on the step-kind line: away from the target and
-- item buttons (strip or dock), so a hurried click on those never sends the quest to the end
local laterStripBtn = outlineButton(card, "Later", "Come back to this quest later: the guide moves on, reminds you when you're back here, and returns to it at the end.",
    function() local s = card.step if s and s.quest then G:Later(s.quest) end end)
laterStripBtn:SetHeight(18)
laterStripBtn:SetWidth(math.max(44, (laterStripBtn.text:GetStringWidth() or 0) + 16))
laterStripBtn:SetPoint("TOPRIGHT", card, "TOPRIGHT", 0, 2)
laterStripBtn:Hide()
verbText:SetPoint("RIGHT", laterStripBtn, "LEFT", -6, 0)
UI.laterStripBtn = laterStripBtn

-- pools: objective rows (name, count, bar), extra lines (hints, drop rates, notes), also-here
-- rows, party chips, upcoming rows
local objLines, objRows, groupRows, partyChips, rows = {}, {}, {}, {}, {}

local function objLine(i)
    if not objLines[i] then
        local l = fs(card, 11, C.sub)
        l:SetPoint("RIGHT")
        objLines[i] = l
    end
    return objLines[i]
end

local function objRow(i)
    if not objRows[i] then
        local r = CreateFrame("Frame", nil, card)
        r:SetHeight(20)
        r.count = fs(r, 11, C.sub)
        r.count:SetPoint("TOPRIGHT", 0, 0)
        r.count:SetJustifyH("RIGHT")
        r.count:SetWordWrap(false)
        r.name = fs(r, 12, C.text)
        r.name:SetPoint("TOPLEFT", 0, 0)
        r.name:SetPoint("RIGHT", r.count, "LEFT", -6, 0)
        r.name:SetWordWrap(false)
        r.track = r:CreateTexture(nil, "ARTWORK")
        r.track:SetColorTexture(1, 1, 1, 0.08)
        r.track:SetPoint("BOTTOMLEFT", 0, 1)
        r.track:SetPoint("BOTTOMRIGHT", 0, 1)
        r.track:SetHeight(3)
        r.fill = r:CreateTexture(nil, "ARTWORK", nil, 1)
        S.Accent(r.fill, "color")
        r.fill:SetPoint("TOPLEFT", r.track)
        r.fill:SetHeight(3)
        objRows[i] = r
    end
    return objRows[i]
end

local function groupRow(i)
    if not groupRows[i] then
        local r = CreateFrame("Button", nil, card)
        r:SetHeight(16)
        r.count = fs(r, 11, C.sub)
        r.count:SetPoint("RIGHT")
        r.count:SetJustifyH("RIGHT")
        r.count:SetWordWrap(false)
        r.name = fs(r, 12, C.text)
        r.name:SetPoint("LEFT")
        r.name:SetPoint("RIGHT", r.count, "LEFT", -6, 0)
        r.name:SetWordWrap(false)
        r:SetScript("OnEnter", function(self)
            local s = self.step
            if not s then return end
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:AddLine(questTitle(s.quest))
            local e = QS:Get(s.quest)
            for _, o in ipairs(e and e.objectives or {}) do
                GameTooltip:AddLine((o.finished and "+ " or "- ") .. (o.text or ""), o.finished and 0.45 or 0.8, o.finished and 0.85 or 0.8, o.finished and 0.45 or 0.8)
            end
            local h = G:QuestHint(s.quest)
            if h then GameTooltip:AddLine(h, C.hint[1], C.hint[2], C.hint[3], true) end
            GameTooltip:Show()
        end)
        r:SetScript("OnLeave", function() GameTooltip:Hide() end)
        groupRows[i] = r
    end
    return groupRows[i]
end

local alsoLabel = fs(card, 10, C.dim)
alsoLabel:SetWordWrap(false)
local nextLabel = fs(f, 10, C.dim)
nextLabel:SetWordWrap(false)
nextLabel:SetText("NEXT")

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
        r.dot:SetPoint("LEFT", 2, 0)
        r.text = fs(r, 12, C.sub)
        r.text:SetWordWrap(false)
        r.text:SetPoint("LEFT", 18, 0)
        r.text:SetPoint("RIGHT")
        rows[i] = r
    end
    return rows[i]
end

-- the lines under the card: ONE of them is the notice (the most pressing, full text, tinted), the
-- others sit as short links in the footer row
local function lineButton(color)
    local bt = CreateFrame("Button", nil, f)
    bt:SetHeight(14)
    -- the notice look: a thin rounded accent outline with a faint accent wash inside, so the text
    -- stays light-on-dark like the rest of the panel (a solid accent fill washed white text out).
    -- The outline texture is drawn 1:1 (16px, 6px corners): shrinking the 64px glass rim to fit
    -- lost its 1px top and left edges to filtering.
    -- Parented to the panel, under the button, so it never draws over the text.
    bt.bg = CreateFrame("Frame", nil, f)
    bt.bg:SetPoint("TOPLEFT", bt, "TOPLEFT", -8, 5)
    bt.bg:SetPoint("BOTTOMRIGHT", bt, "BOTTOMRIGHT", 8, -5)
    S.Accent(S.Nine(bt.bg, "BACKGROUND", 0, MEDIA .. "glass_body", 64, 16, 6, 0), "nine", 0.10)
    S.Accent(S.Nine(bt.bg, "BORDER", 0, MEDIA .. "outline", 16, 6, 6, 0), "nine", 0.85)
    bt.bg:Hide()
    bt:SetFrameLevel(bt.bg:GetFrameLevel() + 2)   -- the text above its outline
    bt.text = fs(bt, 11, color)
    bt.text:SetPoint("LEFT")
    bt.text:SetPoint("RIGHT")
    bt.text:SetJustifyH("LEFT")
    bt.text:SetWordWrap(false)
    bt.color = color
    bt:Hide()
    bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return bt
end

local missedBtn = lineButton(C.dim)
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
missedBtn:SetScript("OnClick", function() G:GoBackToMissed() end)
UI.missedBtn = missedBtn

-- a better-fitting guide than the one you're on (G:Suggestion): click to switch, right-click to hide
local suggestBtn = lineButton(C.accent)
suggestBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
suggestBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("Suggested guide: " .. (self.title or ""))
    GameTooltip:AddLine(self.why or "", 0.8, 0.8, 0.8)
    GameTooltip:AddLine("Click: switch to it.  Right-click: hide this suggestion.", S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])
    GameTooltip:Show()
end)
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

-- turn-ins the guide moved past because the quest isn't finished (G:Waiting)
local function unfinished(q)
    local e = QS:Get(q)
    for _, o in ipairs(e and e.objectives or {}) do
        if not o.finished and o.text and o.text ~= "" then return o.text end
    end
end
local waitBtn = lineButton(C.dim)
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
waitBtn:SetScript("OnClick", function(self)
    local w = self.data
    if w and w.ready[1] then G:GoToStep(w.ready[1]) end
end)

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

-- KILL / LOOT / USE / EXPLORE from what the objectives are; the verb otherwise
local VERB_LABEL = {
    accept = "ACCEPT", turnin = "TURN IN", ["goto"] = "GO TO", fly = "FLY", level = "LEVEL UP",
    note = "NOTE", home = "HEARTHSTONE", train = "TRAIN", craft = "CRAFT", gather = "GATHER",
}
local OBJ_LABEL = { monster = "KILL", item = "LOOT", object = "USE", event = "EXPLORE" }
local function verbLabel(step)
    if step.verb ~= "complete" then return VERB_LABEL[step.verb] or step.verb:upper() end
    local e = step.quest and QS:Get(step.quest)
    local kinds, first = {}, nil
    for i, o in ipairs(e and e.objectives or {}) do
        if not step.obj or step.obj == i then
            local k = OBJ_LABEL[o.type or ""] or ((o.text or ""):find(" slain", 1, true) and "KILL") or nil
            if k and not kinds[k] then kinds[k] = true first = first or k end
        end
    end
    if kinds.KILL and kinds.LOOT then return "KILL AND LOOT" end
    return first or "QUEST"
end
UI.VerbLabel = verbLabel

local function setVerb(step)
    local st = VERB_STYLE[step.verb] or VERB_STYLE.note
    verbText:SetText(verbLabel(step))
    if st.color == C.accent then S.Accent(verbText, "text") else verbText:SetTextColor(rgb(st.color)) end
end

local function locationLine(step)
    local parts = {}
    local cur = WP:Current()
    if cur and cur.step == step then
        if cur.leg == "cross" and cur.cross then
            parts[#parts + 1] = "first the " .. cur.cross.kind .. " from " .. cur.cross.from.name .. " to " .. cur.cross.to.name
        elseif step.verb == "fly" then
            -- the place is the step's title; here, who you land by
            local _, who = W.Travel.SplitFlightNpc(step.npc)
            if who then parts[#parts + 1] = "flight master " .. who end
            -- not discovered yet: how you get there instead
            local plan = step.plan
            if cur.leg == "walk" then parts[#parts + 1] = "not discovered: walk there to learn it"
            elseif plan and plan.via then parts[#parts + 1] = "not discovered: fly to " .. plan.via.name .. ", then walk" end
        elseif cur.name then
            parts[#parts + 1] = cur.name
        end
        -- the place by name when the map has one for it ("Powderfuse Port"), then the coordinates
        local here = C_Map.GetBestMapForUnit("player")
        local place = W.Travel.PlaceName(cur.map, cur.x, cur.y)
        if cur.map ~= here then
            local info = C_Map.GetMapInfo and C_Map.GetMapInfo(cur.map)
            local zone = info and info.name or "another zone"
            parts[#parts + 1] = (place and place ~= zone and (place .. ", ") or "") .. zone .. (" %.0f, %.0f"):format(cur.x, cur.y)
        else
            if place then parts[#parts + 1] = place end
            parts[#parts + 1] = ("%.1f, %.1f"):format(cur.x, cur.y)
        end
        local d = W.Travel.Distance(cur.map, cur.x, cur.y)
        if d then parts[#parts + 1] = ("%d yd"):format(d) end
    elseif step.npc then
        parts[#parts + 1] = step.npc
    end
    if step.note and step.verb ~= "goto" then parts[#parts + 1] = step.note end
    if step.group then parts[#parts + 1] = UI.GroupText(step.group) end
    if step.item and W.Item and W.Item.Has(step.item) then   -- only when you have it to use
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

-- "Makeshift Stickin' Spear: 3/20" or (Forever's log) "3/20 Makeshift Stickin' Spear" -> name,
-- have, need (have/need from the log when it has them)
local function splitObjective(o)
    local text = o.text or ""
    local name, a, b = text:match("^(.-):%s*(%d+)%s*/%s*(%d+)%s*$")
    if not name then
        a, b, name = text:match("^(%d+)%s*/%s*(%d+)%s+(.+)$")
    end
    local have, need = o.have or tonumber(a), o.need or tonumber(b)
    if not name then name = (text:gsub(":%s*$", "")) end
    return name, have, need
end
UI.SplitObjective = splitObjective

-- a quest's progress summed over its objectives ("4/20"), or "done"
local function questProgress(q)
    local e = QS:Get(q)
    if not e then return "" end
    local have, need, all = 0, 0, true
    for _, o in ipairs(e.objectives or {}) do
        local _, h, n = splitObjective(o)
        if n and n > 0 then have, need = have + math.min(h or 0, n), need + n end
        if not o.finished then all = false end
    end
    if all and #(e.objectives or {}) > 0 then return "|cff66d973done|r" end
    return need > 0 and (have .. "/" .. need) or ""
end

-- the action strip shows when there's a mob to target or an item to use, unless the buttons live
-- in the dock (Options > Navigation)
local function wantsStrip(step)
    if not step or W.db.collapsed or W.db.targetDetached then return false end
    local TG = W.Target
    if W.db.targetButton and TG and step.verb == "complete" and #TG.MobsForGroup(G:Group()) > 0 then return true end
    return W.db.itemButton ~= false and W.Item and #W.Item.ForGroup() > 0 or false
end

---------------------------------------------------------------------------
-- Render
---------------------------------------------------------------------------
local shownTogether = {}   -- steps listed on the card as "also here" (left out of upcoming)

-- what the last render showed, so changes since then can animate (Anim)
local objSeen = {}         -- ["quest:objective"] = finished
local last = {}            -- guide, step, done, quest, questReady, barW
UI.lastShown = last

-- an objective just finished: its "done" pops and the line eases to the dimmed colour
function UI.PlayTick(r, i)
    local path = S.FontPath("body")
    return A.Play("obj" .. i, 0.5, function(t)
        local e = A.EaseOut(t)
        r.name:SetTextColor(C.text[1] + (C.dim[1] - C.text[1]) * e, C.text[2] + (C.dim[2] - C.text[2]) * e,
            C.text[3] + (C.dim[3] - C.text[3]) * e)
        r.count:SetFont(path, 11 + 3 * A.Bump(math.min(1, t * 1.4)), "")
    end)
end

-- the progress bar slides to its new length with a glint at the leading edge
local function setBar(target, animate)
    if not animate then
        if not A.Running("bar") then
            barGlint:Hide()
            bar:SetWidth(target)
            last.barW = target
        end
        return
    end
    if A.Running("bar") and last.barTarget == target then return end
    local from = last.barW or target
    last.barTarget = target
    A.Play("bar", 0.6, function(t)
        local wv = from + (target - from) * A.EaseOut(t)
        bar:SetWidth(wv)
        last.barW = wv
        barGlint:ClearAllPoints()
        barGlint:SetPoint("CENTER", bar, "RIGHT", 0, 0)
        barGlint:SetVertexColor(S.ACCENT[1], S.ACCENT[2], S.ACCENT[3], 0.9 * A.Bump(t))
        barGlint:SetShown(t < 1)
    end)
end

-- the next step: the card fades up a few pixels into place, like turning a page
local function playTurn(y)
    A.Play("turn", 0.28, function(t)
        local e = A.EaseOut(t)
        card:ClearAllPoints()
        card:SetPoint("TOPLEFT", PAD, -(y + 5 * (1 - e)))
        card:SetPoint("RIGHT", -PAD, 0)
        card:SetAlpha(0.35 + 0.65 * e)
    end)
end

-- the guide is finished: the header art warms to full colour and back, the bar glows once
function UI.PlayFinished()
    return A.Play("finished", 2.4, function(t)
        local b = A.Bump(t)
        for _, tex in ipairs(artTiles) do
            if tex.SetDesaturation then tex:SetDesaturation(1 - 0.85 * b) end
            tex:SetVertexColor(1, 1, 1, math.min(1, (tonumber(tex.baseA) or ART_ALPHA) * (1 + 2.5 * b)))
        end
        if shotTex.SetDesaturation then shotTex:SetDesaturation(1 - 0.85 * b) end
        shotTex:SetVertexColor(1, 1, 1, math.min(1, (tonumber(shotTex.baseA) or SHOT_ALPHA) * (1 + 2.5 * b)))
        barGlow:SetVertexColor(S.ACCENT[1], S.ACCENT[2], S.ACCENT[3], 0.35 + 0.65 * b)
    end)
end
local NOTICE_H = 22
function UI:Render()
    if not f:IsShown() then return end
    shownTogether = {}
    local g = G:Active()
    local done, total = G:Progress()
    if g and g.levels and g.kind ~= "profession" and not g.smart then
        title:SetText(g.zone or g.title)
        count:SetText(("%d-%d  ·  %s"):format(g.levels[1], g.levels[2], total > 0 and (done .. "/" .. total) or ""))
    else
        title:SetText(g and g.title or "Onward")
        count:SetText(total > 0 and (done .. "/" .. total) or "")
    end
    local barTarget = math.max(1, BAR_W * (total > 0 and done / total or 0))
    local sameGuide = g ~= nil and last.guide == g.id
    setBar(barTarget, sameGuide and last.done ~= nil and done > last.done)
    btnCollapse.icon:SetTexture(MEDIA .. (W.db.collapsed and "expand" or "collapse"))
    btnArrow:SetTint(W.db.arrow and C.accent or C.sub)
    f.glass:SetOpacity(W.db.bgAlpha or 0.72)
    renderArt(g)

    local list = G:Upcoming(W.db.showNext + 4)   -- extra so grouped steps don't shorten the list
    local step = list[1]
    local y = 46
    card:ClearAllPoints()
    card:SetPoint("TOPLEFT", PAD, -y)
    card:SetPoint("RIGHT", -PAD, 0)

    for _, l in ipairs(objLines) do l:Hide() end
    for _, r in ipairs(objRows) do r:Hide() end
    for _, r in ipairs(groupRows) do r:Hide() end
    for _, c in ipairs(partyChips) do c:Hide() end
    for _, r in ipairs(rows) do r:Hide() end
    for _, b in ipairs({ missedBtn, suggestBtn, busyBtn, laterBtn, waitBtn }) do b:Hide() b.bg:Hide() end
    divider:Hide()
    alsoLabel:Hide()
    nextLabel:Hide()
    strip:Hide()

    -- the quest last shown on the card just became ready to turn in: the sheen
    if sameGuide and last.quest and last.questReady == false and QS:IsReady(last.quest) then UI.PlayReady() end
    local turned = sameGuide and last.step ~= nil and step ~= last.step
    local finished = sameGuide and last.step ~= nil and not step
    last.guide, last.done, last.step = g and g.id, done, step
    last.quest = step and step.quest
    last.questReady = (step and step.quest and QS:IsReady(step.quest)) and true or false
    if finished then UI.PlayFinished() end
    if turned and step and not W.db.collapsed then playTurn(y) elseif not A.Running("turn") then card:SetAlpha(1) end

    if not step then
        laterStripBtn:Hide()
        verbText:SetText("NEXT GUIDE")
        S.Accent(verbText, "text")
        -- nothing to do: offer the recommended guide (a new character's first quest is in it)
        local rec, why = G:Recommend()
        card.recommend = rec and rec.id
        mainText:SetText(g and g.id == "smart" and "Quest log is empty" or "Guide complete")
        subText:SetText(rec and ("Click to start %s (%s)."):format(rec.title, G:ReasonText(why))
            or "Open the guide list to pick the next one.")
        subText:Show()
        card:SetHeight(verbText:GetStringHeight() + 2 + mainText:GetStringHeight() + subText:GetStringHeight() + 6)
        f:SetHeight(y + card:GetHeight() + PAD)
        card.step = nil
        UI.areaBtn:Hide()
        if W.Target then W.Target:Sync() end
        return
    end
    card.step = step
    UI.areaBtn:Hide()

    -- current step: what kind, the title, where
    setVerb(step)
    laterStripBtn:SetShown(step.verb == "complete" and step.quest ~= nil and not G:IsLater(step) and not W.db.collapsed)
    local text = UI.StepText(step)
    -- a kill/loot step or turn-in for a quest you haven't picked up: send you to the quest giver
    local pickup = G:IsMissing(step) and WP:Current() and WP:Current().step == step and WP:Current().pickup
    if pickup then
        verbText:SetText("PICK UP FIRST")
        text = questTitle(step.quest)
    elseif G:IsMissing(step) then
        text = text .. "  |cffff7366(not in quest log)|r"
    elseif G:HeldReason(step) then
        text = text .. "  |cffff7366(" .. G:HeldReason(step) .. ")|r"
    end
    mainText:SetText(text)
    local sub = locationLine(step)
    if step.verb == "note" then sub = (sub ~= "" and (sub .. "  ·  ") or "") .. "click when done" end
    if step.verb == "home" then sub = (sub ~= "" and (sub .. "  ·  ") or "") .. "talk to the innkeeper: Make this inn your home" end
    subText:SetText(sub)
    subText:SetShown(sub ~= "")
    local h = verbText:GetStringHeight() + 2 + mainText:GetStringHeight() + (sub ~= "" and (subText:GetStringHeight() + 3) or 0)

    if W.db.collapsed then
        card:SetHeight(math.max(18, h))
        f:SetHeight(y + card:GetHeight() + PAD)
        if W.Target then W.Target:Sync() end
        return
    end

    local anchor = sub ~= "" and subText or mainText
    local function place(region, gap, height)
        region:ClearAllPoints()
        region:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
        region:SetPoint("RIGHT", card, "RIGHT")
        anchor = region
        h = h + gap + height
    end

    -- the action strip
    if wantsStrip(step) then
        strip:Show()
        place(strip, 8, STRIP_H)
    end

    -- several camps for this step: which one it points at, and a click to the next
    local areas, area = WP:Areas(step)
    if areas and not G:IsMissing(step) then
        UI.areaBtn.text:SetText(("Area %d of %d%s  ·  |c%snext area|r"):format(area.index, #areas,
            area.name and ("  ·  " .. area.name) or ("  ·  %.0f, %.0f"):format(area.x, area.y), S.AccentHex()))
        UI.areaBtn:Show()
        place(UI.areaBtn, 6, 14)
    end

    -- objectives, extra lines (drop rates once there's data, hints, your notes)
    local n, nr = 0, 0
    local function line(text, color, gap)
        n = n + 1
        local l = objLine(n)
        l:SetTextColor(rgb(color))
        l:SetText(text)
        l:Show()
        l:ClearAllPoints()
        l:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -(gap or 3))
        l:SetPoint("RIGHT", card, "RIGHT")
        anchor = l
        h = h + l:GetStringHeight() + (gap or 3)
    end
    local function objective(o, s)
        nr = nr + 1
        local r = objRow(nr)
        local name, have, need = splitObjective(o)
        r.name:SetText(name)
        local okey = (s.quest or 0) .. ":" .. (name or nr)
        local was = objSeen[okey]
        objSeen[okey] = o.finished and true or false
        if was == false and o.finished then
            UI.PlayTick(r, nr)
        elseif not A.Running("obj" .. nr) then
            r.name:SetTextColor(rgb(o.finished and C.dim or C.text))
        end
        if o.finished then
            r.count:SetText("|cff66d973done|r")
        else
            r.count:SetText(need and need > 0 and ((have or 0) .. "/" .. need) or "")
        end
        local frac = need and need > 0 and math.min(1, (have or 0) / need) or (o.finished and 1 or 0)
        r.track:SetShown(need ~= nil and need > 1)
        r.fill:SetShown(need ~= nil and need > 1 and frac > 0)
        r.fill:SetWidth(math.max(1, BAR_W * frac))   -- the card spans the panel inside its padding
        r:SetHeight((need and need > 1) and 20 or 16)
        r:Show()
        place(r, nr == 1 and 8 or 4, r:GetHeight())
        local drop = W.Drops and W.Drops:Line(o, s.quest)
        if drop then line(drop, C.dim, 1) end
    end
    local function hints(q, builtIn, s)
        local hh = builtIn and G:QuestHint(q)
        if hh then line(hh, C.hint, 6) end
        local mine = G:MyHint(q)
        if mine then line("Your note: " .. mine, C.hint, 4) end
        -- the objective hints of the unfinished objectives
        local e = s and QS:Get(q)
        for i, o in ipairs(e and e.objectives or {}) do
            if (not s.obj or s.obj == i) and not o.finished then
                local oh = G:ObjectiveHint(q, o.text)
                if oh then line(splitObjective(o) .. ": " .. oh, C.hint, 4) end
            end
        end
    end
    if step.verb == "complete" and step.quest then
        local e = W.db.showObjectives and QS:Get(step.quest)
        for i, o in ipairs(e and e.objectives or {}) do
            if not step.obj or step.obj == i then objective(o, step) end
        end
        hints(step.quest, true, step)
        -- the other kill/loot quests worked in the same area: one row each, objectives on hover
        local group = G:Group()
        if #group > 1 then
            alsoLabel:SetText(("ALSO HERE  ·  %d"):format(#group - 1))
            alsoLabel:Show()
            place(alsoLabel, 10, alsoLabel:GetStringHeight())
            for i = 2, #group do
                local s = group[i]
                shownTogether[s] = true
                local r = groupRow(i - 1)
                r.step = s
                r.name:SetText(questTitle(s.quest))
                r.count:SetText(questProgress(s.quest))
                r:Show()
                place(r, 4, 16)
            end
        end
    else
        if step.quest then hints(step.quest, false) end   -- your own note on accept / turn-in too
        if G.PROF_VERB[step.verb] and W.Prof then
            -- skill, crafts left, recipe to learn, mats against your bags, the game's best pick now
            for _, l in ipairs(W.Prof:CardLines(step)) do line(l[1], C[l[2] or "sub"] or C.sub) end
        end
    end
    card:SetHeight(math.max(18, h))
    y = y + card:GetHeight() + 14

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

    -- notices: work out every line that applies, most pressing first
    local notices = {}
    if step.verb == "complete" and step.quest and W.Target then
        local busy, tagged, total = W.Target:Busy()
        if busy then
            busyBtn.quest, busyBtn.tagged, busyBtn.total = step.quest, tagged, total
            busyBtn.full = ("Busy: %d of %d here are tagged by others  ·  |c%scome back later|r"):format(tagged, total, S.AccentHex())
            busyBtn.short = "Busy here"
            notices[#notices + 1] = busyBtn
        end
    end
    local w = G:Waiting()
    if #w.ready > 0 or #w.waiting > 0 then
        waitBtn.data = w
        if #w.ready > 0 then
            waitBtn.full = ("|cff66d973Ready to turn in:|r %s%s  |c" .. S.AccentHex() .. "(click)|r"):format(questTitle(w.ready[1].quest),
                #w.ready > 1 and (" +" .. (#w.ready - 1)) or "")
            waitBtn.short = ("|cff66d973%d ready|r"):format(#w.ready)
            waitBtn.rank = 2
        elseif #w.waiting == 1 then
            local left = unfinished(w.waiting[1].quest)
            waitBtn.full = ("Turn-in waiting: %s%s"):format(questTitle(w.waiting[1].quest), left and ("  |cffff7366(" .. left .. ")|r") or "")
            waitBtn.short = "1 waiting"
            waitBtn.rank = 4
        else
            waitBtn.full = ("%d turn-ins waiting on unfinished quests"):format(#w.waiting)
            waitBtn.short = ("%d waiting"):format(#w.waiting)
            waitBtn.rank = 4
        end
    end
    local later = G:LaterList()
    local near = #later > 0 and G:LaterNearby() or nil
    if #later > 0 then
        laterBtn.quests, laterBtn.quest = later, near or later[1]
        if near then
            laterBtn.full = ("|c%sBack near %s|r (left for later)  ·  click to do it now"):format(S.AccentHex(), questTitle(near))
        else
            laterBtn.full = ("Left for later: %s%s"):format(questTitle(later[1]), #later > 1 and (" +" .. (#later - 1)) or "")
        end
        laterBtn.short = ("Left for later · %d"):format(#later)
    end
    local sug, sugWhy = G:Suggestion()
    if sug then
        suggestBtn.id, suggestBtn.title, suggestBtn.why = sug.id, sug.title, "Fits better: " .. G:ReasonText(sugWhy) .. "."
        suggestBtn.full = "Suggested: " .. sug.title .. "  ·  click to switch"
        suggestBtn.short = "Better guide"
    end
    local missed = G:Missed()
    if #missed > 0 then
        missedBtn.quests = missed
        missedBtn.full = ("%d earlier quest%s missed"):format(#missed, #missed == 1 and "" or "s")
        missedBtn.short = ("%d missed"):format(#missed)
    end
    -- order: busy, ready to hand in, back near a later quest, a waiting turn-in, a better guide,
    -- the later list; missed quests are never the notice, only a footer link
    if (w.ready and #w.ready > 0) then notices[#notices + 1] = waitBtn end
    if near then notices[#notices + 1] = laterBtn end
    if #w.ready == 0 and #w.waiting > 0 then notices[#notices + 1] = waitBtn end
    if sug then notices[#notices + 1] = suggestBtn end
    if #later > 0 and not near then notices[#notices + 1] = laterBtn end
    local top = notices[1]
    if top then
        top.text:SetText(top.full)
        top.text:SetTextColor(rgb(top == busyBtn and C.warn or C.text))
        if top == suggestBtn then S.Accent(top.text, "text") end
        top.bg:SetAlpha(1)
        top.bg:Show()
        top:ClearAllPoints()
        top:SetPoint("TOPLEFT", PAD + 8, -(y + 5))
        top:SetPoint("RIGHT", -PAD - 8, 0)
        top:Show()
        y = y + NOTICE_H + 8
    end
    -- the footer: short links for everything else
    local footer = {}
    for _, b in ipairs(notices) do if b ~= top then footer[#footer + 1] = b end end
    if #missed > 0 then footer[#footer + 1] = missedBtn end
    local fx = PAD
    if #footer > 0 then y = y + 2 end
    for _, b in ipairs(footer) do
        b.text:SetText(b.short .. " ›")
        b.text:SetTextColor(rgb(C.sub))
        local wdt = (b.text:GetStringWidth() or 40) + 2
        if fx + wdt > WIDTH - PAD and fx > PAD then fx = PAD y = y + 16 end
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", fx, -y)
        b:SetWidth(wdt)
        b:Show()
        fx = fx + wdt + 14
    end
    if #footer > 0 then y = y + 18 end

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
        y = y + 8
        nextLabel:ClearAllPoints()
        nextLabel:SetPoint("TOPLEFT", PAD, -y)
        nextLabel:Show()
        y = y + 14
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
    -- the secure buttons follow the strip (or the dock); they move only out of combat
    if W.Target then W.Target:Sync() end
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
    -- the quest's own text and its hint source, for the "where exactly?" moments
    local q = self.step.quest
    if q then
        GameTooltip:AddLine(questTitle(q))
        local desc = QS:Description(q)
        if desc then
            if #desc > 600 then desc = desc:sub(1, 600):gsub("%s+%S*$", "") .. " ..." end
            GameTooltip:AddLine(desc, 0.85, 0.85, 0.85, true)
        end
        local src = G:HintSource(q)
        if src then GameTooltip:AddLine("Hints: " .. src, 0.6, 0.6, 0.6, true) end
        GameTooltip:AddLine(" ")
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
