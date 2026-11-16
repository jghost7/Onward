-- Party sync. Two sources, merged per party member:
--   1. Sloppy Questing's own addon messages (prefix SLOPQ): current step + quest state changes.
--   2. Questie's party data (any member running Questie, no Sloppy Questing needed).
-- Midnight-era rule: addon messages are blocked during chat lockdown (instances / encounters),
-- so messages queue and flush when lockdown lifts.
local _, W = ...
local P = {}
W.Party = P

local PREFIX = "SLOPQ"
local PROTO = "1"
local QB = W.QuestieBridge

local members = {}      -- [name] = { step = {...}, quests = { [q] = state }, seen = t }
local queue = {}        -- coalesced outgoing: [key] = msg
local queueOrder = {}
local flushPending = false

local function short(name)
    if not name then return end
    return Ambiguate and Ambiguate(name, "none") or name:match("^[^-]+")
end

local function channel()
    if IsInRaid() then return "RAID" end
    if IsInGroup() then return "PARTY" end
end

local function locked()
    return C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown()
end

local function flush()
    flushPending = false
    local ch = channel()
    if not ch or not W.db.partySync then wipe(queue) wipe(queueOrder) return end
    if locked() then
        flushPending = true
        C_Timer.After(5, flush)
        return
    end
    for _, k in ipairs(queueOrder) do
        local msg = queue[k]
        if msg then C_ChatInfo.SendAddonMessage(PREFIX, msg, ch) end
    end
    wipe(queue)
    wipe(queueOrder)
end

local function send(key, msg)
    if not W.db.partySync or not channel() then return end
    if not queue[key] then queueOrder[#queueOrder + 1] = key end
    queue[key] = PROTO .. "|" .. msg
    if not flushPending then
        flushPending = true
        C_Timer.After(0.5, flush)
    end
end

---------------------------------------------------------------------------
-- Outgoing
---------------------------------------------------------------------------
local STATE_CODE = { accepted = "a", ready = "r", turnedin = "t", removed = "x" }
local CODE_STATE = { a = "accepted", r = "ready", t = "turnedin", x = "removed" }

local function sendStep()
    local g, step = W.Guide:Active(), W.Guide:Current()
    if not g then return end
    send("S", ("S|%s|%d|%s|%d"):format(g.id, step and step.index or 0, step and step.verb or "done", step and step.quest or 0))
end

local function sendQuestLog()
    -- compact snapshot so a new member sees what we're on: Q-list of ids, ready ones flagged
    local parts = {}
    for _, q in ipairs(W.QuestState:Order()) do
        parts[#parts + 1] = q .. (W.QuestState:IsReady(q) and "r" or "")
        if #parts >= 25 then break end -- 255-byte message limit
    end
    send("L", "L|" .. table.concat(parts, ","))
end

W:On("WF_QUEST_STATE", function(_, q, state)
    local code = STATE_CODE[state]
    if code then send("Q" .. q, ("Q|%d|%s"):format(q, code)) end
    if state == "ready" and W.db.partyChat and channel() and not locked() then
        local title = W.QuestState:Title(q)
        if title then pcall(C_ChatInfo.SendChatMessage or SendChatMessage, "[Sloppy Questing] done: " .. title, channel()) end
    end
end)

W:On("WF_STEP_CHANGED", function() sendStep() end)

---------------------------------------------------------------------------
-- Incoming
---------------------------------------------------------------------------
local function member(name)
    local m = members[name]
    if not m then m = { quests = {} } members[name] = m end
    m.seen = GetTime()
    return m
end

W:On("CHAT_MSG_ADDON", function(_, prefix, msg, _, sender)
    if prefix ~= PREFIX then return end
    local name = short(sender)
    if not name or name == UnitName("player") then return end
    local proto, kind, a, b, c, d = strsplit("|", msg)
    if proto ~= PROTO then return end
    local m = member(name)
    if kind == "Q" then
        local q, state = tonumber(a), CODE_STATE[b]
        if q and state then
            m.quests[q] = state
            W:Fire("WF_PARTY_EVENT", name, q, state)
        end
    elseif kind == "S" then
        m.step = { guide = a, index = tonumber(b), verb = c, quest = tonumber(d) }
    elseif kind == "L" then
        for item in (a or ""):gmatch("[^,]+") do
            local q, r = item:match("^(%d+)(r?)$")
            if q then m.quests[tonumber(q)] = (r == "r") and "ready" or "accepted" end
        end
    elseif kind == "H" then
        sendStep()
        sendQuestLog()
    end
    W:Fire("WF_PARTY_UPDATED")
end)

W:On("WF_INIT", function()
    C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
end)

local lastSize = 0
W:On("GROUP_ROSTER_UPDATE", function()
    local size = GetNumGroupMembers() or 0
    if size > lastSize and size > 1 then
        send("H", "H")
        sendStep()
        sendQuestLog()
    end
    if size == 0 then wipe(members) end
    lastSize = size
    W:Fire("WF_PARTY_UPDATED")
end)

---------------------------------------------------------------------------
-- Query for the UI: party status for a quest.
-- returns array of { name, class, state, have, need, source }
-- state: "turnedin" | "ready" | "accepted" | "missing" | "unknown"
---------------------------------------------------------------------------
function P:StatusFor(q)
    local out = {}
    if not IsInGroup() or IsInRaid() then return out end
    local questie = q and QB:PartyProgress(q)
    for i = 1, 4 do
        local unit = "party" .. i
        if UnitExists(unit) then
            local name = W.Safe(UnitName(unit))
            local _, class = UnitClass(unit)
            if name then
                local row = { name = name, class = W.Safe(class), state = "unknown" }
                local m = members[name]
                local qz = questie and (questie[name] or questie[name .. "-" .. (GetNormalizedRealmName() or "")])
                if m and q and m.quests[q] then
                    row.state, row.source = m.quests[q], "addon"
                    if row.state == "removed" then row.state = "missing" end
                elseif qz then
                    row.state = qz.done and "ready" or "accepted"
                    row.have, row.need, row.source = qz.have, qz.need, "questie"
                elseif m then
                    row.state = "missing"   -- they run Sloppy Questing and don't have it
                end
                if qz and not row.have then row.have, row.need = qz.have, qz.need end
                out[#out + 1] = row
            end
        end
    end
    return out
end

function P:Member(name) return members[name] end
