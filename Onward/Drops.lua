-- Drop tracker for "collect N items" quest objectives: your drop rate per kill, compared with the
-- expected one from Questie's drop tables (Wowhead's crowd-sourced rates, private-server data for
-- quest-only drops, Questie's own corrections). Stats are account-wide and add up across
-- characters and repeat runs.
--
-- Kills. Forever blocks the combat log for addons, so deaths are watched on unit tokens instead:
-- your target and every enemy nameplate. A kill is a mob that dies after you (or your group) were
-- fighting it and that isn't tapped by someone else. GUIDs can be secret on Forever, so mobs are
-- matched by name: a kill counts toward an item when the mob's name is one Questie lists as
-- dropping it, or a mob that has dropped it for you. Mobs that die off your screen with no
-- nameplate showing are missed.
--
-- Drops. Each loot window is read slot by slot (GetLootSourceInfo): every corpse that gave a
-- wanted quest item counts one drop, deduplicated by corpse. The looted corpses themselves are a
-- second, fallback count of "kills" (always available, but corpses with no loot never open a
-- window, so it reads high); the panel uses it only when kill watching has seen nothing, or has
-- clearly missed kills (more drops than kills).
--
-- Only while the item objective is unfinished. Pickpocketing a living mob, re-opening a corpse
-- and the same death seen on target and nameplate are counted once.
local _, W = ...
local D = {}
W.Drops = D

local QS, QB = W.QuestState, W.QuestieBridge
local MIN_KILLS = 5          -- below this, show the count only, no verdict
local SCHEMA = 2
local seen, seenCount = {}, 0
D.log = {}                   -- last few kill / loot events, for /ow drops debug
D.unmatched = {}             -- kills (this session) of mobs not yet known to drop a wanted item

local function note(fmt, ...)
    table.insert(D.log, 1, ("%s  " .. fmt):format(date and date("%H:%M:%S") or "", ...))
    D.log[11] = nil
end

-- db.drops = { schema, items = { [itemId] = { name, kills = {[mob] = n}, got = n,
--              corpses = n, cgot = n, mobs = {[mob] = true} } } }
local function store()
    local s = W.db.drops
    if type(s) ~= "table" or s.schema ~= SCHEMA then
        s = { schema = SCHEMA, items = {} }
        W.db.drops = s
    end
    return s.items
end

-- "Hag Charm: 2/8" and "2/8 Hag Charm" both -> "Hag Charm"
function D.ItemName(text)
    if not text then return end
    local name = text:gsub("%s*%d+%s*/%s*%d+%s*", " "):gsub(":", ""):match("^%s*(.-)%s*$")
    return name ~= "" and name or nil
end

local function npcIdFromGuid(guid)
    if type(guid) ~= "string" then return end
    local kind, _, _, _, _, id = strsplit("-", guid)
    if kind == "Creature" or kind == "Vehicle" then return tonumber(id) end
end

-- Is this objective a "collect an item" one, and which item? Returns name, itemId-or-true.
-- The client's type is "item"; when it isn't set (or says something else) but Questie lists an
-- item of that name for the quest, it counts too.
function D.ItemObjective(o, q)
    if not o or o.finished then return end
    local name = D.ItemName(o.text)
    if not name then return end
    local ids = q and QB:ItemObjectives(q) or {}
    for _, io in ipairs(ids) do
        if io.name == name then return name, io.id end
    end
    if o.type == "item" then return name, true end
end

-- unfinished item objectives in the log: { [itemName] = itemId or true } (the id comes from
-- Questie when it's installed)
local function wanted()
    local out = {}
    for _, q in ipairs(QS:Order()) do
        local e = QS:Get(q)
        for _, o in ipairs(e and e.objectives or {}) do
            local name, id = D.ItemObjective(o, q)
            if name and (out[name] == nil or out[name] == true) then out[name] = id end
        end
    end
    return out
end

-- the item's record; the first time, seed its dropping mobs from Questie (by name)
local function entry(itemId, name)
    local items = store()
    local e = items[itemId]
    if not e then
        e = { name = name, kills = {}, got = 0, corpses = 0, cgot = 0, mobs = {} }
        items[itemId] = e
        for npc in pairs(QB:ItemDropNpcs(itemId) or {}) do
            local n = QB:NpcName(npc)
            if n then e.mobs[n] = true end
        end
    end
    e.name = e.name or name
    return e
end

-- wanted items we can identify: { [itemId] = name } (from Questie, or from earlier drops)
local function wantedIds()
    local want, out = wanted(), {}
    for name, id in pairs(want) do if id ~= true then out[id] = name end end
    for itemId, e in pairs(store()) do
        if e.name and want[e.name] then out[itemId] = e.name end
    end
    return out, want
end

---------------------------------------------------------------------------
-- kills: deaths on target and nameplate tokens
---------------------------------------------------------------------------
local units = {}             -- token -> { name, guid, fought, dead }
local counted = {}           -- guid -> true (when GUIDs are readable)

local function isPlate(u) return u:find("^nameplate%d+$") ~= nil end

local function fresh(u)
    local name = W.Safe(UnitName(u))
    if not name then units[u] = nil return end
    units[u] = { name = name, guid = W.Safe(UnitGUID and UnitGUID(u)),
                 dead = W.Safe(UnitIsDead(u)) and true or false, fought = false }
end

function D:Kill(name, guid)
    if guid then
        if counted[guid] then return end
        counted[guid] = true
    end
    local n = 0
    local ids, want = wantedIds()
    for itemId, iname in pairs(ids) do
        local e = entry(itemId, iname)
        if e.mobs[name] then
            e.kills[name] = (e.kills[name] or 0) + 1
            n = n + 1
        end
    end
    -- not (yet) known to drop anything wanted: hold the kill, in case its first drop teaches us
    if n == 0 and next(want) then D.unmatched[name] = (D.unmatched[name] or 0) + 1 end
    note("kill %s%s", name, n > 0 and "" or " (not a drop mob for any open objective)")
    if n > 0 then W:RequestRefresh() end
end

-- the same death can arrive on the target and on its nameplate (in either order, and the plate
-- is often removed in the same moment): count it once
local lastDeath = { plate = {}, target = {} }
local SAME_DEATH = 0.25      -- seconds: target and plate events for one death arrive together
local function sameDeathCounted(u, name)
    local now = GetTime()
    if u == "target" then
        -- the plate of a dying mob is usually removed in the same moment; only a death of the
        -- same name that very instant is taken as this one
        if (lastDeath.plate[name] or -9) > now - SAME_DEATH and (lastDeath.plateTarget or -9) > now - SAME_DEATH then return true end
        for tok in pairs(units) do
            if isPlate(tok) and W.Safe(UnitIsUnit(tok, "target")) and units[tok].dead then return true end
        end
    elseif W.Safe(UnitIsUnit(u, "target")) and (lastDeath.target[name] or -9) > now - SAME_DEATH then
        return true
    end
    return false
end
local function noteDeath(u, name)
    local now = GetTime()
    if u == "target" then
        lastDeath.target[name] = now
    else
        lastDeath.plate[name] = now
        -- remember when the dying plate was our target (checked before the plate goes away)
        if W.Safe(UnitIsUnit(u, "target")) then lastDeath.plateTarget = now end
    end
end

local function check(u)
    local st = units[u]
    if not st then return end
    if W.Safe(UnitIsDead(u)) then
        if st.dead then return end
        st.dead = true
        local denied = W.Safe(UnitIsTapDenied and UnitIsTapDenied(u))
        if st.fought and not denied and not sameDeathCounted(u, st.name) then
            noteDeath(u, st.name)
            D:Kill(st.name, st.guid)
        end
        return
    end
    st.dead = false
    if not st.fought and W.Safe(UnitCanAttack("player", u)) and not W.Safe(UnitIsTapDenied and UnitIsTapDenied(u)) then
        local threat = W.Safe(UnitThreatSituation and UnitThreatSituation("player", u))
        local fighting = W.Safe(UnitAffectingCombat(u)) and W.Safe(UnitAffectingCombat("player"))
        if threat ~= nil or (fighting and W.Safe(UnitIsUnit(u, "target"))) then st.fought = true end
    end
end

local function unitEvent(_, u)
    if u and (u == "target" or isPlate(u)) then
        if not units[u] then fresh(u) end
        check(u)
    end
end
W:On("UNIT_HEALTH", unitEvent)
W:On("UNIT_FLAGS", unitEvent)
W:On("UNIT_THREAT_LIST_UPDATE", unitEvent)
W:On("UNIT_COMBAT", unitEvent)
W:On("NAME_PLATE_UNIT_ADDED", function(_, u) fresh(u) check(u) end)
W:On("NAME_PLATE_UNIT_REMOVED", function(_, u) check(u) units[u] = nil end)   -- often removed on death
W:On("PLAYER_TARGET_CHANGED", function() fresh("target") check("target") end)

---------------------------------------------------------------------------
-- loot: drops (and looted corpses, the fallback kill count)
---------------------------------------------------------------------------
function D:OnLoot()
    local ids, want = wantedIds()
    if not next(want) then return end
    local n = W.Safe(GetNumLootItems and GetNumLootItems()) or 0
    local corpses, gave = {}, {}               -- key -> true ; key -> {itemId = true}
    local target = W.Safe(UnitGUID and UnitGUID("target"))
    local targetAlive = UnitExists("target") and not W.Safe(UnitIsDead("target"))
    local anon = 0
    for slot = 1, n do
        local link = W.Safe(GetLootSlotLink(slot))
        local itemId = link and tonumber(link:match("item:(%d+)"))
        local name = link and link:match("%[(.-)%]")
        local isWanted = itemId and name and want[name]
        if isWanted then ids[itemId] = name end
        local src = { GetLootSourceInfo(slot) }
        local any = false
        for i = 1, #src, 2 do
            local guid = W.Safe(src[i])
            if guid then
                any = true
                if npcIdFromGuid(guid) and not seen[guid] and not (targetAlive and guid == target) then
                    corpses[guid] = true
                    if isWanted then gave[guid] = gave[guid] or {} gave[guid][itemId] = true end
                end
            end
        end
        if not any and not targetAlive then
            -- corpse ids hidden: treat the window as one corpse
            anon = 1
            if isWanted then gave.window = gave.window or {} gave.window[itemId] = true end
        end
    end
    if anon > 0 and not next(corpses) then corpses.window = true end
    -- whose corpse: Questie's name for the npc id, or the dead target's name when it's the target
    local tname = UnitExists("target") and W.Safe(UnitIsDead("target")) and W.Safe(UnitName("target"))
    local nCorpses = 0
    for _ in pairs(corpses) do nCorpses = nCorpses + 1 end
    for key in pairs(corpses) do
        if key ~= "window" then seen[key] = true seenCount = seenCount + 1 end
        local npc = key ~= "window" and npcIdFromGuid(key)
        -- one corpse while the target lies dead: that's the target (its GUID may be hidden)
        local cname = (npc and QB:NpcName(npc)) or ((key == "window" or key == target or nCorpses == 1) and tname) or nil
        for itemId, iname in pairs(ids) do
            local e = entry(itemId, iname)
            local got = gave[key] and gave[key][itemId]
            if got and cname and not e.mobs[cname] then                            -- learned dropper
                e.mobs[cname] = true
                local held = D.unmatched[cname]
                if held then
                    e.kills[cname] = (e.kills[cname] or 0) + held
                    D.unmatched[cname] = nil
                end
            end
            if got or (cname and e.mobs[cname]) then
                e.corpses = e.corpses + 1
                if got then
                    e.got, e.cgot = e.got + 1, e.cgot + 1
                    note("loot: %s from %s", iname, cname or "a corpse")
                end
            end
        end
    end
    if seenCount > 2000 then wipe(seen) seenCount = 0 end
    if next(corpses) then W:RequestRefresh() end
end
W:On("LOOT_READY", function() D:OnLoot() end)

---------------------------------------------------------------------------
-- stats
---------------------------------------------------------------------------
-- expected chance of the item from a mob, by name: mean of Questie's rates over the npc ids
-- with that name (rare variants share names)
local function rateFor(itemId, mob)
    local sum, n, src = 0, 0, nil
    for npc in pairs(QB:ItemDropNpcs(itemId) or {}) do
        if QB:NpcName(npc) == mob then
            local pct, s = QB:DropRate(itemId, npc)
            if pct then sum, n, src = sum + pct, n + 1, s end
        end
    end
    if n > 0 then return math.min(math.max(sum / n / 100, 0), 1), src end
end

-- { kills, drops, basis = "kill" | "loot", expected, var, ratedKills, source, name }
function D:Stats(itemId)
    local e = store()[itemId]
    if not e then return end
    local k = 0
    for _, n in pairs(e.kills) do k = k + n end
    local s = { name = e.name, expected = 0, var = 0, ratedKills = 0 }
    if k > 0 and e.got <= k then
        s.kills, s.drops, s.basis = k, e.got, "kill"
        local sources = {}
        for mob, n in pairs(e.kills) do
            local p, src = rateFor(itemId, mob)
            if p then
                s.expected, s.var, s.ratedKills = s.expected + n * p, s.var + n * p * (1 - p), s.ratedKills + n
                sources[src or "?"] = true
            end
        end
        local only = next(sources)
        s.source = only and (next(sources, only) == nil and only or "mixed") or nil
    else
        s.kills, s.drops, s.basis = e.corpses, e.cgot, "loot"
        -- no per-mob kill split here: compare with the mean rate of the item's known droppers
        local sum, n, src = 0, 0, nil
        for mob in pairs(e.mobs) do
            local p, srcm = rateFor(itemId, mob)
            if p then sum, n, src = sum + p, n + 1, srcm end
        end
        if n > 0 and s.kills > 0 then
            local p = sum / n
            s.expected, s.var, s.ratedKills, s.source = s.kills * p, s.kills * p * (1 - p), s.kills, src
        end
    end
    return s
end

function D:ItemIdByName(name)
    for itemId, e in pairs(store()) do if e.name == name then return itemId end end
end

local SOURCE = { wowhead = "Wowhead", cmangos = "server data", mangos3 = "server data", questie = "Questie", mixed = "expected" }

-- the expected rate for an item before any kill: mean over the mobs Questie lists as dropping it
local function expectedAny(itemId)
    local sum, n, src = 0, 0, nil
    for npc in pairs(QB:ItemDropNpcs(itemId) or {}) do
        local pct, s = QB:DropRate(itemId, npc)
        if pct then sum, n, src = sum + pct, n + 1, s end
    end
    if n > 0 then return math.min(math.max(sum / n / 100, 0), 1), src end
end

-- One line for an item objective on the step card. Shown from the start, so the feature is
-- visible before the first kill: the expected rate (when Questie has one) and "counting".
function D:Line(o, q)
    if not W.db.dropStats then return end
    local name, qid = D.ItemObjective(o, q)
    if not name then return end
    local itemId = D:ItemIdByName(name) or (qid ~= true and qid) or nil
    -- looted from an object (a chest, a crate on the ground), never from a mob: kills mean nothing
    if itemId and QB:ItemFromMobs(itemId) == false then return end
    local s = itemId and D:Stats(itemId)
    if not s or s.kills == 0 then
        local p, src = nil, nil
        if itemId then p, src = expectedAny(itemId) end
        local left = (o.need or 0) - (o.have or 0)
        if p and p > 0 then
            local line = ("drop rate: %s %d%%"):format(SOURCE[src] or "expected", math.floor(100 * p + 0.5))
            if left > 0 then line = line .. ("  ·  ~%d kills"):format(math.ceil(left / p)) end
            return line .. "  ·  counting your kills"
        end
        return "drop rate: counting your kills"
    end
    local unit = s.basis == "kill" and "kills" or "looted"
    local parts = { ("%d in %d %s (%d%%)"):format(s.drops, s.kills, unit, math.floor(100 * s.drops / s.kills + 0.5)) }
    -- the per-corpse rate too: likely what Wowhead's own figure measures (its Looter addon sees
    -- loot windows), so the two can be compared like for like
    local e = store()[itemId]
    if s.basis == "kill" and e and e.corpses > 0 then
        parts[1] = parts[1] .. ("  ·  %d%% per looted"):format(math.floor(100 * e.cgot / e.corpses + 0.5))
    end
    local p = s.ratedKills > 0 and s.expected / s.ratedKills or nil
    if p then
        parts[#parts + 1] = ("%s %d%%"):format(SOURCE[s.source] or "expected", math.floor(100 * p + 0.5))
        if s.ratedKills >= MIN_KILLS and s.var > 0 then
            local z = (s.drops * s.ratedKills / s.kills - s.expected) / math.sqrt(s.var)
            parts[#parts + 1] = z > 1 and "|cff66d973luckier|r" or z < -1 and "|cffff7366unluckier|r" or "about average"
        end
    end
    local left = (o.need or 0) - (o.have or 0)
    local rate = p or (s.kills >= MIN_KILLS and s.drops > 0 and s.drops / s.kills) or nil
    if left > 0 and rate and rate > 0 then
        parts[#parts + 1] = ("~%d more kills"):format(math.ceil(left / rate))
    end
    return table.concat(parts, "  ·  ")
end

function D:Reset()
    W.db.drops = nil
    wipe(counted)
    W.Print("drop stats cleared")
    W:RequestRefresh()
end

function D:Report()
    local any = false
    for itemId, e in pairs(store()) do
        local s = D:Stats(itemId)
        if s and s.kills > 0 then
            any = true
            local p = s.ratedKills > 0 and (" vs %s %d%%"):format(SOURCE[s.source] or "expected", math.floor(100 * s.expected / s.ratedKills + 0.5)) or ""
            W.Print(("%s: %d in %d %s (%d%%)%s"):format(e.name or itemId, s.drops, s.kills,
                s.basis == "kill" and "kills" or "looted corpses", math.floor(100 * s.drops / s.kills + 0.5), p))
        end
    end
    if not any then W.Print("no quest drops tracked yet") end
end

-- /ow drops debug: what kill watching can see right now, and the last events
function D:Debug()
    local function yes(v) return v ~= nil and "yes" or "|cffff7366hidden|r" end
    W.Print("target name:", yes(W.Safe(UnitName("target"))), " guid:", yes(W.Safe(UnitGUID and UnitGUID("target"))),
        " threat:", tostring(W.Safe(UnitThreatSituation and UnitThreatSituation("player", "target"))))
    local plates = 0
    for u in pairs(units) do if isPlate(u) then plates = plates + 1 end end
    W.Print("nameplates watched:", plates, "(enemy nameplates must be on to see kills you don't target)")
    for itemId in pairs(store()) do
        local e = store()[itemId]
        local k = 0
        for _, n in pairs(e.kills) do k = k + n end
        W.Print(("%s: %d kills seen, %d looted corpses, %d drops"):format(e.name or itemId, k, e.corpses, e.got))
    end
    if #D.log == 0 then W.Print("no kills or quest drops seen yet") end
    for i = #D.log, 1, -1 do W.Print(D.log[i]) end
end
