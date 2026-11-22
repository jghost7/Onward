-- Theme: the look shared by every Onward window. Every theme is frosted glass (drop shadow,
-- tinted rounded body, grain, sheen, lit rim; WoW can't blur the scene behind a frame, so the
-- frost is faked with layers). Themes differ only in colour and headline font, switchable live:
--   onward    (default) the logo: deep teal glass, a gold-lit rim, gold accent (#E3C154, the
--             lettering) and Friz Quadrata headlines.
--   glass     blue-slate glass, Ellesmere green accent (#0CD29D), Friz Quadrata headlines.
--   flat      ("Ellesmere" in the options; the value is kept for saved settings) neutral dark
--             glass, green accent, one clean body face. With EllesmereUI installed its public
--             skinning API supplies the user's own accent and panel colour here, and its font in
--             every look; live changes there repaint our windows. Nothing of EllesmereUI's art
--             or code is copied; we only read those three values.
-- The square "flat" geometry (solid fills, 1px edges, square badges) is still in the code paths
-- below but no theme uses it.
--
-- Windows never pick colours or fonts themselves for themed parts: they call
--   S.Glass(frame, opts)   window or pill background (name kept from the first theme)
--   S.Nine(...)            fills and borders inside windows (rounded in glass, square in flat)
--   S.Hover(button, size)  hover highlight
--   S.Badge(texture)       a step badge: circle in glass, square in flat
--   S.Accent(region, how [, alpha])  colour it with the accent, now and on every change
--   S.Font(fontString, size, kind [, flags])  kind "head" or "body"
-- and S.Refresh() repaints everything after a theme or look change.
local _, W = ...
local S = {}
W.Skin = S

local MEDIA = "Interface\\AddOns\\Onward\\media\\"
local WHITE = "Interface\\Buttons\\WHITE8x8"
S.MEDIA = MEDIA
S.FONT_HEAD = STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
S.FONT_BODY = "Fonts\\ARIALN.TTF"

-- shared colour tables: modules keep references, Refresh rewrites them in place
S.ACCENT = { 0.047, 0.824, 0.616 }   -- Ellesmere green #0CD29D
S.TINT = { 0.055, 0.068, 0.092 }     -- glass body (deep blue-slate)
S.PANEL = { 0.067, 0.071, 0.078 }    -- flat body (near black, neutral)
S.BORDER = { 0, 0, 0, 1 }
S.STRIP = { 0, 0, 0, 0.35 }          -- flat title strip, over the body

local panels, nines, accents, fonts, hovers, badges = {}, {}, {}, {}, {}, {}

-- colour looks: the same glass in other colours (glass body tint, highlight accent, lit rim).
-- Each pairs a dark body with a highlight from the other side of the wheel, so the accent reads.
S.PALETTES = {
    twilight = { accent = { 0.24, 0.86, 0.80 }, tint = { 0.072, 0.045, 0.118 }, rim = { 0.24, 0.86, 0.80, 0.24 } },  -- teal on violet
    alliance = { accent = { 0.96, 0.80, 0.34 }, tint = { 0.030, 0.062, 0.140 }, rim = { 0.40, 0.62, 1.00, 0.30 } },  -- gold on navy, blue edge
    horde    = { accent = { 0.95, 0.33, 0.24 }, tint = { 0.105, 0.036, 0.032 }, rim = { 0.80, 0.52, 0.26, 0.28 } },  -- ember on blood-iron, bronze edge
    feywood  = { accent = { 0.62, 0.98, 0.66 }, tint = { 0.020, 0.070, 0.058 }, rim = { 0.66, 0.48, 1.00, 0.26 } },  -- glowing fae green on deep moss, violet edge
    neon     = { accent = { 1.00, 0.32, 0.72 }, tint = { 0.078, 0.034, 0.112 }, rim = { 0.20, 0.88, 0.82, 0.30 } },  -- hot pink on deep purple, teal edge
}
local THEMES = { onward = true, flat = true, glass = true }
for k in pairs(S.PALETTES) do THEMES[k] = true end
function S.Theme()
    local t = W.db and W.db.theme
    return THEMES[t] and t or "onward"
end
local function flat() return false end
S.Square = flat
S.RIM = { 1, 1, 1, 0.09 }           -- glass rim colour (lit edge), per theme

-- the Onward palette, sampled from the logo
S.ONWARD = {
    accent = { 0.890, 0.757, 0.329 },   -- #E3C154 gold lettering
    tint   = { 0.016, 0.125, 0.125 },   -- #042020 the logo's deep teal, as glass
    rim    = { 0.890, 0.757, 0.329, 0.28 }, -- a gold-lit edge, like the ring
    jade   = { 0.106, 0.584, 0.478 },   -- #1B957A mountains
    glow   = { 0.988, 0.906, 0.592 },   -- #FCE797 the lit path
}

-- preview colours for the Appearance tab swatches
function S.ThemeColors(id)
    if id == "onward" then return S.ONWARD.tint, S.ONWARD.accent, S.ONWARD.rim end
    if S.PALETTES[id] then
        local p = S.PALETTES[id]
        return p.tint, p.accent, p.rim
    end
    if id == "flat" then return S.PANEL, { 0.047, 0.824, 0.616 }, { 1, 1, 1, 0.09 } end
    return { 0.055, 0.068, 0.092 }, { 0.047, 0.824, 0.616 }, { 1, 1, 1, 0.09 }
end

---------------------------------------------------------------------------
-- EllesmereUI (optional): accent, panel colour and font from the user's EUI theme
---------------------------------------------------------------------------
local eui
local DEFAULT_ACCENT = { S.ACCENT[1], S.ACCENT[2], S.ACCENT[3] }
local DEFAULT_PANEL = { S.PANEL[1], S.PANEL[2], S.PANEL[3] }
local SLATE = { S.TINT[1], S.TINT[2], S.TINT[3] }
local WHITE_RIM = { 1, 1, 1, 0.09 }
local function pullLooks()
    local a, p = DEFAULT_ACCENT, DEFAULT_PANEL
    local tint, rim = SLATE, WHITE_RIM
    S.fontOverride = nil
    local theme = S.Theme()
    local euiOn = eui and (not eui.IsEnabled or eui.IsEnabled())
    -- EllesmereUI's font is used in every look; its colours only in the Ellesmere look
    if euiOn then
        local ok3, path = pcall(eui.GetFont)
        if ok3 and path then S.fontOverride = path end
    end
    if theme == "onward" then
        a, tint, rim = S.ONWARD.accent, S.ONWARD.tint, S.ONWARD.rim
    elseif S.PALETTES[theme] then
        local pal = S.PALETTES[theme]
        a, tint, rim = pal.accent, pal.tint, pal.rim
    elseif theme == "flat" and euiOn then
        local ok, r, g, b = pcall(eui.GetAccentColor)
        if ok and r then a = { r, g, b } end
        local ok2, pr, pg, pb = pcall(eui.GetPanelColor)
        if ok2 and pr then p = { pr, pg, pb } end
    end
    S.ACCENT[1], S.ACCENT[2], S.ACCENT[3] = a[1], a[2], a[3]
    S.PANEL[1], S.PANEL[2], S.PANEL[3] = p[1], p[2], p[3]
    if theme == "flat" then tint = p end      -- Ellesmere: neutral (or EllesmereUI's) panel colour as glass
    S.TINT[1], S.TINT[2], S.TINT[3] = tint[1], tint[2], tint[3]
    for i = 1, 4 do S.RIM[i] = rim[i] end
end
function S.UsingEllesmere() return eui ~= nil end

if EllesmereUI and EllesmereUI.RegisterSkin then
    pcall(EllesmereUI.RegisterSkin, "Onward", function(E)
        eui = E
        if E.OnLooksChanged then E.OnLooksChanged(function() S.Refresh() end) end
        S.Refresh()
    end)
end

---------------------------------------------------------------------------
-- fills and borders: rounded 9-slice (glass) or square flat (flat)
---------------------------------------------------------------------------
-- margin = slice size in texture px, corner = on-screen corner size, out = how far it extends
-- past the frame. The texture says what the piece is: glass_body is a fill, glass_rim a border,
-- glass_toplight / glass_shadow are glass-only light and shadow.
local function nine(frame, layer, sub, file, texSize, margin, corner, out)
    local m = margin / texSize
    local tc = {
        { 0, m, 0, m }, { m, 1 - m, 0, m }, { 1 - m, 1, 0, m },
        { 0, m, m, 1 - m }, { m, 1 - m, m, 1 - m }, { 1 - m, 1, m, 1 - m },
        { 0, m, 1 - m, 1 }, { m, 1 - m, 1 - m, 1 }, { 1 - m, 1, 1 - m, 1 },
    }
    local p = {}
    for i = 1, 9 do
        local t = frame:CreateTexture(nil, layer, nil, sub)
        t:SetTexture(file)
        t:SetTexCoord(tc[i][1], tc[i][2], tc[i][3], tc[i][4])
        p[i] = t
    end
    out = out or 0
    for _, i in ipairs({ 1, 3, 7, 9 }) do p[i]:SetSize(corner, corner) end
    p[1]:SetPoint("TOPLEFT", -out, out)
    p[3]:SetPoint("TOPRIGHT", out, out)
    p[7]:SetPoint("BOTTOMLEFT", -out, -out)
    p[9]:SetPoint("BOTTOMRIGHT", out, -out)
    p[2]:SetPoint("TOPLEFT", p[1], "TOPRIGHT") p[2]:SetPoint("BOTTOMRIGHT", p[3], "BOTTOMLEFT")
    p[8]:SetPoint("TOPLEFT", p[7], "TOPRIGHT") p[8]:SetPoint("BOTTOMRIGHT", p[9], "BOTTOMLEFT")
    p[4]:SetPoint("TOPLEFT", p[1], "BOTTOMLEFT") p[4]:SetPoint("BOTTOMRIGHT", p[7], "TOPRIGHT")
    p[6]:SetPoint("TOPLEFT", p[3], "BOTTOMLEFT") p[6]:SetPoint("BOTTOMRIGHT", p[9], "TOPRIGHT")
    p[5]:SetPoint("TOPLEFT", p[1], "BOTTOMRIGHT") p[5]:SetPoint("BOTTOMRIGHT", p[9], "TOPLEFT")

    local obj = { parts = p, shown = true, color = { 1, 1, 1, 1 } }
    function obj:SetColor(r, g, b, a)
        self.color = { r, g, b, a }
        for i = 1, 9 do p[i]:SetVertexColor(r, g, b, a) end
    end
    function obj:SetShown(v) self.shown = v and true or false self:Apply() end
    function obj:Apply()
        for i = 1, 9 do p[i]:SetShown(self.shown) end
    end
    obj:Apply()
    nines[#nines + 1] = obj
    return obj
end
S.Nine = nine

---------------------------------------------------------------------------
-- window / pill background. opts: alpha (body opacity), shadow (default true), corner,
-- tint (glass body colour)
---------------------------------------------------------------------------
function S.Glass(frame, opts)
    opts = opts or {}
    local corner = opts.corner or 12
    local g = { opts = opts }
    if opts.shadow ~= false then
        g.shadow = nine(frame, "BACKGROUND", -8, MEDIA .. "glass_shadow", 128, 44, corner + 22, 16)
    end
    g.body = nine(frame, "BACKGROUND", -7, MEDIA .. "glass_body", 64, 16, corner)

    g.grain = frame:CreateTexture(nil, "BACKGROUND", nil, -6)
    g.grain:SetTexture(MEDIA .. "grain", "REPEAT", "REPEAT")
    if g.grain.SetHorizTile then g.grain:SetHorizTile(true) g.grain:SetVertTile(true) end
    g.grain:SetPoint("TOPLEFT", corner * 0.5, -corner * 0.5)
    g.grain:SetPoint("BOTTOMRIGHT", -corner * 0.5, corner * 0.5)

    g.sheen = frame:CreateTexture(nil, "BACKGROUND", nil, -5)
    g.sheen:SetTexture(MEDIA .. "sheen")
    g.sheen:SetPoint("TOPLEFT", corner * 0.6, -1)
    g.sheen:SetPoint("TOPRIGHT", -corner * 0.6, -1)
    g.sheen:SetHeight(46)
    g.sheen:SetVertexColor(1, 1, 1, 0.06)

    g.rim = nine(frame, "BORDER", 0, MEDIA .. "glass_rim", 64, 16, corner)
    g.toplight = nine(frame, "BORDER", 1, MEDIA .. "glass_toplight", 64, 16, corner)
    g.toplight:SetColor(1, 1, 1, 0.20)

    function g:SetOpacity(a)
        self.alpha = a
        local t = opts.tint or S.TINT
        g.body:SetColor(t[1], t[2], t[3], a)
        g.rim:SetColor(S.RIM[1], S.RIM[2], S.RIM[3], S.RIM[4])
        -- the frost and edges fade with the body so a nearly clear panel stays clean
        g.grain:SetVertexColor(1, 1, 1, 0.035 * math.min(1, a / 0.5))
        if g.shadow then g.shadow:SetColor(0, 0, 0, 0.55 * math.min(1, a / 0.6)) end
    end
    function g:Apply()
        g.grain:SetShown(true)
        g.sheen:SetShown(true)
        g.toplight:SetShown(true)
        if g.shadow then g.shadow:SetShown(true) end
        g:SetOpacity(g.alpha or opts.alpha or 0.72)
    end
    g.alpha = opts.alpha or 0.72
    g:Apply()
    frame.glass = g
    panels[#panels + 1] = g
    return g
end

---------------------------------------------------------------------------
-- small pieces
---------------------------------------------------------------------------
-- hover highlight: soft circle
function S.Hover(button, size)
    local h = button:CreateTexture(nil, "HIGHLIGHT")
    h:SetPoint("CENTER")
    h.size = size or 22
    hovers[#hovers + 1] = h
    S.ApplyHover(h)
    return h
end
function S.ApplyHover(h)
    h:SetTexture(MEDIA .. "circle")
    h:SetSize(h.size, h.size)
    h:SetVertexColor(1, 1, 1, 0.08)
end

-- step badge background: circle (its colour is set by the caller)
function S.Badge(tex)
    badges[#badges + 1] = tex
    tex:SetTexture(MEDIA .. "circle")
    return tex
end

-- how: "text" (SetTextColor), "vertex" (SetVertexColor), "color" (SetColorTexture),
-- "nine" (S.Nine object). Returns the region.
function S.Accent(region, how, alpha)
    accents[#accents + 1] = { region, how, alpha or 1 }
    S.ApplyAccent(accents[#accents])
    return region
end
function S.ApplyAccent(a)
    local r, g, b = S.ACCENT[1], S.ACCENT[2], S.ACCENT[3]
    local region, how, alpha = a[1], a[2], a[3]
    if how == "text" then region:SetTextColor(r, g, b, alpha)
    elseif how == "vertex" then region:SetVertexColor(r, g, b, alpha)
    elseif how == "color" then region:SetColorTexture(r, g, b, alpha)
    elseif how == "nine" then region:SetColor(r, g, b, alpha) end
end
function S.AccentHex()
    return ("ff%02x%02x%02x"):format(S.ACCENT[1] * 255, S.ACCENT[2] * 255, S.ACCENT[3] * 255)
end

-- fonts: the one picked in Options (W.db.font, a name from S.FontChoices) for all text; else
-- EllesmereUI's font when it supplies one; else the look's headline / body defaults (Ellesmere
-- keeps one clean face throughout; glass and onward set headlines in Friz Quadrata)
S.GAME_FONTS = {
    { name = "Friz Quadrata", path = "Fonts\\FRIZQT__.TTF" },
    { name = "Arial Narrow", path = "Fonts\\ARIALN.TTF" },
    { name = "Skurri", path = "Fonts\\skurri.ttf" },
    { name = "Morpheus", path = "Fonts\\MORPHEUS.TTF" },
}
local function sharedMedia()
    return LibStub and LibStub("LibSharedMedia-3.0", true)
end
-- [{name, path}]: the game's own fonts, then every font other addons share through
-- LibSharedMedia (SharedMedia, ElvUI, Details...), each file once
function S.FontChoices()
    local out, seen = {}, {}
    local function add(name, path)
        local k = type(path) == "string" and path:lower():gsub("/", "\\")
        if k and not seen[k] then seen[k] = true out[#out + 1] = { name = name, path = path } end
    end
    for _, f in ipairs(S.GAME_FONTS) do add(f.name, f.path) end
    local LSM = sharedMedia()
    if LSM then
        local shared = {}
        local ok, names = pcall(LSM.List, LSM, "font")
        for _, n in ipairs(ok and names or {}) do
            local ok2, path = pcall(LSM.Fetch, LSM, "font", n, true)
            if ok2 and path then shared[#shared + 1] = { name = n, path = path } end
        end
        table.sort(shared, function(a, b) return a.name:lower() < b.name:lower() end)
        for _, f in ipairs(shared) do add(f.name, f.path) end
    end
    return out
end
-- the picked font's file, or nil (automatic, or its addon is gone: never a missing file,
-- which would leave text with no font at all)
function S.ChosenFont()
    local name = W.db and W.db.font
    if not name or name == "auto" then return nil end
    for _, f in ipairs(S.FontChoices()) do
        if f.name == name then return f.path end
    end
end
local chosen
function S.FontPath(kind)
    if chosen then return chosen end
    if S.fontOverride then return S.fontOverride end
    return (kind == "head" and S.Theme() ~= "flat") and S.FONT_HEAD or S.FONT_BODY
end
function S.Font(fs, size, kind, flags)
    fonts[#fonts + 1] = { fs, size, kind or "body", flags or "" }
    fs:SetFont(S.FontPath(kind or "body"), size, flags or "")
    return fs
end

---------------------------------------------------------------------------
-- repaint everything (theme switch, EllesmereUI look change, login)
---------------------------------------------------------------------------
function S.Refresh()
    pullLooks()
    chosen = S.ChosenFont()
    for _, n in ipairs(nines) do n:Apply() end
    for _, g in ipairs(panels) do g:Apply() end
    for _, h in ipairs(hovers) do S.ApplyHover(h) end
    for _, t in ipairs(badges) do t:SetTexture(MEDIA .. "circle") end
    for _, a in ipairs(accents) do S.ApplyAccent(a) end
    for _, f in ipairs(fonts) do f[1]:SetFont(S.FontPath(f[3]), f[2], f[4]) end
    if W.Fire then W:Fire("WF_THEME_CHANGED") end
end

-- addons that load after us (SharedMedia, ElvUI...) register their fonts later: repaint once
-- every addon is in, and whenever the picked font registers after that
local listening
local function listen()
    local LSM = sharedMedia()
    if listening or not (LSM and LSM.RegisterCallback) then return end
    listening = true
    pcall(LSM.RegisterCallback, S, "LibSharedMedia_Registered", function(_, kind, name)
        if kind == "font" and W.db and name == W.db.font then S.Refresh() end
    end)
end
W:On("WF_INIT", function() S.Refresh() listen() end)
W:On("PLAYER_LOGIN", function()
    listen()
    if W.db and W.db.font ~= "auto" then S.Refresh() end
end)
