-- Waypoints: decides where the current step points, sets Blizzard's map pin (and TomTom),
-- and feeds the nav arrow. One 0.5s timer runs only while a goto/fly step waits for arrival.
local _, W = ...
local WP = {}
W.Waypoint = WP

local QB, T = W.QuestieBridge, W.Travel
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
        local spots = QB:ObjectiveSpots(step.quest)
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
    local map, x, y, name, legKind
    if step.verb == "fly" then
        local leg
        leg, legKind = flyLeg(step)
        map, x, y, name = leg.map or step.at.map, leg.x, leg.y, step.npc
        T:SetWantedDestination(T.World(step.at.map, step.at.x, step.at.y))
    else
        map, x, y, name = WP:Resolve(step)
        T:SetWantedDestination(nil)
    end

    if map and x then
        current = { step = step, map = map, x = x, y = y, name = name, title = title, leg = legKind }
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
    if step.verb ~= "complete" or not step.quest then return end
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
        for _, s in ipairs(QB:ObjectiveSpots(step.quest, done) or {}) do
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

-- What the nav arrow points at: flight advice when it beats running, else the step target.
-- returns { label, sub, cont, wx, wy, radius, arrived } or nil
function WP:ArrowTarget()
    if not current then return end
    local step = current.step
    local label = current.title
    local spot = nearestSpot(current)
    if spot then
        -- far from every spot, flight advice still applies (to the spot itself)
        local cx, cy = current.x, current.y
        local advice = T:Advice(current.map, cx, cy)
        if advice then
            local A, B = advice.from, advice.to
            T:SetWantedDestination(spot.cont, B.wx, B.wy)
            return { label = "Fly: " .. A.name, sub = "to " .. B.name .. ", then " .. label, cont = spot.cont, wx = A.wx, wy = A.wy, radius = 10, flight = true,
                     via = { wx = B.wx, wy = B.wy }, final = { cont = spot.cont, wx = spot.wx, wy = spot.wy } }
        end
        T:SetWantedDestination(nil)
        return { label = label, sub = spot.name and ("nearest: " .. spot.name) or current.name, cont = spot.cont, wx = spot.wx, wy = spot.wy, radius = 30, spot = true }
    end
    local radius = (step.verb == "goto" or (step.verb == "fly" and current.leg == "arrive")) and step.radius or 10
    local advice = step.verb ~= "fly" and T:Advice(current.map, current.x, current.y)
    if step.verb ~= "fly" and not advice then T:SetWantedDestination(nil) end
    if advice then
        local A, B = advice.from, advice.to
        local cont = T.PlayerWorld()
        T:SetWantedDestination(cont, B.wx, B.wy)
        local fc, fx, fy = T.World(current.map, current.x, current.y)
        return { label = "Fly: " .. A.name, sub = "to " .. B.name .. ", then " .. label, cont = cont, wx = A.wx, wy = A.wy, radius = 10, flight = true,
                 via = { wx = B.wx, wy = B.wy }, final = fc and { cont = fc, wx = fx, wy = fy } or nil }
    end
    local cont, wx, wy = T.World(current.map, current.x, current.y)
    if not cont then return end
    local sub = current.name
    if step.verb == "fly" then
        sub = UnitOnTaxi("player") and "in flight" or (current.name and ("flight master, then " .. current.name) or "flight master")
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
W:On("WF_GUIDE_CHANGED", function() C_Timer.After(2, function() WP:Update() end) end)
W:On("WF_LANDED", function() local s = W.Guide:Current() if s and s.verb == "fly" then WP:Update() end end)
-- take-off: switch the pin from the departure flight master to the destination
W:On("PLAYER_CONTROL_LOST", function()
    C_Timer.After(1, function() local s = W.Guide:Current() if s and s.verb == "fly" then WP:Update() end end)
end)
W:On("WF_SETTINGS_CHANGED", function() WP:Update() end)
