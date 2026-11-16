-- Guide registry, step parser and step engine.
--
-- Guide files call Onward:RegisterGuide{ id, title, zone, faction, levels = {min, max}, next, steps = [[ ... ]] }.
-- Step text is parsed only when a guide is activated, so dozens of guides cost almost nothing at login.
-- Format reference: Guides/FORMAT.md
local _, W = ...
local G = {}
W.Guide = G

local QS = W.QuestState
local registry, ordered = {}, {}
local active               -- the parsed active guide
local cursor = 1           -- index of the current step in active.steps
local reached = {}         -- goto steps reached this session: [step] = true

---------------------------------------------------------------------------
-- Registration
---------------------------------------------------------------------------
function W:RegisterGuide(def)
    assert(type(def) == "table" and def.id and def.steps, "Onward:RegisterGuide needs id and steps")
    if registry[def.id] then W.Print("duplicate guide id", def.id) end
    def.title = def.title or def.id
    def.levels = def.levels or { 1, 60 }
    registry[def.id] = def
    ordered[#ordered + 1] = def
end

---------------------------------------------------------------------------
-- Quest hints (Guides/QuestHints.lua): a note for the whole quest and notes per objective, by
-- the objective's name as the quest log shows it. Your own notes (/ow hint) sit beside them.
---------------------------------------------------------------------------
local hints = {}
function W:RegisterHints(t)
    for q, h in pairs(t) do hints[q] = h end
end
-- built-in note for the quest, or nil
function G:QuestHint(q)
    return q and hints[q] and hints[q].quest
end
-- built-in note for one objective (matched by name inside the objective's text), or nil
function G:ObjectiveHint(q, text)
    local h = q and hints[q]
    if not (h and h.objectives and text) then return end
    for name, note in pairs(h.objectives) do
        if text:find(name, 1, true) then return note end
    end
end
function G:HintSource(q) return q and hints[q] and hints[q].source end
-- your own note for the quest (account-wide), or nil
function G:MyHint(q)
    return q and W.db and W.db.hints and W.db.hints[q]
end
function G:SetMyHint(q, text)
    W.db.hints = W.db.hints or {}
    W.db.hints[q] = (text and text ~= "") and text or nil
    W:Fire("WF_UPDATED")
end

function G:All() return ordered end
function G:Get(id) return registry[id] end
function G:Active() return active end

---------------------------------------------------------------------------
-- Parser
---------------------------------------------------------------------------
local VERBS = { accept = true, complete = true, turnin = true, ["goto"] = true, fly = true, level = true, note = true,
                train = true, craft = true, gather = true }   -- the last three: profession guides (Prof.lua)
local PROF_VERB = { train = true, craft = true, gather = true }
G.PROF_VERB = PROF_VERB

-- |race tokens by race ID. Forever's Skyborne (95, 96) aren't classic races, so their race file
-- name can't be trusted to match; the ID can. Undead's file name is "Scourge"; "Undead" works too.
local RACE_TOKEN = { [1] = "human", [2] = "orc", [3] = "dwarf", [4] = "nightelf", [5] = "scourge",
                     [6] = "tauren", [7] = "gnome", [8] = "troll",
                     [95] = "skybornealliance", [96] = "skybornehorde" }
G.RACE_TOKEN = RACE_TOKEN

local function inList(list, token)
    return (","..list:lower():gsub("%s", "")..","):find(","..token..",", 1, true) ~= nil
end

local function playerMatches(opts)
    if opts.faction then
        local f = UnitFactionGroup("player")
        if f and opts.faction:sub(1, 1):upper() ~= f:sub(1, 1) then return false end
    end
    if opts.class then
        local _, cls = UnitClass("player")
        if cls and not inList(opts.class, cls:lower()) then return false end
    end
    if opts.race then
        local _, file, id = UnitRace("player")
        local token = RACE_TOKEN[id] or (file and file:lower())
        if token and not (inList(opts.race, token) or (token == "scourge" and inList(opts.race, "undead"))) then
            return false
        end
    end
    return true
end
G.PlayerMatches = playerMatches

local function parseCoords(s)
    -- "1423 45.2,60.1" or "45.2,60.1"
    local map, x, y = s:match("^(%d+)%s+([%d%.]+)%s*,%s*([%d%.]+)")
    if map then return { map = tonumber(map), x = tonumber(x), y = tonumber(y) } end
    x, y = s:match("^([%d%.]+)%s*,%s*([%d%.]+)")
    if x then return { x = tonumber(x), y = tonumber(y) } end
end

local function parseLine(line, lineNo, guideId)
    line = line:gsub("%s+%-%-.*$", "")   -- trailing "  -- comment"
    local parts = {}
    for seg in (line .. "|"):gmatch("(.-)|") do parts[#parts + 1] = seg:match("^%s*(.-)%s*$") end
    local verb, arg = parts[1]:match("^(%S+)%s*(.*)$")
    verb = verb and verb:lower()
    if not verb or not VERBS[verb] then
        W.Print(("guide %s line %d: unknown step %q"):format(guideId, lineNo, parts[1]))
        return
    end
    local step = { verb = verb, line = lineNo }
    if verb == "accept" or verb == "complete" or verb == "turnin" then
        local q, obj = arg:match("^(%d+)%s*(%d*)")
        step.quest = tonumber(q)
        step.obj = tonumber(obj)
        if not step.quest then
            W.Print(("guide %s line %d: %s needs a quest ID"):format(guideId, lineNo, verb))
            return
        end
    elseif verb == "goto" or verb == "fly" then
        -- goto <map> x,y [radius]       fly <map> x,y [radius] |from <map> x,y |npc <destination>
        step.at = parseCoords(arg)
        local rest = arg:match(",%s*[%d%.]+%s+(%d+)%s*$")
        step.radius = tonumber(rest) or (verb == "fly" and 150 or 15)
        if not (step.at and step.at.map) then
            W.Print(("guide %s line %d: %s needs 'mapID x,y'"):format(guideId, lineNo, verb))
            return
        end
    elseif verb == "level" then
        step.level = tonumber(arg)
    elseif verb == "note" then
        step.text = arg
    elseif verb == "train" or verb == "gather" or verb == "craft" then
        -- train <skillLine> <cap> | gather <skillLine> <until> | craft <spellID> <until>
        local a, b = arg:match("^(%d+)%s+(%d+)")
        if not a then
            W.Print(("guide %s line %d: %s needs two numbers"):format(guideId, lineNo, verb))
            return
        end
        a, b = tonumber(a), tonumber(b)
        if verb == "train" then step.skill, step.cap = a, b
        elseif verb == "gather" then step.skill, step.untilSkill = a, b
        else step.spell, step.untilSkill = a, b end
    end
    local opts = {}
    for i = 2, #parts do
        local k, v = parts[i]:match("^(%S+)%s*(.*)$")
        if k then opts[k:lower()] = v end
    end
    if not playerMatches(opts) then return end
    -- quest value tags: "mid" = dropped in fastest mode, "low" = dropped in efficient and fastest
    local mode = W.db and W.db.questMode or "efficient"
    if opts.value == "low" and mode ~= "all" then return end
    if opts.value == "mid" and mode == "fastest" then return end
    step.value = opts.value
    -- group tags: "elite" (elite targets), "dungeon" (targets inside an instance),
    -- "chain" (only reachable through one of those); hidden when group quests are off
    if opts.group then
        if W.db and W.db.groupQuests == "hide" then return end
        step.group = opts.group ~= "" and opts.group:lower() or "elite"
    end
    if opts.at then step.at = parseCoords(opts.at) end
    if opts.from then step.from = parseCoords(opts.from) end
    step.npc = opts.npc
    step.note = opts.note
    step.item = tonumber(opts.item)
    if opts.mobs and opts.mobs ~= "" then
        step.mobs = {}
        for name in opts.mobs:gmatch("[^;]+") do
            name = name:match("^%s*(.-)%s*$")
            if name ~= "" then step.mobs[#step.mobs + 1] = name end
        end
    end
    step.optional = opts.optional ~= nil
    if PROF_VERB[verb] then
        step.skill = step.skill or tonumber(opts.prof)
        step.name = opts.name
        step.n = tonumber(opts.n)
        step.from = tonumber(opts.from)
        step.recipe = tonumber(opts.recipe)
        step.book = tonumber(opts.book)
        step.questId = tonumber(opts.quest)
        step.level = tonumber(opts.level)
        step.beasts = tonumber(opts.beasts)
        if opts.mats and opts.mats ~= "" then
            step.mats = {}
            for id, n in opts.mats:gmatch("(%d+):(%d+)") do
                step.mats[#step.mats + 1] = { id = tonumber(id), n = tonumber(n) }
            end
        end
    end
    return step
end

local function parse(def)
    local g = { def = def, id = def.id, title = def.title, steps = {} }
    local n = 0
    for raw in (def.steps .. "\n"):gmatch("(.-)\r?\n") do
        n = n + 1
        local line = raw:match("^%s*(.-)%s*$")
        if line ~= "" and not line:find("^%-%-") and not line:find("^#") then
            local step = parseLine(line, n, def.id)
            if step and PROF_VERB[step.verb] and not step.skill then step.skill = def.skill end   -- craft: the guide's profession
            if step then
                step.index = #g.steps + 1
                g.steps[step.index] = step
            end
        end
    end
    return g
end

---------------------------------------------------------------------------
-- Smart guide: built every refresh from the quest log. Covers any zone,
-- including new Forever zones nobody has written a guide for yet.
---------------------------------------------------------------------------
local smartDef = { id = "smart", title = "Quest log (auto)", levels = { 1, 60 }, smart = true }
registry.smart = smartDef

local function buildSmart()
    local g = active and active.id == "smart" and active or { def = smartDef, id = "smart", title = smartDef.title, steps = {} }
    wipe(g.steps)
    local list = {}
    for _, q in ipairs(QS:Order()) do
        local e = QS:Get(q)
        local dist = C_QuestLog.GetDistanceSqToQuest and C_QuestLog.GetDistanceSqToQuest(q)
        dist = W.Safe(dist) or 1e12
        if e.ready then dist = dist * 0.5 end -- hand-ins are quick wins: pull them forward
        list[#list + 1] = { q = q, ready = e.ready, d = dist }
    end
    table.sort(list, function(a, b) return a.d < b.d end)
    for i, it in ipairs(list) do
        g.steps[i] = { index = i, verb = it.ready and "turnin" or "complete", quest = it.q }
    end
    return g
end

---------------------------------------------------------------------------
-- Step state
---------------------------------------------------------------------------
-- Skips persist per guide, keyed by step index. The smart guide is rebuilt constantly, so its
-- skips are keyed by quest and last only for this session.
local smartSkips = {}
local function skippedSet()
    if active.id == "smart" then return smartSkips end
    local s = W.cdb.skipped[active.id]
    if not s then s = {} W.cdb.skipped[active.id] = s end
    return s
end
local function key(step)
    return active.id == "smart" and step.quest or step.index
end

function G:IsComplete(step)
    local v, q = step.verb, step.quest
    if v == "accept" then
        return QS:IsOnQuest(q) or QS:IsDone(q)
    elseif v == "complete" then
        if QS:IsDone(q) then return true end
        if step.obj then
            local o = QS:Objective(q, step.obj)
            return o and o.finished or false
        end
        return QS:IsReady(q)
    elseif v == "turnin" then
        return QS:IsDone(q)
    elseif v == "goto" or v == "fly" then
        return reached[step] or false
    elseif v == "level" then
        return (UnitLevel("player") or 0) >= (step.level or 0)
    elseif PROF_VERB[v] then
        return W.Prof and W.Prof:IsDone(step) or false
    end
    return false -- notes complete when the player clicks them
end

function G:IsSkipped(step)
    return active and skippedSet()[key(step)] or false
end

-- A step the player can't do from here: completing/turning in a quest not in the log.
function G:IsMissing(step)
    return (step.verb == "complete" or step.verb == "turnin") and not QS:IsOnQuest(step.quest) and not QS:IsDone(step.quest)
end

---------------------------------------------------------------------------
-- Resume: the frontier is the furthest step the game's own quest records show you've reached
-- (a quest turned in, accepted or finished). Everything before it that the game can't track
-- (goto, fly, notes, level steps) counts as done, so a guide picks up where you are after a
-- relog or on a character that levelled without it. Quest steps behind the frontier that you
-- never took are "missed": counted and listed, not forced on you. Quests still in your log
-- stay open wherever they are.
---------------------------------------------------------------------------
local forced = {}   -- steps the player stepped back to on purpose (Skip -1)
local notified = {} -- waiting turn-ins already announced (held back / now ready)
local readyNotified = {}

local function progressed(step)
    local q = step.quest
    if not q then return false end
    if QS:IsDone(q) then return true end
    if step.verb == "accept" then return QS:IsOnQuest(q) end
    if step.verb == "complete" then return G:IsComplete(step) end
    return false
end

local function computeFrontier()
    if not active or active.id == "smart" then return 0 end
    for i = #active.steps, 1, -1 do
        if progressed(active.steps[i]) then return i end
    end
    return 0
end

function G:IsBehind(step)
    return active and active.frontier and step.index < active.frontier or false
end

function G:IsMissed(step)
    return step.quest and G:IsBehind(step) and not G:IsComplete(step) and not QS:IsOnQuest(step.quest) or false
end

-- quests behind the frontier you never did (unique, in guide order)
function G:Missed()
    local out, seen = {}, {}
    if not active then return out end
    for i = 1, (active.frontier or 0) - 1 do
        local s = active.steps[i]
        if G:IsMissed(s) and not G:IsSkipped(s) and not seen[s.quest] then
            seen[s.quest] = true
            out[#out + 1] = s.quest
        end
    end
    return out
end

-- A turn-in you can't do yet: the quest is in your log but not finished (you skipped its
-- objectives, or the guide got there first). It doesn't become the current step; it waits in a
-- "waiting" list and comes back once the quest is ready (G:Waiting, G:GoToStep).
function G:IsWaiting(step)
    return step.verb == "turnin" and step.quest and QS:IsOnQuest(step.quest)
        and not QS:IsReady(step.quest) and not QS:IsDone(step.quest) or false
end

-- "Come back later": quests you set aside (an area overrun with players, say). Their steps are
-- left out until you pick them up again from the panel, walk back into their area (offered, not
-- forced), or reach the end of the guide, which brings you back to them before moving on.
-- Turn-ins are never held: a set-aside quest you finished anyway can still be handed in.
local function laterSet()
    W.cdb.later = W.cdb.later or {}
    return W.cdb.later
end
function G:IsLater(step)
    return step.quest and step.verb ~= "turnin" and laterSet()[step.quest] ~= nil and not QS:IsDone(step.quest) or false
end

local function isOpen(step)
    if G:IsComplete(step) then return false end
    if G:IsWaiting(step) then return false end
    if forced[step] then return true end
    if G:IsLater(step) then return false end
    if G:IsSkipped(step) then return false end
    if G:IsBehind(step) then
        if not step.quest then return false end                -- travel / notes you've moved past
        if not QS:IsOnQuest(step.quest) then return false end  -- missed: listed, not forced
    end
    return true
end

function G:Current()
    return active and active.steps[cursor]
end

-- Kill/loot steps you can work on together: the current `complete` step plus later open
-- `complete` steps whose quest is already in your log and whose objective area lies within
-- GROUP_YARDS of the current one. Steps without coordinates join only when they directly follow.
-- The scan stops at travel (goto / fly) and looks at most GROUP_LOOKAHEAD open steps ahead.
local GROUP_YARDS, GROUP_LOOKAHEAD, GROUP_MAX = 350, 8, 4
local function near(a, b)
    if not (a.at and b.at and a.at.map and b.at.map) then return nil end
    local T = W.Travel
    if not T then return nil end
    local ca, xa, ya = T.World(a.at.map, a.at.x, a.at.y)
    local cb, xb, yb = T.World(b.at.map, b.at.x, b.at.y)
    if not (ca and cb) or ca ~= cb then return false end
    return (xa - xb) ^ 2 + (ya - yb) ^ 2 <= GROUP_YARDS ^ 2
end
function G:Group()
    local list = G:Upcoming(GROUP_LOOKAHEAD)
    local first = list[1]
    if not first or first.verb ~= "complete" or not first.quest then return first and { first } or {} end
    local out, seen, adjacent = { first }, { [first.quest] = true }, true
    for i = 2, #list do
        local s = list[i]
        if s.verb == "goto" or s.verb == "fly" or #out >= GROUP_MAX then break end
        local joined = false
        if s.verb == "complete" and s.quest and not seen[s.quest] and QS:IsOnQuest(s.quest) then
            local n = near(first, s)
            if n or (n == nil and adjacent) then
                out[#out + 1] = s
                seen[s.quest] = true
                joined = true
            end
        end
        if not joined then adjacent = false end
    end
    return out
end

-- current step + the next n open steps
function G:Upcoming(n)
    local out = {}
    if not active then return out end
    for i = cursor, #active.steps do
        local s = active.steps[i]
        if isOpen(s) then
            out[#out + 1] = s
            if #out > n then break end
        end
    end
    return out
end

function G:Progress()
    if not active or #active.steps == 0 then return 0, 0 end
    local done = 0
    for _, s in ipairs(active.steps) do
        if not isOpen(s) then done = done + 1 end
    end
    return done, #active.steps
end

-- Move the cursor to the first open step. Steps never "un-complete" except on abandon,
-- so we scan forward from the cursor and only rescan from 1 when a quest is removed.
local function advance(fromStart)
    if not active then return end
    local before = active.frontier
    active.frontier = computeFrontier()
    if before and active.frontier < before then fromStart = true end   -- an abandon moved it back
    local start = fromStart and 1 or cursor
    local n = #active.steps
    local i = start
    while i <= n and not isOpen(active.steps[i]) do
        local s = active.steps[i]
        if not fromStart and G:IsWaiting(s) and not G:IsSkipped(s) and not notified[s] then
            notified[s] = true
            W:Fire("WF_TURNIN_WAITING", s)
        end
        i = i + 1
    end
    local changed = i ~= cursor
    cursor = i
    -- end of the guide: first back to the quests you left for later
    if cursor > n and active.id ~= "smart" and #G:LaterList() > 0 then
        local names = {}
        for _, q in ipairs(G:LaterList()) do
            names[#names + 1] = QS:Title(q) or ("quest " .. q)
            G:ResumeLater(q, true)
        end
        W.Print("before moving on, back to the quests you left for later: " .. table.concat(names, ", "))
        return advance(true)
    end
    if cursor > n and active.def.next and registry[active.def.next] then
        W.Print("guide complete, moving on to", registry[active.def.next].title)
        G:Activate(active.def.next)
        return
    end
    if changed then W:Fire("WF_STEP_CHANGED", active.steps[cursor]) end
end

-- Share of a guide's quests already turned in, from the game's records (for the guide list).
local parsedCache = {}

-- Quest mode changed (all / efficient / fastest): re-read guides, keep the same one open.
function G:Reload()
    wipe(parsedCache)
    if active then G:Activate(active.id) end
end
function G:ProgressFor(def)
    if def.smart then return end
    if def.kind == "profession" then return W.Prof and W.Prof:Progress(def) end
    local g = parsedCache[def.id]
    if not g then
        g = parse(def)
        parsedCache[def.id] = g
    end
    local total, done = 0, 0
    for _, s in ipairs(g.steps) do
        if s.verb == "turnin" then
            total = total + 1
            if QS:IsDone(s.quest) then done = done + 1 end
        end
    end
    if total > 0 then return done / total, done, total end
end

---------------------------------------------------------------------------
-- Recommendation: the leveling guide that suits this character now.
-- Weighs, in order: quests already in your log that a guide covers (you're mid-way through
-- it), your starting zone while you're new, the zone you stand in, your level against the
-- guide's range, and progress already made. Finished guides and the other faction's are out.
---------------------------------------------------------------------------
local START_ZONE = { [1] = "Elwynn Forest", [3] = "Dun Morogh", [7] = "Dun Morogh", [4] = "Teldrassil",
                     [2] = "Durotar", [8] = "Durotar", [6] = "Mulgore", [5] = "Tirisfal Glades",
                     [95] = "Zephras Isle", [96] = "Zephras Isle" }
G.START_ZONE = START_ZONE

local function parsedFor(def)
    local g = parsedCache[def.id]
    if not g then
        g = parse(def)
        parsedCache[def.id] = g
    end
    return g
end

function G:LogCount()
    local n = 0
    for _ in ipairs(QS:Order()) do n = n + 1 end
    return n
end

-- returns def, reason ("start" | "log" | "zone" | "level"), or nil when nothing fits
function G:Recommend()
    local lvl = UnitLevel("player") or 1
    local faction = UnitFactionGroup("player")
    local _, _, raceId = UnitRace("player")
    local home = START_ZONE[raceId]
    local here = GetRealZoneText and GetRealZoneText() or ""
    local inLog = {}
    for _, q in ipairs(QS:Order()) do inLog[q] = true end
    local best, bestScore, bestReason
    for i, def in ipairs(ordered) do
        local factionOk = not (def.faction and def.faction ~= "" and faction and def.faction:sub(1, 1):upper() ~= faction:sub(1, 1))
        if not def.smart and def.kind ~= "profession" and factionOk and def.steps then
            local lo, hi = def.levels[1], def.levels[2]
            local pct = G:ProgressFor(def) or 0
            if pct < 1 and lvl <= hi + 1 then
                local held, seen = 0, {}
                for _, s in ipairs(parsedFor(def).steps) do
                    if s.quest and inLog[s.quest] and not seen[s.quest] then seen[s.quest] = true held = held + 1 end
                end
                local isHome = home and def.zone == home and lvl < 10 and lvl <= hi
                local inRange = isHome or (lvl >= lo - 2 and lvl <= hi)   -- a starting zone fits from level 1
                local score, reason = 0, "level"
                if held > 0 then score, reason = score + 20 + 3 * held, "log" end
                if isHome then
                    score = score + 15
                    if reason == "level" then reason = "start" end
                end
                if def.zone == here and inRange then
                    score = score + 8
                    if reason == "level" then reason = "zone" end
                end
                if inRange then score = score + 6 end
                if pct > 0 then score = score + 4 * pct end
                score = score - math.abs(lvl - lo) * 0.3 - i * 1e-4   -- closest start level, then list order
                if (inRange or held > 0) and (not bestScore or score > bestScore) then
                    best, bestScore, bestReason = def, score, reason
                end
            end
        end
    end
    return best, bestReason
end

-- The recommendation, offered on the panel only when the guide you're on no longer suits you:
-- you've out-levelled it (or are well under it), finished it, or you're on the quest-log guide
-- without having picked it. Never the guide you're on, never one you hid. Cached for 5 seconds.
local sugCache = {}
function G:Suggestion()
    local now = GetTime and GetTime() or 0
    if sugCache.t and now - sugCache.t < 5 and sugCache.active == (active and active.id) then
        return sugCache.def, sugCache.why
    end
    local def, why
    if active then
        local rec, r = G:Recommend()
        local cur = active.def
        if rec and rec ~= cur and W.cdb.hiddenSuggestion ~= rec.id and cur.kind ~= "profession" then
            local lvl = UnitLevel("player") or 1
            local stale
            if cur.smart then
                stale = not W.cdb.pickedSmart
            else
                local lo, hi = cur.levels[1], cur.levels[2]
                stale = lvl > hi + 1 or lvl < lo - 3 or (G:ProgressFor(cur) or 0) >= 1
            end
            if stale then def, why = rec, r end
        end
    end
    sugCache.t, sugCache.active, sugCache.def, sugCache.why = now, active and active.id, def, why
    return def, why
end
function G:ClearSuggestion() sugCache.t = nil end

local REASON = { start = "your starting zone", log = "it covers quests in your log",
                 zone = "you're in this zone", level = "it fits your level" }
function G:ReasonText(reason) return REASON[reason] or "" end

-- Switch to the recommended guide and say why. Returns the def, or nil when nothing fits.
function G:StartRecommended(quiet)
    local def, reason = G:Recommend()
    if not def then
        if not quiet then W.Print("no guide fits your level and faction yet; the quest log guide stays on") end
        return
    end
    G:Activate(def.id)
    W.Print(("guide: %s (%s). /ow guides to pick another."):format(def.title, REASON[reason]))
    return def
end

function G:Activate(id)
    local def = registry[id] or registry.smart
    reached = {}
    wipe(forced)
    wipe(notified)
    wipe(readyNotified)
    cursor = 1
    if def.smart then
        active = nil
        active = buildSmart()
    else
        active = parse(def)
    end
    W.cdb.guide = def.id
    advance(true)
    W:Fire("WF_GUIDE_CHANGED", active)
    W:Fire("WF_STEP_CHANGED", active.steps[cursor])
    W:Fire("WF_UPDATED")
end

-- Manual skip (+1) or back (-1). Back un-skips the previous step.
function G:Skip(delta)
    if not active then return end
    local s = skippedSet()
    if delta > 0 then
        local step = active.steps[cursor]
        if step then
            s[key(step)] = true
            forced[step] = nil
        end
        advance()
    else
        -- step back to the previous step you can still do: one you skipped, a travel/note step,
        -- or a quest you missed earlier
        for i = cursor - 1, 1, -1 do
            local step = active.steps[i]
            if s[key(step)] or step.verb == "goto" or step.verb == "fly" or step.verb == "note" or G:IsMissed(step) then
                s[key(step)] = nil
                reached[step] = nil
                forced[step] = true
                cursor = i
                break
            end
        end
        W:Fire("WF_STEP_CHANGED", active.steps[cursor])
    end
    W:Fire("WF_UPDATED")
end

-- Turn-ins the guide has moved past: { waiting = {steps not finished yet}, ready = {steps now
-- ready to hand in} }. Skipped steps and quests no longer in the log are left out.
function G:Waiting()
    local out = { waiting = {}, ready = {} }
    if not active or active.id == "smart" then return out end
    local seen = {}
    for i = 1, math.min(cursor - 1, #active.steps) do
        local s = active.steps[i]
        if s.verb == "turnin" and not seen[s.quest] and QS:IsOnQuest(s.quest) and not G:IsSkipped(s) then
            seen[s.quest] = true
            if QS:IsReady(s.quest) then
                out.ready[#out.ready + 1] = s
            else
                out.waiting[#out.waiting + 1] = s
            end
        end
    end
    return out
end

-- Jump to a step behind the cursor (e.g. a turn-in that has become ready). The guide carries
-- on from there; steps in between that are done or skipped are passed over again.
function G:GoToStep(step)
    if not active or not step or active.steps[step.index] ~= step then return end
    forced[step] = true
    cursor = step.index
    W:Fire("WF_STEP_CHANGED", step)
    W:Fire("WF_UPDATED")
end

-- Jump back to the most recent quest you skipped past (its first step: usually the accept).
function G:GoBackToMissed()
    if not active then return end
    local q
    for i = (active.frontier or 0) - 1, 1, -1 do
        local s = active.steps[i]
        if G:IsMissed(s) and not G:IsSkipped(s) then q = s.quest break end
    end
    if not q then return end
    -- start at that quest's first step (usually the accept), and open all its steps
    local target
    for i = 1, #active.steps do
        if active.steps[i].quest == q then target = i break end
    end
    for i = target, (active.frontier or 0) - 1 do
        if active.steps[i].quest == q then forced[active.steps[i]] = true end
    end
    cursor = target
    W:Fire("WF_STEP_CHANGED", active.steps[cursor])
    W:Fire("WF_UPDATED")
end

-- Set a quest aside for later (current step's quest when none is given).
function G:Later(q)
    q = q or (G:Current() and G:Current().quest)
    if not q or not active then return end
    laterSet()[q] = { guide = active.id, t = GetTime() }
    for _, s in ipairs(active.steps) do if s.quest == q then forced[s] = nil end end
    W.Print(("left %s for later: it's listed on the panel, and the guide comes back to it before moving on.")
        :format(QS:Title(q) or ("quest " .. q)))
    advance()
    W:Fire("WF_UPDATED")
end

-- Quests of this guide you left for later and haven't finished, in guide order.
function G:LaterList()
    local out, seen = {}, {}
    if not active then return out end
    local set = laterSet()
    for _, s in ipairs(active.steps) do
        local q = s.quest
        if q and set[q] and not seen[q] and not QS:IsDone(q) then
            seen[q] = true
            out[#out + 1] = q
        end
    end
    return out
end

-- Pick a set-aside quest up again: its open steps come back, and (unless quiet) the guide goes
-- to the first of them now.
function G:ResumeLater(q, quiet)
    if not active then return end
    laterSet()[q] = nil
    local first
    for _, s in ipairs(active.steps) do
        if s.quest == q and not G:IsComplete(s) and not G:IsWaiting(s) then
            forced[s] = true
            first = first or s
        end
    end
    if quiet then return end
    if first then G:GoToStep(first) else advance(true) W:Fire("WF_UPDATED") end
end

-- A set-aside quest whose area you're back in (within 250 yd of one of its objective steps),
-- at least two minutes after you left it: offered on the panel, never switched to by itself.
local LATER_NEAR, LATER_AFTER = 250, 120
function G:LaterNearby()
    local T = W.Travel
    if not (active and T) then return end
    local pc, px, py = T.PlayerWorld()
    if not pc then return end
    local now = GetTime()
    for _, q in ipairs(G:LaterList()) do
        local e = laterSet()[q]
        if not e.t or e.t > now or now - e.t >= LATER_AFTER then
            for _, s in ipairs(active.steps) do
                if s.quest == q and s.verb == "complete" and s.at and s.at.map then
                    local c, x, y = T.World(s.at.map, s.at.x, s.at.y)
                    if c == pc and (x - px) ^ 2 + (y - py) ^ 2 <= LATER_NEAR ^ 2 then return q end
                end
            end
        end
    end
end

-- Click on a note step = done
function G:MarkDone(step)
    if not active then return end
    skippedSet()[key(step)] = true
    forced[step] = nil
    advance()
    W:Fire("WF_UPDATED")
end

function G:MarkReached(step)
    reached[step] = true
    forced[step] = nil
    advance()
    W:Fire("WF_UPDATED")
end

---------------------------------------------------------------------------
-- Wiring
---------------------------------------------------------------------------
local needRescan = false

W:On("WF_INIT", function()
    table.sort(ordered, function(a, b) return a.levels[1] < b.levels[1] end)
end)

W:On("PLAYER_LOGIN", function()
    G:Activate(W.cdb.guide)
    -- A character on the quest-log guide with nothing in its log (a new character, say) gets the
    -- recommended guide instead: its first step is the first quest to pick up. Checked once, a few
    -- seconds in, when the quest log has loaded; never when you chose the quest-log guide yourself.
    C_Timer.After(3, function() G:CheckEmptyStart() end)
end)

function G:CheckEmptyStart()
    if active and active.id == "smart" and not W.cdb.pickedSmart and G:LogCount() == 0 then
        return G:StartRecommended(true)
    end
end

W:On("WF_QUEST_STATE", function(_, _, state)
    if state == "removed" then needRescan = true end
end)

W:On("PLAYER_LEVEL_UP", function() G:ClearSuggestion() W:RequestRefresh() end)

W:On("WF_REFRESH", function()
    if not active then return end
    if active.id == "smart" then
        local cur = active.steps[cursor]
        local before = cur and (cur.verb .. cur.quest)
        buildSmart()
        cursor = 1
        while cursor <= #active.steps and not isOpen(active.steps[cursor]) do cursor = cursor + 1 end
        cur = active.steps[cursor]
        if (cur and (cur.verb .. cur.quest)) ~= before then
            W:Fire("WF_STEP_CHANGED", cur)
        end
    else
        advance(needRescan)
        needRescan = false
        local fresh = {}
        for _, s in ipairs(G:Waiting().ready) do
            if not readyNotified[s] then
                readyNotified[s] = true
                fresh[#fresh + 1] = s
            end
        end
        if #fresh > 0 then W:Fire("WF_TURNIN_READY", fresh) end   -- one notice per burst
    end
    W:Fire("WF_UPDATED")
end)
