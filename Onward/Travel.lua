-- Travel: world positions, known flight paths, flight advice and auto-taxi.
--
-- Everything distance-related works in world coordinates (yards), so targets in another zone
-- on the same continent still get a real distance and direction.
-- Flight paths come from C_TaxiMap.GetTaxiNodesForMap on the continent maps: only nodes this
-- character has learned are used, so advice never sends you to a flight you can't take.
local _, W = ...
local T = {}
W.Travel = T

local CONTINENTS = { 1414, 1415 }      -- Kalimdor, Eastern Kingdoms
local FLIGHT_SPEED = 3.2               -- flying vs running, roughly
local FLIGHT_OVERHEAD = 120            -- yards-equivalent for talking, take-off and landing
local nodes = {}                       -- [continentID] = { {name, wx, wy, known, map, x, y}, ... }
local lastRefresh = 0

---------------------------------------------------------------------------
-- Positions
---------------------------------------------------------------------------
-- map x,y in 0-100 -> continentID, worldX, worldY
function T.World(map, x, y)
    if not (map and x and y and C_Map.GetWorldPosFromMapPos) then return end
    local ok, cont, pos = pcall(C_Map.GetWorldPosFromMapPos, map, CreateVector2D(x / 100, y / 100))
    if ok and cont and pos then return cont, pos.x, pos.y end
end

-- The player's world position. Inside caves and buildings the best map is often a micro map
-- with no world coordinates (or no player position), so walk up to its parent zone until one
-- gives an answer, instead of losing the arrow there.
function T.PlayerWorld()
    local map = C_Map.GetBestMapForUnit("player")
    for _ = 1, 4 do
        if not map or map == 0 then return end
        local p = C_Map.GetPlayerMapPosition(map, "player")
        if p and p.x then
            local cont, wx, wy = T.World(map, p.x * 100, p.y * 100)
            if cont then return cont, wx, wy end
        end
        local info = C_Map.GetMapInfo and C_Map.GetMapInfo(map)
        map = info and info.parentMapID
    end
end

local function d2(ax, ay, bx, by) return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2) end

-- yards from the player to map x,y; nil when on another continent or unknown
function T.Distance(map, x, y)
    local pc, px, py = T.PlayerWorld()
    local tc, tx, ty = T.World(map, x, y)
    if not pc or not tc or pc ~= tc then return end
    return d2(px, py, tx, ty)
end

---------------------------------------------------------------------------
-- Flight nodes
---------------------------------------------------------------------------
local UNREACHABLE = (Enum and Enum.FlightPathState and Enum.FlightPathState.Unreachable) or 2

local function storeNodes(contMap, list)
    if type(list) ~= "table" then return end
    for _, n in ipairs(list) do
        if n.position and n.name then
            local cont, wx, wy = T.World(contMap, n.position.x * 100, n.position.y * 100)
            if cont then
                nodes[cont] = nodes[cont] or {}
                local known = n.state ~= UNREACHABLE
                local found
                for _, e in ipairs(nodes[cont]) do
                    if e.name == n.name then found = e break end
                end
                if found then
                    found.known = found.known or known
                else
                    table.insert(nodes[cont], { name = n.name, wx = wx, wy = wy, known = known, id = n.nodeID })
                end
            end
        end
    end
end

function T:Refresh(force)
    if not force and GetTime() - lastRefresh < 30 then return end
    lastRefresh = GetTime()
    if not (C_TaxiMap and C_TaxiMap.GetTaxiNodesForMap) then return end
    for _, m in ipairs(CONTINENTS) do
        local ok, list = pcall(C_TaxiMap.GetTaxiNodesForMap, m)
        if ok then storeNodes(m, list) end
    end
end

-- The named area a map spot is in ("Powderfuse Port"), from the world map's own named areas
-- (Places.lua): the smallest one that holds the spot, or nil (open country, or a map without them).
function T.PlaceName(map, x, y)
    local list = W.PlaceData and map and W.PlaceData[map]
    if not (list and x and y) then return end
    local best, size
    for _, r in ipairs(list) do
        if x >= r[1] and x <= r[3] and y >= r[2] and y <= r[4] then
            local s = (r[3] - r[1]) * (r[4] - r[2])
            if not size or s < size then best, size = r[5], s end
        end
    end
    return best
end

-- The flight point at (or next to) a map spot, by its in-game name ("Tarren Mill, Hillsbrad"),
-- known or not; nil when there's none within 300 yd or the taxi map hasn't been read yet.
function T:PlaceAt(map, x, y)
    T:Refresh()
    local cont, wx, wy = T.World(map, x, y)
    if not cont then return end
    local best, bestD
    for _, n in ipairs(nodes[cont] or {}) do
        local dd = d2(n.wx, n.wy, wx, wy)
        if not bestD or dd < bestD then best, bestD = n, dd end
    end
    if best and bestD <= 300 then return best.name end
end

-- Guide fly steps name the destination as "Zone (Flight Master)" (another zone) or "Flight
-- Master" (same zone): split that into the two parts.
function T.SplitFlightNpc(npc)
    if not npc then return end
    local zone, who = npc:match("^(.-) %((.-)%)$")
    if zone then return zone, who end
    return nil, npc
end

function T:KnownNodes(cont)
    local out = {}
    for _, n in ipairs(nodes[cont] or {}) do if n.known then out[#out + 1] = n end end
    return out
end

---------------------------------------------------------------------------
-- Advice: is flying faster than running to map x,y?
-- returns { from = node, to = node, save = yards } or nil
---------------------------------------------------------------------------
local cache = { key = nil, at = 0, result = nil }
-- Advice is sticky: once a flight is suggested for a target, it stays (same flight masters)
-- while it still saves at least 10% over running, so the arrow doesn't flip between the flight
-- master and the quest as the numbers drift with every step you take.
local sticky = { key = nil, pick = nil }
local KEEP_RATIO, NEW_RATIO = 0.9, 0.75

function T:Advice(map, x, y)
    if not W.db.travelAdvice or UnitOnTaxi("player") then return end
    local key = (map or 0) .. ":" .. math.floor((x or 0) * 10) .. ":" .. math.floor((y or 0) * 10)
    if cache.key == key and GetTime() - cache.at < 3 then return cache.result end
    cache.key, cache.at, cache.result = key, GetTime(), nil

    T:Refresh()
    local pc, px, py = T.PlayerWorld()
    local tc, tx, ty = T.World(map, x, y)
    if not pc or not tc or pc ~= tc then return end
    local walk = d2(px, py, tx, ty)
    if sticky.key == key and sticky.pick then
        local A, B = sticky.pick.from, sticky.pick.to
        local cost = d2(px, py, A.wx, A.wy) + d2(A.wx, A.wy, B.wx, B.wy) / FLIGHT_SPEED + FLIGHT_OVERHEAD + d2(B.wx, B.wy, tx, ty)
        if cost < walk * KEEP_RATIO then
            sticky.pick.save = walk - cost
            cache.result = sticky.pick
            return sticky.pick
        end
    end
    sticky.key, sticky.pick = key, nil
    if walk < 900 then return end

    local known = T:KnownNodes(pc)
    if #known < 2 then return end
    -- best departure is near the player, best arrival near the target: check the closest few of each
    table.sort(known, function(a, b) return d2(px, py, a.wx, a.wy) < d2(px, py, b.wx, b.wy) end)
    local froms = { known[1], known[2], known[3] }
    table.sort(known, function(a, b) return d2(tx, ty, a.wx, a.wy) < d2(tx, ty, b.wx, b.wy) end)
    local tos = { known[1], known[2], known[3] }
    local best, bestCost
    for _, A in ipairs(froms) do
        for _, B in ipairs(tos) do
            if A ~= B then
                local cost = d2(px, py, A.wx, A.wy) + d2(A.wx, A.wy, B.wx, B.wy) / FLIGHT_SPEED + FLIGHT_OVERHEAD + d2(B.wx, B.wy, tx, ty)
                if not bestCost or cost < bestCost then best, bestCost = { from = A, to = B }, cost end
            end
        end
    end
    if best and bestCost < walk * NEW_RATIO then
        best.save = walk - bestCost
        cache.result = best
        sticky.pick = best
        return best
    end
end

---------------------------------------------------------------------------
-- Auto-taxi: at a flight master, take the flight the current step (or advice) wants.
---------------------------------------------------------------------------
local wantedDest   -- { cont, wx, wy, name }: name = the flight point's in-game name, when known

function T:SetWantedDestination(cont, wx, wy, name)
    wantedDest = cont and { cont = cont, wx = wx, wy = wy, name = name } or nil
end

-- The node on this flight master's map that the guide wants: by name first, else the one
-- nearest the wanted spot (within 600 yd). Returns { slot, name, current } or nil.
function T.WantedNode()
    if not wantedDest then return end
    local taxiMap = GetTaxiMapID and GetTaxiMapID()
    if taxiMap and C_TaxiMap and C_TaxiMap.GetAllTaxiNodes then
        local ok, list = pcall(C_TaxiMap.GetAllTaxiNodes, taxiMap)
        if ok and type(list) == "table" then
            storeNodes(taxiMap, list)
            local CURRENT = (Enum and Enum.FlightPathState and Enum.FlightPathState.Current) or 0
            local best, bestD
            for _, n in ipairs(list) do
                if n.slotIndex and n.state ~= UNREACHABLE then
                    if wantedDest.name and n.name == wantedDest.name then best, bestD = n, 0 break end
                    if n.position then
                        local cont, wx, wy = T.World(taxiMap, n.position.x * 100, n.position.y * 100)
                        if cont == wantedDest.cont then
                            local d = d2(wx, wy, wantedDest.wx, wantedDest.wy)
                            if not bestD or d < bestD then best, bestD = n, d end
                        end
                    end
                end
            end
            if best and bestD < 600 then return { slot = best.slotIndex, name = best.name, current = best.state == CURRENT } end
        end
    end
    -- older taxi API: by name only (its positions are frame offsets, not map spots)
    if wantedDest.name and NumTaxiNodes and TaxiNodeName then
        for i = 1, NumTaxiNodes() do
            if TaxiNodeName(i) == wantedDest.name then
                local kind = TaxiNodeGetType and TaxiNodeGetType(i)
                if kind ~= "NONE" and kind ~= "DISTANT" then return { slot = i, name = wantedDest.name, current = kind == "CURRENT" } end
            end
        end
    end
end

-- a glow around the wanted node's button on the flight map, so the hint is there to see
-- even when you pick the flight yourself
local mark
local function markNode(slot)
    local b = slot and _G["TaxiButton" .. slot]
    if not (b and b.IsShown and b:IsShown()) then
        if mark then mark:Hide() end
        return
    end
    if not mark then
        mark = CreateFrame("Frame", nil, UIParent)
        mark.ring = mark:CreateTexture(nil, "OVERLAY")
        mark.ring:SetAllPoints()
        mark.ring:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
        mark.ring:SetBlendMode("ADD")
        mark.text = mark:CreateFontString(nil, "OVERLAY")
        mark.text:SetPoint("BOTTOM", mark, "TOP", 0, -6)
    end
    local A = W.Skin and W.Skin.ACCENT or { 0.3, 0.8, 1 }
    mark:SetParent(b:GetParent() or UIParent)
    mark:SetFrameStrata(b:GetFrameStrata() or "DIALOG")
    mark:SetFrameLevel((b:GetFrameLevel() or 1) + 2)
    mark:ClearAllPoints()
    local w = math.max(tonumber(b:GetWidth()) or 16, 16)
    mark:SetSize(w * 3, w * 3)
    mark:SetPoint("CENTER", b, "CENTER", 0, 0)
    mark.ring:SetVertexColor(A[1], A[2], A[3], 1)
    mark.text:SetFont(W.Skin and W.Skin.FontPath("body") or "Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    mark.text:SetTextColor(A[1], A[2], A[3])
    mark.text:SetText("Onward")
    mark:Show()
    T.marked = slot
end

local function takeFlight()
    -- talking to the flight master refreshes the guide, which can clear the wanted flight a
    -- moment before the map opens: ask the arrow again so it's set from the current step
    if W.Waypoint and W.Waypoint.ArrowTarget then pcall(W.Waypoint.ArrowTarget, W.Waypoint) end
    T.marked = nil
    if not wantedDest then return end
    local node = T.WantedNode()
    if not node then
        if wantedDest.name then W.Print("This flight master can't fly you to " .. wantedDest.name .. " yet.") end
        return
    end
    if node.current then return end
    markNode(node.slot)
    if W.db.autoTaxi and not IsShiftKeyDown() then
        W.Print("Auto flight to " .. node.name .. ". To pick your own destination, hold Shift when you talk to the flight master.")
        TakeTaxiNode(node.slot)
    else
        W.Print("Fly to " .. node.name .. " (marked on the flight map).")
    end
end

W:On("TAXIMAP_OPENED", function() C_Timer.After(0.1, takeFlight) end)
W:On("TAXIMAP_CLOSED", function() if mark then mark:Hide() end end)
W:On("PLAYER_ENTERING_WORLD", function() C_Timer.After(3, function() T:Refresh(true) end) end)
-- learning a new flight path: re-read known nodes shortly after
W:On("UI_INFO_MESSAGE", function(_, _, msg)
    if msg and ERR_NEWTAXIPATH and msg == ERR_NEWTAXIPATH then C_Timer.After(0.5, function() T:Refresh(true) end) end
end)
W:On("PLAYER_CONTROL_GAINED", function() W:RequestRefresh() W:Fire("WF_LANDED") end)
