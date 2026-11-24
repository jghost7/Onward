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
-- Flight advice compares real-world travel times. Taxis fly ~32 yd/s over mountains (~1.25x
-- straight line -> 25 yd/s effective); riding within one zone (<= 2000 yd) is nearly straight,
-- while multi-zone rides wind around mountain passes, rivers and roads (1.6x on distance past
-- 2000 yd). Talking, take-off and landing cost ~15 s. A flight is suggested when it saves 30 s
-- and 15% of the ride, and kept (no flip-flopping as you move) while it still saves 8%.
local TAXI_SPEED = 25                  -- yd/s along the straight line between the flight points
local STRAIGHT_GROUND = 2000           -- within ~1 zone, ground paths are fairly direct
local CROSS_ZONE_WIND = 1.6            -- beyond 1 zone, roads wind around mountains and borders
local FLIGHT_OVERHEAD = 15             -- seconds
local MIN_SAVE, NEW_SHARE, KEEP_SHARE = 30, 0.15, 0.08
local RUN_SPEED, MOUNT_MAX = 7, 14
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

-- can the open flight map fly to this node? The flight map's own answer (TaxiNodeGetType:
-- REACHABLE / CURRENT, not DISTANT: a point you discovered with no route from here, drawn on the
-- map with no line to it) beats the node's state, which counts those as reachable.
local function flyable(n)
    if not (n and n.slotIndex) then return false end
    if TaxiNodeGetType then
        local ok, kind = pcall(TaxiNodeGetType, n.slotIndex)
        if ok and kind then return kind == "REACHABLE" or kind == "CURRENT" end
    end
    return n.state ~= UNREACHABLE
end
T.Flyable = flyable

local function isWrongFaction(n)
    local f = n and n.faction
    if f == nil then return false end
    local player = UnitFactionGroup and UnitFactionGroup("player")
    if not player then return false end
    if type(f) == "string" then
        local fl = f:lower()
        return (fl == "alliance" and player == "Horde") or (fl == "horde" and player == "Alliance")
    end
    local E = Enum and Enum.FlightPathFaction
    if not E then return false end
    if player == "Horde" and E.Alliance ~= nil and f == E.Alliance then return true end
    if player == "Alliance" and E.Horde ~= nil and f == E.Horde then return true end
    return false
end

local function storeNodes(contMap, list, authoritative)
    if type(list) ~= "table" then return end
    for _, n in ipairs(list) do
        if n.position and n.name and not isWrongFaction(n) then
            local cont, wx, wy = T.World(contMap, n.position.x * 100, n.position.y * 100)
            if cont then
                nodes[cont] = nodes[cont] or {}
                local known = n.state ~= UNREACHABLE
                local found
                for _, e in ipairs(nodes[cont]) do
                    if e.name == n.name then found = e break end
                end
                if found then
                    -- Neutral towns (Gadgetzan, Booty Bay, Everlook) have two flight masters with
                    -- the same name. Never keep an unreachable (opposite-faction) node's position
                    -- once a known or authoritative flight-map node arrives.
                    if authoritative or (known and not found.known) then
                        found.wx, found.wy, found.id = wx, wy, n.nodeID
                    end
                    found.known = found.known or known
                else
                    local net = W.cdb and W.cdb.taxiNet and W.cdb.taxiNet[n.name] or nil
                    table.insert(nodes[cont], { name = n.name, wx = wx, wy = wy, known = known, id = n.nodeID, net = net })
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

-- A guide fly step whose destination you haven't discovered yet can't be flown. Returns nil
-- when it can (or the flight map hasn't been read yet), else a plan:
--   { via = node }  fly to the learned flight point nearest the destination, then walk on
--   { walk = true } no learned point gets you closer than you'd start: walk there
-- Either way the last part is on foot to the destination's flight master, which learns it.
function T:FlightPlan(step)
    if not (step and step.verb == "fly" and step.at) then return end
    T:Refresh()
    local dc, dx, dy = T.World(step.at.map, step.at.x, step.at.y)
    local list = dc and nodes[dc]
    if not list or #list == 0 then return end
    -- where the flight would start: the departure flight master, else where you stand
    local sc, sx, sy
    if step.from then sc, sx, sy = T.World(step.from.map or step.at.map, step.from.x, step.from.y) end
    local pc, px, py = T.PlayerWorld()
    if not sc or (pc and sc ~= pc and pc == dc) then sc, sx, sy = pc, px, py end
    -- the known flight point there: only points on its network can be flown to
    local startNode, startNodeD
    if sc == dc then
        for _, n in ipairs(list) do
            local d = n.known and d2(n.wx, n.wy, sx, sy)
            if d and d <= 300 and (not startNodeD or d < startNodeD) then startNode, startNodeD = n, d end
        end
    end
    local via, viaD
    for _, n in ipairs(list) do
        if n.known and T.SameNetwork(n, startNode) then
            local d = d2(n.wx, n.wy, dx, dy)
            if d <= 300 then return end                    -- the destination is learned: fly it
            if not viaD or d < viaD then via, viaD = n, d end
        end
    end
    local startD = sc == dc and d2(sx, sy, dx, dy) or math.huge
    if via and viaD < startD * 0.8 and d2(via.wx, via.wy, sx or 0, sy or 0) > 300 then
        return { via = via, viaD = viaD }
    end
    return { walk = true }
end

---------------------------------------------------------------------------
-- Between continents: boats and zeppelins (Classic + WoW Forever sea lanes).
-- Positions are the docks/towers (map x,y in 0-100); faction nil = anyone can ride.
---------------------------------------------------------------------------
local CROSSINGS = {
    { kind = "boat", faction = nil,
      a = { map = 2548, x = 79.5, y = 52.7, name = "Powderfuse Port" }, b = { map = 1446, x = 67.6, y = 23.1, name = "Steamwheedle Port" } },
    { kind = "boat", faction = nil,
      a = { map = 1434, x = 25.8, y = 73.1, name = "Booty Bay" }, b = { map = 1413, x = 63.7, y = 38.6, name = "Ratchet" } },
    { kind = "zeppelin", faction = "Horde",
      a = { map = 1434, x = 31.3, y = 29.2, name = "Grom'gol" }, b = { map = 1411, x = 50.8, y = 13.6, name = "Orgrimmar" } },
    { kind = "zeppelin", faction = "Horde",
      a = { map = 1420, x = 60.8, y = 58.8, name = "Undercity" }, b = { map = 1411, x = 50.6, y = 12.6, name = "Orgrimmar" } },
    { kind = "boat", faction = "Alliance",
      a = { map = 1453, x = 22.8, y = 56.1, name = "Stormwind Harbor" }, b = { map = 1439, x = 32.4, y = 43.8, name = "Auberdine" } },
    { kind = "boat", faction = "Alliance",
      a = { map = 1437, x = 4.6, y = 57.1, name = "Menethil Harbor" }, b = { map = 1445, x = 71.6, y = 56.4, name = "Theramore" } },
    { kind = "boat", faction = "Alliance",
      a = { map = 1437, x = 4.8, y = 63.6, name = "Menethil Harbor" }, b = { map = 1439, x = 32.4, y = 43.8, name = "Auberdine" } },
    { kind = "boat", faction = "Alliance",
      a = { map = 1424, x = 50.7, y = 68.6, name = "Southshore" }, b = { map = 1439, x = 32.4, y = 43.8, name = "Auberdine" } },
}
T.CROSSINGS = CROSSINGS

function T:KnownNodes(cont)
    local out = {}
    for _, n in ipairs(nodes[cont] or {}) do if n.known then out[#out + 1] = n end end
    return out
end

-- Your travel speed (yd/s): on foot 7, or your mount's speed once you've ridden it, since you'd
-- ride to the flight master and on from it. Speed boosts without a mount (Cheetah) don't count.
function T.Speed()
    local mounted = IsMounted and W.Safe(IsMounted())
    if mounted and not UnitOnTaxi("player") then
        local s = GetUnitSpeed and W.Safe(GetUnitSpeed("player")) or 0
        if s > RUN_SPEED and s <= MOUNT_MAX and s > (W.cdb.mountSpeed or 0) then W.cdb.mountSpeed = s end
    end
    return W.cdb.mountSpeed or RUN_SPEED
end

-- Walkable zone borders (undirected uiMapID graph) so flight advice never lands on the wrong
-- side of an impassable mountain wall (e.g. Hammerfall in Arathi for a target in The Hinterlands,
-- which has no path and must be entered via Hillsbrad Foothills).
local ZONE_ADJ = {}
local function linkZones(a, list)
    ZONE_ADJ[a] = ZONE_ADJ[a] or {}
    for _, b in ipairs(list) do
        ZONE_ADJ[a][b] = true
        ZONE_ADJ[b] = ZONE_ADJ[b] or {}
        ZONE_ADJ[b][a] = true
    end
end
-- Eastern Kingdoms
linkZones(1420, { 1458, 1421, 1422 })                 -- Tirisfal <-> Undercity, Silverpine, WPL
linkZones(1421, { 1424 })                             -- Silverpine <-> Hillsbrad
linkZones(1424, { 1416, 1417, 1425 })                 -- Hillsbrad <-> Alterac, Arathi, Hinterlands
linkZones(1416, { 1422 })                             -- Alterac <-> WPL
linkZones(1422, { 1423 })                             -- WPL <-> EPL
linkZones(1417, { 1437 })                             -- Arathi <-> Wetlands (Thandol Span)
linkZones(1437, { 1432 })                             -- Wetlands <-> Loch Modan (Dun Algaz)
linkZones(1432, { 1426, 1418 })                       -- Loch Modan <-> Dun Morogh, Badlands
linkZones(1426, { 1455 })                             -- Dun Morogh <-> Ironforge
linkZones(1418, { 1427 })                             -- Badlands <-> Searing Gorge
linkZones(1427, { 1428 })                             -- Searing Gorge <-> Burning Steppes
linkZones(1428, { 1433 })                             -- Burning Steppes <-> Redridge
linkZones(1429, { 1453, 1436, 1431, 1433 })           -- Elwynn <-> Stormwind, Westfall, Duskwood, Redridge
linkZones(1436, { 1431 })                             -- Westfall <-> Duskwood
linkZones(1431, { 1433, 1434, 1430 })                 -- Duskwood <-> Redridge, STV, Deadwind Pass
linkZones(1430, { 1435 })                             -- Deadwind Pass <-> Swamp of Sorrows
linkZones(1435, { 1419 })                             -- Swamp of Sorrows <-> Blasted Lands
-- Kalimdor
linkZones(1438, { 1457 })                             -- Teldrassil <-> Darnassus (island)
linkZones(1439, { 1440 })                             -- Darkshore <-> Ashenvale
linkZones(1440, { 1448, 1447, 1413, 1442 })           -- Ashenvale <-> Felwood, Azshara, Barrens, Stonetalon
linkZones(1448, { 1450, 1452 })                       -- Felwood <-> Moonglade, Winterspring
linkZones(1450, { 1452 })                             -- Moonglade <-> Winterspring
linkZones(1411, { 1454, 1413 })                       -- Durotar <-> Orgrimmar, Barrens
linkZones(1413, { 1412, 1442, 1445, 1441 })           -- Barrens <-> Mulgore, Stonetalon, Dustwallow, 1k Needles
linkZones(1412, { 1456 })                             -- Mulgore <-> Thunder Bluff
linkZones(1442, { 1443 })                             -- Stonetalon <-> Desolace
linkZones(1443, { 1444 })                             -- Desolace <-> Feralas
linkZones(1444, { 1441 })                             -- Feralas <-> 1k Needles
linkZones(1441, { 1446 })                             -- 1k Needles <-> Tanaris
linkZones(1446, { 1449 })                             -- Tanaris <-> Un'Goro
linkZones(1449, { 1451 })                             -- Un'Goro <-> Silithus

-- Flight-point zone suffix (", Arathi", ", Hillsbrad", etc.) -> uiMapID
local ZONE_NAME_MAP = {
    ["durotar"] = 1411, ["orgrimmar"] = 1454, ["mulgore"] = 1412, ["thunder bluff"] = 1456,
    ["the barrens"] = 1413, ["barrens"] = 1413, ["alterac mountains"] = 1416, ["alterac"] = 1416,
    ["arathi highlands"] = 1417, ["arathi"] = 1417, ["badlands"] = 1418, ["blasted lands"] = 1419,
    ["tirisfal glades"] = 1420, ["tirisfal"] = 1420, ["undercity"] = 1458,
    ["silverpine forest"] = 1421, ["silverpine"] = 1421,
    ["western plaguelands"] = 1422, ["eastern plaguelands"] = 1423,
    ["hillsbrad foothills"] = 1424, ["hillsbrad"] = 1424,
    ["the hinterlands"] = 1425, ["hinterlands"] = 1425,
    ["dun morogh"] = 1426, ["ironforge"] = 1455, ["searing gorge"] = 1427, ["burning steppes"] = 1428,
    ["elwynn forest"] = 1429, ["elwynn"] = 1429, ["stormwind"] = 1453, ["stormwind city"] = 1453,
    ["deadwind pass"] = 1430, ["duskwood"] = 1431, ["loch modan"] = 1432,
    ["redridge mountains"] = 1433, ["redridge"] = 1433,
    ["stranglethorn vale"] = 1434, ["stranglethorn"] = 1434,
    ["swamp of sorrows"] = 1435, ["westfall"] = 1436, ["wetlands"] = 1437,
    ["teldrassil"] = 1438, ["darnassus"] = 1457, ["darkshore"] = 1439, ["ashenvale"] = 1440,
    ["thousand needles"] = 1441, ["stonetalon mountains"] = 1442, ["stonetalon"] = 1442,
    ["desolace"] = 1443, ["feralas"] = 1444, ["dustwallow marsh"] = 1445, ["dustwallow"] = 1445,
    ["tanaris"] = 1446, ["azshara"] = 1447, ["felwood"] = 1448, ["un'goro crater"] = 1449,
    ["moonglade"] = 1450, ["silithus"] = 1451, ["winterspring"] = 1452,
}

local function nodeZone(n)
    if not n then return nil end
    if n.map then return n.map end
    local name = n.name
    if type(name) ~= "string" then return nil end
    local suffix = name:match(",%s*([^,]+)%s*$")
    if suffix then
        local m = ZONE_NAME_MAP[suffix:lower()]
        if m then return m end
    end
    return ZONE_NAME_MAP[name:lower()]
end
T.NodeZone = nodeZone

local hopCache = {}
local function zoneHops(a, b)
    if not (a and b) then return nil end
    if a == b then return 0 end
    if not (ZONE_ADJ[a] and ZONE_ADJ[b]) then return nil end
    if ZONE_ADJ[a][b] then return 1 end
    local key = a * 10000 + b
    local cached = hopCache[key]
    if cached ~= nil then return cached >= 0 and cached or nil end
    local dists = { [a] = 0 }
    local q, head = { a }, 1
    while head <= #q do
        local u = q[head]
        head = head + 1
        local d = dists[u]
        for v in pairs(ZONE_ADJ[u]) do
            if v == b then
                hopCache[key] = d + 1
                return d + 1
            end
            if not dists[v] then
                dists[v] = d + 1
                q[#q + 1] = v
            end
        end
    end
    hopCache[key] = -1
    return nil
end
T.ZoneHops = zoneHops

-- Extra riding distance added when two zones have no direct walkable border (mountain wall or sea).
local BARRIER_DETOUR = 2600
local ISLAND_DETOUR = 25000
local function barrierDist(aMap, bMap, straight)
    if not (aMap and bMap and ZONE_ADJ[aMap] and ZONE_ADJ[bMap]) then return straight end
    local h = zoneHops(aMap, bMap)
    if not h then return straight + ISLAND_DETOUR end
    if h >= 2 then return straight + (h - 1) * BARRIER_DETOUR end
    return straight
end

-- seconds riding d straight-line yards: direct within one zone, winding across zone borders/mountains
local function groundTime(d, v)
    if d <= STRAIGHT_GROUND then return d / v end
    return (STRAIGHT_GROUND + (d - STRAIGHT_GROUND) * CROSS_ZONE_WIND) / v
end

-- seconds from here to the target via flight A -> B (accounting for impassable mountain borders)
local function flightTime(v, px, py, A, B, tx, ty, pMap, tMap)
    local dDep = barrierDist(pMap, nodeZone(A), d2(px, py, A.wx, A.wy))
    local dArr = barrierDist(nodeZone(B), tMap, d2(B.wx, B.wy, tx, ty))
    return groundTime(dDep, v)
        + d2(A.wx, A.wy, B.wx, B.wy) / TAXI_SPEED
        + FLIGHT_OVERHEAD
        + groundTime(dArr, v)
end

-- Pick up to `limit` nearest nodes to (x, y), also guaranteeing the nearest node of any other
-- known flight network so an isolated local network never hides a connected mainland flight master.
local function pickNearestNodes(known, x, y, limit, zoneMap)
    table.sort(known, function(a, b)
        local da = barrierDist(zoneMap, nodeZone(a), d2(x, y, a.wx, a.wy))
        local db = barrierDist(zoneMap, nodeZone(b), d2(x, y, b.wx, b.wy))
        return da < db
    end)
    local out, seenNet = {}, {}
    for i = 1, math.min(limit, #known) do
        local n = known[i]
        out[#out + 1] = n
        if n.net then seenNet[n.net] = true end
    end
    for i = limit + 1, #known do
        local n = known[i]
        if n.net and not seenNet[n.net] then
            seenNet[n.net] = true
            out[#out + 1] = n
        end
    end
    return out
end

-- Fastest estimated travel time (seconds) between two points on the same continent, accounting for
-- known flight paths on that continent when flying beats riding.
local function legTime(cont, sx, sy, ex, ey)
    local v = T.Speed()
    local best = groundTime(d2(sx, sy, ex, ey), v)
    if not (W.db and W.db.travelAdvice) then return best end
    local known = T:KnownNodes(cont)
    if #known < 2 then return best end
    local froms = pickNearestNodes(known, sx, sy, 4)
    local tos = pickNearestNodes(known, ex, ey, 4)
    for _, A in ipairs(froms) do
        for _, B in ipairs(tos) do
            if A ~= B and T.SameNetwork(A, B) then
                local t = flightTime(v, sx, sy, A, B, ex, ey)
                if t < best then best = t end
            end
        end
    end
    return best
end

local crossCache = { key = nil, at = 0, result = nil }

-- From where you stand to a target on another continent: the crossing with the shortest total
-- travel time (walking or known flights on both continents).
-- Returns { kind, from = {cont, wx, wy, map, x, y, name}, to = {...}, cost = seconds } or nil.
function T:Crossing(tc, tx, ty)
    local pc, px, py = T.PlayerWorld()
    if not (pc and tc) or pc == tc then return end
    local ck = ("%d:%d:%d:%d:%d:%d"):format(pc, math.floor(px / 40), math.floor(py / 40), tc, math.floor(tx / 40), math.floor(ty / 40))
    if crossCache.key == ck and GetTime() - crossCache.at < 3 then return crossCache.result end
    T:Refresh()
    local faction = UnitFactionGroup and UnitFactionGroup("player")
    local best, bestCost
    for _, c in ipairs(CROSSINGS) do
        if not c.faction or c.faction == faction then
            for _, ends in ipairs({ { c.a, c.b }, { c.b, c.a } }) do
                local A, B = ends[1], ends[2]
                local ac, ax, ay = T.World(A.map, A.x, A.y)
                local bc, bx, by = T.World(B.map, B.x, B.y)
                if ac == pc and bc == tc then
                    local cost = legTime(pc, px, py, ax, ay) + legTime(tc, bx, by, tx, ty)
                    if not bestCost or cost < bestCost then
                        bestCost = cost
                        best = { kind = c.kind, cost = cost,
                                 from = { cont = ac, wx = ax, wy = ay, map = A.map, x = A.x, y = A.y, name = A.name },
                                 to = { cont = bc, wx = bx, wy = by, map = B.map, x = B.x, y = B.y, name = B.name } }
                    end
                end
            end
        end
    end
    crossCache.key, crossCache.at, crossCache.result = ck, GetTime(), best
    return best
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
T.toldCut = {}
local function forgetAdvice()
    cache.key, sticky.key, sticky.pick = nil, nil, nil
    crossCache.key, crossCache.result = nil, nil
end

function T:Advice(map, x, y)
    if not W.db.travelAdvice or UnitOnTaxi("player") then return end
    local key = (map or 0) .. ":" .. math.floor((x or 0) * 10) .. ":" .. math.floor((y or 0) * 10)
    if cache.key == key and GetTime() - cache.at < 3 then return cache.result end
    cache.key, cache.at, cache.result = key, GetTime(), nil

    T:Refresh()
    local pc, px, py = T.PlayerWorld()
    local tc, tx, ty = T.World(map, x, y)
    if not pc or not tc or pc ~= tc then return end
    local pMap = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local v = T.Speed()
    local straight = d2(px, py, tx, ty)
    local rawWalk = groundTime(straight, v)
    local barrierWalk = groundTime(barrierDist(pMap, map, straight), v)
    -- Only compare against the barrier-adjusted walk when both taxi nodes identify a zone,
    -- so synthetic/unnamed nodes compare apples-to-apples against raw straight-line distance.
    local function walkFor(A, B)
        return (nodeZone(A) and nodeZone(B)) and barrierWalk or rawWalk
    end
    if sticky.key == key and sticky.pick then
        local A, B = sticky.pick.from, sticky.pick.to
        local w = walkFor(A, B)
        local t = flightTime(v, px, py, A, B, tx, ty, pMap, map)
        if w - t >= w * KEEP_SHARE then
            sticky.pick.save = (w - t) * v      -- in yards, for the hearthstone comparison
            cache.result = sticky.pick
            return sticky.pick
        end
    end
    sticky.key, sticky.pick = key, nil
    if barrierWalk < MIN_SAVE + FLIGHT_OVERHEAD then return end

    local known = T:KnownNodes(pc)
    if #known < 2 then return end
    -- best departure is near the player, best arrival near the target (spanning all known networks
    -- and penalizing landings separated from the target by impassable mountain walls)
    local froms = pickNearestNodes(known, px, py, 4, pMap)
    table.sort(known, function(a, b)
        return barrierDist(nodeZone(a), map, d2(tx, ty, a.wx, a.wy))
             < barrierDist(nodeZone(b), map, d2(tx, ty, b.wx, b.wy))
    end)
    local tos = {}
    for _, B in ipairs(known) do
        for _, A in ipairs(froms) do
            if A ~= B and T.SameNetwork(A, B) then tos[#tos + 1] = B break end
        end
        if #tos == 4 then break end
    end
    local best, bestSave
    for _, A in ipairs(froms) do
        for _, B in ipairs(tos) do
            if A ~= B and T.SameNetwork(A, B) then
                local w = walkFor(A, B)
                local cost = flightTime(v, px, py, A, B, tx, ty, pMap, map)
                local save = w - cost
                if save >= math.max(MIN_SAVE, w * NEW_SHARE) and (not bestSave or save > bestSave) then
                    best, bestSave = { from = A, to = B }, save
                end
            end
        end
    end
    if best then
        best.save = bestSave * v
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
            storeNodes(taxiMap, list, true)
            local CURRENT = (Enum and Enum.FlightPathState and Enum.FlightPathState.Current) or 0
            local best, bestD
            for _, n in ipairs(list) do
                if flyable(n) then
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
        mark.ring:SetTexture("Interface\\AddOns\\Onward\\media\\glow")   -- soft and round, no box
        mark.ring:SetBlendMode("ADD")
        mark.text = mark:CreateFontString(nil, "OVERLAY")
        mark.text:SetPoint("BOTTOM", mark, "TOP", 0, -6)
    end
    local A = W.Skin and W.Skin.ACCENT or { 0.3, 0.8, 1 }
    mark:SetParent(b:GetParent() or UIParent)
    mark:SetFrameStrata(b:GetFrameStrata() or "DIALOG")
    mark:SetFrameLevel(math.max((tonumber(b:GetFrameLevel()) or 1) - 1, 0))   -- behind the node icon
    mark:ClearAllPoints()
    local w = math.max(tonumber(b:GetWidth()) or 16, 16)
    mark:SetSize(w * 3, w * 3)
    mark:SetPoint("CENTER", b, "CENTER", 0, 0)
    mark.ring:SetVertexColor(A[1], A[2], A[3], 0.95)
    mark.text:SetFont(W.Skin and W.Skin.FontPath("body") or "Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    mark.text:SetTextColor(A[1], A[2], A[3])
    mark.text:SetText("Onward")
    mark:Show()
    T.marked = slot
    -- a slow breath while the flight map is open, so the eye finds it without any blinking
    W.Anim.Loop("taxi", 1.8, function(t)
        local b = 0.5 - 0.5 * math.cos(2 * math.pi * t)
        mark.ring:SetAlpha(0.5 + 0.5 * b)
        mark.ring:ClearAllPoints()
        local grow = w * 0.25 * b
        mark.ring:SetPoint("TOPLEFT", mark, "TOPLEFT", -grow, grow)
        mark.ring:SetPoint("BOTTOMRIGHT", mark, "BOTTOMRIGHT", grow, -grow)
    end)
end

-- Flight networks. The flight master's own list is the truth about where you can fly from there.
-- The continent map also shows flight points you know on a network of their own (a zone with
-- its own flights and no route to the rest, like Riverglades). Each flight master visit names
-- its network after the first of its points (alphabetically) and marks the points you know that
-- it doesn't reach "~<that name>"; remembered per character. Flights are only planned between
-- points of one network (or points whose network isn't known yet). Returns true on a change.

local function learnNetwork()
    local taxiMap = GetTaxiMapID and GetTaxiMapID()
    if not (taxiMap and C_TaxiMap and C_TaxiMap.GetAllTaxiNodes) then return end
    local ok, list = pcall(C_TaxiMap.GetAllTaxiNodes, taxiMap)
    if not (ok and type(list) == "table") then return end
    storeNodes(taxiMap, list, true)
    local offered, key = {}, nil
    for _, n in ipairs(list) do
        if n.name and flyable(n) then
            offered[n.name] = true
            if not key or n.name < key then key = n.name end
        end
    end
    if not key then return end
    local pc = T.PlayerWorld()
    W.cdb.taxiNet = W.cdb.taxiNet or {}
    local changed
    for _, n in ipairs(nodes[pc] or {}) do
        local net = offered[n.name] and key or (n.known and "~" .. key) or nil
        if net and net ~= n.net then
            changed = true
            n.net = net
            W.cdb.taxiNet[n.name] = net
        end
    end
    return changed
end
-- can you fly from a to b (as far as Onward knows)?
-- (two points that are both just "not on that network" aren't known to share one)
function T.SameNetwork(a, b)
    if not (a and b and a.net and b.net) then return true end
    return a.net == b.net and a.net:sub(1, 1) ~= "~"
end
T.LearnNetwork = learnNetwork

local function takeFlight()
    T.marked = nil
    local asked = wantedDest and wantedDest.name
    -- what this flight master really reaches, before any plan uses it; always re-evaluate advice
    -- fresh while the flight map is open so updated nodes take effect immediately
    local netChanged = learnNetwork()
    forgetAdvice()
    if netChanged and W.Waypoint and W.Waypoint.Update then pcall(W.Waypoint.Update, W.Waypoint) end
    -- talking to the flight master refreshes the guide, which can clear the wanted flight a
    -- moment before the map opens: ask the arrow again so it's set from the current step
    if W.Waypoint and W.Waypoint.ArrowTarget then pcall(W.Waypoint.ArrowTarget, W.Waypoint) end
    -- the flight the plan wanted is on the map but not linked to this one: say why, once
    local cutOff = asked and W.cdb.taxiNet and (W.cdb.taxiNet[asked] or ""):sub(1, 1) == "~"
    if cutOff and not T.toldCut[asked] then
        T.toldCut[asked] = true
        W.Print(asked .. " is on your flight map, but no flight path links it to here yet: a flight point between them is still to find. Learn the flight points you pass on the way and it joins up.")
    end
    if not wantedDest then
        if cutOff then W.Print("No flight from here gets you closer. The arrow leads the way on foot.") end
        return
    end
    local node = T.WantedNode()
    if not node then
        if wantedDest.name then W.Print("No flight from here reaches " .. wantedDest.name .. ". The arrow leads the rest of the way.") end
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
W:On("TAXIMAP_CLOSED", function() W.Anim.Stop("taxi") if mark then mark:Hide() end end)
W:On("PLAYER_ENTERING_WORLD", function() C_Timer.After(3, function() T:Refresh(true) end) end)
-- learning a new flight path: re-read known nodes shortly after
W:On("UI_INFO_MESSAGE", function(_, _, msg)
    if msg and ERR_NEWTAXIPATH and msg == ERR_NEWTAXIPATH then C_Timer.After(0.5, function() T:Refresh(true) end) end
end)
W:On("PLAYER_CONTROL_GAINED", function() W:RequestRefresh() W:Fire("WF_LANDED") end)
