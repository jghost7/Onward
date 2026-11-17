-- Hearth: where your hearthstone takes you, and when using it beats running or flying.
--
-- The game only tells us the name of your bind location (GetBindLocation: "Tarren Mill"), not
-- where it is, so Onward learns the spot: when you set your hearthstone (HEARTHSTONE_BOUND), and
-- whenever you stand in that subzone (after hearthing there, or walking into town). The spot is
-- kept per character with the name it belongs to, so binding somewhere new forgets the old one.
--
-- Advice: when the hearthstone is ready and hearthing (cast + loading screen, then the walk from
-- the inn) beats getting there now (running, or the best flight) by a clear margin, the arrow
-- says "Hearth to <town>". Never while it's on cooldown or out of your bags.
local _, W = ...
local H = {}
W.Hearth = H

local T = W.Travel
local STONE = 6948
local OVERHEAD = 250       -- yards-equivalent for the 10 s cast and the loading screen
local RATIO, MIN_SAVE = 0.6, 600   -- hearth must cost under 60% of the alternative and save 600 yd
local NEAR_HOME = 300      -- already this close to the inn: never suggest it
local AT_INN = 200         -- a "set your hearthstone" step is done when home is this close to it

local function d(ax, ay, bx, by) return math.sqrt((ax - bx) ^ 2 + (ay - by) ^ 2) end

function H:BindName()
    return GetBindLocation and W.Safe(GetBindLocation()) or nil
end

-- the learned spot for your current bind location, or nil while it's still unknown
function H:Home()
    local h, bind = W.cdb and W.cdb.home, H:BindName()
    if h and bind and h.name == bind then return h end
end

local function record()
    local c, x, y = T.PlayerWorld()
    local bind = H:BindName()
    if c and bind then
        W.cdb.home = { name = bind, cont = c, wx = x, wy = y }
        W:Fire("WF_UPDATED")
    end
end
H.Record = record

-- hearthstone in your bags and off cooldown
function H:Ready()
    local count = (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(STONE)) or (GetItemCount and GetItemCount(STONE)) or 0
    if (W.Safe(count) or 0) < 1 then return false end
    local cd = (C_Container and C_Container.GetItemCooldown) or GetItemCooldown
    if not cd then return true end
    local start, dur = cd(STONE)
    start, dur = W.Safe(start) or 0, W.Safe(dur) or 0
    return dur == 0 or start + dur <= GetTime()
end

-- Should you hearth to reach (cont, x, y)? `now` = yards it takes without (running, or the best
-- flight's cost); nil = walk. Returns { name, save, home } or nil.
function H:Advice(cont, tx, ty, now)
    if not (W.db and W.db.hearthAdvice ~= false) or (UnitOnTaxi and UnitOnTaxi("player")) then return end
    local home = H:Home()
    if not home or home.cont ~= cont or not H:Ready() then return end
    local pc, px, py = T.PlayerWorld()
    if not pc then return end
    if pc == home.cont and d(px, py, home.wx, home.wy) < NEAR_HOME then return end
    local cost = OVERHEAD + d(home.wx, home.wy, tx, ty)
    local alt = (pc ~= cont) and math.huge or (now or d(px, py, tx, ty))
    if cost < alt * RATIO and alt - cost >= MIN_SAVE then
        return { name = home.name, save = alt - cost, home = home }
    end
end

-- for "set your hearthstone" steps: is your home at this map spot?
function H:IsHomeAt(map, x, y)
    local home = H:Home()
    if not (home and map) then return false end
    local c, wx, wy = T.World(map, x, y)
    return c == home.cont and d(wx, wy, home.wx, home.wy) <= AT_INN
end

-- learning the spot: on binding, and whenever you're standing in your bind location's subzone
W:On("HEARTHSTONE_BOUND", function() C_Timer.After(0.5, record) end)
W:On("WF_INIT", function()
    C_Timer.NewTicker(5, function()
        local bind = H:BindName()
        if not bind or (W.cdb.home and W.cdb.home.name == bind) then return end
        local here = GetSubZoneText and W.Safe(GetSubZoneText())
        if here and here == bind then record() end
    end)
end)
