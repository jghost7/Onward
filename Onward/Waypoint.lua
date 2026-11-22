-- Waypoints: decides where the current step points, sets Blizzard's map pin (and TomTom),
-- and feeds the nav arrow. One 0.5s timer runs only while a goto/fly step waits for arrival.
local _, W = ...
local WP = {}
W.Waypoint = WP

local QB, T = W.QuestieBridge, W.Travel

-- Objective spots: Questie's spawns, else our own looked-up list (Guides/QuestSpots.lua) for
-- quests Questie has nothing for. done[i] = objective i is finished; our spots are matched to
-- objectives by item name ("Sweetberry: 8/8" finished -> its bushes drop out).
local ownCache = {}
function WP.ObjectiveSpots(q, done)
    local s = QB:ObjectiveSpots(q, done)
    if s and #s > 0 then return s end
    local data = W.QuestSpots and W.QuestSpots[q]
    if not data then return s end
    local finished = {}
    local e = W.QuestState and W.QuestState:Get(q)
    for i, o in ipairs(e and e.objectives or {}) do
        if (o.finished or (done and done[i])) and o.text then finished[#finished + 1] = o.text:lower() end
    end
    if not ownCache[q] then
        ownCache[q] = {}
        for _, d in ipairs(data) do
            for x, y in d[3]:gmatch("([%d.]+),([%d.]+)") do
                ownCache[q][#ownCache[q] + 1] = { map = d[1], x = tonumber(x), y = tonumber(y), name = d[2] }
            end
        end
    end
    local out = {}
    for _, p in ipairs(ownCache[q]) do
        local skip = false
        for _, f in ipairs(finished) do
            if f:find(p.name:lower(), 1, true) == 1 then skip = true break end
        end
        if not skip then out[#out + 1] = p end
    end
    return out
end
local tomtomUid
local ticker
local current       -- { step, map, x, y, name, title } : the step's own target

local function clearTomTom()
    if tomtomUid and TomTom and TomTom.RemoveWaypoint then pcall(TomTom.RemoveWaypoint, TomTom, tomtomUid) end
    tomtomUid = nil
end

local function stopTicker()
    if ticker then ticker:Cancel() ticker = nil end
end

local function setPin(map, x, y, title)
    if not W.db.waypoints then return false end
    if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(map) then return false end
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(map, x / 100, y / 100))
    pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)   -- protected on some builds: quiet failure is fine
    clearTomTom()
    if W.db.tomtom and TomTom and TomTom.AddWaypoint then
        local ok, uid = pcall(TomTom.AddWaypoint, TomTom, map, x / 100, y / 100,
            { title = title, persistent = false, minimap = true, world = true, from = "Onward" })
        if ok then tomtomUid = uid end
    end
    return true
end

local function clearPin()
    C_Map.ClearUserWaypoint()
    clearTomTom()
end

-- arrival check for goto and fly steps
local function startProximity(step)
    stopTicker()
    ticker = C_Timer.NewTicker(0.5, function()
        if W.Guide:Current() ~= step then stopTicker() return end
        if step.verb == "fly" and UnitOnTaxi("player") then return end
        local d = T.Distance(step.at.map, step.at.x, step.at.y)
        local r = step.radius or 15
        if step.verb == "fly" and step.plan and (step.plan.walk or step.landed) then r = math.min(r, 20) end
        if d and d <= r then
            stopTicker()
            W.Guide:MarkReached(step)
        end
    end)
end

---------------------------------------------------------------------------
-- Areas: a kill/loot step whose mobs or objects sit in several camps well apart (|areas).
-- The step points at the camp nearest you, and only moves to another when that one is clearly
-- closer (30%). Picking one yourself (the panel's area line, /ow area) keeps it until the step
-- is done: for a camp that's overrun, or one that suits the way you're heading.
---------------------------------------------------------------------------
local AREA_SWITCH = 0.7
local function areaList(step)
    if not (step and step.verb == "complete" and step.areas and step.at and step.at.map) then return end
    if not step.areaWorld then
        local list = {}
        for i, a in ipairs(step.areas) do
            local cont, wx, wy = T.World(step.at.map, a.x, a.y)
            if cont then
                list[#list + 1] = { index = i, map = step.at.map, x = a.x, y = a.y, n = a.n, cont = cont, wx = wx, wy = wy,
                                    name = T.PlaceName(step.at.map, a.x, a.y) }
            end
        end
        if #list < #step.areas then return #list > 1 and list or nil end   -- map data not in yet: don't keep it
        step.areaWorld = list
    end
    return #step.areaWorld > 1 and step.areaWorld or nil
end

local function pickArea(step)
    local list = areaList(step)
    if not list then return end
    if step.areaPinned and list[step.area] then return list[step.area], list end
    local pc, px, py = T.PlayerWorld()
    local best, bestD
    for k, a in ipairs(list) do
        if a.cont == pc then
            local d = (a.wx - px) ^ 2 + (a.wy - py) ^ 2
            if not bestD or d < bestD then best, bestD = k, d end
        end
    end
    local cur = step.area and list[step.area]
    if not best then
        best = cur and step.area or 1
    elseif cur and best ~= step.area and cur.cont == pc
        and bestD >= ((cur.wx - px) ^ 2 + (cur.wy - py) ^ 2) * AREA_SWITCH * AREA_SWITCH then
        best = step.area                                                -- not clearly closer: keep
    end
    step.area = best
    return list[best], list
end

-- the current step's areas and the one it points at: list, chosen (nil when it has only one place)
function WP:Areas(step)
    step = step or (W.Guide:Current())
    local chosen, list = pickArea(step)
    if not chosen then return end
    return list, chosen, step.areaPinned or false
end

-- point the step at its next area (in the guide's order, biggest camp first) and keep it there
function WP:NextArea()
    local step = W.Guide:Current()
    local chosen, list = pickArea(step)
    if not chosen then return end
    step.area = step.area % #list + 1
    step.areaPinned = true
    WP:Update()
    W:Fire("WF_UPDATED")
    return list[step.area], #list
end

-- Where a step points: explicit coords, then Questie NPC data, then Blizzard's quest waypoint.
function WP:Resolve(step)
    if (step.verb == "train" or step.verb == "craft") and W.Prof then
        return W.Prof:Location(step)        -- trainer, book / recipe vendor or quest giver
    end
    -- working on (or handing in) a quest you haven't picked up, or a failed quest (escort/timed):
    -- go to its giver first. The guide's own accept step knows who and where; else Questie does.
    local G = W.Guide
    if (step.verb == "complete" or step.verb == "turnin") and step.quest and G and (G:IsMissing(step) or G:IsFailed(step)) then
        for _, s in ipairs(G:Active() and G:Active().steps or {}) do
            if s.verb == "accept" and s.quest == step.quest and s.at then
                return s.at.map or C_Map.GetBestMapForUnit("player"), s.at.x, s.at.y, s.npc, true
            end
        end
        local loc = QB:StartLocation(step.quest)
        if loc then return loc.map, loc.x, loc.y, loc.name, true end
    end
    -- a turn-in whose quest is in your log and unfinished (guide had no `complete` step for it):
    -- point at the quest's live objective instead of the turn-in NPC until it's ready
    if step.verb == "turnin" and step.quest and G and G:IsUnfinishedTurnin(step) then
        if C_QuestLog.GetNextWaypoint and C_QuestLog.IsOnQuest(step.quest) then
            local ok, map, x, y = pcall(C_QuestLog.GetNextWaypoint, step.quest)
            if ok and map and x then return map, x * 100, y * 100, nil end
        end
        local spots = WP.ObjectiveSpots(step.quest)
        if spots then
            local pc, px, py = T.PlayerWorld()
            local best, bestD
            for _, s in ipairs(spots) do
                local c, wx, wy = T.World(s.map, s.x, s.y)
                local d = c and pc == c and (wx - px) ^ 2 + (wy - py) ^ 2 or math.huge
                if not best or d < bestD then best, bestD = s, d end
            end
            if best then return best.map, best.x, best.y, best.name end
        end
    end
    -- an accept that waits on a quest the guide doesn't cover: lead to that quest's giver
    if step.verb == "accept" and G then
        local _, kind, pre = G:HeldReason(step)
        local g = G:Active()
        if kind == "pre" and pre and not (g and g.acceptOf and g.acceptOf[pre]) then
            local first = QB:StartLocation(pre)
            if first then return first.map, first.x, first.y, first.name end
        end
    end
    if step.verb == "complete" then
        local area = pickArea(step)
        if area then return area.map, area.x, area.y, area.name or step.npc end
    end
    if step.at then
        return step.at.map or C_Map.GetBestMapForUnit("player"), step.at.x, step.at.y, step.npc
    end
    local loc
    if step.verb == "accept" then loc = QB:StartLocation(step.quest)
    elseif step.verb == "turnin" then loc = QB:EndLocation(step.quest) end
    if loc then return loc.map, loc.x, loc.y, step.npc or loc.name end
    if step.quest and C_QuestLog.GetNextWaypoint and C_QuestLog.IsOnQuest(step.quest) then
        local ok, map, x, y = pcall(C_QuestLog.GetNextWaypoint, step.quest)
        if ok and map and x then return map, x * 100, y * 100, nil end
    end
    -- a kill/loot step the guide has no place for (its mobs are over a zone border, say): the
    -- nearest place Questie knows the objective can be done
    if step.verb == "complete" and step.quest then
        local spots = WP.ObjectiveSpots(step.quest)
        if spots then
            local pc, px, py = T.PlayerWorld()
            local best, bestD
            for _, s in ipairs(spots) do
                local c, wx, wy = T.World(s.map, s.x, s.y)
                local d = c and pc == c and (wx - px) ^ 2 + (wy - py) ^ 2 or math.huge
                if not best or d < bestD then best, bestD = s, d end
            end
            if best then return best.map, best.x, best.y, best.name end
        end
    end
end

-- fly steps: before take-off the pin is the departure flight master, after it the destination.
-- A destination you haven't discovered can't be flown to (Travel:FlightPlan): then the flight goes
-- to the learned point nearest it, and from there (or straight away, when no flight helps) the
-- pin leads on foot to the destination's flight master, which learns it ("walk" leg).
local function flyLeg(step)
    local plan = T:FlightPlan(step)
    step.plan = plan
    if UnitOnTaxi("player") then return step.at, "arrive" end
    if plan and (plan.walk or step.landed) then return step.at, "walk" end
    local d = T.Distance(step.at.map, step.at.x, step.at.y)
    if d and d <= (step.radius or 150) then return step.at, "arrive" end
    local pc, px, py = T.PlayerWorld()
    local fc = step.from and T.World(step.from.map or step.at.map, step.from.x, step.from.y)
    if step.from and (fc == pc or not pc) then return step.from, "depart" end
    -- no departure in the guide, or it's on the other continent (you came over by boat or
    -- zeppelin): the learned flight point nearest you, other than the one you're flying to
    local dc, dx, dy = T.World(step.at.map, step.at.x, step.at.y)
    local best, bestD
    for _, n in ipairs(pc and T:KnownNodes(pc) or {}) do
        local dd = (n.wx - px) ^ 2 + (n.wy - py) ^ 2
        local isDest = dc == pc and (n.wx - dx) ^ 2 + (n.wy - dy) ^ 2 <= 300 ^ 2
        if n ~= (plan and plan.via) and not isDest and (not bestD or dd < bestD) then best, bestD = n, dd end
    end
    if best then return { world = best }, "depart" end
    return step.from or step.at, step.from and "depart" or "arrive"
end

function WP:Update()
    stopTicker()
    local old = current
    current = nil
    local step = W.Guide:Current()
    if not step then clearPin() T:SetWantedDestination(nil) return end

    local title = W.UI and W.UI.StepText and W.UI.StepText(step) or step.verb
    local map, x, y, name, legKind, pickup
    if step.verb == "fly" then
        local leg
        leg, legKind = flyLeg(step)
        if leg.world then
            -- a flight point known only in world coordinates: put it on the player's zone map
            local pm = C_Map.GetBestMapForUnit("player")
            local ok, _, pos = pcall(C_Map.GetMapPosFromWorldPos, T.PlayerWorld(), CreateVector2D(leg.world.wx, leg.world.wy), pm)
            if ok and pos then map, x, y = pm, pos.x * 100, pos.y * 100 end
            name = leg.world.name
        else
            map, x, y, name = leg.map or step.at.map, leg.x, leg.y, step.npc
        end
        local plan = step.plan
        if plan and plan.via then
            -- not discovered yet: the flight goes to the learned point nearest it
            local dc = T.World(step.at.map, step.at.x, step.at.y)
            T:SetWantedDestination(dc, plan.via.wx, plan.via.wy, plan.via.name)
        elseif plan and plan.walk then
            T:SetWantedDestination(nil)
        else
            local wc, wx, wy = T.World(step.at.map, step.at.x, step.at.y)
            T:SetWantedDestination(wc, wx, wy, T:PlaceAt(step.at.map, step.at.x, step.at.y))
        end
    else
        map, x, y, name, pickup = WP:Resolve(step)
        T:SetWantedDestination(nil)
        if pickup then title = "Pick up " .. (W.QuestState:Title(step.quest) or "the quest") .. " first" end
    end

    -- the target is on the other continent: first to the boat or zeppelin that makes the trip shortest
    local cross, dest
    if map and x then
        local tm, tx, ty = map, x, y
        if step.verb == "fly" then tm, tx, ty = step.at.map, step.at.x, step.at.y end
        local tc, wx, wy = T.World(tm, tx, ty)
        cross = tc and T:Crossing(tc, wx, wy)
        if cross then
            dest = { cont = tc, wx = wx, wy = wy, map = tm, x = tx, y = ty }
            map, x, y, name, legKind = cross.from.map, cross.from.x, cross.from.y, cross.from.name, "cross"
            T:SetWantedDestination(nil)
        end
    end

    if map and x then
        current = { step = step, map = map, x = x, y = y, name = name, title = title, leg = legKind, pickup = pickup, cross = cross, dest = dest }
        if old and old.step == step then   -- same step re-resolved (settings, delayed refresh): keep the chosen spot
            current.spots, current.spot, current.spotSig = old.spots, old.spot, old.spotSig
        end
        if not setPin(map, x, y, title) then clearPin() end
        if step.verb == "goto" or step.verb == "fly" then startProximity(step) end
    else
        clearPin()
        if step.quest and C_QuestLog.IsOnQuest(step.quest) then pcall(C_SuperTrack.SetSuperTrackedQuestID, step.quest) end
    end
    W:Fire("WF_TARGET_CHANGED", current)
end

function WP:Current() return current end

---------------------------------------------------------------------------
-- Kill / loot / use steps: point at the nearest place the objective can be done (Questie's
-- spawns for the unfinished objectives), not at the middle of the whole area. The choice is
-- re-checked every second and only switches when another spot is clearly closer (30%), so the
-- arrow doesn't swing between two equally near camps.
---------------------------------------------------------------------------
local SPOT_SWITCH = 0.7
local function doneSignature(q)
    local e = W.QuestState:Get(q)
    local done, sig = {}, ""
    for i, o in ipairs(e and e.objectives or {}) do
        if o.finished then done[i] = true sig = sig .. i .. "," end
    end
    return done, sig
end

local function nearestSpot(c)
    local step = c.step
    if step.verb ~= "complete" or not step.quest or c.pickup then return end
    local now = GetTime()
    if c.spotsAt and now - c.spotsAt < 1 then return c.spot end
    c.spotsAt = now
    local done, sig = doneSignature(step.quest)
    local area, areas = pickArea(step)
    if area then sig = sig .. "|area" .. area.index end
    if c.spotSig ~= sig then
        c.spotSig, c.spot = sig, nil
        c.spots = {}
        if step.obj then   -- a step for one objective: only that one
            for i in pairs(W.QuestState:Get(step.quest) and W.QuestState:Get(step.quest).objectives or {}) do
                if i ~= step.obj then done[i] = true end
            end
        elseif step.objName then
            local needle = step.objName:lower()
            for i, o in ipairs(W.QuestState:Get(step.quest) and W.QuestState:Get(step.quest).objectives or {}) do
                if not (o.text and o.text:lower():find(needle, 1, true)) then done[i] = true end
            end
        end
        for _, s in ipairs(WP.ObjectiveSpots(step.quest, done) or {}) do
            local cont, wx, wy = T.World(s.map, s.x, s.y)
            local here = cont ~= nil
            if here and area then
                -- only the spawns of the chosen camp: those nearer to it than to any other
                local own = (area.wx - wx) ^ 2 + (area.wy - wy) ^ 2
                for _, o in ipairs(areas) do
                    if o ~= area and o.cont == cont and (o.wx - wx) ^ 2 + (o.wy - wy) ^ 2 < own then here = false break end
                end
            end
            if here then c.spots[#c.spots + 1] = { cont = cont, wx = wx, wy = wy, name = s.name } end
        end
    end
    if #c.spots == 0 then return end
    local pc, px, py = T.PlayerWorld()
    if not pc then return c.spot end
    local best, bestD
    for _, s in ipairs(c.spots) do
        if s.cont == pc then
            local d = (s.wx - px) ^ 2 + (s.wy - py) ^ 2
            if not bestD or d < bestD then best, bestD = s, d end
        end
    end
    if not best then return c.spot end
    local cur = c.spot
    if cur and cur.cont == pc then
        local dc = (cur.wx - px) ^ 2 + (cur.wy - py) ^ 2
        if bestD >= dc * SPOT_SWITCH * SPOT_SWITCH then best = cur end   -- not clearly closer: keep
    end
    c.spot = best
    return best
end

-- Hearthstone advice for a target, weighed against walking or the flight advice (its cost is
-- the straight-line walk minus what the flight saves). Returns an arrow target, or nil.
local function hearthFor(cont, wx, wy, label, flight)
    if not (W.Hearth and cont) then return end
    local now
    if flight and flight.save then
        local pc, px, py = T.PlayerWorld()
        if pc == cont then now = math.sqrt((wx - px) ^ 2 + (wy - py) ^ 2) - flight.save end
    end
    local h = W.Hearth:Advice(cont, wx, wy, now)
    if not h then return end
    T:SetWantedDestination(nil)
    return { label = "Hearth to " .. h.name, sub = "hearthstone is ready, then " .. (label or "on from there"),
             cont = cont, wx = wx, wy = wy, radius = 10, hearth = true, route = "use your hearthstone to " .. h.name }
end

-- Dead and released: the arrow leads back to your body instead of the step, and the guide
-- picks up again once you're alive (at the body, a spirit healer or a resurrection).
-- The corpse is looked up on the map you're on, then its parents (a graveyard in the next zone).
local corpse
function WP:CorpseTarget()
    if not (UnitIsGhost and UnitIsGhost("player")) then corpse = nil return end
    if not corpse and C_DeathInfo and C_DeathInfo.GetCorpseMapPosition then
        local m = C_Map.GetBestMapForUnit("player")
        for _ = 1, 4 do
            if not m then break end
            local ok, pos = pcall(C_DeathInfo.GetCorpseMapPosition, m)
            if ok and pos and pos.x and (pos.x > 0 or pos.y > 0) then
                local cont, wx, wy = T.World(m, pos.x * 100, pos.y * 100)
                if cont then corpse = { cont = cont, wx = wx, wy = wy } end
                break
            end
            local info = C_Map.GetMapInfo(m)
            m = info and info.parentMapID
        end
    end
    if not corpse then return end
    return { label = "Back to your body", sub = current and ("then " .. current.title) or "run back to resurrect",
             cont = corpse.cont, wx = corpse.wx, wy = corpse.wy, radius = 25, corpse = true }
end

local function deathChanged()
    corpse = nil
    W:Fire("WF_TARGET_CHANGED", current)
end
W:On("PLAYER_DEAD", deathChanged)
W:On("PLAYER_ALIVE", deathChanged)     -- also fires on release, as a ghost
W:On("PLAYER_UNGHOST", deathChanged)

-- What the nav arrow points at: hearthstone or flight advice when it beats running, else the
-- step target. returns { label, sub, cont, wx, wy, radius, arrived } or nil
-- This is the travel plan. Guides don't carry flight or boat steps of their own any more: a
-- step only says where it is, and the way there is worked out here from where you stand, each
-- time: a boat or zeppelin when it's on the other continent (with a flight to the dock when
-- that's far), your hearthstone when it's ready and faster, a flight between two points you've
-- learned when that beats running, else on foot. `route` says the first leg in words, for the
-- panel ("fly from Rog'mar to Undercity").
function WP:ArrowTarget()
    local body = WP:CorpseTarget()
    if body then return body end
    if not current then return end
    local step = current.step
    local label = current.title
    if current.cross then
        -- hearthstone bound on the destination continent beats taking a boat/zeppelin every time
        if current.dest then
            local hsDest = hearthFor(current.dest.cont, current.dest.wx, current.dest.wy, label)
            if hsDest then return hsDest end
            local fresh = T:Crossing(current.dest.cont, current.dest.wx, current.dest.wy)
            if fresh then current.cross = fresh end
        end
        local c = current.cross
        local boat = "take the " .. c.kind .. " to " .. c.to.name
        -- the dock is far: check hearthstone toward the dock or flight to the flight point nearest it
        local advice = T:Advice(c.from.map, c.from.x, c.from.y)
        local hsDock = hearthFor(c.from.cont, c.from.wx, c.from.wy, boat, advice)
        if hsDock then return hsDock end
        if advice then
            local A, B = advice.from, advice.to
            T:SetWantedDestination(c.from.cont, B.wx, B.wy, B.name)
            return { label = "Fly: " .. A.name, sub = "to " .. B.name .. ", then " .. boat, cont = c.from.cont, wx = A.wx, wy = A.wy,
                     radius = 10, flight = true, via = { wx = B.wx, wy = B.wy }, final = { cont = c.from.cont, wx = c.from.wx, wy = c.from.wy },
                     route = "fly from " .. A.name .. " to " .. B.name .. ", then " .. boat }
        end
        T:SetWantedDestination(nil)
        return { label = "Take the " .. c.kind .. " to " .. c.to.name,
                 sub = "from " .. c.from.name .. ", then " .. label,
                 cont = c.from.cont, wx = c.from.wx, wy = c.from.wy, radius = 15, crossing = true,
                 route = "take the " .. c.kind .. " from " .. c.from.name .. " to " .. c.to.name }
    end
    -- several camps: keep pointing at the nearest as you move (unless you picked one)
    if step.areas and not step.areaPinned and not current.pickup then
        local before = step.area
        pickArea(step)
        if before and step.area ~= before then
            C_Timer.After(0, function() WP:Update() W:Fire("WF_UPDATED") end)
        end
    end
    local spot = nearestSpot(current)
    if spot then
        -- far from every spot, flight advice still applies (to the spot itself)
        local cx, cy = current.x, current.y
        local advice = T:Advice(current.map, cx, cy)
        local hs = hearthFor(spot.cont, spot.wx, spot.wy, label, advice)
        if hs then return hs end
        if advice then
            local A, B = advice.from, advice.to
            T:SetWantedDestination(spot.cont, B.wx, B.wy, B.name)
            return { label = "Fly: " .. A.name, sub = "to " .. B.name .. ", then " .. label, cont = spot.cont, wx = A.wx, wy = A.wy, radius = 10, flight = true,
                     via = { wx = B.wx, wy = B.wy }, final = { cont = spot.cont, wx = spot.wx, wy = spot.wy },
                     route = "fly from " .. A.name .. " to " .. B.name }
        end
        T:SetWantedDestination(nil)
        local sub = spot.name and ("nearest: " .. spot.name) or current.name
        local list, chosen = WP:Areas(step)
        if list then sub = ("area %d of %d"):format(chosen.index, #list) .. (sub and ("  ·  " .. sub) or "") end
        return { label = label, sub = sub, cont = spot.cont, wx = spot.wx, wy = spot.wy, radius = 30, spot = true }
    end
    local radius = (step.verb == "goto" or (step.verb == "fly" and current.leg == "arrive")) and step.radius
        or (current.leg == "walk" and 20) or 10
    local advice = step.verb ~= "fly" and T:Advice(current.map, current.x, current.y)
    if step.verb ~= "fly" and step.verb ~= "home" then
        local hc, hx, hy = T.World(current.map, current.x, current.y)
        local hs = hearthFor(hc, hx, hy, label, advice or nil)
        if hs then return hs end
    end
    if step.verb ~= "fly" and not advice then T:SetWantedDestination(nil) end
    if advice then
        local A, B = advice.from, advice.to
        local cont = T.PlayerWorld()
        T:SetWantedDestination(cont, B.wx, B.wy, B.name)
        local fc, fx, fy = T.World(current.map, current.x, current.y)
        return { label = "Fly: " .. A.name, sub = "to " .. B.name .. ", then " .. label, cont = cont, wx = A.wx, wy = A.wy, radius = 10, flight = true,
                 via = { wx = B.wx, wy = B.wy }, final = fc and { cont = fc, wx = fx, wy = fy } or nil,
                 route = "fly from " .. A.name .. " to " .. B.name }
    end
    local cont, wx, wy = T.World(current.map, current.x, current.y)
    if not cont then return end
    local sub = current.name
    if step.verb == "fly" then
        local _, who = T.SplitFlightNpc(step.npc)
        local plan = step.plan
        local place = T:PlaceAt(step.at.map, step.at.x, step.at.y) or "there"
        if UnitOnTaxi("player") then
            local landing = plan and plan.via and plan.via.name or who
            sub = "in flight" .. (landing and (", landing " .. (plan and plan.via and "at " or "by ") .. landing) or "")
        elseif current.leg == "walk" then
            label = "Find the flight master: " .. place
            sub = "not discovered yet: " .. (who and ("talk to " .. who .. " to learn it") or "talk to the flight master to learn it")
        elseif plan and plan.via then
            sub = "fly to " .. plan.via.name .. " (" .. place .. " isn't discovered yet), then walk on"
        else
            sub = "go to the flight master and take this flight"
        end
    elseif W.Trail then
        -- back to a quest giver (or any place you walked from): lead along the way you came
        local pc, px, py = T.PlayerWorld()
        local ax, ay, along, path = W.Trail:Guide(cont, wx, wy, pc, px, py)
        if ax then
            return { label = label, sub = "the way you came" .. (current.name and (", to " .. current.name) or ""),
                     cont = cont, wx = ax, wy = ay, radius = 0, trail = true, yards = along, path = path,
                     final = { cont = cont, wx = wx, wy = wy } }
        end
    end
    return { label = label, sub = sub, cont = cont, wx = wx, wy = wy, radius = radius }
end

W:On("WF_STEP_CHANGED", function() WP:Update() end)
-- picked up the quest the current step was waiting on: back from its giver to the step itself
W:On("QUEST_ACCEPTED", function()
    C_Timer.After(0.5, function() if current and current.pickup then WP:Update() end end)
end)
W:On("WF_GUIDE_CHANGED", function() C_Timer.After(2, function() WP:Update() end) end)
W:On("WF_LANDED", function()
    local s = W.Guide:Current()
    if not (s and s.verb == "fly") then return end
    if s.plan and s.plan.via then s.landed = true end
    WP:Update()
end)
-- take-off: switch the pin from the departure flight master to the destination
W:On("PLAYER_CONTROL_LOST", function()
    C_Timer.After(1, function() local s = W.Guide:Current() if s and s.verb == "fly" then WP:Update() end end)
end)
W:On("WF_SETTINGS_CHANGED", function() WP:Update() end)
-- a boat or zeppelin crossing ends in a loading screen: re-plan from the new continent
W:On("PLAYER_ENTERING_WORLD", function() C_Timer.After(2, function() WP:Update() end) end)
