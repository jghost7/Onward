-- Trail: the way you came. While you play, a point is dropped every STEP yards of travel, so the
-- arrow can lead you back to a quest giver along ground you actually crossed (around the cliff,
-- over the bridge) instead of in a straight line through it.
--
-- The trail is one simple path from its oldest point to you:
--   * walking back over it (or closing a loop) cuts it at the earlier point, so retracing your
--     steps shrinks it and circling a mob camp leaves no loops behind;
--   * a flight, a teleport, a hearthstone, a release to a graveyard or a continent change starts
--     it over, since there is no walkable path across a jump.
--
-- Trail:Guide(cont, wx, wy) answers "where should the arrow point to reach this place?": a point
-- LEAD yards back along the trail while it heads there, or nil to point straight at it (no trail
-- near the target, you're close already, you've left the trail, or the trail is a long detour).
local _, W = ...
local Tr = {}
W.Trail = Tr

local STEP = 15          -- yards between trail points
local MAX_POINTS = 600   -- ~9 km of path
local JOIN = 12          -- a new point this close to an earlier one closes a loop there
local JUMP = 150         -- more than this between two samples (0.5 s) is a teleport or a flight
local NEAR_TARGET = 60   -- the trail must pass this close to the target to be worth following
local DIRECT = 45        -- this close to the target (or to where the trail meets it): point straight
local OFF_TRAIL = 70     -- further than this from the trail: you've left it, point straight
local DETOUR = 2.5       -- trail longer than this many times the straight line: point straight
local LEAD = 30          -- how far ahead along the trail the arrow aims

local pts, cont = {}, nil          -- { {x, y}, ... } oldest first, on continent `cont`
local lastX, lastY

local function dist(ax, ay, bx, by) return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2) end

function Tr:Clear()
    wipe(pts)
    cont, lastX, lastY = nil, nil, nil
end

-- one position sample (called twice a second; exposed for tests)
function Tr:Sample(c, x, y)
    if not c then return end
    if c ~= cont or (lastX and dist(x, y, lastX, lastY) > JUMP) then
        wipe(pts)
        cont = c
    end
    lastX, lastY = x, y
    local n = #pts
    -- back at an earlier point: cut the trail there (the earliest one, so the whole loop goes).
    -- Checked on every sample, not only every STEP yards, or the last few yards of a loop slip by.
    for i = 1, n - 1 do
        if dist(x, y, pts[i][1], pts[i][2]) < JOIN then
            for j = n, i + 1, -1 do pts[j] = nil end
            return
        end
    end
    if n > 0 and dist(x, y, pts[n][1], pts[n][2]) < STEP then return end
    pts[n + 1] = { x, y }
    if #pts > MAX_POINTS then table.remove(pts, 1) end
end

function Tr:Count() return #pts end
function Tr:Points() return pts, cont end

-- where to point for target (tc, tx, ty) from the player at (pc, px, py):
-- returns wx, wy, yardsAlongTrail, path (trail points from you back to the target's end, for the
-- map route), or nil for "straight at it"
function Tr:Guide(tc, tx, ty, pc, px, py)
    if not (W.db and W.db.trailBack ~= false) then return end
    local n = #pts
    if n < 3 or tc ~= cont or pc ~= cont then return end
    local straight = dist(px, py, tx, ty)
    if straight <= DIRECT then return end
    -- where the trail comes closest to the target
    local j, dj
    for i = 1, n do
        local d = dist(pts[i][1], pts[i][2], tx, ty)
        if not dj or d < dj then j, dj = i, d end
    end
    if dj > NEAR_TARGET then return end
    -- where you are on the trail: the nearest point from the target's end onward
    local k, dk
    for i = j, n do
        local d = dist(pts[i][1], pts[i][2], px, py)
        if not dk or d < dk then k, dk = i, d end
    end
    if not k or dk > OFF_TRAIL then return end
    if dist(px, py, pts[j][1], pts[j][2]) <= DIRECT then return end
    -- length of the way back: you -> trail -> along it -> target
    local along = dk + dj
    for i = k, j + 1, -1 do along = along + dist(pts[i][1], pts[i][2], pts[i - 1][1], pts[i - 1][2]) end
    if along > straight * DETOUR then return end
    -- aim LEAD yards back along the trail from your nearest point
    local aim, run = j, 0
    for i = k, j + 1, -1 do
        run = run + dist(pts[i][1], pts[i][2], pts[i - 1][1], pts[i - 1][2])
        if run >= LEAD then aim = i - 1 break end
    end
    local path = {}
    for i = k, j, -1 do path[#path + 1] = { wx = pts[i][1], wy = pts[i][2] } end
    return pts[aim][1], pts[aim][2], along, path
end

local function tick()
    if UnitOnTaxi and UnitOnTaxi("player") then
        Tr:Clear()
        return
    end
    Tr:Sample(W.Travel.PlayerWorld())
end

W:On("WF_INIT", function()
    if C_Timer and C_Timer.NewTicker then C_Timer.NewTicker(0.5, tick) end
end)
