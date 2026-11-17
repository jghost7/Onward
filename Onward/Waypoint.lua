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
        if d and d <= (step.radius or 15) then
            stopTicker()
            W.Guide:MarkReached(step)
        end
    end)
end

-- Where a step points: explicit coords, then Questie NPC data, then Blizzard's quest waypoint.
function WP:Resolve(step)
    if (step.verb == "train" or step.verb == "craft") and W.Prof then
        return W.Prof:Location(step)        -- trainer, book / recipe vendor or quest giver
    end
    -- working on (or handing in) a quest you haven't picked up: go to its giver first. The
    -- guide's own accept step knows who and where; else Questie does. The 5th value marks it.
    local G = W.Guide
    if (step.verb == "complete" or step.verb == "turnin") and step.quest and G and G:IsMissing(step) then
        for _, s in ipairs(G:Active() and G:Active().steps or {}) do
            if s.verb == "accept" and s.quest == step.quest and s.at then
                return s.at.map or C_Map.GetBestMapForUnit("player"), s.at.x, s.at.y, s.npc, true
            end
        end
        local loc = QB:StartLocation(step.quest)
        if loc then return loc.map, loc.x, loc.y, loc.name, true end
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

-- fly steps: before take-off the pin is the departure flight master, after it the destination
local function flyLeg(step)
    if step.from and not UnitOnTaxi("player") then
        local d = T.Distance(step.at.map, step.at.x, step.at.y)
        if not d or d > (step.radius or 150) then return step.from, "depart" end
    end
    return step.at, "arrive"
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
        map, x, y, name = leg.map or step.at.map, leg.x, leg.y, step.npc
        local wc, wx, wy = T.World(step.at.map, step.at.x, step.at.y)
        T:SetWantedDestination(wc, wx, wy, T:PlaceAt(step.at.map, step.at.x, step.at.y))
    else
        map, x, y, name, pickup = WP:Resolve(step)
        T:SetWantedDestination(nil)
        if pickup then title = "Pick up " .. (W.QuestState:Title(step.quest) or "the quest") .. " first" end
    end

    if map and x then
        current = { step = step, map = map, x = x, y = y, name = name, title = title, leg = legKind, pickup = pickup }
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
    if c.spotSig ~= sig then
        c.spotSig, c.spot = sig, nil
        c.spots = {}
        if step.obj then   -- a step for one objective: only that one
            for i in pairs(W.QuestState:Get(step.quest) and W.QuestState:Get(step.quest).objectives or {}) do
                if i ~= step.obj then done[i] = true end
            end
        end
        for _, s in ipairs(WP.ObjectiveSpots(step.quest, done) or {}) do
            local cont, wx, wy = T.World(s.map, s.x, s.y)
            if cont then c.spots[#c.spots + 1] = { cont = cont, wx = wx, wy = wy, name = s.name } end
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
             cont = cont, wx = wx, wy = wy, radius = 10, hearth = true }
end

-- What the nav arrow points at: hearthstone or flight advice when it beats running, else the
-- step target. returns { label, sub, cont, wx, wy, radius, arrived } or nil
function WP:ArrowTarget()
    if not current then return end
    local step = current.step
    local label = current.title
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
                     via = { wx = B.wx, wy = B.wy }, final = { cont = spot.cont, wx = spot.wx, wy = spot.wy } }
        end
        T:SetWantedDestination(nil)
        return { label = label, sub = spot.name and ("nearest: " .. spot.name) or current.name, cont = spot.cont, wx = spot.wx, wy = spot.wy, radius = 30, spot = true }
    end
    local radius = (step.verb == "goto" or (step.verb == "fly" and current.leg == "arrive")) and step.radius or 10
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
                 via = { wx = B.wx, wy = B.wy }, final = fc and { cont = fc, wx = fx, wy = fy } or nil }
    end
    local cont, wx, wy = T.World(current.map, current.x, current.y)
    if not cont then return end
    local sub = current.name
    if step.verb == "fly" then
        local _, who = T.SplitFlightNpc(current.name)
        sub = UnitOnTaxi("player") and ("in flight" .. (who and (", landing by " .. who) or ""))
            or "go to the flight master and take this flight"
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
W:On("WF_LANDED", function() local s = W.Guide:Current() if s and s.verb == "fly" then WP:Update() end end)
-- take-off: switch the pin from the departure flight master to the destination
W:On("PLAYER_CONTROL_LOST", function()
    C_Timer.After(1, function() local s = W.Guide:Current() if s and s.verb == "fly" then WP:Update() end end)
end)
W:On("WF_SETTINGS_CHANGED", function() WP:Update() end)
