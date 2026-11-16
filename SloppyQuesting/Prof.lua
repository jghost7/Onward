-- Professions: your ranks, the recipes you know (with their live colour), and where to train or
-- buy. Profession guides (Guides/Professions, built by tools/draft_professions.py) are ordinary
-- guides with three extra step types the guide engine asks this module about:
--   train <skillLine> <cap>      done when your max rank reaches cap (75/150/225/300)
--   craft <spellID> <until>      done when your rank reaches until
--   gather <skillLine> <until>   done when your rank reaches until
-- The routes are planned from client data; this module checks them against the game: the
-- recipes you actually know and their real colours (read whenever the profession window is
-- open), and the mats in your bags and bank.
local _, W = ...
local P = {}
W.Prof = P

local T = W.Travel
P.NAMES = { [171] = "Alchemy", [164] = "Blacksmithing", [333] = "Enchanting", [202] = "Engineering",
            [165] = "Leatherworking", [197] = "Tailoring", [185] = "Cooking", [129] = "First Aid",
            [182] = "Herbalism", [186] = "Mining", [393] = "Skinning", [356] = "Fishing" }
P.RANK_NAME = { [75] = "Apprentice", [150] = "Journeyman", [225] = "Expert", [300] = "Artisan" }
local GATHER_VERB = { [182] = "Gather herbs", [186] = "Mine", [393] = "Skin beasts", [356] = "Fish" }
-- Enum.TradeskillRelativeDifficulty: Optimal (orange) 0, Medium (yellow) 1, Easy (green) 2, Trivial (grey) 3
P.COLOR = { [0] = "ffff8040", [1] = "ffffff00", [2] = "ff40bf40", [3] = "ff808080" }
P.COLOR_NAME = { [0] = "orange", [1] = "yellow", [2] = "green", [3] = "grey" }

---------------------------------------------------------------------------
-- ranks
---------------------------------------------------------------------------
local ranks = {}       -- [skillLine] = { rank, max }
local byName = {}
for id, n in pairs(P.NAMES) do byName[n] = id end

function P:Scan()
    wipe(ranks)
    if GetProfessions and GetProfessionInfo then
        for _, idx in pairs({ GetProfessions() }) do
            if idx then
                local name, _, rank, max, _, _, line = GetProfessionInfo(idx)
                line = W.Safe(line) or (name and byName[name])
                if line then ranks[line] = { rank = W.Safe(rank) or 0, max = W.Safe(max) or 0 } end
            end
        end
    end
    -- older skill list (and a fallback when the above is empty)
    if not next(ranks) and GetNumSkillLines and GetSkillLineInfo then
        for i = 1, GetNumSkillLines() do
            local name, header, _, rank, _, _, max = GetSkillLineInfo(i)
            local line = not header and name and byName[name]
            if line then ranks[line] = { rank = rank or 0, max = max or 0 } end
        end
    end
end

-- your rank and max rank in a profession, or nil when you don't have it
function P:Rank(skill)
    local r = ranks[skill]
    if r then return r.rank, r.max end
end

---------------------------------------------------------------------------
-- recipes you know: read from the profession window, kept per character
---------------------------------------------------------------------------
local avail = {}       -- [spell] = craftable now (this session)
local function store(skill)
    W.cdb.recipes = W.cdb.recipes or {}
    W.cdb.recipes[skill] = W.cdb.recipes[skill] or {}
    return W.cdb.recipes[skill]
end

function P:ReadWindow()
    local api = C_TradeSkillUI
    if not (api and api.GetAllRecipeIDs and api.GetRecipeInfo) then return end
    local line
    if api.GetBaseProfessionInfo then
        local info = api.GetBaseProfessionInfo()
        line = info and W.Safe(info.professionID)
    end
    if (not line or not P.NAMES[line]) and api.GetTradeSkillLine then
        local id, name = api.GetTradeSkillLine()
        line = (P.NAMES[id or 0] and id) or (name and byName[name])
    end
    if not (line and P.NAMES[line]) then return end
    local ok, ids = pcall(api.GetAllRecipeIDs)
    if not ok or type(ids) ~= "table" then return end
    local known = store(line)
    wipe(known)
    for _, id in ipairs(ids) do
        local r = api.GetRecipeInfo(id)
        if r and r.learned then
            known[id] = { name = r.name, diff = r.relativeDifficulty }
            avail[id] = r.numAvailable or 0
        end
    end
    P.readAt = GetTime()
    P:Scan()
    W:RequestRefresh()
end

function P:Knows(spell, skill)
    local known = W.cdb.recipes and skill and W.cdb.recipes[skill]
    if known and known[spell] then return true end
    if IsPlayerSpell then
        local ok, yes = pcall(IsPlayerSpell, spell)
        if ok and yes then return true end
    end
    if known and next(known) then return false end
    return nil                       -- never seen this profession's window: unknown
end

-- the best skill-up you can do right now from what you know: orange before yellow, ones you have
-- the mats for first. Only from the last time the profession window was open.
function P:Best(skill)
    local known = W.cdb.recipes and W.cdb.recipes[skill]
    if not known then return end
    local best, bestKey
    for id, r in pairs(known) do
        if r.diff == 0 or r.diff == 1 then
            local have = (avail[id] or 0) > 0
            local key = (have and 0 or 2) + r.diff
            if not best or key < bestKey then best, bestKey = { spell = id, name = r.name, diff = r.diff, available = avail[id] or 0 }, key end
        end
    end
    return best
end

function P:Difficulty(spell, skill)
    local known = W.cdb.recipes and W.cdb.recipes[skill]
    local r = known and known[spell]
    return r and r.diff
end

---------------------------------------------------------------------------
-- steps
---------------------------------------------------------------------------
-- crafts still to go on a craft step, from the route's estimate scaled by the skill left
function P:CraftsLeft(step)
    local rank = P:Rank(step.skill or 0)
    if not rank or not step.n then return step.n end
    local from, to = step.from or 1, step.untilSkill
    if rank >= to then return 0 end
    if rank <= from then return step.n end
    return math.ceil(step.n * (to - rank) / math.max(1, to - from))
end

function P:ItemName(id)
    local n = C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(id)
    return n or (W.ProfData and W.ProfData.items[id]) or ("item " .. id)
end

function P:Count(id)
    local n = (C_Item and C_Item.GetItemCount and C_Item.GetItemCount(id, true)) or (GetItemCount and GetItemCount(id, true)) or 0
    return W.Safe(n) or 0
end

-- mats for the rest of a craft step: { {id, name, have, need} }
function P:Mats(step)
    local out, left = {}, P:CraftsLeft(step) or 0
    for _, m in ipairs(step.mats or {}) do
        out[#out + 1] = { id = m.id, name = P:ItemName(m.id), have = P:Count(m.id), need = m.n * left }
    end
    return out
end

function P:IsDone(step)
    local rank, max = P:Rank(step.skill or 0)
    if step.verb == "train" then return max ~= nil and max >= step.cap end
    return rank ~= nil and rank >= step.untilSkill
end

function P:StepText(step)
    local pname = P.NAMES[step.skill] or "profession"
    if step.verb == "train" then
        local rn = P.RANK_NAME[step.cap] or ("rank " .. step.cap)
        if step.cap == 75 then return "Learn " .. pname end
        if step.book then return ("%s %s: read %s"):format(rn, pname, P:ItemName(step.book)) end
        if step.questId then
            local t = W.QuestState:Title(step.questId) or (C_QuestLog.GetTitleForQuestID and C_QuestLog.GetTitleForQuestID(step.questId))
            return ("%s %s: quest %s"):format(rn, pname, t or step.questId)
        end
        return ("Train %s %s"):format(rn, pname)
    elseif step.verb == "craft" then
        local name = step.name or (GetSpellInfo and GetSpellInfo(step.spell)) or ("recipe " .. step.spell)
        local d = P:Difficulty(step.spell, step.skill)
        if d and P.COLOR[d] then name = "|c" .. P.COLOR[d] .. name .. "|r" end
        return ("Craft %s to %d"):format(name, step.untilSkill)
    elseif step.verb == "gather" then
        return ("%s to %d"):format(GATHER_VERB[step.skill] or pname, step.untilSkill)
    end
end

-- nearest entry of a {faction, map, x, y, name} style list for your faction
local function nearest(list, factionIdx, mapIdx, filter)
    if not list then return end
    local f = (UnitFactionGroup("player") or "A"):sub(1, 1)
    local pc, px, py = T.PlayerWorld()
    local best, bestD
    for _, e in ipairs(list) do
        if e[factionIdx]:find(f, 1, true) and (not filter or filter(e)) then
            local c, x, y = T.World(e[mapIdx], e[mapIdx + 1], e[mapIdx + 2])
            local d = (pc and c == pc) and ((x - px) ^ 2 + (y - py) ^ 2) or 1e12   -- other continent: last resort
            if not bestD or d < bestD then best, bestD = e, d end
        end
    end
    if best then return best[mapIdx], best[mapIdx + 1], best[mapIdx + 2], best[mapIdx + 3] end
end

-- where a profession step points: the trainer, the book or recipe vendor, or the quest giver
function P:Location(step)
    local D = W.ProfData
    if step.verb == "train" then
        if step.book and D then return nearest(D.vendors[step.book], 1, 2) end
        if step.questId then
            local loc = W.QuestieBridge:StartLocation(step.questId)
            if loc then return loc.map, loc.x, loc.y, loc.name end
        end
        return nearest(D and D.trainers[step.skill], 2, 3, function(e) return e[1] >= step.cap end)
    elseif step.verb == "craft" then
        local knows = P:Knows(step.spell, step.skill)
        if knows then return end
        if step.recipe and D then return nearest(D.vendors[step.recipe], 1, 2) end
        if knows == false then
            -- known profession, recipe not learned yet: the trainer
            return nearest(D and D.trainers[step.skill], 2, 3)
        end
    end
end

-- extra lines under a profession step on the panel: { {text, color} }
function P:CardLines(step)
    local out = {}
    local rank, max = P:Rank(step.skill)
    if step.verb == "train" then
        if rank then out[#out + 1] = { ("skill %d/%d"):format(rank, max) } end
        if step.level and (UnitLevel("player") or 0) < step.level then
            out[#out + 1] = { ("needs level %d"):format(step.level), "warn" }
        end
        return out
    end
    if step.verb == "gather" then
        if rank then out[#out + 1] = { ("skill %d/%d"):format(rank, max) } end
        if step.beasts then
            out[#out + 1] = { ("beasts level %d+ (skinnable while not grey)"):format(step.beasts) }
        end
        return out
    end
    -- craft
    local left = P:CraftsLeft(step)
    local parts = {}
    if rank then parts[#parts + 1] = ("skill %d/%d"):format(rank, max) end
    if left and left > 0 then parts[#parts + 1] = ("~%d crafts left"):format(left) end
    if #parts > 0 then out[#out + 1] = { table.concat(parts, "  ·  ") } end
    local knows = P:Knows(step.spell, step.skill)
    if knows == false then
        if step.recipe then
            out[#out + 1] = { "buy the recipe: " .. P:ItemName(step.recipe), "warn" }
        else
            out[#out + 1] = { "learn it from your trainer", "warn" }
        end
    elseif knows == nil then
        out[#out + 1] = { "open your " .. (P.NAMES[step.skill] or "profession") .. " window once so the guide can see your recipes" }
    end
    for _, m in ipairs(P:Mats(step)) do
        local ok = m.have >= m.need
        out[#out + 1] = { ("%s %s  %d/%d"):format(ok and "|cff66d973+|r" or "-", m.name, math.min(m.have, m.need), m.need), ok and "dim" or "sub" }
    end
    -- what the game says you can do best right now, when it isn't the route's recipe
    local best = P:Best(step.skill)
    local d = P:Difficulty(step.spell, step.skill)
    if best and best.spell ~= step.spell and (d == nil or d >= 2 or not knows or (avail[step.spell] or 0) == 0) then
        local can = best.available > 0 and ("  ·  can make %d"):format(best.available) or ""
        out[#out + 1] = { ("instead now: |c%s%s|r (%s)%s"):format(P.COLOR[best.diff], best.name or "?", P.COLOR_NAME[best.diff], can) }
    end
    return out
end

-- picker: how far you are in a profession guide (rank / 300)
function P:Progress(def)
    local rank = P:Rank(def.skill)
    if rank then return math.min(1, rank / 300), rank end
end

---------------------------------------------------------------------------
-- wiring
---------------------------------------------------------------------------
W:On("PLAYER_LOGIN", function() P:Scan() end)
W:On("SKILL_LINES_CHANGED", function() P:Scan() W:RequestRefresh() end)
W:On("CHAT_MSG_SKILL", function() P:Scan() W:RequestRefresh() end)
W:On("TRADE_SKILL_SHOW", function() C_Timer.After(0.3, function() P:ReadWindow() end) end)
W:On("TRADE_SKILL_LIST_UPDATE", function() P:ReadWindow() end)
W:On("NEW_RECIPE_LEARNED", function() C_Timer.After(0.3, function() P:ReadWindow() end) end)
W:On("BAG_UPDATE_DELAYED", function()
    local g = W.Guide:Active()
    if g and g.def and g.def.kind == "profession" then W:Fire("WF_UPDATED") end
end)
