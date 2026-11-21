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
local VERBS = { accept = true, complete = true, turnin = true, ["goto"] = true, fly = true, level = true, note = true, home = true,
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
    local step = { verb = verb, line = lineNo, raw = line }
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
    -- what the game asks before it offers the quest (accept steps): |lvl n, |pre a,b (all turned
    -- in), |preany a,b (one of them)
    step.lvl = tonumber(opts.lvl)
    -- |loose: nowhere to send you for this quest (it starts from a drop nobody has placed, or a
    -- giver the data has no spot for). |startitem <id>: the item it starts from.
    step.loose = opts.loose ~= nil
    step.startItem = tonumber(opts.startitem)
    for name, field in pairs({ pre = "pre", preany = "preAny" }) do
        if opts[name] and opts[name]:find("%d") then
            step[field] = {}
            for id in opts[name]:gmatch("%d+") do table.insert(step[field], tonumber(id)) end
        end
    end
    step.item = tonumber(opts.item)
    -- |pick <itemId>: a first part of a quest that isn't one of its objectives: an item you have to
    -- get before the objective can be done (the remains you bury, the key that opens the cage).
    -- The step is done once the item is in your bags (or the quest is finished).
    step.pick = tonumber(opts.pick)
    -- |need id:count:name:where;...  items the quest wants that nothing drops: bought or crafted
    if opts.need and opts.need ~= "" then
        step.need = {}
        for id, n, name, where in opts.need:gmatch("(%d+):(%d+):([^:;]*):([^;]*)") do
            step.need[#step.need + 1] = { id = tonumber(id), n = tonumber(n), name = name, where = where }
        end
    end
    if opts.mobs and opts.mobs ~= "" then
        step.mobs = {}
        -- "Mob@Item": the mob is there for that item (Target drops it once the item is collected)
        for entry in opts.mobs:gmatch("[^;]+") do
            local name, item = entry:match("^%s*(.-)%s*@%s*(.-)%s*$")
            name = name or entry:match("^%s*(.-)%s*$")
            if name ~= "" then
                step.mobs[#step.mobs + 1] = name
                if item and item ~= "" then
                    step.mobItem = step.mobItem or {}
                    step.mobItem[name] = item
                end
            end
        end
    end
    -- |areas x,y:n;x,y:n  the separate camps a kill/loot step can be done at (on the step's map)
    if opts.areas and step.at and step.at.map then
        local list = {}
        for x, y, n in opts.areas:gmatch("([%d%.]+)%s*,%s*([%d%.]+):?(%d*)") do
            list[#list + 1] = { x = tonumber(x), y = tonumber(y), n = tonumber(n) }
        end
        if #list > 1 then step.areas = list end
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
G.ParseStep = function(line) return parseLine(line, 1, "test") end   -- one guide line -> step (tests)

-- What a step is, whatever its place in the guide: "accept:123", "complete:123:2", or the line
-- itself for travel and notes. Skips and ticked notes are saved under it, so they stay on the
-- same step when the quest mode, a class filter or a new version of the guide moves the numbers.
local function stepKey(step, seen)
    local k
    if step.quest then
        k = step.verb .. ":" .. step.quest .. (step.obj and (":" .. step.obj) or "")
    else
        k = step.raw or step.verb
    end
    seen[k] = (seen[k] or 0) + 1
    return seen[k] > 1 and (k .. "#" .. seen[k]) or k
end

local function parse(def)
    local g = { def = def, id = def.id, title = def.title, steps = {}, acceptOf = {}, turninAt = {}, needOf = {} }
    local n, seen = 0, {}
    for raw in (def.steps .. "\n"):gmatch("(.-)\r?\n") do
        n = n + 1
        local line = raw:match("^%s*(.-)%s*$")
        if line ~= "" and not line:find("^%-%-") and not line:find("^#") then
            local step = parseLine(line, n, def.id)
            if step and PROF_VERB[step.verb] and not step.skill then step.skill = def.skill end   -- craft: the guide's profession
            if step then
                step.index = #g.steps + 1
                step.key = stepKey(step, seen)
                g.steps[step.index] = step
                if step.verb == "accept" then g.acceptOf[step.quest] = g.acceptOf[step.quest] or step end
                if step.need then g.needOf[step.quest] = step end
                if step.pick then g.hasPick = true end
                if step.loose and step.startItem then g.hasStartItems = true end
                if step.verb == "turnin" then g.turninAt[step.quest] = g.turninAt[step.quest] or step.index end
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
    local g = active and active.id == "smart" and active
        or { def = smartDef, id = "smart", title = smartDef.title, steps = {}, acceptOf = {}, turninAt = {} }
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
-- Skips persist per guide, keyed by what the step is (stepKey). The smart guide is rebuilt
-- constantly, so its skips are keyed by quest and last only for this session.
local smartSkips = {}
local function skippedSet()
    if active.id == "smart" then return smartSkips end
    local s = W.cdb.skipped[active.id]
    if not s then s = {} W.cdb.skipped[active.id] = s end
    return s
end
local function key(step)
    return active.id == "smart" and step.quest or step.key
end

function G:IsComplete(step)
    local v, q = step.verb, step.quest
    if v == "accept" then
        return QS:IsOnQuest(q) or QS:IsDone(q)
    elseif v == "complete" then
        if QS:IsDone(q) then return true end
        if step.pick then
            local have = (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(step.pick)) or (GetItemCount and GetItemCount(step.pick)) or 0
            return have > 0 or QS:IsReady(q)
        end
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
    elseif v == "home" then
        -- your hearthstone is set at this inn (Onward knows where once you set it or stand in town)
        return step.at and W.Hearth and W.Hearth:IsHomeAt(step.at.map, step.at.x, step.at.y) or false
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
-- Resume: where a character that already did part of this guide picks it up. Worked out ONCE
-- per guide and character, from quests turned in only, and saved (as the quest whose turn-in it
-- sits on, so it survives the step numbers moving). It is the point in the guide that best
-- divides "handed in" from "not yet": each turn-in before it counts +1 when done, -1 when not,
-- and the highest total wins (the earlier point on a tie). One quest done far ahead doesn't
-- move it, and picking a quest up early never does.
-- Everything before it that the game can't track (goto, fly, notes, level steps) counts as done.
-- Quest steps behind it that you never took are "missed": counted and listed, not forced on you.
-- Quests still in your log stay open wherever they are. After that the guide only follows what
-- each step's own quest says. /ow resume works it out again.
---------------------------------------------------------------------------
local forced = {}   -- steps the player stepped back to on purpose (Skip -1)
local notified = {} -- waiting turn-ins already announced (held back / now ready)
local readyNotified = {}
local settleUntil = 0   -- quest records are still arriving until then (see PLAYER_LOGIN)

local function resumeSet()
    W.cdb.resume = W.cdb.resume or {}
    return W.cdb.resume
end

local function computeFrontier()
    local best, bestScore, score = 0, 0, 0
    for i, s in ipairs(active.steps) do
        if s.verb == "turnin" then
            score = score + (QS:IsDone(s.quest) and 1 or -1)
            if score > bestScore then best, bestScore = i, score end
        end
    end
    return best
end

local function frontierIndex()
    if not active or active.id == "smart" then return 0 end
    local saved = resumeSet()[active.id]
    if saved == 0 then return 0 end
    if saved and active.turninAt[saved] then return active.turninAt[saved] end
    local f = computeFrontier()
    -- at login the completed-quest records arrive late: keep working it out until they're in
    if GetTime() >= settleUntil then
        resumeSet()[active.id] = f > 0 and active.steps[f].quest or 0
    end
    return f
end

-- work the resume point out again from the quests you've turned in
function G:Resume()
    if not active or active.id == "smart" then return end
    resumeSet()[active.id] = nil
    G:Activate(active.id)
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

-- An accept the game won't offer yet: you're under the quest's level, or a quest it follows
-- isn't turned in. Returns the reason for the panel, its kind ("level" | "pre") and, for
-- "pre", the quest to do first; or nil.
-- The step is passed over and comes back by itself once it's on offer.
function G:HeldReason(step)
    if step.verb ~= "accept" then return end
    if step.loose then
        -- comes up once the item that starts it is in your bags; never waited on otherwise
        local id = step.startItem
        local have = id and ((C_Item and C_Item.GetItemCount and C_Item.GetItemCount(id)) or (GetItemCount and GetItemCount(id)) or 0) or 0
        if have == 0 then return "no known place to pick this up", "loose" end
    end
    if step.lvl and (UnitLevel("player") or 0) < step.lvl then
        return ("needs level %d"):format(step.lvl), "level"
    end
    if step.pre then
        for _, p in ipairs(step.pre) do
            if not QS:IsDone(p) then return ("after %s"):format(QS:Title(p) or ("quest " .. p)), "pre", p end
        end
    end
    if step.preAny then
        for _, p in ipairs(step.preAny) do
            if QS:IsDone(p) then return end
        end
        local p = step.preAny[1]
        for _, alt in ipairs(step.preAny) do          -- the one this guide covers, if any
            if active and active.acceptOf[alt] then p = alt break end
        end
        return ("after %s"):format(QS:Title(p) or ("quest " .. p)), "pre", p
    end
end

-- Items to bring: things a quest of this guide wants that no mob or object drops, so they have
-- to be bought from a vendor or made by a profession (Frost Oil for "Coolant Heads Prevail").
-- G:NeedsFor(quest) = what's still missing for one quest; G:Needs() = for every quest of the guide
-- you haven't finished or dropped. Each entry: { id, n, name, where, have, bank, quest }.
local function bagCount(id, bank)
    return (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(id, bank)) or (GetItemCount and GetItemCount(id, bank)) or 0
end
function G:NeedsFor(quest)
    local out = {}
    local s = active and active.needOf and active.needOf[quest]
    if not s or QS:IsDone(quest) or QS:IsReady(quest) then return out end
    for _, it in ipairs(s.need) do
        local have = bagCount(it.id)
        if have < it.n then
            out[#out + 1] = { id = it.id, n = it.n, name = it.name, where = it.where, have = have,
                              bank = math.max(0, bagCount(it.id, true) - have), quest = quest }
        end
    end
    return out
end
function G:Needs()
    local out = {}
    if not active or active.id == "smart" then return out end
    for _, s in ipairs(active.steps) do
        if s.need and not G:IsSkipped(s) and not G:IsLater(s) then
            local a = active.acceptOf[s.quest]
            local dropped = a and G:IsSkipped(a) and not QS:IsOnQuest(s.quest)
            local missed = G:IsBehind(s) and not QS:IsOnQuest(s.quest)
            if not dropped and not missed then
                for _, it in ipairs(G:NeedsFor(s.quest)) do out[#out + 1] = it end
            end
        end
    end
    return out
end

-- Quests of this guide with no known place to pick them up, that you don't have yet: the
-- panel lists them with what is known (the item, what drops it, who takes it), since the guide
-- can't lead you to them.
function G:Loose()
    local out = {}
    if not active or active.id == "smart" then return out end
    for _, s in ipairs(active.steps) do
        if s.verb == "accept" and s.loose and not G:IsComplete(s) and not G:IsSkipped(s) then
            local _, kind = G:HeldReason(s)
            if kind == "loose" then out[#out + 1] = s end
        end
    end
    return out
end

-- Objectives and the turn-in of a quest you don't have, when its accept step was skipped or
-- can't be done yet: nothing to do here, so they go with it. Picking the quest up anyway
-- brings them back.
function G:IsBlocked(step)
    if not (step.verb == "complete" or step.verb == "turnin") or not active then return false end
    local q = step.quest
    if QS:IsOnQuest(q) or QS:IsDone(q) then return false end
    local a = active.acceptOf[q]
    if not a or forced[a] then return false end
    return G:IsSkipped(a) or G:HeldReason(a) ~= nil
end

-- The wall: at the end of a guide, with only held quests left, the first of them becomes the
-- step instead of the guide ending: one you're under-level for (marked "needs level N"), or
-- one that follows a quest this guide doesn't cover (marked "after <quest>", with the arrow
-- on that quest's giver when Questie knows it). A quest held by one the guide does cover stays
-- out: you skipped that one.
local wall = false
local function wallOpens(kind, pre)
    return wall and (kind == "level" or (kind == "pre" and not (active and active.acceptOf[pre])))
end

local isOpen

-- A flight with nothing left to do where it lands: every step between it and the next flight
-- is done, skipped or held (you already have the quest the trip was for, say). It is passed
-- over, and so is the flight back from there. The last flight of a guide always stands: it
-- takes you to the next zone.
local function idleFlight(step)
    if not active or active.id == "smart" then return false end
    local steps, nextFly = active.steps
    for i = step.index + 1, #steps do
        local s = steps[i]
        if s.verb == "fly" then nextFly = s break end
        if s.verb ~= "goto" and isOpen(s) then return false end
    end
    return nextFly ~= nil
end
-- A trip you don't need: a run of flights and boat walks with nothing left to do along the way
-- that ends nearer to you than this leg's own stops (it comes back to where you are, or you
-- are already where it goes). The leg is passed over. A flight's own landing counts only when
-- nothing is left to do before it either, so the way back from an errand stays in the list.
local function yards(at)
    return at and at.map and W.Travel.Distance(at.map, at.x, at.y) or math.huge
end
local function pointlessLeg(step)
    if not active or active.id == "smart" then return false end
    local steps = active.steps
    if UnitOnTaxi and UnitOnTaxi("player") then return false end
    local first = step.index + 1
    if step.verb == "fly" then
        -- its own landing counts when it closes a trip: a flight before it that you didn't take,
        -- with nothing open in between
        for i = step.index - 1, 1, -1 do
            local s = steps[i]
            if s.verb == "fly" then
                if not reached[s] then first = step.index end
                break
            end
            if s.verb ~= "goto" and isOpen(s) then break end
        end
    end
    for i = first, #steps do
        local s = steps[i]
        if s.verb == "fly" then
            local d = yards(s.at)
            if d < math.huge and d <= yards(step.from) and (i == step.index or d < yards(step.at)) then return true end
        elseif s.verb ~= "goto" and isOpen(s) then
            return false
        end
    end
    return false
end

function isOpen(step)
    if G:IsComplete(step) then return false end
    if G:IsWaiting(step) then return false end
    if forced[step] then return true end
    if G:IsLater(step) then return false end
    if G:IsSkipped(step) then return false end
    if step.index and (step.verb == "fly" and (idleFlight(step) or pointlessLeg(step))
        or step.verb == "goto" and pointlessLeg(step)) then return false end
    if G:IsBlocked(step) then return false end
    local _, held, pre = G:HeldReason(step)
    if held and not wallOpens(held, pre) then return false end
    if G:IsBehind(step) then
        if not step.quest then return false end                -- travel / notes you've moved past
        if not QS:IsOnQuest(step.quest) then return false end  -- missed: listed, not forced
    end
    return true
end

-- What a flight or boat step is for: the first step after it that isn't travel and is still
-- open. The panel shows it, so a trip never looks like travel for its own sake.
function G:TripReason(step)
    if not active or not step.index or active.steps[step.index] ~= step then return end
    for i = step.index + 1, #active.steps do
        local s = active.steps[i]
        if s.verb ~= "fly" and s.verb ~= "goto" and isOpen(s) then return s end
    end
end

-- /ow report: everything needed to see what a step did wrong, as text to paste into an issue.
-- No character or realm name: level, class, race and position only.
function G:Report(note)
    local out = {}
    local function add(fmt, ...) out[#out + 1] = select("#", ...) > 0 and fmt:format(...) or fmt end
    local step = G:Current()
    local build = GetBuildInfo and select(1, GetBuildInfo()) or "?"
    add("Onward %s, game %s", tostring(W.version), tostring(build))
    if note and note ~= "" then add("What happened: %s", note) end
    local _, class = UnitClass("player")
    local _, race = UnitRace("player")
    add("Character: level %s %s %s (%s)", tostring(UnitLevel("player")), tostring(race), tostring(class), tostring(UnitFactionGroup("player")))
    local map = C_Map.GetBestMapForUnit("player")
    local p = map and C_Map.GetPlayerMapPosition(map, "player")
    add("Position: map %s %s", tostring(map), p and p.x and ("%.1f, %.1f"):format(p.x * 100, p.y * 100) or "?")
    add("Settings: quests %s, group quests %s", tostring(W.db.questMode), tostring(W.db.groupQuests))
    if not active then add("No guide active") return table.concat(out, "\n") end
    add("Guide: %s (%s), step %d of %d", tostring(active.title), tostring(active.id), cursor, #active.steps)
    local function state(s)
        local f = {}
        if G:IsComplete(s) then f[#f + 1] = "complete" end
        if G:IsSkipped(s) then f[#f + 1] = "skipped" end
        if G:IsLater(s) then f[#f + 1] = "later" end
        if G:IsWaiting(s) then f[#f + 1] = "waiting" end
        if G:IsBlocked(s) then f[#f + 1] = "blocked" end
        if G:IsBehind(s) then f[#f + 1] = "behind" end
        local why = G:HeldReason(s)
        if why then f[#f + 1] = "held: " .. why end
        if s.quest then
            f[#f + 1] = QS:IsDone(s.quest) and "quest done" or QS:IsReady(s.quest) and "quest ready"
                or QS:IsOnQuest(s.quest) and "quest in log" or "quest not in log"
        end
        return #f > 0 and table.concat(f, ", ") or "open"
    end
    for i = math.max(1, cursor - 2), math.min(#active.steps, cursor + 3) do
        local s = active.steps[i]
        add("%s %d. %s", i == cursor and ">" or " ", i, tostring(s.raw or s.verb))
        add("      [%s]", state(s))
    end
    if step and step.quest then
        local text = QS:ObjectiveText(step.quest)
        if text and text ~= "" then add("Objectives: %s", tostring(text):gsub("\n", "; ")) end
    end
    local cur = W.Waypoint and W.Waypoint:Current()
    if cur then
        add("Arrow: map %s %.1f, %.1f%s%s", tostring(cur.map), cur.x or 0, cur.y or 0,
            cur.leg and (" (" .. cur.leg .. ")") or "", cur.name and (" " .. cur.name) or "")
        local ok, tgt = pcall(W.Waypoint.ArrowTarget, W.Waypoint)
        if ok and tgt then add("Travel plan: %s / %s", tostring(tgt.label), tostring(tgt.route or tgt.sub or "on foot")) end
    end
    return table.concat(out, "\n")
end

function G:Current()
    return active and active.steps[cursor]
end

-- Kill/loot steps you can work on together: the current `complete` step plus later open
-- `complete` steps whose quest is already in your log and whose objective area lies within
-- GROUP_YARDS of the current one. Steps without coordinates join only when they directly follow
-- one that has none either (a placed step far away is not "also here").
-- The scan stops at travel (goto / fly) and looks at most GROUP_LOOKAHEAD open steps ahead.
local GROUP_YARDS, GROUP_LOOKAHEAD, GROUP_MAX = 350, 8, 4
local function near(a, b)
    local ha, hb = a.at and a.at.map, b.at and b.at.map
    if not (ha or hb) then return nil end        -- neither placed: adjacency decides
    if not (ha and hb) then return false end     -- one placed, one not: no reason to think they're together

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

-- On your way: kill/loot steps from anywhere later in the guide whose quest is already in your
-- log and whose area is close to you or to where the current step sends you. They aren't the
-- step yet, but there's no reason to run past their mobs: the card lists them and the target
-- button knows their mobs. Nearest first, at most PASS_MAX; steps already in the group are left
-- out. Nothing is listed while you're on another continent or the option is off.
local PASS_YARDS, PASS_MAX = 700, 4
function G:Passing()
    local out = {}
    local T = W.Travel
    if not active or active.id == "smart" or not T or (W.db and W.db.passing == false) then return out end
    local cur = active.steps[cursor]
    if not cur then return out end
    local inGroup, seen = {}, {}
    for _, s in ipairs(G:Group()) do inGroup[s] = true if s.quest then seen[s.quest] = true end end
    local pc, px, py = T.PlayerWorld()
    local tc, tx, ty
    if cur.at and cur.at.map then tc, tx, ty = T.World(cur.at.map, cur.at.x, cur.at.y) end
    if not pc then return out end
    local found = {}
    for i = cursor + 1, #active.steps do
        local s = active.steps[i]
        if s.verb == "complete" and s.quest and s.at and s.at.map and not inGroup[s] and not seen[s.quest]
           and QS:IsOnQuest(s.quest) and isOpen(s) then
            local c, x, y = T.World(s.at.map, s.at.x, s.at.y)
            if c == pc then
                local d = math.sqrt((x - px) ^ 2 + (y - py) ^ 2)
                if tc == c then d = math.min(d, math.sqrt((x - tx) ^ 2 + (y - ty) ^ 2)) end
                if d <= PASS_YARDS then
                    seen[s.quest] = true
                    found[#found + 1] = { s = s, d = d }
                end
            end
        end
    end
    table.sort(found, function(a, b) return a.d < b.d end)
    for i = 1, math.min(PASS_MAX, #found) do out[i] = found[i].s end
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
    -- steps behind you: done, skipped, set aside or passed. A quest that isn't on offer yet (and
    -- its objectives and turn-in) is still ahead of you, so it doesn't count: a fresh character
    -- starts at 0, not at the number of quests with a prerequisite.
    local done = 0
    for _, s in ipairs(active.steps) do
        if G:IsComplete(s) then
            done = done + 1
        elseif not isOpen(s) then
            local a = s.verb == "accept" and s or (G:IsBlocked(s) and active.acceptOf[s.quest])
            local stillAhead = a and not G:IsSkipped(a) and not G:IsBehind(a) and G:HeldReason(a) ~= nil
            if not stillAhead then done = done + 1 end
        end
    end
    return done, #active.steps
end

-- Move the cursor to the first open step: forward from where it is, or back to a quest step
-- behind it that has opened again (an objective you lost the items for, a quest that came on
-- offer or that you picked up after all). Turn-ins behind the cursor don't pull it back: they
-- are offered on the panel when ready (G:Waiting). A removed quest rescans from the start.
local function scan(i, fromStart)
    local n = #active.steps
    while i <= n and not isOpen(active.steps[i]) do
        local s = active.steps[i]
        if not fromStart and G:IsWaiting(s) and not G:IsSkipped(s) and not notified[s] then
            notified[s] = true
            W:Fire("WF_TURNIN_WAITING", s)
        end
        i = i + 1
    end
    return i
end

local function advance(fromStart)
    if not active then return end
    active.frontier = frontierIndex()
    local n = #active.steps
    local start = fromStart and 1 or cursor
    wall = false
    if not fromStart then
        for k = 1, math.min(cursor - 1, n) do
            local s = active.steps[k]
            if (s.verb == "accept" or s.verb == "complete") and isOpen(s) then start = k break end
        end
    end
    local i = scan(start, fromStart)
    if i > n and active.id ~= "smart" and #G:LaterList() == 0 then
        wall = true
        i = scan(1, true)
        if i > n then wall = false end
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
        local nxt = registry[active.def.next]
        local lvl = UnitLevel("player") or 1
        local lo = nxt.levels and nxt.levels[1] or 1
        if lvl < lo - 1 then
            -- you finished early (quests skipped, or a faster mode): the next part is above you.
            -- Go to a guide that fits your level instead, if there is one.
            local rec = G:Recommend()
            if rec and rec ~= nxt and rec ~= active.def then
                W.Print(("guide complete. %s starts around level %d and you're %d, so on to %s for now."):format(nxt.title, lo, lvl, rec.title))
                G:Activate(rec.id)
                return
            end
            W.Print(("guide complete. %s starts around level %d and you're %d: its first quests may not be on offer yet."):format(nxt.title, lo, lvl))
        else
            W.Print("guide complete, moving on to", nxt.title)
        end
        G:Activate(nxt.id)
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
    -- the guide you're on is out once you've reached its end, even with turn-ins skipped on the way
    local finished = active and not active.def.smart and not active.steps[cursor] and active.def
    local best, bestScore, bestReason
    for i, def in ipairs(ordered) do
        local factionOk = not (def.faction and def.faction ~= "" and faction and def.faction:sub(1, 1):upper() ~= faction:sub(1, 1))
        if not def.smart and def.kind ~= "profession" and factionOk and def.steps and def ~= finished then
            local lo, hi = def.levels[1], def.levels[2]
            local pct = G:ProgressFor(def) or 0
            if pct < 1 and lvl <= hi + 1 then
                local held, seen = 0, {}
                for _, s in ipairs(parsedFor(def).steps) do
                    if s.quest and inLog[s.quest] and not seen[s.quest] then seen[s.quest] = true held = held + 1 end
                end
                local isHome = home and def.zone == home and lvl < 10 and lvl <= hi
                local inRange = isHome or (lvl >= lo - 1 and lvl <= hi)   -- a starting zone fits from level 1
                local score, reason = 0, "level"
                -- quests in your log speak for a guide only when you can do it: a breadcrumb to a
                -- zone five levels up used to pull its guide in on its own
                if held > 0 and not (isHome or lvl >= lo - 2) then held = 0 end
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
        -- skips saved by step number (before 0.6.22) can't be matched to steps any more
        local old = W.cdb.skipped[def.id]
        if old then
            for k in pairs(old) do
                if type(k) == "number" then old[k] = nil end
            end
        end
    end
    wall = false
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

-- The quest log and the completed-quest records arrive over the first seconds after login, so
-- the step picked at login can sit on a quest you've done or already have. Normal refreshes only
-- move forward from the current step, so for a while after login every refresh rescans the
-- guide from the start (what choosing the guide again does), and a few timed passes catch data
-- that lands without a quest log event.
local SETTLE_S = 12
function G:Rescan()
    if not active or active.id == "smart" then return end
    advance(true)
    W:Fire("WF_UPDATED")
end
W:On("PLAYER_LOGIN", function()
    settleUntil = GetTime() + SETTLE_S   -- before Activate: a resume point isn't saved until the records are in
    G:Activate(W.cdb.guide)
    for _, t in ipairs({ 1, 3, 6, SETTLE_S }) do C_Timer.After(t, function() G:Rescan() end) end
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
-- an item that starts a quest landed in your bags: its accept step can come up
W:On("BAG_UPDATE_DELAYED", function()
    -- start items and items to bring both depend on what's in your bags
    if not (active and (active.hasStartItems or active.hasPick or (active.needOf and next(active.needOf)))) then return end
    W:RequestRefresh()
end)

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
        advance(needRescan or GetTime() < settleUntil)
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
