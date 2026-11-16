-- Theme: the look shared by every Onward window. Three themes, switchable live:
--   onward (default) the logo's look: flat geometry in deep teal (#0A2626) with a thin gold
--         border, gold accent (#E3C154, the logo's lettering) and Friz Quadrata headlines.
--         Its own palette, so EllesmereUI's colours and font don't apply to it.
--
--   flat  Ellesmere-style: solid dark panels, 1px borders, a darker title strip,
--         square buttons, checkboxes and badges, one accent colour (Ellesmere green #0CD29D).
--         With EllesmereUI installed, its public skinning API supplies the user's own accent,
--         panel colour and font, and live changes there repaint our windows. Nothing of
--         EllesmereUI's art or code is copied; we only read those three values.
--   glass the frosted look: drop shadow, tinted rounded body, grain, sheen, lit rim. WoW can't
--         blur the scene behind a frame, so the frost is faked with layers.
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

local THEMES = { onward = true, flat = true, glass = true }
function S.Theme()
    local t = W.db and W.db.theme
    return THEMES[t] and t or "onward"
end
-- square geometry (solid fills, 1px borders, square badges): every theme but glass
local function flat() return S.Theme() ~= "glass" end
S.Square = flat

-- the Onward palette, sampled from the logo
S.ONWARD = {
    accent = { 0.890, 0.757, 0.329 },   -- #E3C154 gold lettering
    panel  = { 0.039, 0.149, 0.149 },   -- #0A2626 deep teal, a step up from the logo's #012222
    border = { 0.725, 0.475, 0.071, 0.70 }, -- #B97912 the ring's darker gold
    strip  = { 0.004, 0.090, 0.090, 0.65 }, -- #011717 darker teal title strip
    jade   = { 0.106, 0.584, 0.478 },   -- #1B957A mountains
    glow   = { 0.988, 0.906, 0.592 },   -- #FCE797 the lit path
}

---------------------------------------------------------------------------
-- EllesmereUI (optional): accent, panel colour and font from the user's EUI theme
---------------------------------------------------------------------------
local eui
local DEFAULT_ACCENT = { S.ACCENT[1], S.ACCENT[2], S.ACCENT[3] }
local DEFAULT_PANEL = { S.PANEL[1], S.PANEL[2], S.PANEL[3] }
local function pullLooks()
    local a, p = DEFAULT_ACCENT, DEFAULT_PANEL
    local border, strip = { 0, 0, 0, 1 }, { 0, 0, 0, 0.35 }
    S.fontOverride = nil
    if S.Theme() == "onward" then
        a, p, border, strip = S.ONWARD.accent, S.ONWARD.panel, S.ONWARD.border, S.ONWARD.strip
    elseif eui and (not eui.IsEnabled or eui.IsEnabled()) then
        local ok, r, g, b = pcall(eui.GetAccentColor)
        if ok and r then a = { r, g, b } end
        local ok2, pr, pg, pb = pcall(eui.GetPanelColor)
        if ok2 and pr then p = { pr, pg, pb } end
        local ok3, path = pcall(eui.GetFont)
        if ok3 and path then S.fontOverride = path end
    end
    S.ACCENT[1], S.ACCENT[2], S.ACCENT[3] = a[1], a[2], a[3]
    S.PANEL[1], S.PANEL[2], S.PANEL[3] = p[1], p[2], p[3]
    for i = 1, 4 do S.BORDER[i], S.STRIP[i] = border[i], strip[i] end
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

    -- the flat twin: a solid fill, or four 1px edges for a border
    local kind = file:find("glass_rim") and "border" or file:find("glass_body") and "fill" or "glassonly"
    local f = {}
    if kind == "fill" then
        f[1] = frame:CreateTexture(nil, layer, nil, sub)
        f[1]:SetTexture(WHITE)
        f[1]:SetAllPoints(frame)
    elseif kind == "border" then
        for i = 1, 4 do f[i] = frame:CreateTexture(nil, layer, nil, sub) f[i]:SetTexture(WHITE) end
        f[1]:SetPoint("TOPLEFT") f[1]:SetPoint("TOPRIGHT") f[1]:SetHeight(1)
        f[2]:SetPoint("BOTTOMLEFT") f[2]:SetPoint("BOTTOMRIGHT") f[2]:SetHeight(1)
        f[3]:SetPoint("TOPLEFT", 0, -1) f[3]:SetPoint("BOTTOMLEFT", 0, 1) f[3]:SetWidth(1)
        f[4]:SetPoint("TOPRIGHT", 0, -1) f[4]:SetPoint("BOTTOMRIGHT", 0, 1) f[4]:SetWidth(1)
    end

    local obj = { parts = p, flat = f, kind = kind, shown = true, color = { 1, 1, 1, 1 } }
    function obj:SetColor(r, g, b, a)
        self.color = { r, g, b, a }
        for i = 1, 9 do p[i]:SetVertexColor(r, g, b, a) end
        for _, t in ipairs(f) do t:SetVertexColor(r, g, b, a) end
    end
    function obj:SetShown(v) self.shown = v and true or false self:Apply() end
    function obj:Apply()
        local isFlat = flat()
        for i = 1, 9 do p[i]:SetShown(self.shown and not isFlat) end
        for _, t in ipairs(f) do t:SetShown(self.shown and isFlat) end
    end
    obj:Apply()
    nines[#nines + 1] = obj
    return obj
end
S.Nine = nine

---------------------------------------------------------------------------
-- window / pill background. opts: alpha (body opacity), shadow (default true), corner,
-- tint (glass body colour), titleBar (height of the flat theme's darker title strip)
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

    if opts.titleBar then
        g.strip = frame:CreateTexture(nil, "BACKGROUND", nil, -4)
        g.strip:SetTexture(WHITE)
        g.strip:SetPoint("TOPLEFT", 1, -1)
        g.strip:SetPoint("TOPRIGHT", -1, -1)
        g.strip:SetHeight(opts.titleBar)
    end

    g.rim = nine(frame, "BORDER", 0, MEDIA .. "glass_rim", 64, 16, corner)
    g.toplight = nine(frame, "BORDER", 1, MEDIA .. "glass_toplight", 64, 16, corner)
    g.toplight:SetColor(1, 1, 1, 0.20)

    function g:SetOpacity(a)
        self.alpha = a
        if flat() then
            g.body:SetColor(S.PANEL[1], S.PANEL[2], S.PANEL[3], a)
            g.rim:SetColor(S.BORDER[1], S.BORDER[2], S.BORDER[3], S.BORDER[4] * math.min(1, a + 0.15))
        else
            local t = opts.tint or S.TINT
            g.body:SetColor(t[1], t[2], t[3], a)
            g.rim:SetColor(1, 1, 1, 0.09)
            -- the frost and edges fade with the body so a nearly clear panel stays clean
            g.grain:SetVertexColor(1, 1, 1, 0.035 * math.min(1, a / 0.5))
            if g.shadow then g.shadow:SetColor(0, 0, 0, 0.55 * math.min(1, a / 0.6)) end
        end
        if g.strip then g.strip:SetVertexColor(S.STRIP[1], S.STRIP[2], S.STRIP[3], S.STRIP[4] * math.min(1, a / 0.6)) end
    end
    function g:Apply()
        local isFlat = flat()
        g.grain:SetShown(not isFlat)
        g.sheen:SetShown(not isFlat)
        g.toplight:SetShown(not isFlat)
        if g.shadow then g.shadow:SetShown(not isFlat) end
        if g.strip then g.strip:SetShown(isFlat) end
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
-- hover highlight: a soft circle in glass, a square wash in flat
function S.Hover(button, size)
    local h = button:CreateTexture(nil, "HIGHLIGHT")
    h:SetPoint("CENTER")
    h.size = size or 22
    hovers[#hovers + 1] = h
    S.ApplyHover(h)
    return h
end
function S.ApplyHover(h)
    if flat() then
        h:SetTexture(WHITE)
        h:SetSize(h.size - 2, h.size - 2)
        h:SetVertexColor(1, 1, 1, 0.07)
    else
        h:SetTexture(MEDIA .. "circle")
        h:SetSize(h.size, h.size)
        h:SetVertexColor(1, 1, 1, 0.08)
    end
end

-- step badge background: circle in glass, square in flat (its colour is set by the caller)
function S.Badge(tex)
    badges[#badges + 1] = tex
    tex:SetTexture(flat() and WHITE or (MEDIA .. "circle"))
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

-- fonts: EllesmereUI's font when it supplies one, otherwise headline / body defaults
-- (flat keeps one clean face throughout; glass and onward set headlines in the game's Friz Quadrata)
function S.FontPath(kind)
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
    for _, n in ipairs(nines) do n:Apply() end
    for _, g in ipairs(panels) do g:Apply() end
    for _, h in ipairs(hovers) do S.ApplyHover(h) end
    for _, t in ipairs(badges) do t:SetTexture(flat() and WHITE or (MEDIA .. "circle")) end
    for _, a in ipairs(accents) do S.ApplyAccent(a) end
    for _, f in ipairs(fonts) do f[1]:SetFont(S.FontPath(f[3]), f[2], f[4]) end
    if W.Fire then W:Fire("WF_THEME_CHANGED") end
end

W:On("WF_INIT", function() S.Refresh() end)
