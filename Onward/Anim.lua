-- Small one-shot animations: a sheen when a quest is ready, objective ticks, the progress bar
-- sliding, the step card turning, the arrival pulse, the guide-finished glow, and the flight
-- marker's breathing. Each plays once (the flight marker only while the flight map is open),
-- never starts in combat, and finishes at once when combat starts. Options > Panel > Animations
-- turns them all off; then every change lands at its end state straight away.
--
-- A.Play(key, seconds, fn(t), done): fn gets 0..1 over the time; a new Play with the same key
-- replaces the old one. A.Loop(key, period, fn(t)) repeats until A.Stop(key).
local _, W = ...
local A = {}
W.Anim = A

local running = {}
local ticker

function A.Enabled()
    return not (W.db and W.db.animations == false) and not InCombatLockdown()
end

function A.EaseOut(t) return 1 - (1 - t) ^ 3 end
-- 0 -> 1 -> 0, smooth at both ends
function A.Bump(t) return math.sin(math.pi * math.min(1, math.max(0, t))) end

local function tick()
    local now = GetTime()
    local finished = {}
    for key, a in pairs(running) do
        local t = (now - a.start) / a.dur
        if a.loop then
            a.fn(t % 1)
        elseif t >= 1 then
            running[key] = nil
            finished[#finished + 1] = a
        else
            a.fn(t)
        end
    end
    -- end states and callbacks after the walk, so a callback can start another animation
    for _, a in ipairs(finished) do
        a.fn(1)
        if a.done then a.done() end
    end
    if not next(running) and ticker then ticker:Cancel() ticker = nil end
end
A.Tick = tick

local function start(key, dur, fn, done, loop)
    running[key] = { start = GetTime(), dur = dur, fn = fn, done = done, loop = loop }
    fn(0)
    if not ticker then ticker = C_Timer.NewTicker(0.016, tick) end
end

-- returns true when it animates, false when it jumped straight to the end (off, or in combat)
function A.Play(key, dur, fn, done)
    if not A.Enabled() then
        A.Stop(key)
        fn(1)
        if done then done() end
        return false
    end
    start(key, dur, fn, done, false)
    return true
end

function A.Loop(key, period, fn)
    if not A.Enabled() then fn(0) return false end
    start(key, period, fn, nil, true)
    return true
end

function A.Running(key) return running[key] ~= nil end

-- finish = true: jump to the end state (and run its callback); loops just stop
function A.Stop(key, finish)
    local a = running[key]
    if not a then return end
    running[key] = nil
    if finish and not a.loop then
        a.fn(1)
        if a.done then a.done() end
    end
end

function A.StopAll()
    local keys = {}
    for k in pairs(running) do keys[#keys + 1] = k end
    for _, k in ipairs(keys) do A.Stop(k, true) end
end

-- combat: everything settles at once, nothing moves while you fight
W:On("PLAYER_REGEN_DISABLED", function() A.StopAll() end)
