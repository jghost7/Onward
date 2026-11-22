-- Travel route on the world map: a dotted line from you to where the guide sends you next.
--   Current: you -> the arrow's target. When a flight beats running it goes via the two flight
--            masters, and the flight leg is drawn in the travel colour.
--   Next:    the same, then on through the next few step locations, numbered in order.
-- Everything is computed in world coordinates and projected onto whatever map you're looking
-- at, so the route shows on the zone map and on the continent map alike. It only draws while
-- the world map is open: one 0.5s timer then, nothing otherwise.
local _, W = ...
local R = {}
W.Route = R

local T, WP, G = W.Travel, W.Waypoint, W.Guide
local DOT_GAP, DOT_SIZE, MARK_SIZE = 11, 4, 14   -- screen pixels, kept constant at any zoom
local MAX_DOTS = 700
local SAME_PLACE = 20                            -- yards: stops this close merge

---------------------------------------------------------------------------
-- the route as world points: { {cont, wx, wy, leg = "walk"|"fly", stop = n|nil, label}, ... }
---------------------------------------------------------------------------
local function locate(step)
    if step.verb == "fly" and step.at then
        return T.World(step.at.map, step.at.x, step.at.y)
    end
    local map, x, y = WP:Resolve(step)
    if map and x then return T.World(map, x, y) end
end

function R:Points()
    local mode = W.db.routeMode or "next"
    if mode == "off" then return {} end
    local pc, px, py = T.PlayerWorld()
    if not pc then return {} end
    local pts = { { cont = pc, wx = px, wy = py, you = true } }
    local function add(cont, wx, wy, leg, label, stop)
        if not cont then return end
        local last = pts[#pts]
        if last.cont == cont and (last.wx - wx) ^ 2 + (last.wy - wy) ^ 2 < SAME_PLACE ^ 2 then
            if stop and not last.stop then last.stop, last.label = stop, label end
            return
        end
        pts[#pts + 1] = { cont = cont, wx = wx, wy = wy, leg = leg, label = label, stop = stop }
    end

    local tgt = WP:ArrowTarget()
    local stop = 0
    if tgt then
        if tgt.flight and tgt.via then
            add(tgt.cont, tgt.wx, tgt.wy, "walk", tgt.label)
            add(tgt.cont, tgt.via.wx, tgt.via.wy, "fly")
            stop = 1
            if tgt.final then add(tgt.final.cont, tgt.final.wx, tgt.final.wy, "walk", tgt.sub, stop) end
        elseif tgt.trail and tgt.final then
            -- the way you came: along the trail, then to the quest giver
            for _, p in ipairs(tgt.path or {}) do add(tgt.cont, p.wx, p.wy, "walk") end
            stop = 1
            add(tgt.final.cont, tgt.final.wx, tgt.final.wy, "walk", tgt.label, stop)
        else
            stop = 1
            add(tgt.cont, tgt.wx, tgt.wy, "walk", tgt.label, stop)
        end
    end
    -- Current with nowhere left to go (you're at the target): show the step after it instead,
    -- so the map never goes blank while you work a step
    local more = mode == "next" and (W.db.routeStops or 3) or (#pts == 1 and 1 or 0)
    if more > 0 then
        local list = G:Upcoming(more + 2)
        local cur = WP:Current()
        local base = math.max(stop, 1)
        for i = 2, #list do
            if stop >= base + more then break end
            local s = list[i]
            if not (cur and cur.step == s) then
                if s.verb == "fly" and s.from then
                    local fc, fx, fy = T.World(s.from.map or s.at.map, s.from.x, s.from.y)
                    add(fc, fx, fy, "walk")                       -- to the flight master
                    local c, x, y = locate(s)
                    stop = stop + 1
                    add(c, x, y, "fly", W.UI and W.UI.StepText(s), stop)
                else
                    local c, x, y = locate(s)
                    if c then
                        stop = stop + 1
                        add(c, x, y, "walk", W.UI and W.UI.StepText(s), stop)
                    end
                end
            end
        end
    end
    return pts
end

---------------------------------------------------------------------------
-- drawing on the world map canvas
---------------------------------------------------------------------------
local overlay, dots, marks, nDots = nil, {}, {}, 0

local function canvas()
    return WorldMapFrame and WorldMapFrame.ScrollContainer and WorldMapFrame.ScrollContainer.Child
end

local function setup()
    if overlay then return true end
    local c = canvas()
    if not c then return false end
    overlay = CreateFrame("Frame", nil, c)
    overlay:SetAllPoints(c)
    overlay:SetFrameLevel((c:GetFrameLevel() or 1) + 500)
    return true
end

local function dot(i)
    local d = dots[i]
    if not d then
        d = overlay:CreateTexture(nil, "OVERLAY")
        d:SetTexture(W.Skin.MEDIA .. "circle")
        dots[i] = d
    end
    return d
end

local function mark(i)
    local m = marks[i]
    if not m then
        m = CreateFrame("Frame", nil, overlay)
        m:EnableMouse(true)
        m.bg = m:CreateTexture(nil, "ARTWORK")
        m.bg:SetAllPoints()
        m.bg:SetTexture(W.Skin.MEDIA .. "circle")
        m.edge = m:CreateTexture(nil, "BACKGROUND")
        m.edge:SetPoint("TOPLEFT", -2, 2) m.edge:SetPoint("BOTTOMRIGHT", 2, -2)
        m.edge:SetTexture(W.Skin.MEDIA .. "circle")
        m.edge:SetVertexColor(0, 0, 0, 0.85)
        m.num = m:CreateFontString(nil, "OVERLAY")
        m.num:SetPoint("CENTER", 0, 0)
        m:SetScript("OnEnter", function(self)
            if not self.tipTitle then return end
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.tipTitle)
            if self.tipBody then GameTooltip:AddLine(self.tipBody, 0.85, 0.87, 0.90, true) end
            if self.tipSub then GameTooltip:AddLine(self.tipSub, 0.62, 0.65, 0.70, true) end
            GameTooltip:Show()
        end)
        m:SetScript("OnLeave", function() GameTooltip:Hide() end)
        marks[i] = m
    end
    return m
end
R.marks, R.dots = marks, dots

local function project(mapID, p)
    if not (C_Map.GetMapPosFromWorldPos and p.cont) then return end
    local ok, _, pos = pcall(C_Map.GetMapPosFromWorldPos, p.cont, CreateVector2D(p.wx, p.wy), mapID)
    if ok and pos and pos.x then return pos.x, pos.y end
end

local function inside(x, y) return x >= 0 and x <= 1 and y >= 0 and y <= 1 end

function R:Draw()
    if not setup() then return end
    nDots = 0
    for _, d in ipairs(dots) do d:Hide() end
    for _, m in ipairs(marks) do m:Hide() end
    R.drawn = { dots = 0, marks = 0 }
    if not (WorldMapFrame:IsShown()) then return end
    local mapID = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
    local c = canvas()
    local cw, ch = c:GetWidth(), c:GetHeight()
    if not (mapID and cw and cw > 0) then return end
    local scale = (WorldMapFrame.ScrollContainer.GetCanvasScale and WorldMapFrame.ScrollContainer:GetCanvasScale()) or 1
    if not scale or scale <= 0 then scale = 1 end
    local gap, size, msize = DOT_GAP / scale, DOT_SIZE / scale, MARK_SIZE / scale
    local A, TR = W.Skin.ACCENT, { 0.75, 0.60, 1.00 }

    local pts = R:Points()
    local prev
    for i, p in ipairs(pts) do
        local x, y = project(mapID, p)
        p.mx, p.my = x, y
        if prev and prev.mx and x then
            -- dots along the leg, in canvas units, skipping parts off this map
            local dx, dy = (x - prev.mx) * cw, (y - prev.my) * ch
            local len = math.sqrt(dx * dx + dy * dy)
            local n = math.floor(len / gap)
            local col = p.leg == "fly" and TR or A
            for k = 1, n do
                if nDots >= MAX_DOTS then break end
                local t = k / (n + 1)
                local fx, fy = prev.mx + (x - prev.mx) * t, prev.my + (y - prev.my) * t
                if inside(fx, fy) then
                    nDots = nDots + 1
                    local d = dot(nDots)
                    d:SetSize(size, size)
                    d:ClearAllPoints()
                    d:SetPoint("CENTER", overlay, "TOPLEFT", fx * cw, -fy * ch)
                    -- fade with distance along the route: the next leg reads first
                    d:SetVertexColor(col[1], col[2], col[3], i <= 2 and 0.95 or 0.6)
                    d:Show()
                end
            end
        end
        prev = p
    end
    -- numbered stops
    local nm = 0
    for _, p in ipairs(pts) do
        if p.stop and p.mx and inside(p.mx, p.my) then
            nm = nm + 1
            local m = mark(nm)
            m:SetSize(msize, msize)
            m:ClearAllPoints()
            m:SetPoint("CENTER", overlay, "TOPLEFT", p.mx * cw, -p.my * ch)
            if p.stop == 1 then m.bg:SetVertexColor(A[1], A[2], A[3], 1) else m.bg:SetVertexColor(0.85, 0.87, 0.9, 0.9) end
            m.num:SetFont(W.Skin.FontPath("body"), math.max(6, math.floor(10 / scale)), "")
            m.num:SetTextColor(0.05, 0.06, 0.07)
            m.num:SetText(tostring(p.stop))
            m.tipTitle = ("Stop %d%s"):format(p.stop, p.stop == 1 and " (current)" or "")
            m.tipBody = p.label
            m.tipSub = p.leg == "fly" and "Flight leg" or nil
            m:Show()
        end
    end
    -- the step's other areas: small translucent circle markers, so you can see where else it can be done
    local areas, chosen = WP:Areas()
    local na = 0
    for _, a in ipairs(areas or {}) do
        local x, y = project(mapID, a)
        if a ~= chosen and x and inside(x, y) then
            nm, na = nm + 1, na + 1
            local m = mark(nm)
            m:SetSize(msize * 0.85, msize * 0.85)
            m:ClearAllPoints()
            m:SetPoint("CENTER", overlay, "TOPLEFT", x * cw, -y * ch)
            m.bg:SetVertexColor(A[1], A[2], A[3], 0.48)
            m.num:SetFont(W.Skin.FontPath("body"), math.max(6, math.floor(9 / scale)), "")
            m.num:SetTextColor(0.05, 0.06, 0.07)
            m.num:SetText(tostring(a.index))
            m.tipTitle = ("Alternate area %d"):format(a.index)
            m.tipBody = a.name or "Another camp for this step"
            m.tipSub = "Click Area on the panel (or /ow area) to switch"
            m:Show()
        end
    end
    R.drawn = { dots = nDots, marks = nm, areas = na }
end

---------------------------------------------------------------------------
-- keep it current while the map is open
---------------------------------------------------------------------------
local ticker
local function start()
    if ticker then return end
    R:Draw()
    ticker = C_Timer.NewTicker(0.5, function() R:Draw() end)
end
local function stop()
    if ticker then ticker:Cancel() ticker = nil end
    if overlay then R:Draw() end
end

W:On("WF_INIT", function()
    if not (WorldMapFrame and WorldMapFrame.HookScript) then return end
    WorldMapFrame:HookScript("OnShow", start)
    WorldMapFrame:HookScript("OnHide", stop)
    if hooksecurefunc and WorldMapFrame.OnMapChanged then
        hooksecurefunc(WorldMapFrame, "OnMapChanged", function() if ticker then R:Draw() end end)
    end
end)
W:On("WF_TARGET_CHANGED", function() if ticker then R:Draw() end end)
W:On("WF_SETTINGS_CHANGED", function() if ticker then R:Draw() end end)
