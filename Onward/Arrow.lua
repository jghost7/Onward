-- Nav arrow: a rotating on-screen arrow for the current target, with distance and arrival time.
-- Turns green when you face the target, amber off to the side, red behind you; switches to a
-- check ring on arrival. Points at a flight master when flying beats running (Travel advice).
-- Drag to move (unless locked); right-click for quick options.
local _, W = ...
local A = {}
W.Arrow = A

local T, WP = W.Travel, W.Waypoint
local MEDIA = "Interface\\AddOns\\Onward\\media\\"
local FONT = STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
local TAU = math.pi * 2

local f = CreateFrame("Frame", "OnwardArrow", UIParent)
f:SetSize(196, 124)
f:SetClampedToScreen(true)
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetFrameStrata("MEDIUM")
f:Hide()

local arrow = f:CreateTexture(nil, "ARTWORK")
arrow:SetTexture(MEDIA .. "arrow")
arrow:SetSize(64, 64)
arrow:SetPoint("TOP", 0, -2)

local ring = f:CreateTexture(nil, "ARTWORK")
ring:SetTexture(MEDIA .. "arrive")
ring:SetSize(54, 54)
ring:SetPoint("CENTER", arrow)
ring:SetVertexColor(0.40, 0.85, 0.45)
ring:Hide()

-- arrival: one soft ring pulses out from the check as it appears (Anim)
local pulse = f:CreateTexture(nil, "ARTWORK", nil, -1)
pulse:SetTexture(MEDIA .. "ring")
if pulse.SetBlendMode then pulse:SetBlendMode("ADD") end
pulse:SetPoint("CENTER", arrow)
pulse:Hide()
local arrivedKey, wasArrived
function A.PlayArrive()
    return W.Anim.Play("arrive", 0.7, function(t)
        local e = W.Anim.EaseOut(t)
        pulse:SetSize(44 + 70 * e, 44 + 70 * e)
        pulse:SetVertexColor(0.40, 0.85, 0.45, 0.7 * (1 - e))
        pulse:SetShown(t < 1)
    end)
end
A.pulse = pulse

-- the readout under the arrow: no box, just text with a firm shadow over a soft dark fade that
-- keeps it readable on bright ground. Its size is its own setting (Options > Navigation).
local pill = CreateFrame("Frame", nil, f)
pill:SetSize(196, 54)
pill:SetPoint("TOP", arrow, "BOTTOM", 0, -2)
local fade = pill:CreateTexture(nil, "BACKGROUND")
fade:SetTexture(MEDIA .. "text_fade")
fade:SetPoint("TOPLEFT", -26, 8)
fade:SetPoint("BOTTOMRIGHT", 26, -8)

local texts = {}
local function text(size, r, g, b, font)
    local t = pill:CreateFontString(nil, "OVERLAY")
    t.baseSize, t.kind = size, font and "head" or "body"
    W.Skin.Font(t, size, t.kind)
    t:SetShadowColor(0, 0, 0, 1)
    t:SetShadowOffset(1, -1)
    t:SetTextColor(r, g, b)
    t:SetWidth(184)
    t:SetWordWrap(false)
    texts[#texts + 1] = t
    return t
end
local dist = text(15, 1, 1, 1, FONT)
dist:SetPoint("TOP", pill, "TOP", 0, -7)
local label = text(12, 0.93, 0.94, 0.96)
label:SetPoint("TOP", dist, "BOTTOM", 0, -3)
local sub = text(11, 1, 1, 1)
W.Skin.Accent(sub, "text")
sub:SetPoint("TOP", label, "BOTTOM", 0, -2)

-- text size: W.db.arrowTextScale (0.7 - 1.6), separate from the arrow's own size
local textScale = 1
local function applyTextScale()
    textScale = (W.db and W.db.arrowTextScale) or 1
    for _, t in ipairs(texts) do
        W.Skin.Font(t, math.floor(t.baseSize * textScale + 0.5), t.kind)
        t:SetWidth(184 * math.max(1, textScale))
    end
    pill:SetWidth(196 * math.max(1, textScale))
end
A.ApplyTextScale = applyTextScale

A.frame, A.tex, A.dist, A.label, A.sub, A.fade = f, arrow, dist, label, sub, fade   -- for tests / skins

---------------------------------------------------------------------------
local function lerp(a, b, t) return a + (b - a) * t end
-- 0 = facing (green) .. 0.5 = side (amber) .. 1 = behind (red)
local function colorFor(off)
    if off < 0.5 then
        local t = off / 0.5
        return lerp(0.40, 1.00, t), lerp(0.88, 0.78, t), lerp(0.45, 0.25, t)
    end
    local t = (off - 0.5) / 0.5
    return 1.00, lerp(0.78, 0.35, t), lerp(0.25, 0.30, t)
end

local function fmtTime(sec)
    if sec >= 3600 then return ("%dh %dm"):format(sec / 3600, (sec % 3600) / 60) end
    if sec >= 60 then return ("%dm %02ds"):format(sec / 60, sec % 60) end
    return ("%ds"):format(sec)
end

local elapsed = 0
local function update(_, dt)
    elapsed = elapsed + dt
    if elapsed < 0.03 then return end
    elapsed = 0

    local tgt = WP:ArrowTarget()
    if not tgt then f:SetAlpha(0) return end
    f:SetAlpha(1)
    label:SetText(tgt.label or "")
    sub:SetText(tgt.sub or "")
    pill:SetHeight(((tgt.sub and tgt.sub ~= "") and 54 or 40) * textScale)

    local pc, px, py = T.PlayerWorld()
    if not pc or pc ~= tgt.cont then
        arrow:Hide() ring:Hide()
        dist:SetText("other continent")
        return
    end
    -- world coords: x grows north, y grows west
    local north, west = tgt.wx - px, tgt.wy - py
    local yards = math.sqrt(north * north + west * west)

    -- the same target as last time, and you just reached it: the pulse
    local key = (tgt.label or "") .. ":" .. math.floor(tgt.wx or 0) .. ":" .. math.floor(tgt.wy or 0)
    local here = yards <= (tgt.radius or 10)
    if here and key == arrivedKey and wasArrived == false then A.PlayArrive() end
    arrivedKey, wasArrived = key, here
    if here then
        arrow:Hide()
        ring:Show()
        dist:SetText("arrived")
        return
    end
    ring:Hide()
    arrow:Show()

    -- following the trail: the distance shown is the whole way back, not to the next bend
    local total = tgt.yards or yards
    local speed = GetUnitSpeed and W.Safe(GetUnitSpeed("player")) or 0
    local eta = speed and speed > 0 and ("  ·  " .. fmtTime(total / speed)) or ""
    dist:SetText(("%d yd%s"):format(total, eta))

    local facing = W.Safe(GetPlayerFacing and GetPlayerFacing())
    if not facing then
        -- the game isn't giving your facing right now (it can hide it): keep the last direction,
        -- greyed, rather than snapping the arrow to "straight ahead"
        arrow:SetVertexColor(0.55, 0.55, 0.55)
        A.lastFacingMissing = true
        return
    end
    A.lastFacingMissing = nil
    local bearing = math.atan2(west, north)          -- counter-clockwise from north, like facing
    local rot = (bearing - facing) % TAU
    arrow:SetRotation(rot)
    local off = (rot > math.pi and (TAU - rot) or rot) / math.pi
    arrow:SetVertexColor(colorFor(off))
    A.last = { yards = yards, bearing = bearing, facing = facing, rot = rot }
end

-- /ow arrow debug: everything the arrow is working from, to tell a data problem from a math one
function A:Debug()
    local map = C_Map.GetBestMapForUnit("player")
    local pc, px, py = T.PlayerWorld()
    W.Print(("player: map %s  world %s %.0f, %.0f"):format(tostring(map), tostring(pc), px or 0, py or 0))
    W.Print("facing:", tostring(W.Safe(GetPlayerFacing and GetPlayerFacing())))
    local c = WP:Current()
    if c then
        W.Print(("step target: %s  map %d  %.1f, %.1f  (%s)"):format(c.step.verb, c.map, c.x, c.y, c.name or "?"))
    else
        W.Print("no step target (this step has no location)")
    end
    local tgt = WP:ArrowTarget()
    if tgt then
        W.Print(("arrow points at: %s%s  world %s %.0f, %.0f"):format(tgt.label or "?", tgt.flight and " (flight advice)" or tgt.hearth and " (hearthstone advice)" or tgt.spot and " (nearest objective spot)" or tgt.trail and " (the way you came)" or "",
            tostring(tgt.cont), tgt.wx or 0, tgt.wy or 0))
    end
    if W.Trail then
        local pts = W.Trail:Points()
        W.Print(("trail: %d points (%s)"):format(#pts, W.db.trailBack == false and "path back off" or "path back on"))
    end
    if W.Hearth then
        local home = W.Hearth:Home()
        W.Print(("hearthstone: bound to %s, %s, %s"):format(tostring(W.Hearth:BindName()),
            home and "spot known" or "spot not learned yet (set it again, or walk into that town)",
            W.Hearth:Ready() and "ready" or "not ready"))
    end
    if A.last then
        W.Print(("distance %.0f yd, bearing %.0f deg, facing %.0f deg, arrow turned %.0f deg"):format(A.last.yards,
            math.deg(A.last.bearing) % 360, math.deg(A.last.facing) % 360, math.deg(A.last.rot)))
    end
end

---------------------------------------------------------------------------
-- placement, visibility, quick menu
---------------------------------------------------------------------------
local function place()
    f:ClearAllPoints()
    local p = W.db.arrowPoint
    if p then f:SetPoint(p[1], UIParent, p[2], p[3], p[4]) else f:SetPoint("TOP", UIParent, "TOP", 0, -140) end
    f:SetScale(W.db.arrowScale or 1)
    applyTextScale()
end

function A:Sync()
    local want = W.db.arrow and WP:Current() ~= nil
    if want and not f:IsShown() then
        f:Show()
        f:SetScript("OnUpdate", update)
    elseif not want and f:IsShown() then
        f:SetScript("OnUpdate", nil)
        f:Hide()
    end
    f:EnableMouse(not W.db.arrowLocked)
end

function A:Toggle()
    W.db.arrow = not W.db.arrow
    A:Sync()
    W:Fire("WF_SETTINGS_CHANGED")
end

f:SetScript("OnDragStart", function(self) if not W.db.arrowLocked then self:StartMoving() end end)
f:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, rp, x, y = self:GetPoint()
    W.db.arrowPoint = { p, rp, x, y }
end)
f:SetScript("OnMouseUp", function(_, button)
    if button == "RightButton" then W:Fire("WF_SHOW_OPTIONS") end
end)
f:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine("Onward arrow")
    GameTooltip:AddLine("Drag to move  ·  Right-click for options", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end)
f:SetScript("OnLeave", function() GameTooltip:Hide() end)

W:On("WF_INIT", place)
W:On("WF_RESET_POSITION", place)
W:On("WF_TARGET_CHANGED", function() A:Sync() end)
W:On("WF_SETTINGS_CHANGED", function() place() A:Sync() end)
