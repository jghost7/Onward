-- Headless scenario test. Run: python tests/run.py
local W = Onward
local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        -- kept apart from MOCK.printed, which some checks clear
        MOCK.fails = MOCK.fails or {}
        table.insert(MOCK.fails, "FAIL " .. name .. (detail and (": " .. tostring(detail)) or ""))
    end
end
local function settle() MOCK.advance(1) end
local function cur() return W.Guide:Current() end
local function called(name)
    for _, c in ipairs(MOCK.calls) do if c[1] == name then return c end end
end

-- register a guide the way a guide file would
W:RegisterGuide{
    id = "test", title = "Test Zone (35-36)", levels = { 35, 36 }, faction = "",
    steps = [[
-- comment
accept 100 |npc Vell |at 1423 40.0,40.0
accept 101
note Mage only step |class MAGE
complete 100 |note kill things
goto 1423 50.0,50.0 20 |note Cross the bridge
complete 101
turnin 100
turnin 101
level 36
note Train abilities
bogus 1
]]}

MOCK.fire("ADDON_LOADED", "Onward")
MOCK.fire("PLAYER_LOGIN")
settle()
check("starts on smart guide by default", W.Guide:Active().id == "smart")

W.Guide:Activate("test")
settle()
local g = W.Guide:Active()
check("parser drops class-filtered and bogus lines", #g.steps == 9, #g.steps)
check("unknown verb reported", (function() for _, p in ipairs(MOCK.printed) do if p:find("unknown step") then return true end end end)())
check("first step is accept 100", cur().verb == "accept" and cur().quest == 100)
check("waypoint pinned from |at", MOCK.waypoint and MOCK.waypoint.x == 0.4, MOCK.waypoint and MOCK.waypoint.x)

-- auto accept: guide quest yes, shift pauses, non-guide quest no
MOCK.questId = 100 MOCK.fire("QUEST_DETAIL")
check("auto-accepts guide quest", called("AcceptQuest"))
MOCK.calls = {} MOCK.shift = true MOCK.fire("QUEST_DETAIL") MOCK.shift = false
check("shift pauses auto-accept", not called("AcceptQuest"))
MOCK.questId = 999 MOCK.fire("QUEST_DETAIL")
check("ignores quests outside the guide", not called("AcceptQuest"))

-- party join, then accept both quests
MOCK.inGroup = true
MOCK.party = { { name = "Alex", class = "MAGE" }, { name = "Sam", class = "PRIEST" } }
MOCK.fire("GROUP_ROSTER_UPDATE")
MOCK.addQuest(100, "Into the Glades", { { text = "Glade Stalker slain: 0/4", finished = false, numFulfilled = 0, numRequired = 4 } })
MOCK.fire("QUEST_ACCEPTED", 100)
MOCK.addQuest(101, "Lost Cargo")
MOCK.fire("QUEST_ACCEPTED", 101)
settle()
check("advances past accepts to complete 100", cur().verb == "complete" and cur().quest == 100, cur().verb)
check("complete step super-tracks the quest", MOCK.supertrack == 100, MOCK.supertrack)
local sawAccept = false
for _, s in ipairs(MOCK.sent) do if s[2] == "1|Q|100|a" then sawAccept = true end end
check("party told about accept", sawAccept)

-- party member reports progress
MOCK.fire("CHAT_MSG_ADDON", "ONWRD", "1|Q|100|r", "PARTY", "Alex-Realm")
settle()
local st = W.Party:StatusFor(100)
check("party status has two members", #st == 2, #st)
check("Alex is ready on 100", st[1].name == "Alex" and st[1].state == "ready", st[1] and st[1].state)
check("Sam unknown (no addon)", st[2].state == "unknown", st[2] and st[2].state)

-- finish quest 100 -> goto step
MOCK.finish(100)
MOCK.fire("QUEST_LOG_UPDATE")
settle()
check("advances to goto", cur().verb == "goto", cur().verb)
local sawReady = false
for _, s in ipairs(MOCK.sent) do if s[2] == "1|Q|100|r" then sawReady = true end end
check("party told quest 100 ready", sawReady)

-- walk into the radius (20 yd on a 1000yd map = 0.02)
MOCK.pos.x, MOCK.pos.y = 0.51, 0.505
MOCK.advance(1)
settle()
check("goto completes on arrival", cur().verb == "complete" and cur().quest == 101, cur().verb)

-- manual skip and back
W.Guide:Skip(1)
check("skip moves to turnin 100", cur().verb == "turnin" and cur().quest == 100)
W.Guide:Skip(-1)
check("back returns to complete 101", cur().verb == "complete" and cur().quest == 101, cur().verb)

-- auto turn-in through gossip + reward
MOCK.calls = {}
MOCK.gossipActive = { { questID = 100, isComplete = true } }
MOCK.fire("GOSSIP_SHOW")
check("gossip selects completed quest", called("SelectActiveQuest"))
MOCK.fire("QUEST_PROGRESS")
check("completes quest", called("CompleteQuest"))
MOCK.choices = 3 MOCK.fire("QUEST_COMPLETE")
check("never picks among several rewards", not called("GetQuestReward"))
MOCK.choices = 1 MOCK.fire("QUEST_COMPLETE")
check("takes single reward", called("GetQuestReward"))

-- finish everything
MOCK.finish(101)
MOCK.turnIn(100) MOCK.fire("QUEST_TURNED_IN", 100)
MOCK.turnIn(101) MOCK.fire("QUEST_TURNED_IN", 101)
settle()
check("level step is next", cur().verb == "level", cur().verb)
MOCK.level = 36 MOCK.fire("PLAYER_LEVEL_UP", 36)
settle()
check("note step after level", cur().verb == "note")
W.Guide:MarkDone(cur())
check("guide complete", cur() == nil)
local d, t = W.Guide:Progress()
check("progress full", d == t and t == 9, d .. "/" .. t)

-- abandon handling: smart guide rebuilds from the log
MOCK.addQuest(300, "Far quest") MOCK.addQuest(200, "Near quest")
MOCK.finish(300)
MOCK.fire("QUEST_LOG_UPDATE")
W.Guide:Activate("smart")
settle()
check("smart guide lists log quests", #W.Guide:Active().steps == 2)
-- mock distance = id*10; ready quests count half: 300 ready -> 1500 beats 200 -> 2000
check("smart puts nearby hand-ins first", cur().quest == 300 and cur().verb == "turnin", cur().quest)

-- recorder
W.Recorder:Command("start Riverglades")
settle()
MOCK.npc = "Harbormaster Vell"
MOCK.fire("QUEST_DETAIL")
MOCK.pos.x, MOCK.pos.y = 0.452, 0.601
MOCK.addQuest(400, "Recorded quest")
MOCK.fire("QUEST_ACCEPTED", 400)
settle()
MOCK.finish(400) MOCK.fire("QUEST_LOG_UPDATE") settle()
MOCK.turnIn(400) MOCK.fire("QUEST_TURNED_IN", 400) settle()
W.Recorder:Command("stop")
local text = W.Recorder:ToGuide(OnwardDB.recordings[1])
check("recorder: accept line with npc + coords", text:find("accept 400 |npc Harbormaster Vell |at 1423 45.2,60.1", 1, true), text)
check("recorder: complete line", text:find("complete 400", 1, true))
check("recorder: turnin line", text:find("turnin 400", 1, true))
check("recorder: did not record pre-finished quest 300", not text:find("300", 1, true))
-- the recorded text must itself parse as a guide
local chunk = loadstring(text)
check("recorder output is valid Lua", chunk ~= nil)
if chunk then chunk() W.Guide:Activate("riverglades") settle() check("recorded guide loads", #W.Guide:Active().steps >= 3, #W.Guide:Active().steps) end

-- lockdown: queued, then sent
MOCK.sent = {} MOCK.lockdown = true
MOCK.fire("QUEST_ACCEPTED", 500) MOCK.advance(1)
check("nothing sent during lockdown", #MOCK.sent == 0)
MOCK.lockdown = false MOCK.advance(6)
check("queued message sent after lockdown", #MOCK.sent > 0)

-- nav arrow ---------------------------------------------------------------
W:RegisterGuide{ id = "nav", title = "Nav test", levels = { 1, 60 }, steps = [[
goto 1423 50.0,10.0 |note North camp
goto 1424 50.0,50.0 |note East zone
fly 1424 50.0,50.0 |from 1423 52.0,52.0 |npc Eastwatch
note done
]] }
MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
MOCK.facing = 0
W.Guide:Activate("nav") settle()
local AF = W.Arrow.frame
check("arrow shows for a goto step", AF.shown and AF.scripts.OnUpdate ~= nil)
AF.scripts.OnUpdate(AF, 0.05)
check("arrow points straight ahead when facing the target", math.abs(W.Arrow.tex.rotation or 9) < 0.01, W.Arrow.tex.rotation)
check("facing target = green", W.Arrow.tex.color[2] > 0.8 and W.Arrow.tex.color[1] < 0.5)
check("distance text", W.Arrow.dist.text:find("400 yd", 1, true), W.Arrow.dist.text)
MOCK.facing = math.pi
AF.scripts.OnUpdate(AF, 0.05)
check("target behind = red, rotated half a turn", W.Arrow.tex.color[1] > 0.9 and W.Arrow.tex.color[2] < 0.5
    and math.abs(W.Arrow.tex.rotation - math.pi) < 0.01, W.Arrow.tex.rotation)
MOCK.facing = math.pi / 2   -- facing west; target north is to the right (clockwise = negative)
AF.scripts.OnUpdate(AF, 0.05)
check("target to the right rotates clockwise", math.abs(W.Arrow.tex.rotation - 3 * math.pi / 2) < 0.01, W.Arrow.tex.rotation)
W.db.arrow = false W.Arrow:Sync()
check("arrow can be turned off", not AF.shown)
W.db.arrow = true W.Arrow:Sync()

-- the way you came: the arrow leads back to a quest giver along your own trail
do
    local Tr, T = W.Trail, W.Travel
    local function walk(x1, y1, x2, y2)          -- map units on 1423 (1 unit = 10 yd), 5 yd per sample
        local n = math.max(1, math.floor(math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) * 2))
        for i = 0, n do Tr:Sample(T.World(1423, x1 + (x2 - x1) * i / n, y1 + (y2 - y1) * i / n)) end
        MOCK.pos = { map = 1423, x = x2 / 100, y = y2 / 100 }
    end
    W:RegisterGuide{ id = "trail", title = "Trail", faction = "", steps = [[
turnin 9960 |npc Giver |at 1423 40.0,50.0
note done
]] }
    MOCK.addQuest(9960, "Back to the giver") MOCK.finish(9960) MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("trail") settle()
    Tr:Clear()
    -- out: east 200 yd, then north 200 yd (straight back would be a 283 yd diagonal)
    walk(40, 50, 60, 50) walk(60, 50, 60, 30)
    check("trail records the walk every ~15 yd", Tr:Count() >= 25 and Tr:Count() <= 30, Tr:Count())
    local tgt = W.Waypoint:ArrowTarget()
    local _, bx, by = T.World(1423, 60, 33)
    check("turn-in: the arrow follows the way you came", tgt and tgt.trail and math.abs(tgt.wx - bx) < 16 and math.abs(tgt.wy - by) < 16,
          tgt and ("%s %.0f,%.0f want %.0f,%.0f"):format(tostring(tgt.trail), tgt.wx, tgt.wy, bx, by))
    check("distance shown is the whole way back", tgt and tgt.yards and tgt.yards > 380 and tgt.yards < 420, tgt and tgt.yards)
    check("pill says why", tgt and tgt.sub:find("the way you came", 1, true) and tgt.sub:find("Giver", 1, true), tgt and tgt.sub)
    AF.scripts.OnUpdate(AF, 0.05)
    check("arrow shows the trail distance", W.Arrow.dist.text:find("^%d+ yd") and tonumber(W.Arrow.dist.text:match("^(%d+)")) > 380, W.Arrow.dist.text)
    local route = W.Route and W.Route.Points and W.Route:Points()
    if route then check("map route follows the trail back", #route > 5, #route) end
    -- walking back along it shrinks the trail; round the corner the arrow points down the first leg
    walk(60, 30, 60, 50)
    tgt = W.Waypoint:ArrowTarget()
    _, bx, by = T.World(1423, 57, 50)
    check("walking back shrinks the trail", Tr:Count() <= 16, Tr:Count())
    check("after the corner it leads along the first leg", tgt and tgt.trail and math.abs(tgt.wx - bx) < 16 and math.abs(tgt.wy - by) < 16,
          tgt and ("%.0f,%.0f want %.0f,%.0f"):format(tgt.wx, tgt.wy, bx, by))
    walk(60, 50, 44, 50)
    tgt = W.Waypoint:ArrowTarget()
    check("close to the giver: straight at them", tgt and not tgt.trail and tgt.radius == 10)
    -- a loop around a camp leaves no loop behind
    Tr:Clear() walk(40, 50, 60, 50) local before = Tr:Count()
    walk(60, 50, 65, 45) walk(65, 45, 70, 50) walk(70, 50, 65, 55) walk(65, 55, 60, 50)
    check("closing a loop cuts it out", Tr:Count() <= before + 1, Tr:Count() .. " vs " .. before)
    -- a teleport starts over; no trail near the giver = straight line
    Tr:Sample(T.World(1423, 90, 90))
    check("a jump starts the trail over", Tr:Count() <= 1, Tr:Count())
    walk(90, 90, 90, 70)
    tgt = W.Waypoint:ArrowTarget()
    check("trail nowhere near the giver: straight line", tgt and not tgt.trail)
    -- option off
    Tr:Clear() walk(40, 50, 60, 50) walk(60, 50, 60, 30)
    W.db.trailBack = false
    check("path back can be turned off", not W.Waypoint:ArrowTarget().trail)
    W.db.trailBack = true
    MOCK.onTaxi = true MOCK.advance(1) MOCK.onTaxi = false
    check("a flight clears the trail", Tr:Count() == 0, Tr:Count())
    MOCK.turnIn(9960) MOCK.fire("QUEST_TURNED_IN", 9960) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    Tr:Clear()
    W.Guide:Activate("nav") settle()
end

-- a kill/loot step with no coordinates (its mobs over a zone border): the nearest Questie spot
do
    local QBr = W.QuestieBridge
    local saved = QBr.ObjectiveSpots
    QBr.ObjectiveSpots = function(_, q)
        if q == 9980 then return { { map = 1424, x = 80, y = 50, name = "Far Ogre" }, { map = 1423, x = 70, y = 50, name = "Near Ogre" } } end
    end
    W:RegisterGuide{ id = "nopin", title = "No pin", faction = "", steps = [[
complete 9980
note done
]] }
    MOCK.addQuest(9980, "Over the border") MOCK.fire("QUEST_LOG_UPDATE")
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W.Guide:Activate("nopin") settle()
    local c = W.Waypoint:Current()
    check("step without coordinates: points at the nearest Questie spot", c and c.map == 1423 and c.x == 70, c and (c.map .. " " .. c.x))
    check("...so the arrow shows", W.Arrow.frame.shown)
    QBr.ObjectiveSpots = saved
    MOCK.turnIn(9980) MOCK.fire("QUEST_TURNED_IN", 9980) MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("nav") settle()
end

-- our own looked-up spots (Guides/QuestSpots.lua) when Questie has none; a finished objective's
-- spots drop out
do
    W.QuestSpots[8970] = { { 1423, "Clam", "70,50 71,50" }, { 1423, "Reed", "52,50" } }
    W:RegisterGuide{ id = "ownspots", title = "Own spots", faction = "", steps = [[
complete 8970
note done
]] }
    MOCK.addQuest(8970, "Shore Things", {
        { text = "Clam: 0/2", finished = false, numFulfilled = 0, numRequired = 2 },
        { text = "Reed: 0/5", finished = false, numFulfilled = 0, numRequired = 5 },
    })
    MOCK.fire("QUEST_LOG_UPDATE")
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W.Guide:Activate("ownspots") settle()
    local c = W.Waypoint:Current()
    check("own spots: points at the nearest one", c and c.map == 1423 and c.x == 52, c and (c.map .. " " .. c.x))
    MOCK.log[8970].objectives[2].finished = true MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("own spots: a finished objective's spots drop out", #W.Waypoint.ObjectiveSpots(8970) == 2 and W.Waypoint.ObjectiveSpots(8970)[1].name == "Clam")
    MOCK.finish(8970) MOCK.turnIn(8970) MOCK.fire("QUEST_TURNED_IN", 8970) MOCK.fire("QUEST_LOG_UPDATE")
    W.QuestSpots[8970] = nil
    W.Guide:Activate("nav") settle()
end

-- quest hints: built-in notes on the card (per objective, gone once it's done), your own notes
do
    W:RegisterGuide{ id = "hints", title = "Hints", faction = "", steps = [[
complete 662
note done
]] }
    MOCK.addQuest(662, "Deep Sea Salvage", {
        { text = "Maiden's Folly Charts: 0/1", finished = false, numFulfilled = 0, numRequired = 1 },
        { text = "Maiden's Folly Log: 1/1", finished = true, numFulfilled = 1, numRequired = 1 },
    })
    MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("hints") settle()
    local function shown(s)
        for _, fsn in ipairs(MOCK.strings) do if fsn.shown and (fsn.text or ""):find(s, 1, true) then return true end end
    end
    W.UI:Render()
    check("quest hint on the card", shown("Naga in the lowest holds"))
    check("objective hint under its objective", shown("north side of the mast"))
    check("no hint for an objective already done", not shown("A book in a bucket"))
    check("hint source is known", (W.Guide:HintSource(662) or ""):find("Wowhead", 1, true))
    SlashCmdList.ONWARD("hint Swim in from the south side")
    W.UI:Render()
    check("/ow hint adds your own note", W.db.hints and W.db.hints[662] == "Swim in from the south side" and shown("Your note: Swim in"))
    local shownText
    local savedShow = W.UI.ShowText
    W.UI.ShowText = function(title, text) shownText = text end
    SlashCmdList.ONWARD("hints")
    W.UI.ShowText = savedShow
    check("/ow hints lists your notes to share", shownText and shownText:find("[662]", 1, true) and shownText:find("south side", 1, true), shownText)
    SlashCmdList.ONWARD("hint clear")
    check("/ow hint clear removes it", W.db.hints[662] == nil)
    MOCK.turnIn(662) MOCK.fire("QUEST_TURNED_IN", 662) MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("nav") settle()
end

-- hearthstone: Onward learns where you're bound, and says "hearth" when it clearly beats the trip
do
    local H = W.Hearth
    local bind, sub, cdStart, cdDur = "Test Town", "Test Town", 0, 0
    GetBindLocation = function() return bind end
    GetSubZoneText = function() return sub end
    local hadContainer = C_Container
    C_Container = C_Container or {}
    C_Container.GetItemCooldown = function() return cdStart, cdDur, 1 end
    W.cdb.home = nil
    -- standing in your bind town teaches Onward where it is
    MOCK.pos = { map = 1424, x = 0.5, y = 0.5 }
    MOCK.advance(6)
    check("hearth: learns the spot when you're in your bind town", H:Home() and H:Home().name == "Test Town")
    W:RegisterGuide{ id = "hearth", title = "Hearth", faction = "", steps = [[
home |npc Innkeeper Test |at 1424 50.0,50.0
goto 1424 52.0,50.0
note done
]] }
    W.Guide:Activate("hearth") settle()
    check("set-your-hearthstone step is done when you're bound there", W.Guide:IsComplete(W.Guide:Active().steps[1]))
    -- far away, stone in the bags and ready: hearth beats the 1400 yd trip
    sub = "Elsewhere"
    MOCK.pos = { map = 1423, x = 0.1, y = 0.5 }
    MOCK.bags[6948] = nil
    local tgt = W.Waypoint:ArrowTarget()
    check("no hearthstone in your bags: no advice", tgt and not tgt.hearth)
    MOCK.bags[6948] = 1
    tgt = W.Waypoint:ArrowTarget()
    check("hearth advice when it clearly beats the trip", tgt and tgt.hearth and tgt.label == "Hearth to Test Town", tgt and tgt.label)
    cdStart, cdDur = GetTime(), 3600
    check("never while it's on cooldown", not W.Waypoint:ArrowTarget().hearth)
    cdStart, cdDur = 0, 0
    MOCK.pos = { map = 1424, x = 0.4, y = 0.5 }
    check("close to the target already: no advice", not W.Waypoint:ArrowTarget().hearth)
    MOCK.pos = { map = 1423, x = 0.1, y = 0.5 }
    W.db.hearthAdvice = false
    check("advice can be turned off", not W.Waypoint:ArrowTarget().hearth)
    W.db.hearthAdvice = true
    -- bound somewhere new: the old spot no longer counts until Onward learns the new one
    bind = "Other Town"
    check("rebinding forgets the old spot", H:Home() == nil and not W.Waypoint:ArrowTarget().hearth)
    check("...and the set-hearthstone step is open again", not W.Guide:IsComplete(W.Guide:Active().steps[1]))
    -- setting it at an innkeeper records the spot straight away
    MOCK.pos = { map = 1424, x = 0.5, y = 0.5 }
    MOCK.fire("HEARTHSTONE_BOUND") MOCK.advance(1)
    check("binding at an inn records the spot", H:Home() and H:Home().name == "Other Town")
    MOCK.bags[6948] = nil
    GetBindLocation, GetSubZoneText = nil, nil
    C_Container = hadContainer
    W.cdb.home = nil
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W.Guide:Activate("nav") settle()
end

-- place names from the world map's named areas; a step for a quest you haven't picked up sends
-- you to its giver first
do
    local T = W.Travel
    check("place name: Riverglades 83,52 is Powderfuse Port", T.PlaceName(2548, 83, 52) == "Powderfuse Port", T.PlaceName(2548, 83, 52))
    check("place name: Tarren Mill", T.PlaceName(1424, 61.5, 20.9) == "Tarren Mill", T.PlaceName(1424, 61.5, 20.9))
    check("open country has no name", T.PlaceName(9999, 50, 50) == nil)
    W:RegisterGuide{ id = "pickup", title = "Pickup", faction = "", steps = [[
accept 9990 |npc Trap Hunter |at 1423 40.0,40.0
complete 9990 |at 1423 60.0,60.0
turnin 9990 |npc Trap Hunter |at 1423 40.0,40.0
]] }
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W.Guide:Activate("pickup") settle()
    W.Guide:Skip(1) settle()
    check("skipping the accept skips the quest: its objectives and turn-in go with it", W.Guide:Current() == nil, W.Guide:Current() and W.Guide:Current().verb)
    W.Guide:GoToStep(W.Guide:Active().steps[2]) settle()      -- stepping to its objectives on purpose
    local c = W.Waypoint:Current()
    check("not picked up: points at the quest giver", c and c.pickup and c.x == 40 and c.name == "Trap Hunter", c and (tostring(c.pickup) .. " " .. c.x))
    check("...and says so", c and c.title:find("^Pick up") and c.title:find("first", 1, true), c and c.title)
    MOCK.addQuest(9990, "WANTED: Trapclaw") MOCK.fire("QUEST_LOG_UPDATE") MOCK.fire("QUEST_ACCEPTED", 9990) MOCK.advance(1) settle()
    c = W.Waypoint:Current()
    check("picked up: back to the objective", c and not c.pickup and c.x == 60, c and c.x)
    MOCK.turnIn(9990) MOCK.fire("QUEST_TURNED_IN", 9990) MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("nav") settle()
end

-- come back later: a busy area offers it; set-aside quests are listed, offered when you're back
-- near them, and brought back at the end of the guide
do
    W:RegisterGuide{ id = "later", title = "Later", faction = "", steps = [[
accept 9970 |at 1423 50.0,50.0
complete 9970 |at 1423 60.0,50.0 |mobs Mire Hag
accept 9971 |at 1423 50.0,50.0
complete 9971 |at 1423 30.0,30.0 |mobs Bog Lurker
turnin 9971 |at 1423 50.0,50.0
turnin 9970 |at 1423 50.0,50.0
]] }
    MOCK.addQuest(9970, "Hag Hunt", { { text = "Mire Hag slain: 0/6", finished = false, numFulfilled = 0, numRequired = 6 } })
    MOCK.addQuest(9971, "Lurker Hunt") MOCK.fire("QUEST_LOG_UPDATE")
    MOCK.pos = { map = 1423, x = 0.6, y = 0.5 }
    W.Guide:Activate("later") settle()
    local cur = function() return W.Guide:Current() end
    check("later: starts on the hag step", cur() and cur().quest == 9970 and cur().verb == "complete", cur() and cur().quest)
    for i = 1, 4 do MOCK.units["nameplate" .. i] = { name = "Mire Hag", tapDenied = i <= 3 } end
    MOCK.units.nameplate5 = { name = "Mire Hag", dead = true, tapDenied = true }
    local busy, tagged, total = W.Target:Busy()
    check("busy: most living quest mobs in sight are tagged by others", busy and tagged == 3 and total == 4, tagged .. "/" .. total)
    W.UI:Render()
    check("busy prompt on the panel", W.UI.busyBtn:IsShown() and W.UI.busyBtn.text:GetText():find("3 of 4", 1, true), W.UI.busyBtn.text:GetText())
    W.UI.busyBtn:GetScript("OnClick")(W.UI.busyBtn)
    settle()
    check("come back later: the guide moves on", cur() and cur().quest == 9971, cur() and cur().quest)
    W.UI:Render()
    check("left-for-later line", W.UI.laterBtn:IsShown() and W.UI.laterBtn.text:GetText():find("Left for later", 1, true), W.UI.laterBtn.text:GetText())
    check("not offered right away while you're still there", W.Guide:LaterNearby() == nil)
    MOCK.advance(130)
    check("back near it later: offered", W.Guide:LaterNearby() == 9970)
    MOCK.pos = { map = 1423, x = 0.3, y = 0.3 }
    check("not offered from elsewhere", W.Guide:LaterNearby() == nil)
    W.UI.laterBtn.quest = 9970
    W.UI.laterBtn:GetScript("OnClick")(W.UI.laterBtn) settle()
    check("click: back to it now", cur() and cur().quest == 9970 and #W.Guide:LaterList() == 0, cur() and cur().quest)
    -- set aside again, finish the rest: the end of the guide brings it back
    MOCK.shift = true
    W.UI.card:GetScript("OnClick")(W.UI.card, "RightButton") settle()
    MOCK.shift = false
    check("shift-right-click sets the quest aside", cur() and cur().quest == 9971 and #W.Guide:LaterList() == 1)
    MOCK.finish(9971) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.turnIn(9971) MOCK.fire("QUEST_TURNED_IN", 9971) MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("end of the guide: back to the quests left for later", cur() and cur().quest == 9970 and cur().verb == "complete", cur() and (cur().verb .. " " .. tostring(cur().quest)))
    for i = 1, 5 do MOCK.units["nameplate" .. i] = nil end
    -- the target button on its own
    W.db.targetDetached = true W.Target:Sync()
    local tb = W.Target.button
    check("detached target button: action-button size", tb.shown and tb.w == 40, tb.w)
    tb.GetPoint = function() return "CENTER", UIParent, "CENTER", 120, -40 end
    tb:GetScript("OnDragStop")(tb)
    check("dragging it saves where it goes", W.db.targetPoint and W.db.targetPoint[3] == 120, W.db.targetPoint and W.db.targetPoint[3])
    W.db.targetDetached = false W.db.targetPoint = nil W.Target:Sync()
    tb.GetPoint = nil
    check("back on the step card", tb.w == 26, tb.w)
    MOCK.turnIn(9970) MOCK.fire("QUEST_TURNED_IN", 9970) MOCK.fire("QUEST_LOG_UPDATE")
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W.Guide:Activate("nav") settle()
end

-- flight advice: a known flight master next to the player and one at the far target
MOCK.taxi = {
    { name = "Here Town", nodeID = 1, slotIndex = 1, state = 0, position = { x = 0.52, y = 0.52 } },
    { name = "Eastwatch", nodeID = 2, slotIndex = 2, state = 1, position = { x = 1.5, y = 0.5 } },
    { name = "Unlearned", nodeID = 3, slotIndex = 3, state = 2, position = { x = 1.4, y = 0.5 } },
}
W.Travel:Refresh(true)
W.Guide:Skip(1) settle()   -- to "East zone" (1000 yd away)
local tgt = W.Waypoint:ArrowTarget()
check("far target: arrow suggests the flight", tgt and tgt.flight and tgt.label == "Fly: Here Town", tgt and tgt.label)
check("the travel plan says its first leg in words", tgt and tgt.route == "fly from Here Town to Eastwatch", tgt and tgt.route)
check("auto-taxi defaults off on a fresh install", W.db.autoTaxi == false)
W.db.autoTaxi = true
MOCK.calls = {}
MOCK.fire("TAXIMAP_OPENED") settle()
local took = called("TakeTaxiNode")
check("auto-taxi takes the learned flight near the target", took and took[2] == 2, took and took[2])
MOCK.calls = {} MOCK.shift = true MOCK.fire("TAXIMAP_OPENED") settle() MOCK.shift = false
check("shift at the flight master = choose yourself", not called("TakeTaxiNode"))
do  -- talking to the flight master refreshes the guide and clears the wanted flight just
    -- before the map opens: the flight is still found, marked and taken
    _G.TaxiButton2 = CreateFrame("Button", "TaxiButton2", UIParent) _G.TaxiButton2:Show()
    W.Travel:SetWantedDestination(nil)
    MOCK.calls = {} MOCK.fire("TAXIMAP_OPENED") settle()
    local t2 = called("TakeTaxiNode")
    check("wanted flight survives a refresh at the flight master", t2 and t2[2] == 2, t2 and t2[2])
    check("wanted flight is marked on the flight map", W.Travel.marked == 2, W.Travel.marked)
    W.db.autoTaxi = false MOCK.printed = {}
    MOCK.calls = {} MOCK.fire("TAXIMAP_OPENED") settle()
    local hinted = false
    for _, p in ipairs(MOCK.printed) do if p:find("Fly to Eastwatch") then hinted = true end end
    check("auto flight off: marked and named, not taken", hinted and W.Travel.marked == 2 and not called("TakeTaxiNode"))
    check("the marked flight point breathes while the map is open", W.Anim.Running("taxi"))
    W.db.autoTaxi = true
    MOCK.fire("TAXIMAP_CLOSED")
    check("closing the flight map stops it", not W.Anim.Running("taxi"))
    _G.TaxiButton2 = nil
end
-- fly steps are named by place (the flight point), with the flight master as the detail
do
    local s = { verb = "fly", at = { map = 1424, x = 50, y = 50 }, npc = "East Zone (Bob Gryphonhand)" }
    check("fly step reads as the place", W.UI.StepText(s) == "Fly to Eastwatch", W.UI.StepText(s))
    local far = { verb = "fly", at = { map = 1424, x = 5, y = 5 }, npc = "East Zone (Bob Gryphonhand)" }
    check("no flight point there: the zone", W.UI.StepText(far) == "Fly to East Zone", W.UI.StepText(far))
    local zone, who = W.Travel.SplitFlightNpc("East Zone (Bob Gryphonhand)")
    check("flight master name kept for the detail line", zone == "East Zone" and who == "Bob Gryphonhand")
end
-- advice is sticky: walking closer (now under the 900 yd a new suggestion needs) keeps the same
-- flight while it still saves 10%, instead of flipping the arrow back to the quest
MOCK.pos.x = 0.62 MOCK.advance(4)
tgt = W.Waypoint:ArrowTarget()
check("flight advice stays while it still pays", tgt and tgt.flight and tgt.label == "Fly: Here Town", tgt and tgt.label)
MOCK.pos.x = 0.5 MOCK.advance(4)
-- route on the world map: you -> flight master -> (flight) -> destination
WorldMapFrame:Show() MOCK.advance(1)
local RT = W.Route
local pts = RT:Points()
check("route goes via both flight masters", #pts >= 3 and pts[3].leg == "fly", #pts)
check("route dots drawn on the world map", RT.drawn and RT.drawn.dots > 10, RT.drawn and RT.drawn.dots)
MOCK.mapShown = 1424 RT:Draw()   -- the destination zone's map: its stop gets a number
check("route stops are numbered", RT.drawn.marks >= 1, RT.drawn.marks)
MOCK.mapShown = nil
W.db.routeMode = "off" W:Fire("WF_SETTINGS_CHANGED")
check("route can be turned off", #RT:Points() == 0 and RT.drawn.dots == 0)
do  -- Current while standing on the target: shows the step after it instead of nothing
    W.db.routeMode = "current"
    local realTarget = W.Waypoint.ArrowTarget
    local pc, px, py = W.Travel.PlayerWorld()
    W.Waypoint.ArrowTarget = function() return { cont = pc, wx = px, wy = py, label = "here" } end
    local here = RT:Points()
    check("current, arrived: the next stop is drawn", #here >= 2 and here[#here].stop == 2, #here)
    W.Waypoint.ArrowTarget = function() return { cont = pc, wx = px + 500, wy = py, label = "there" } end
    local there = RT:Points()
    check("current, on the way: only the line to the target", #there == 2 and there[2].label == "there", #there)
    W.Waypoint.ArrowTarget = realTarget
end
W.db.routeMode = "next"
WorldMapFrame:Hide()
W.db.travelAdvice = false
check("advice can be turned off", not (W.Waypoint:ArrowTarget() or {}).flight)
W.db.travelAdvice = true
-- inside a cave the best map can be a micro map with no world position: use its parent zone
MOCK.bestMap, MOCK.parents = 9999, { [9999] = 1423 }
check("player position falls back to the parent zone", W.Travel.PlayerWorld() ~= nil)
MOCK.bestMap, MOCK.parents = nil, nil
-- facing hidden by the game: keep the last direction (greyed), don't snap to straight ahead
AF.scripts.OnUpdate(AF, 0.05)
local lastRot = W.Arrow.tex.rotation
MOCK.facing = nil
AF.scripts.OnUpdate(AF, 0.05)
check("hidden facing keeps the last direction", W.Arrow.tex.rotation == lastRot and W.Arrow.tex.color[1] == 0.55, W.Arrow.tex.rotation)
MOCK.facing = 0

-- fly step: pin at departure, completes on landing near the destination
W.Guide:Skip(1) settle()
check("fly step current", cur().verb == "fly")
check("fly step pins the departure flight master first", MOCK.waypoint and math.abs(MOCK.waypoint.x - 0.52) < 1e-6, MOCK.waypoint and MOCK.waypoint.x)
MOCK.calls = {} MOCK.fire("TAXIMAP_OPENED") settle()
check("fly step auto-takes its flight", called("TakeTaxiNode"))
MOCK.onTaxi = true MOCK.advance(2)
check("still flying = not done", cur().verb == "fly")
MOCK.pos = { map = 1424, x = 0.5, y = 0.505 } MOCK.onTaxi = false
MOCK.fire("PLAYER_CONTROL_GAINED") MOCK.advance(1)
check("landing near the destination completes the fly step", cur().verb == "note", cur().verb)

-- options window
W:Fire("WF_SHOW_OPTIONS")
check("options window opens", _G.OnwardOptions.shown)
do  -- colour looks: each sets its own accent and glass, and the options still fit the window
    local S = W.Skin
    local seen = {}
    for _, look in ipairs({ "twilight", "alliance", "horde", "feywood", "neon" }) do
        W.db.theme = look S.Refresh()
        local p = S.PALETTES[look]
        check(look .. " look: its accent and glass", S.Theme() == look and S.ACCENT[1] == p.accent[1] and S.TINT[3] == p.tint[3])
        seen[("%.2f%.2f%.2f"):format(S.ACCENT[1], S.ACCENT[2], S.ACCENT[3])] = true
    end
    local n = 0 for _ in pairs(seen) do n = n + 1 end
    check("the new looks all differ", n == 5, n)
    W.db.theme = "onward" S.Refresh()
    check("back to Onward", S.ACCENT[1] == S.ONWARD.accent[1])
    check("options columns fit the 780px window", W.Options.cursor[1] > -770 and W.Options.cursor[2] > -770,
          W.Options.cursor[1] .. " / " .. W.Options.cursor[2])
end
W:Fire("WF_SHOW_OPTIONS")
check("options window toggles closed", not _G.OnwardOptions.shown)
MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }

-- resume ------------------------------------------------------------------
-- a character that did quests 701-703 and 705 without this guide (704 never taken)
W:RegisterGuide{ id = "resume", title = "Resume test", levels = { 1, 60 }, steps = [[
accept 701
goto 1423 90.0,90.0 |note Far camp
complete 701
turnin 701
fly 1424 50.0,50.0 |from 1423 52.0,52.0 |npc Eastwatch
accept 704
note Read the sign
accept 702
complete 704
turnin 702
turnin 704
accept 703
turnin 703
accept 705
turnin 705
accept 706
turnin 706
]] }
for _, q in ipairs({ 701, 702, 703, 705 }) do MOCK.done[q] = true end
MOCK.fire("QUEST_LOG_UPDATE")
W.Guide:Activate("resume") settle()
check("resume: starts at the first quest not yet done, past travel and notes", cur().verb == "accept" and cur().quest == 706, cur().verb .. " " .. tostring(cur().quest))
local missed = W.Guide:Missed()
check("resume: the one quest skipped past is listed as missed", #missed == 1 and missed[1] == 704, #missed)
local p = W.Guide:ProgressFor(W.Guide:Get("resume"))
check("guide list shows 4 of 6 turned in", p and math.abs(p - 4 / 6) < 1e-6, p)
W.Guide:GoBackToMissed()
check("go back jumps to the missed quest's accept", cur().verb == "accept" and cur().quest == 704, cur().verb .. " " .. tostring(cur().quest))
MOCK.addQuest(704, "Missed one") MOCK.fire("QUEST_ACCEPTED", 704) settle()
check("after accepting it, its objectives come next", cur().verb == "complete" and cur().quest == 704, cur().verb .. " " .. tostring(cur().quest))
MOCK.finish(704) MOCK.fire("QUEST_LOG_UPDATE") settle()
check("then its turn-in", cur().verb == "turnin" and cur().quest == 704, cur().verb .. " " .. tostring(cur().quest))
MOCK.turnIn(704) MOCK.fire("QUEST_TURNED_IN", 704) settle()
check("then back to where you were", cur().quest == 706, cur().verb .. " " .. tostring(cur().quest))
check("nothing missed any more", #W.Guide:Missed() == 0)
-- a quest still in your log behind the frontier stays open
MOCK.addQuest(800, "Old quest in log")
W:RegisterGuide{ id = "resume2", title = "Resume 2", levels = { 1, 60 }, steps = "accept 800\ncomplete 800\nturnin 800\naccept 801\nturnin 801\n" }
MOCK.done[801] = true MOCK.fire("QUEST_LOG_UPDATE")
W.Guide:Activate("resume2") settle()
check("quest still in your log behind the frontier stays open", cur().verb == "complete" and cur().quest == 800, cur().verb)

-- quest modes -----------------------------------------------------------------
W:RegisterGuide{ id = "modes", title = "Modes", levels = { 1, 60 }, steps = [[
accept 901
accept 902 |value mid
accept 903 |value low
fly 1424 50.0,50.0 |from 1423 52.0,52.0 |value low
turnin 903 |value low
turnin 902 |value mid
turnin 901
]] }
local function stepCount(mode)
    W.db.questMode = mode
    W.Guide:Reload()
    W.Guide:Activate("modes") settle()
    return #W.Guide:Active().steps
end
check("mode all keeps every step", stepCount("all") == 7)
check("mode efficient drops low-value quests and their flight", stepCount("efficient") == 4)
check("mode fastest also drops mid-value quests", stepCount("fastest") == 2)
MOCK.calls = {} MOCK.questId = 903 MOCK.fire("QUEST_DETAIL")
check("a dropped quest is not auto-accepted", not called("AcceptQuest"))
W.db.questMode = "efficient" W.Guide:Reload()

-- elite / dungeon quests: marked when shown, left out (with follow-ups) when hidden
W:RegisterGuide{ id = "groupq", title = "Group quests", levels = { 1, 60 }, steps = [[
accept 910
accept 911 |group elite
complete 911 |group elite
accept 912 |group chain
turnin 911 |group elite
turnin 910
]] }
W.db.groupQuests = "show" W.Guide:Reload() W.Guide:Activate("groupq") settle()
local gsteps = W.Guide:Active().steps
check("group quests shown by default", #gsteps == 6)
check("elite step is marked", gsteps[2].group == "elite" and gsteps[4].group == "chain")
check("elite note on the panel", W.UI.GroupText("elite"):find("Elite") and W.UI.GroupText("dungeon"):find("Dungeon"))
W.db.groupQuests = "hide" W.Guide:Reload() W.Guide:Activate("groupq") settle()
check("group quests hidden on request", #W.Guide:Active().steps == 2)
W.db.groupQuests = "show" W.Guide:Reload()

-- quest-mob target button: secure macro from the guide's mobs plus "slain" objectives
W:RegisterGuide{ id = "target", title = "Target", faction = "", steps = [[
accept 9950
complete 9950 |mobs Bog Lurker;Mire Hag
turnin 9950
]]}
MOCK.addQuest(9950, "Bog Work", {
    { text = "Bog Lurker slain: 0/5", finished = false, numFulfilled = 0, numRequired = 5 },
    { text = "Hag Charm: 0/3", finished = false, numFulfilled = 0, numRequired = 3 },
})
MOCK.fire("QUEST_ACCEPTED", 9950)
W.Guide:Activate("target") settle()
local TB = W.Target.button
local macro = TB:GetAttribute("macrotext") or ""
check("target button shows on a kill step", TB:IsShown() and cur().verb == "complete", cur().verb)
check("macro targets the guide's mobs", macro:find("/targetexact Bog Lurker", 1, true) and macro:find("/targetexact [noexists][dead] Mire Hag", 1, true), macro)
check("macro skips corpses", macro:find("/cleartarget [dead]", 1, true))
-- the refreshed card: verb label, action strip, dock
check("card labels a kill step KILL", W.UI.VerbLabel(cur()) == "KILL" and W.UI.verbText:GetText() == "KILL", W.UI.verbText:GetText())
check("kill step gets the action strip, Later on the card", W.UI.strip:IsShown() and W.UI.laterStripBtn:IsShown())
do
    local n, h, need = W.UI.SplitObjective({ text = "Makeshift Stickin' Spear: 3/20" })
    check("objective split into name and count", n == "Makeshift Stickin' Spear" and h == 3 and need == 20, n)
    local n2, h2, need2 = W.UI.SplitObjective({ text = "0/12 Saltwater Murloc Eye" })
    check("count-first objective split too", n2 == "Saltwater Murloc Eye" and h2 == 0 and need2 == 12, n2)
end
GetBindingKey = function(cmd) if cmd == "CLICK OnwardTargetButton:LeftButton" then return "SHIFT-T" end end
W.db.targetDetached = true W.UI:Render()
check("dock: no strip on the card", not W.UI.strip:IsShown())
check("dock shows behind the detached buttons; Later stays on the card", W.Item.dock:IsShown() and not W.Item.dockLater:IsShown() and W.UI.laterStripBtn:IsShown())
check("dock shows key bindings, shortened", W.Item.KeyLabel(TB) == "sT", W.Item.KeyLabel(TB))
W.db.targetDetached = false W.UI:Render()
check("back in the strip: dock hidden", W.UI.strip:IsShown() and not W.Item.dock:IsShown())
GetBindingKey = nil
check("macro marks with a skull via secure /tm", macro:find("/tm [exists,nodead] 8", 1, true))
check("macro runs no Lua (force-tainted on Forever)", not macro:find("/run", 1, true) and not macro:find("/script", 1, true))
check("macro fits Blizzard's 255 limit", #macro <= 255, #macro)
MOCK.log[9950].objectives[1].finished = true MOCK.log[9950].objectives[1].numFulfilled = 5
MOCK.fire("QUEST_LOG_UPDATE") settle()
check("finished kill objective drops out", not (TB:GetAttribute("macrotext") or ""):find("Bog Lurker", 1, true), TB:GetAttribute("macrotext"))
MOCK.combat = true
MOCK.log[9950].objectives[1].finished = false
MOCK.fire("QUEST_LOG_UPDATE") settle()
check("no macro change in combat", not (TB:GetAttribute("macrotext") or ""):find("Bog Lurker", 1, true))
MOCK.combat = false MOCK.fire("PLAYER_REGEN_ENABLED") settle()
check("macro catches up after combat", (TB:GetAttribute("macrotext") or ""):find("Bog Lurker", 1, true))
-- untagged first: out of combat the macro tries one untagged quest mob's nameplate, then the names
do
    MOCK.units.nameplate1 = { name = "Mire Hag", tapDenied = true }
    MOCK.units.nameplate2 = { name = "Mire Hag", dead = true }
    MOCK.units.nameplate3 = { name = "Swamp Rat" }
    MOCK.units.nameplate4 = { name = "Bog Lurker" }
    MOCK.fire("NAME_PLATE_UNIT_ADDED", "nameplate4") MOCK.advance(1) settle()
    local m = TB:GetAttribute("macrotext") or ""
    check("untagged quest mob on a nameplate is tried first", m:find("/cleartarget\n/target [@nameplate4,exists,nodead,harm] nameplate4\n", 1, true), m)
    check("...with the names still behind it", m:find("/targetexact [noexists][dead] Bog Lurker", 1, true) and m:find("/targetexact [noexists][dead] Mire Hag", 1, true))
    check("plate macro fits 255", #m <= 255, #m)
    MOCK.units.nameplate4.tapDenied = true
    MOCK.fire("UNIT_FLAGS", "nameplate4") MOCK.advance(1) settle()
    m = TB:GetAttribute("macrotext") or ""
    check("tagged by someone else: no plate line, names only", not m:find("nameplate", 1, true) and m:find("/targetexact Bog Lurker", 1, true), m)
    MOCK.units.nameplate4.tapDenied = false
    MOCK.fire("UNIT_FLAGS", "nameplate4") MOCK.advance(1) settle()
    MOCK.fire("PLAYER_REGEN_DISABLED") settle()
    m = TB:GetAttribute("macrotext") or ""
    check("entering combat drops the plate line", not m:find("nameplate", 1, true), m)
    MOCK.fire("PLAYER_REGEN_ENABLED") settle()
    check("after combat it's back", (TB:GetAttribute("macrotext") or ""):find("nameplate4", 1, true))
    for i = 1, 4 do MOCK.units["nameplate" .. i] = nil end
    MOCK.fire("NAME_PLATE_UNIT_REMOVED", "nameplate4") MOCK.advance(1) settle()
    check("no nameplates: names as before", not (TB:GetAttribute("macrotext") or ""):find("nameplate", 1, true))
end
-- droppers leave the button once their item is collected: tied by the guide ("Mob@Item"), or by
-- name when the guide doesn't say ("Sand Crawler" -> "Sand Crawler Meat")
do
    MOCK.addQuest(9955, "A Taste", {
        { text = "Saltwater Murloc Eye: 0/12", finished = false, numFulfilled = 0, numRequired = 12 },
        { text = "Sand Crawler Meat: 6/6", finished = true, numFulfilled = 6, numRequired = 6 },
        { text = "0/4 Crab Claw", finished = false, numFulfilled = 0, numRequired = 4 },
    })
    MOCK.fire("QUEST_ACCEPTED", 9955) MOCK.fire("QUEST_LOG_UPDATE") settle()
    local function names(mobs)
        local st = W.Guide.ParseStep and W.Guide.ParseStep("complete 9955 |mobs " .. mobs)
        return table.concat(W.Target.MobsFor(st), ",")
    end
    if W.Guide.ParseStep then
        check("dropper of a collected item drops out", names("Saltwater Oracle@Saltwater Murloc Eye;Shore Crawler@Sand Crawler Meat") == "Saltwater Oracle",
              names("Saltwater Oracle@Saltwater Murloc Eye;Shore Crawler@Sand Crawler Meat"))
        check("untied mob named like a finished item drops out", names("Sand Crawler;Saltwater Murloc") == "Saltwater Murloc", names("Sand Crawler;Saltwater Murloc"))
        check("untied mob stays while an open objective names it", names("Crab;Sand Crawler") == "Crab", names("Crab;Sand Crawler"))
    else
        check("Guide.ParseStep exists for the dropper tests", false)
    end
end
local long = {}
for i = 1, 12 do long[i] = "Very Long Named Quest Creature " .. i end
check("long mob lists are cut, not overflowed", #W.Target.BuildMacro(long, true) <= 255)
W.db.targetButton = false W:Fire("WF_SETTINGS_CHANGED")
check("target button can be turned off", not TB:IsShown())
W.db.targetButton = true
MOCK.finish(9950) MOCK.turnIn(9950) MOCK.fire("QUEST_TURNED_IN", 9950) MOCK.fire("QUEST_LOG_UPDATE") settle()
check("target button hides off kill steps", not TB:IsShown())

-- quests worked in the same area are grouped: one button targets all their mobs
W:RegisterGuide{ id = "group", title = "Group", faction = "", steps = [[
accept 960
accept 961
accept 962
complete 960 |at 1423 40.0,40.0 |mobs Fen Crawler;Fen Hulk
complete 961 |at 1423 42.0,41.0 |mobs Reed Stalker
complete 962 |at 1424 90.0,90.0 |mobs Far Beast
turnin 960
turnin 961
turnin 962
]]}
for _, q in ipairs({ 960, 961, 962 }) do MOCK.addQuest(q, "Q" .. q) MOCK.fire("QUEST_ACCEPTED", q) end
W.Guide:Activate("group") settle()
local grp = W.Guide:Group()
check("nearby kill quests are grouped", #grp == 2 and grp[1].quest == 960 and grp[2].quest == 961, #grp)
local gm = TB:GetAttribute("macrotext") or ""
check("each grouped quest gets its first mob before seconds", gm:find("Fen Crawler\n/targetexact [noexists][dead] Reed Stalker\n/targetexact [noexists][dead] Fen Hulk", 1, true), gm)
check("far quest stays out of the group", not gm:find("Far Beast", 1, true))
W.UI.panel:Show() W.UI:Render()
local alsoLabel, q961 = false, 0
for _, s in ipairs(MOCK.strings) do
    if s.shown and s.text:find("ALSO HERE", 1, true) then alsoLabel = true end
    if s.shown and s.text == "Q961" then q961 = q961 + 1 end
end
check("card lists the grouped quest as 'also here'", alsoLabel and q961 >= 1)
check("grouped quest is not repeated as an upcoming step", q961 == 1, q961)
MOCK.finish(960) MOCK.fire("QUEST_LOG_UPDATE") settle()
check("group moves on when the first quest is done", W.Guide:Group()[1].quest == 961)
-- a step without coordinates doesn't pull in a placed quest across the zone as "also here"
W:RegisterGuide{ id = "group2", title = "Group 2", faction = "", steps = [[
complete 963
complete 964 |at 1423 90.0,90.0 |mobs Far Beast
]]}
for _, q in ipairs({ 963, 964 }) do MOCK.addQuest(q, "Q" .. q) MOCK.fire("QUEST_ACCEPTED", q) end
W.Guide:Activate("group2") settle()
check("unplaced step doesn't group with a placed one", #W.Guide:Group() == 1, #W.Guide:Group())
for _, q in ipairs({ 963, 964 }) do MOCK.finish(q) MOCK.turnIn(q) MOCK.fire("QUEST_TURNED_IN", q) end
MOCK.fire("QUEST_LOG_UPDATE") settle()
W.Guide:Activate("group") settle()
for _, q in ipairs({ 960, 961, 962 }) do MOCK.finish(q) MOCK.turnIn(q) MOCK.fire("QUEST_TURNED_IN", q) end
MOCK.fire("QUEST_LOG_UPDATE") settle()
-- arrow readout: no box, a soft fade behind shadowed text, its own size setting
do
    check("arrow text sits on a soft fade, not a glass box", W.Arrow.fade and W.Arrow.fade.texture == "Interface\\AddOns\\Onward\\media\\text_fade")
    W.db.arrowTextScale = 1.5 W:Fire("WF_SETTINGS_CHANGED")
    check("arrow text size follows its setting", W.Arrow.dist.fontSize == 23 and W.Arrow.label.fontSize == 18, W.Arrow.dist.fontSize)
    W.db.arrowTextScale = 1 W:Fire("WF_SETTINGS_CHANGED")
    check("arrow text back to normal size", W.Arrow.dist.fontSize == 15, W.Arrow.dist.fontSize)
end

-- zone art: two tiles from the middle of the guide's map, faded behind the header
do
    local savedL, savedT = C_Map.GetMapArtLayers, C_Map.GetMapArtLayerTextures
    local savedShot = W.ZoneShots[1423]
    W.ZoneShots[1423] = nil   -- the shipped picture for this map would stand in for the map tiles
    C_Map.GetMapArtLayers = function(m) return { { layerWidth = 1002, layerHeight = 668, tileWidth = 256, tileHeight = 256 } } end
    C_Map.GetMapArtLayerTextures = function(m) local t = {} for i = 1, 12 do t[i] = m * 100 + i end return t end
    local tiles = W.UI.ZoneArt(1423)
    check("zone art picks the middle tiles of the map", tiles and tiles[1] == 142306 and tiles[2] == 142307, tiles and tiles[1])
    W:RegisterGuide{ id = "artq", title = "Art", faction = "", levels = { 1, 60 }, steps = [[
goto 1423 40.0,40.0 |note somewhere
goto 1423 50.0,50.0 |note elsewhere
]]}
    W.Guide:Activate("artq") settle()
    local art = W.UI.artTiles
    check("header art is off by default", not art[1]:IsShown() and not W.UI.shotTex:IsShown())
    W.UI.HEADER_ART = "shot" W.UI:Render()
    check("zone art shows behind the header", art[1]:IsShown() and art[1].texture == 142306 and art[2].texture == 142307, art[1].texture)
    W.UI.HEADER_ART = "map" W.UI:Render()
    check("header art 'map' shows the map tiles", art[1]:IsShown() and not W.UI.shotTex:IsShown())
    W.UI.HEADER_ART = "shot" W.UI:Render()
    check("no zone shot yet: the map stands in", art[1]:IsShown() and not W.UI.shotTex:IsShown())
    W.ZoneShots[1423] = true W.UI:Render()
    check("zone shot shows instead of the map", W.UI.shotTex:IsShown() and W.UI.shotTex.texture == "Interface\\AddOns\\Onward\\media\\zones\\1423" and not art[1]:IsShown(), W.UI.shotTex.texture)
    W.UI.HEADER_ART = "off" W.UI:Render()
    check("header art can be turned off", not art[1]:IsShown() and not W.UI.shotTex:IsShown())
    W.UI.HEADER_ART = "off" W.ZoneShots[1423] = savedShot
    C_Map.GetMapArtLayers, C_Map.GetMapArtLayerTextures = savedL, savedT
    W.Guide:Activate("group") settle()
end

-- quest item button: the guide's |item, or a usable quest item in your bags the quest text names
do
    local saved = { GetItemSpell = GetItemSpell, GetItemInfoInstant = GetItemInfoInstant, C_Container = C_Container, name = C_Item.GetItemNameByID }
    local NAMES = { [5001] = "Makeshift Spear", [5002] = "Wood Bundle", [5003] = "Shiny Pebble" }
    local bagSlots = { 5002, 5003 }
    GetItemSpell = function(id) return (id == 5001 or id == 5002 or id == 5003) and "Use" or nil end
    GetItemInfoInstant = function(id) return id, nil, nil, nil, nil, 12 end
    C_Item.GetItemNameByID = function(id) return NAMES[id] end
    C_Container = { GetContainerNumSlots = function(bag) return bag == 0 and #bagSlots or 0 end,
                    GetContainerItemID = function(bag, slot) return bag == 0 and bagSlots[slot] or nil end }
    W:RegisterGuide{ id = "itemq", title = "Item", faction = "", steps = [[
complete 8960 |item 5001
complete 8961
complete 8962
]]}
    MOCK.addQuest(8960, "Stick Them", { { text = "Crocolisk impaled: 0/5", finished = false, numFulfilled = 0, numRequired = 5 } })
    MOCK.addQuest(8961, "Fletching", { { text = "Collect Wood Bundles and fletch spears: 0/20", finished = false, numFulfilled = 0, numRequired = 20 } })
    MOCK.addQuest(8962, "Unrelated", { { text = "Wolf slain: 0/5", finished = false, numFulfilled = 0, numRequired = 5 } })
    for _, q in ipairs({ 8960, 8961, 8962 }) do MOCK.fire("QUEST_ACCEPTED", q) end
    W.Guide:Activate("itemq") settle()
    local IB = W.Item.button
    check("no item button while the guide's item isn't in your bags", W.Item.For(W.Guide:Current()) == nil)
    MOCK.bags[5001] = 1 W.Item:Sync()
    check("item button uses the guide's item", IB:IsShown() and IB:GetAttribute("item") == "item:5001", IB:GetAttribute("item"))
    local IB2 = W.Item.buttons[2]
    check("a grouped quest's item gets a second button", IB2:IsShown() and IB2:GetAttribute("item") == "item:5002", IB2:GetAttribute("item"))
    check("no third button without a third item", not W.Item.buttons[3]:IsShown())
    MOCK.finish(8960) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.bags[5002] = 3 W.Item:Sync()
    check("item button finds a bag quest item the quest names", IB:GetAttribute("item") == "item:5002", IB:GetAttribute("item"))
    check("plural in the text matches the item name", W.Item.Names("Collect Wood Bundles", "Wood Bundle") and not W.Item.Names("Woodbundles", "Wood Bundle"))
    MOCK.finish(8961) MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("no item for a quest whose text names none of your items", W.Item.For(W.Guide:Current()) == nil)
    W.db.itemButton = false W.Item:Sync()
    check("item button can be turned off", not IB:IsShown())
    W.db.itemButton = true
    MOCK.bags[5001], MOCK.bags[5002] = nil, nil
    for _, q in ipairs({ 8960, 8961, 8962 }) do MOCK.finish(q) MOCK.turnIn(q) MOCK.fire("QUEST_TURNED_IN", q) end
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    GetItemSpell, GetItemInfoInstant, C_Container, C_Item.GetItemNameByID = saved.GetItemSpell, saved.GetItemInfoInstant, saved.C_Container, saved.name
    W.Item:Sync()
end
-- a turn-in whose quest isn't finished waits instead of becoming the current step
-- (the Panther Mastery case: kill step skipped because the boss was too hard)
W:RegisterGuide{ id = "wait", title = "Wait", faction = "", steps = [[
complete 980
turnin 980
complete 981
turnin 981
]]}
MOCK.addQuest(980, "Panther Mastery", { { text = "Bhag'thera slain: 0/1", finished = false, numFulfilled = 0, numRequired = 1 } })
MOCK.addQuest(981, "Raptor Mastery")
MOCK.fire("QUEST_ACCEPTED", 980) MOCK.fire("QUEST_ACCEPTED", 981)
W.Guide:Activate("wait") settle()
local toasts = {}
local realToast = W.UI.Toast
W.UI.Toast = function(self, msg) table.insert(toasts, msg) end
W.Guide:Skip(1) settle()
check("skipping the kill step does not offer its turn-in", cur().verb == "complete" and cur().quest == 981, cur().verb .. " " .. cur().quest)
check("player is told the turn-in waits", toasts[1] and toasts[1]:find("Can't turn in", 1, true) and toasts[1]:find("Bhag'thera slain: 0/1", 1, true), toasts[1])
local wt = W.Guide:Waiting()
check("waiting list holds it", #wt.waiting == 1 and wt.waiting[1].quest == 980 and #wt.ready == 0)
W.UI.panel:Show() W.UI:Render()
local waitLine = false
for _, s in ipairs(MOCK.strings) do if s.shown and s.text:find("Turn-in waiting: Panther Mastery", 1, true) then waitLine = true end end
check("panel shows the waiting turn-in", waitLine)
MOCK.finish(980) MOCK.fire("QUEST_LOG_UPDATE") settle()
check("finishing it moves it to ready", #W.Guide:Waiting().ready == 1)
check("player is told it's ready", toasts[#toasts]:find("is finished", 1, true), toasts[#toasts])
check("the current step stays where it was", cur().quest == 981)
local n = #toasts
MOCK.fire("QUEST_LOG_UPDATE") settle()
check("ready notice is not repeated", #toasts == n)
W.Guide:GoToStep(W.Guide:Waiting().ready[1]) settle()
check("clicking ready jumps to the turn-in", cur().verb == "turnin" and cur().quest == 980)
MOCK.turnIn(980) MOCK.fire("QUEST_TURNED_IN", 980) MOCK.fire("QUEST_LOG_UPDATE") settle()
check("after handing in, back on the next open step", cur().verb == "complete" and cur().quest == 981, cur().verb .. " " .. cur().quest)
check("nothing waiting any more", #W.Guide:Waiting().ready == 0 and #W.Guide:Waiting().waiting == 0)
W.UI.Toast = realToast
MOCK.finish(981) MOCK.turnIn(981) MOCK.fire("QUEST_TURNED_IN", 981) MOCK.fire("QUEST_LOG_UPDATE") settle()

-- drop tracker: kills seen on nameplates / target vs quest items looted, against Questie's rate
local D, QB = W.Drops, W.QuestieBridge
check("item name from either objective format", D.ItemName("Hag Charm: 2/8") == "Hag Charm" and D.ItemName("2/8 Hag Charm") == "Hag Charm")
local realQB = { ItemObjectives = QB.ItemObjectives, ItemDropNpcs = QB.ItemDropNpcs, NpcName = QB.NpcName, DropRate = QB.DropRate }
QB.ItemObjectives = function(_, q) if q == 970 then return { { id = 5001, name = "Hag Charm" } } end end
QB.ItemDropNpcs = function(_, item) if item == 5001 then return { [3001] = true } end end
QB.NpcName = function(_, npc) return ({ [3001] = "Mire Hag", [3002] = "Gray Wolf" })[npc] end
QB.DropRate = function(_, item, npc) if item == 5001 and npc == 3001 then return 50, "wowhead" end end
MOCK.addQuest(970, "Charms", { { text = "Hag Charm: 0/8", type = "item", finished = false, numFulfilled = 0, numRequired = 8 } })
MOCK.fire("QUEST_ACCEPTED", 970) settle()
-- before any kill the line already shows, with Questie's rate and a kill estimate
local pre = D:Line({ text = "Hag Charm: 0/8", type = "item", finished = false, have = 0, need = 8 }, 970)
check("drop line shows before the first kill", pre and pre:find("50%% drop rate") and pre:find("~16 kills"), pre)
-- objective type missing on the client, but Questie knows it's an item
local untyped = D:Line({ text = "Hag Charm: 0/8", finished = false, have = 0, need = 8 }, 970)
check("drop line for an untyped item objective Questie knows", untyped ~= nil, untyped)
-- no Questie data: still says it's counting
local bare = D:Line({ text = "Odd Rock: 0/3", type = "item", finished = false, have = 0, need = 3 }, 999)
check("no drop line before any kill or expected rate", bare == nil, bare)
-- looted from an object (a chest on the sea floor), not a mob: no kill-based line at all
do
    local QBr = W.QuestieBridge
    local saved = QBr.ItemFromMobs
    QBr.ItemFromMobs = function() return false end
    check("no drop line for an item looted from objects", D:Line({ text = "Hag Charm: 0/8", type = "item", finished = false, have = 0, need = 8 }, 970) == nil)
    QBr.ItemFromMobs = saved
end
check("no drop line on a kill objective", D:Line({ text = "Mire Hag slain: 0/8", type = "monster", finished = false }, 970) == nil)

local plateN = 0
-- a mob on a nameplate (GUID hidden, as on Forever) that we fight and that dies
local function plateKill(name, opts)
    opts = opts or {}
    plateN = plateN + 1
    local tok = "nameplate" .. plateN
    local u = { name = name, threat = opts.fought ~= false and 1 or nil }
    MOCK.units[tok] = u
    MOCK.fire("NAME_PLATE_UNIT_ADDED", tok)
    MOCK.fire("UNIT_THREAT_LIST_UPDATE", tok)
    u.dead, u.tapDenied = true, opts.tapDenied
    MOCK.fire("NAME_PLATE_UNIT_REMOVED", tok)
    MOCK.units[tok] = nil
end
for _ = 1, 4 do plateKill("Mire Hag") end
plateKill("Mire Hag", { tapDenied = true })                     -- someone else's kill
plateKill("Mire Hag", { fought = false })                       -- died near you, never fought
plateKill("Bog Lurker")                                         -- doesn't drop the item
-- target only (nameplates off)
MOCK.units.target = { name = "Mire Hag", threat = 1 }
MOCK.fire("PLAYER_TARGET_CHANGED")
MOCK.units.target.dead = true MOCK.fire("UNIT_HEALTH", "target")
-- the same mob as target and nameplate: one kill
local both = { name = "Mire Hag", threat = 1 }
MOCK.units.target, MOCK.units.nameplate50 = both, both
MOCK.fire("PLAYER_TARGET_CHANGED") MOCK.fire("NAME_PLATE_UNIT_ADDED", "nameplate50")
both.dead = true
MOCK.fire("NAME_PLATE_UNIT_REMOVED", "nameplate50") MOCK.units.nameplate50 = nil
MOCK.fire("UNIT_HEALTH", "target")
MOCK.units.target = nil MOCK.fire("PLAYER_TARGET_CHANGED")
local e5001 = W.db.drops.items[5001]
local k = 0 for _, n in pairs(e5001.kills) do k = k + n end
check("kills counted from nameplates and target, once each", k == 6, k)

-- loot: two of those corpses gave a charm, one didn't, one was a wolf
local CHARM = "|cffffffff|Hitem:5001::::::::|h[Hag Charm]|h|r"
local corpseN = 0
local function loot(npc, drops)
    corpseN = corpseN + 1
    local g = MOCK.corpse(npc, corpseN)
    MOCK.loot = { { link = nil, sources = { g, 1 } } }            -- money slot
    if drops then table.insert(MOCK.loot, { link = CHARM, sources = { g, 1 } }) end
    MOCK.fire("LOOT_READY")
    return g
end
local g1 = loot(3001, true) loot(3001, true) loot(3001, false) loot(3002, false)
local s = D:Stats(5001)
check("per-kill basis when kills are seen", s.basis == "kill" and s.kills == 6 and s.drops == 2, s.basis .. " " .. s.kills .. "/" .. s.drops)
check("expected drops from the rate", math.abs(s.expected - 3) < 1e-9 and s.source == "wowhead", s.expected)
local lineText = D:Line(W.QuestState:Get(970).objectives[1]) or ""
check("card line: compact drop rate and expected avg on line 1", lineText:find("2/6 kills · 33% (avg 50%)", 1, true), lineText)
check("card line puts verdict and kills-left estimate on line 2", lineText:find("\nabout average · ~16 kills left", 1, true), lineText)
check("looted corpses kept as the fallback count", e5001.corpses == 3 and e5001.cgot == 2, e5001.corpses)
MOCK.loot = { { link = CHARM, sources = { g1, 1 } } } MOCK.fire("LOOT_READY")
check("re-opening a corpse is not a new drop", e5001.got == 2)
MOCK.targetGuid, MOCK.targetDead = MOCK.corpse(3001, 999), false
MOCK.loot = { { link = CHARM, sources = { MOCK.targetGuid, 1 } } } MOCK.fire("LOOT_READY")
MOCK.targetGuid = nil
check("pickpocketing a living mob is not a drop", e5001.got == 2)
for _ = 1, 4 do plateKill("Mire Hag") end                       -- 10 kills, 2 drops vs 5 expected
lineText = D:Line(W.QuestState:Get(970).objectives[1]) or ""
check("card line calls bad luck with unlucky icon and colored rate",
    lineText:find("unlucky (-30%)", 1, true) and lineText:find("media\\unlucky", 1, true) and lineText:find("|cffff9f4320%|r", 1, true), lineText)
-- Variance-scaled luck tiers: icons + escalating colors + delta vs expected average
do
    local h1, v1 = D.LuckInfo(1.4, 18)
    check("luck tier +1 sigma: soft green lucky + clover icon + delta",
        h1 == "66d973" and v1:find("media\\lucky", 1, true) and v1:find("lucky (+18%)", 1, true), v1)
    local h2, v2 = D.LuckInfo(2.5, 40)
    check("luck tier +2 sigma: bright emerald very lucky + clover icon",
        h2 == "38f288" and v2:find("media\\lucky", 1, true) and v2:find("very lucky (+40%)", 1, true), v2)
    local h0, v0 = D.LuckInfo(0.3, 2)
    check("luck tier average: neutral text with no icon", h0 == nil and v0 == "about average", v0)
    local hm1, vm1 = D.LuckInfo(-1.3, -15)
    check("luck tier -1 sigma: amber unlucky + rain icon + delta",
        hm1 == "ff9f43" and vm1:find("media\\unlucky", 1, true) and vm1:find("unlucky (-15%)", 1, true), vm1)
    local hm2, vm2 = D.LuckInfo(-2.4, -25)
    check("luck tier -2 sigma: vivid red very unlucky + rain icon",
        hm2 == "ff5252" and vm2:find("media\\unlucky", 1, true) and vm2:find("very unlucky (-25%)", 1, true), vm2)
    -- 1 in 3 kills on a 12% drop (z = +1.14): shows lucky clover immediately at 3 kills
    local savedStats = D.Stats
    local savedFromMobs = QB.ItemFromMobs
    local savedItemObj = D.ItemObjective
    D.ItemObjective = function() return "Crawler Leg", 99901 end
    QB.ItemFromMobs = function() return true end
    D.Stats = function()
        return { name = "Crawler Leg", kills = 3, drops = 1, basis = "kill",
                 expected = 0.36, var = 3 * 0.12 * 0.88, ratedKills = 3, source = "cmangos" }
    end
    local earlyLine = D:Line({ text = "Crawler Leg: 1/10", type = "item", have = 1, need = 10, finished = false }, 999) or ""
    check("luck verdict shows at 3 kills (1 in 3 vs 12% -> lucky +21% + clover)",
        earlyLine:find("media\\lucky", 1, true) and earlyLine:find("lucky (+21%)", 1, true) and earlyLine:find("|cff66d97333%|r", 1, true),
        earlyLine)
    D.Stats, QB.ItemFromMobs, D.ItemObjective = savedStats, savedFromMobs, savedItemObj
end
W:RegisterGuide{ id = "drops", title = "Drops", faction = "", steps = "complete 970\nturnin 970\n" }
W.Guide:Activate("drops") settle()
W.UI.panel:Show() W.UI:Render()
local shownDrop, shownVerdict = false, false
for _, fs in ipairs(MOCK.strings) do
    if fs.shown and fs.text:find("2/10 kills", 1, true) then shownDrop = true end
    if fs.shown and fs.text:find("unlucky (-30%)", 1, true) then shownVerdict = true end
end
check("drop rate and luck verdict appear as separate clean lines on the step card", shownDrop and shownVerdict)
-- missed kills (more drops than kills seen) fall back to looted corpses
for _ = 1, 9 do loot(3001, true) end
s = D:Stats(5001)
check("falls back to looted corpses when kills were missed", s.basis == "loot" and s.kills == 12 and s.drops == 11, s.basis .. " " .. s.kills)
check("fallback line says looted", (D:Line(W.QuestState:Get(970).objectives[1]) or ""):find("looted", 1, true))
MOCK.finish(970) MOCK.fire("QUEST_LOG_UPDATE") settle()
local before = e5001.kills["Mire Hag"]
plateKill("Mire Hag")
check("kills after the objective is done don't count", e5001.kills["Mire Hag"] == before)
W.db.dropStats = false
check("drop line can be turned off", D:Line({ type = "item", text = "Hag Charm: 1/8", have = 1, need = 8 }) == nil)
W.db.dropStats = true
MOCK.turnIn(970) MOCK.fire("QUEST_TURNED_IN", 970) MOCK.fire("QUEST_LOG_UPDATE") settle()
for k2, fn in pairs(realQB) do QB[k2] = fn end

-- without Questie: kills of a mob are held until its first drop shows it drops the item
MOCK.addQuest(971, "Fangs", { { text = "Wolf Fang: 0/5", type = "item", finished = false, numFulfilled = 0, numRequired = 5 } })
MOCK.fire("QUEST_ACCEPTED", 971) settle()
for _ = 1, 2 do
    MOCK.units.target = { name = "Gray Wolf", threat = 1 }
    MOCK.fire("PLAYER_TARGET_CHANGED")
    MOCK.units.target.dead = true MOCK.fire("UNIT_HEALTH", "target")
end
MOCK.loot = { { link = "|Hitem:5002|h[Wolf Fang]|h", sources = { MOCK.corpse(3002, 5000), 1 } } }
MOCK.fire("LOOT_READY")
MOCK.units.target = nil
s = D:Stats(5002)
check("held kills join once the mob is learned", s and s.basis == "kill" and s.kills == 2 and s.drops == 1, s and (s.basis .. " " .. s.kills .. "/" .. s.drops))
MOCK.finish(971) MOCK.turnIn(971) MOCK.fire("QUEST_TURNED_IN", 971) MOCK.fire("QUEST_LOG_UPDATE") settle()
-- kill steps point at the nearest objective spot, and only switch when another is clearly closer
local QB2 = W.QuestieBridge
local realSpots = QB2.ObjectiveSpots
QB2.ObjectiveSpots = function(_, q)
    if q == 990 then
        return { { map = 1423, x = 40, y = 50, name = "Camp West" }, { map = 1423, x = 70, y = 50, name = "Camp East" } }
    end
end
W:RegisterGuide{ id = "spots", title = "Spots", faction = "", steps = "complete 990 |at 1423 55.0,50.0\nturnin 990\n" }
MOCK.addQuest(990, "Two Camps") MOCK.fire("QUEST_ACCEPTED", 990)
MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
W.Guide:Activate("spots") settle()
local t1 = W.Waypoint:ArrowTarget()
check("kill step points at the nearest spawn spot", t1 and t1.spot and t1.sub == "nearest: Camp West", t1 and t1.sub)
MOCK.pos.x = 0.56 MOCK.advance(2)
check("a slightly closer spot doesn't flip the arrow", W.Waypoint:ArrowTarget().sub == "nearest: Camp West")
MOCK.pos.x = 0.62 MOCK.advance(2)
check("a clearly closer spot takes over", W.Waypoint:ArrowTarget().sub == "nearest: Camp East")
QB2.ObjectiveSpots = realSpots
MOCK.finish(990) MOCK.turnIn(990) MOCK.fire("QUEST_TURNED_IN", 990) MOCK.fire("QUEST_LOG_UPDATE") settle()

-- theme: every look is glass, in its own colours; onward by default, EllesmereUI's looks in "flat"
local SK = W.Skin
local pg = W.UI.panel.glass
check("onward theme by default, as glass (no dead flat textures)", SK.Theme() == "onward" and pg.grain.shown and pg.body.parts[1].shown and pg.body.flat == nil)
check("onward: gold accent, teal glass, gold rim", SK.AccentHex() == "ffe2c153" and SK.TINT[2] > 0.1 and SK.TINT[1] < 0.05
      and SK.RIM[1] > 0.8 and pg.rim.color[1] > 0.8, SK.AccentHex())
check("onward headlines in Friz Quadrata", SK.FontPath("head") == SK.FONT_HEAD and SK.FontPath("body") == SK.FONT_BODY)
W.db.theme = "glass" SK.Refresh()
check("glass: slate tint, white rim, green accent", math.abs(SK.TINT[3] - 0.092) < 0.01 and SK.RIM[1] == 1 and pg.grain.shown
      and math.abs(SK.ACCENT[2] - 0.824) < 0.01)
W.db.theme = "flat" SK.Refresh()
check("Ellesmere: glass too, neutral tint, plain font", pg.grain.shown and pg.body.parts[1].shown and math.abs(SK.TINT[1] - 0.067) < 0.01
      and SK.FontPath("head") == SK.FONT_BODY)
check("accent defaults to Ellesmere green", math.abs(SK.ACCENT[1] - 0.047) < 0.01 and math.abs(SK.ACCENT[2] - 0.824) < 0.01)
check("Onward registers with EllesmereUI's skinning API", MOCK.euiSkin and MOCK.euiSkin.name == "Onward")
local looksChanged
local fakeE = {
    IsEnabled = function() return true end,
    GetAccentColor = function() return 0.9, 0.2, 0.3 end,
    GetPanelColor = function() return 0.1, 0.1, 0.12, 0.9 end,
    GetFont = function() return "Fonts\\EUI.TTF", "" end,
    OnLooksChanged = function(fn) looksChanged = fn end,
}
MOCK.euiSkin.fn(fakeE)
check("EllesmereUI accent is used", SK.ACCENT[1] == 0.9 and SK.ACCENT[2] == 0.2, SK.ACCENT[1])
check("EllesmereUI panel colour tints the glass", SK.TINT[1] == 0.1 and SK.TINT[3] == 0.12)
local accentText, euiFont = false, false
for _, s in ipairs(MOCK.strings) do
    if s.textColor and s.textColor[1] == 0.9 and s.textColor[2] == 0.2 then accentText = true end
    if s.font == "Fonts\\EUI.TTF" then euiFont = true end
end
check("accent text recoloured live", accentText)
check("EllesmereUI font applied", euiFont)
fakeE.GetAccentColor = function() return 0.1, 0.5, 0.9 end
looksChanged()
check("EllesmereUI look changes repaint", SK.ACCENT[3] == 0.9)
fakeE.IsEnabled = function() return false end
SK.Refresh()
check("skinning turned off in EllesmereUI falls back to our own look", math.abs(SK.ACCENT[2] - 0.824) < 0.01)
fakeE.IsEnabled = function() return true end
W.db.theme = "onward" SK.Refresh()
check("EllesmereUI's colours stay out of the Onward look", SK.AccentHex() == "ffe2c153")
check("...but its font is used in every look", SK.FontPath("head"):find("EUI.TTF", 1, true) and SK.FontPath("body"):find("EUI.TTF", 1, true))
W.db.theme = "glass" SK.Refresh()
check("glass with EllesmereUI: its font, our own colours", SK.FontPath("body"):find("EUI.TTF", 1, true) and math.abs(SK.ACCENT[2] - 0.824) < 0.01)
W.db.theme = "onward"
fakeE.IsEnabled = function() return false end
SK.Refresh()

-- font picker: game fonts plus LibSharedMedia's, one file once; a pick applies to all text,
-- beats EllesmereUI's font, and a pick whose addon is gone falls back to automatic
do
    local lsmFonts = { ["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF", ["Expressway"] = "Interface\\AddOns\\SM\\Expressway.ttf",
                       ["Bazooka"] = "Interface\\AddOns\\SM\\Bazooka.ttf" }
    local lsm = {
        List = function() local t = {} for n in pairs(lsmFonts) do t[#t + 1] = n end table.sort(t) return t end,
        Fetch = function(_, _, n) return lsmFonts[n] end,
    }
    _G.LibStub = function(name) return name == "LibSharedMedia-3.0" and lsm or nil end
    local names = {}
    for _, f in ipairs(SK.FontChoices()) do names[#names + 1] = f.name end
    check("font list: game fonts first, then shared ones sorted, no duplicate files",
          table.concat(names, ",") == "Friz Quadrata,Arial Narrow,Skurri,Morpheus,Bazooka,Expressway", table.concat(names, ","))
    fakeE.IsEnabled = function() return true end
    SK.Refresh()
    check("automatic: EllesmereUI's font", SK.FontPath("body"):find("EUI.TTF", 1, true))
    local FL = W.Options.fontList
    FL.open()
    check("dropdown lists Automatic plus every font", #FL.entries() == 7 and FL.entries()[1].label == "Automatic")
    local pick
    for _, r in ipairs(FL.rows) do if type(r.e) == "table" and r.e.name == "Expressway" then pick = r end end
    pick:GetScript("OnClick")(pick)
    check("a picked font is used for headlines and body, over EllesmereUI's",
          SK.FontPath("head") == lsmFonts.Expressway and SK.FontPath("body") == lsmFonts.Expressway and W.db.font == "Expressway")
    local applied = false
    for _, s in ipairs(MOCK.strings) do if s.font == lsmFonts.Expressway then applied = true end end
    check("picked font repaints existing text", applied)
    check("the box names the pick in its own font", FL.value.text == "Expressway" and FL.value.font == lsmFonts.Expressway, tostring(FL.value.text))
    lsmFonts.Expressway = nil
    SK.Refresh()
    check("pick from a removed addon falls back to automatic", SK.FontPath("body"):find("EUI.TTF", 1, true))
    W.db.font = "auto"
    _G.LibStub = nil
    fakeE.IsEnabled = function() return false end
    SK.Refresh()
    check("automatic again: the look's fonts", SK.FontPath("head") == SK.FONT_HEAD)
end

-- login: the completed-quest records land a moment after login, with no quest log event. The
-- step picked at login must not stay on a quest you skipped earlier in the guide.
do
    local oldGuide = W.cdb.guide
    W:RegisterGuide{ id = "logintest", title = "Login test", faction = "", steps = [[
accept 9740
accept 9741
turnin 9741
accept 9742
turnin 9742
accept 9743
]]}
    W.cdb.guide = "logintest"
    MOCK.done[9741], MOCK.done[9742] = nil, nil
    MOCK.fire("PLAYER_LOGIN") settle()
    check("login before the records arrive: guide starts at the top", W.Guide:Current().quest == 9740, W.Guide:Current().quest)
    MOCK.done[9741], MOCK.done[9742] = true, true          -- records arrive, no event
    MOCK.advance(4) settle()
    check("login: rescanned once they arrive, past the skipped quest", W.Guide:Current().quest == 9743, W.Guide:Current().quest)
    MOCK.advance(20) settle()
    W.Guide:Activate(oldGuide)
end

check("options fit the tabbed window", W.Options.cursor[1] > -(W.Options.pageHeight or 432) and W.Options.cursor[2] > -(W.Options.pageHeight or 432), W.Options.cursor[1] .. " / " .. W.Options.cursor[2])

-- profession guides: steps complete on your skill, the card shows mats against your bags,
-- the trainer is found, and the game's own best recipe is offered when the route's isn't usable
do
    local P = W.Prof
    W:RegisterGuide{ id = "proftest", title = "First Aid test", kind = "profession", skill = 129, faction = "", steps = [[
train 129 75
craft 3275 51 |name Linen Bandage |n 64 |mats 2589:1 |from 1
train 129 150 |level 10
craft 3276 80 |name Heavy Linen Bandage |n 45 |mats 2589:2 |from 51
gather 182 50 |at 1423 50.0,50.0 |note Peacebloom
]] }
    W.ProfData.trainers[129] = W.ProfData.trainers[129] or {}
    table.insert(W.ProfData.trainers[129], 1, { 150, "AH", 1423, 52.0, 52.0, "Test Medic" })
    MOCK.profs = {}
    MOCK.fire("SKILL_LINES_CHANGED")
    W.Guide:Activate("proftest") settle()
    local cur = W.Guide:Current()
    check("profession not learned: first step is learning it", cur and cur.verb == "train" and cur.cap == 75)
    check("train step text", W.UI.StepText(cur) == "Learn First Aid", W.UI.StepText(cur))
    local map, x, y, name = W.Waypoint:Resolve(cur)
    check("train step points at a trainer", map and name, tostring(name))
    MOCK.profs = { { "First Aid", 20, 75, 129 } }
    MOCK.bags[2589] = 10
    MOCK.fire("SKILL_LINES_CHANGED") settle()
    cur = W.Guide:Current()
    check("learned at 20: on the bandage run", cur and cur.verb == "craft" and cur.spell == 3275)
    local left = P:CraftsLeft(cur)
    check("crafts left scale with skill", left == math.ceil(64 * 31 / 50), left)
    local lines = {}
    for _, l in ipairs(P:CardLines(cur)) do lines[#lines + 1] = l[1] end
    local txt = table.concat(lines, "\n")
    check("card shows skill and crafts left", txt:find("skill 20/75") and txt:find("crafts left"), txt)
    check("card shows mats against bags", txt:find("10/" .. left), txt)
    check("card asks to open the window when recipes are unknown", txt:find("open your First Aid window"), txt)
    -- profession window read: recipe known, orange; another recipe yellow
    MOCK.tradeLine = 129
    MOCK.recipes = { [3275] = { name = "Linen Bandage", learned = true, diff = 2, avail = 0 },
                     [3276] = { name = "Heavy Linen Bandage", learned = true, diff = 0, avail = 3 } }
    P:ReadWindow() settle()
    lines = {}
    for _, l in ipairs(P:CardLines(cur)) do lines[#lines + 1] = l[1] end
    txt = table.concat(lines, "\n")
    check("route recipe green: offers the best orange you can make", txt:find("instead now:.*Heavy Linen Bandage.*can make 3"), txt)
    check("craft text coloured by live difficulty", W.UI.StepText(cur):find("|cff40bf40", 1, true), W.UI.StepText(cur))
    -- cap reached, too low to train: train step stays current and says why
    MOCK.profs = { { "First Aid", 75, 75, 129 } }
    MOCK.level = 8
    MOCK.fire("SKILL_LINES_CHANGED") settle()
    cur = W.Guide:Current()
    check("at the cap the next step is Journeyman", cur and cur.verb == "train" and cur.cap == 150, cur and cur.verb)
    lines = {}
    for _, l in ipairs(P:CardLines(cur)) do lines[#lines + 1] = l[1] end
    check("train step says the level needed", table.concat(lines, "\n"):find("needs level 10"))
    MOCK.profs = { { "First Aid", 80, 150, 129 } }
    MOCK.fire("SKILL_LINES_CHANGED") settle()
    check("trained and past 80: on to the gather step", W.Guide:Current() and W.Guide:Current().verb == "gather")
    check("picker progress is rank / 300", select(2, P:Progress({ skill = 129 })) == 80)
    -- the guide list's tabs: clicking Professions lists profession guides, Leveling switches back
    local function listed()
        local prof, zone = 0, 0
        for _, def in ipairs(W.UI.pickerList or {}) do
            if def.kind == "profession" then prof = prof + 1 else zone = zone + 1 end
        end
        return prof, zone
    end
    W.UI:ShowPicker("zones")
    W.UI.pickerTabs.professions:GetScript("OnClick")(W.UI.pickerTabs.professions)
    local p1, z1 = listed()
    check("clicking the Professions tab lists profession guides only", p1 > 0 and z1 == 0, p1 .. "/" .. z1)
    W.UI.pickerTabs.zones:GetScript("OnClick")(W.UI.pickerTabs.zones)
    local p2, z2 = listed()
    check("clicking the Leveling tab switches back", p2 == 0 and z2 > 0, p2 .. "/" .. z2)
    W.UI:ShowPicker("professions")
    check("/ow prof opens on the Professions tab", (listed()) > 0)
    -- Lockpicking: a class skill, read from the skill list, and its guide is listed for rogues only
    local function hasLock()
        for _, def in ipairs(W.UI.pickerList or {}) do
            if def.id == "prof-lockpicking-A" or def.id == "prof-lockpicking-H" then return def end
        end
    end
    W.UI:ShowPicker("professions")
    check("a warrior isn't shown the Lockpicking guide", W.Guide:Get("prof-lockpicking-A") and not hasLock())
    local realClass = UnitClass
    UnitClass = function(u) if u == "player" then return "Rogue", "ROGUE" end return realClass(u) end
    W.UI:ShowPicker("professions")
    local lock = hasLock()
    check("a rogue is shown the Lockpicking guide for their faction", lock and lock.id == "prof-lockpicking-A", lock and lock.id)
    GetNumSkillLines = function() return 2 end
    GetSkillLineInfo = function(i) if i == 1 then return "Class Skills", true end return "Lockpicking", nil, nil, 105, 0, 0, 150 end
    MOCK.fire("SKILL_LINES_CHANGED")
    check("Lockpicking rank comes from the skill list", P:Rank(633) == 105, tostring(P:Rank(633)))
    W.Guide:Activate("prof-lockpicking-A") settle()
    cur = W.Guide:Current()
    check("at 105 the practice boxes are done: on to Zoram Strand footlockers", cur and cur.verb == "gather" and cur.untilSkill == 150 and cur.at and cur.at.map == 1440, cur and cur.untilSkill)
    check("lockpicking step text", W.UI.StepText(cur) == "Pick locks to 150", W.UI.StepText(cur))

    -- WoW Forever profession routes: check Forever-specific recipes, Horde vendors, and clean Blacksmithing 1-300
    local alch = W.Guide:Get("prof-alchemy-H")
    check("Forever Alchemy starts with Elixir of Minor Force (1245250)",
        alch and alch.steps:find("craft 1245250 10", 1, true) ~= nil)
    local ench = W.Guide:Get("prof-enchanting-H")
    check("Forever Enchanting uses Mote of Magic Bracer enchant (7418)",
        ench and ench.steps:find("craft 7418 20", 1, true) ~= nil)
    local tail = W.Guide:Get("prof-tailoring-H")
    check("Forever Tailoring includes Mount Hyjal Runecloth Cuffs (1257487)",
        tail and tail.steps:find("craft 1257487 280", 1, true) ~= nil)
    local bs = W.Guide:Get("prof-blacksmithing-H")
    check("Forever Blacksmithing uses Imperial Plate instead of Arcanite Skeleton Keys",
        bs and bs.steps:find("craft 16649 270", 1, true) ~= nil and not bs.steps:find("19669", 1, true))
    local widgetVendors = W.ProfData and W.ProfData.vendors and W.ProfData.vendors[16042] or {}
    local hasHordeWidget = false
    for _, v in ipairs(widgetVendors) do if v[1]:find("H", 1, true) then hasHordeWidget = true end end
    check("Forever Engineering has a Horde vendor (Sovik) for Schematic: Thorium Widget (16042)", hasHordeWidget)
    GetNumSkillLines, GetSkillLineInfo, UnitClass = nil, nil, realClass
    W.Guide:Activate("proftest") settle()
    W.UI:ShowPicker("zones")
    MOCK.level = 20
    MOCK.profs, MOCK.recipes, MOCK.tradeLine = {}, {}, nil
    W.cdb.recipes = nil
    MOCK.fire("SKILL_LINES_CHANGED")
end

-- shipped guides: every step line parses, every step is a known verb with a quest or coords
-- (mock player: Alliance Human Warrior; steps filtered to other classes/races are expected to drop)
MOCK.printed = {}
check("riverglades guides registered", W.Guide:Get("riverglades-a") and W.Guide:Get("riverglades-h"))
local nGuides, nSteps, mismatched, noQuest, ids = 0, 0, {}, 0, {}
for _, def in ipairs(W.Guide:All()) do
    if not ({ test = 1, riverglades = 1, nav = 1, resume = 1, resume2 = 1, modes = 1, target = 1, group = 1, group2 = 1, itemq = 1, artq = 1, groupq = 1, trail = 1, later = 1, nopin = 1, ownspots = 1, hints = 1, hearth = 1, pickup = 1, drops = 1, wait = 1, spots = 1 })[def.id] then
        check("unique guide id " .. def.id, not ids[def.id]) ids[def.id] = true
        if def.next then check(def.id .. " next exists", W.Guide:Get(def.next) ~= nil, def.next) end
        local expect = 0
        for l in def.steps:gmatch("[^\n]+") do
            if not l:find("^%s*%-%-") then
                local cls, race = l:match("|class ([%u,]+)"), l:match("|race ([%a,]+)")
                local lowValue = l:find("|value low", 1, true)   -- default mode is efficient
                if (not cls or cls:find("WARRIOR")) and (not race or race:find("Human")) and not lowValue then expect = expect + 1 end
            end
        end
        W.Guide:Activate(def.id) settle()
        local g = W.Guide:Active()
        if #g.steps ~= expect then mismatched[#mismatched + 1] = def.id .. " " .. #g.steps .. "/" .. expect end
        for _, s in ipairs(g.steps) do
            local ok = s.quest or (s.verb == "fly" and s.from) or (s.verb == "home" and s.at)
                or (s.verb == "goto" and s.at and s.note and s.note:find("^Take the"))   -- boat / zeppelin
            if def.kind == "profession" then ok = s.skill or s.spell end
            if not ok then noQuest = noQuest + 1 end
        end
        nGuides, nSteps = nGuides + 1, nSteps + #g.steps
    end
end
local warnings = #MOCK.printed
check("guides parse without warnings", warnings == 0, MOCK.printed[1])
check("every guide parses every line", #mismatched == 0, mismatched[1])
check("every step has a quest", noQuest == 0, noQuest)
W.Guide:Activate("elwynn-forest-a") settle()
local sawNote = false
for _, s in ipairs(W.Guide:Active().steps) do
    if s.note and s.note:find("%-%-") then sawNote = true end
end
W.Guide:Activate("westfall-a") settle()
local sawRace = false
for _, s in ipairs(W.Guide:Active().steps) do
    if s.quest == 6181 then sawRace = true end
end
check("race filter keeps Human-only quest for a Human", sawRace)
check("trailing comments never leak into notes", not sawNote)
-- Hidden elite quests (including object-loot / talk-to / summoned-boss elites in Hinterlands)
local prevFac, prevGrp = MOCK.faction, W.db.groupQuests
MOCK.faction = "Horde"
W.db.groupQuests = "hide"
W.Guide:Activate("the-hinterlands-h") settle()
local leakedElite = {}
local hiddenElites = { [7850] = true, [7849] = true, [7845] = true, [2937] = true }
for _, s in ipairs(W.Guide:Active().steps) do
    if hiddenElites[s.quest] then leakedElite[#leakedElite + 1] = s.quest end
end
check("groupQuests=hide removes Hinterlands object/talk/summon elites", #leakedElite == 0, table.concat(leakedElite, ","))
MOCK.faction, W.db.groupQuests = prevFac, prevGrp
print(("parsed %d guides, %d steps"):format(nGuides, nSteps))

-- class/race eligibility: Forever's Skyborne by race ID, chains inherit their prerequisite's limits
local function hasQuest(id, q)
    W.Guide:Activate(id) settle()
    for _, s in ipairs(W.Guide:Active().steps) do if s.quest == q then return true end end
    return false
end
local PM = W.Guide.PlayerMatches
check("human skips a Skyborne-only chain (Zephras: The Missing Scholar)", not hasQuest("zephras-isle-a", 92850))
check("human skips a night elf chain follow-up (Easing Suffering)", not hasQuest("teldrassil-a", 99073))
MOCK.race = { "High Order Skyborne", "HighOrderSkyborne", 95 }
check("Skyborne gets the Skyborne chain", hasQuest("zephras-isle-a", 92850))
check("Skyborne gets quests open to its faction's whole classic set", hasQuest("teldrassil-a", 99073))
check("Skyborne skips a human-only quest", not hasQuest("elwynn-forest-a", 5805))
MOCK.race = { "Undead", "Scourge", 5 }
check("Undead matches |race Scourge and |race Undead", PM({ race = "Scourge" }) and PM({ race = "Orc,Undead" }))
check("Undead fails |race Tauren", not PM({ race = "Tauren" }))
MOCK.race = nil
check("class filter is case-insensitive", PM({ class = "warrior,mage" }) and not PM({ class = "MAGE" }))
W.Guide:Activate("elwynn-forest-a") settle()

-- recommended guide: new characters start in their home zone, quests in the log win, and an
-- empty quest-log guide is swapped for the recommendation unless you chose it yourself
do
    local G = W.Guide
    local savedLog, savedOrder, savedLevel = MOCK.log, MOCK.logOrder, MOCK.level
    MOCK.log, MOCK.logOrder = {}, {}
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.level = 1
    local r, why = G:Recommend()
    check("level 1 human: Elwynn Forest, as the starting zone", r and r.id == "elwynn-forest-a" and why == "start", r and r.id, why)
    MOCK.race = { "Dwarf", "Dwarf", 3 }
    r = G:Recommend()
    check("level 1 dwarf: Dun Morogh", r and r.id == "dun-morogh-a-1", r and r.id)
    MOCK.race = { "High Order Skyborne", "HighOrderSkyborne", 95 }
    r = G:Recommend()
    check("level 1 Skyborne: Zephras Isle", r and r.id == "zephras-isle-a", r and r.id)
    MOCK.race = nil
    MOCK.level = 13
    MOCK.addQuest(2118, "Plagued Lands") MOCK.fire("QUEST_LOG_UPDATE") settle()
    r, why = G:Recommend()
    check("quests in your log pick their guide", r and r.id == "darkshore-a-1" and why == "log", r and r.id, why)
    -- at the end of a guide (turn-ins skipped, its quest still in the log) it isn't offered again;
    -- level 65 is past every real guide, so the test guide is the only one that could be
    MOCK.level = 65
    W:RegisterGuide{ id = "finq", title = "Finq Vale", faction = "", levels = { 64, 66 }, steps = [[
goto 1439 10.0,10.0 |note somewhere
goto 1439 90.0,90.0 |note elsewhere
]]}
    G:Activate("finq") settle()
    check("the guide you're on is recommended while it has steps left", G:Recommend() and G:Recommend().id == "finq", G:Recommend() and G:Recommend().id)
    for _ = 1, 5 do if G:Current() then G:Skip(1) end end settle()
    W.UI:Render()
    check("a finished guide isn't recommended again", G:Active().id == "finq" and G:Current() == nil and G:Recommend() == nil, G:Recommend() and G:Recommend().id)
    check("...nor offered on its own Guide complete card", W.UI.subText:GetText() == "Open the guide list to pick the next one.", W.UI.subText:GetText())
    G:Get("finq").faction = "Zz"   -- out of every later test's way
    MOCK.level = 13
    G:Activate("elwynn-forest-a") settle()
    MOCK.log, MOCK.logOrder = {}, {}
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.level = 1
    G:Activate("smart") settle()
    W.cdb.pickedSmart = true
    G:CheckEmptyStart() settle()
    check("a quest-log guide you picked yourself stays", G:Active().id == "smart")
    W.cdb.pickedSmart = nil
    G:CheckEmptyStart() settle()
    local first = G:Current()
    check("new character with an empty log starts the recommended guide", G:Active().id == "elwynn-forest-a", G:Active().id)
    check("...on its first quest to pick up", first and first.verb == "accept" and first.quest == 783 and first.npc ~= nil,
          first and (first.verb .. " " .. tostring(first.quest)))
    -- the panel suggests a better guide only when the one you're on stopped fitting
    MOCK.level = 1 G:Activate("elwynn-forest-a") G:ClearSuggestion() settle()
    check("no suggestion while the guide fits", G:Suggestion() == nil)
    MOCK.level = 14 MOCK.addQuest(2118, "Plagued Lands") MOCK.fire("QUEST_LOG_UPDATE") settle()
    G:Activate("elwynn-forest-a") settle() G:ClearSuggestion()
    local sug = G:Suggestion()
    check("out-levelled guide: a better one is suggested", sug and sug.id == "darkshore-a-1", sug and sug.id)
    W.UI:Render()
    check("suggestion line on the panel", W.UI.suggestBtn:IsShown() and W.UI.suggestBtn.text:GetText():find("Darkshore"),
          W.UI.suggestBtn.text:GetText())
    W.UI.suggestBtn:GetScript("OnClick")(W.UI.suggestBtn, "RightButton")
    G:ClearSuggestion()
    check("right-click hides that suggestion", G:Suggestion() == nil and not W.UI.suggestBtn:IsShown())
    W.cdb.hiddenSuggestion = nil
    MOCK.level = 70
    check("nothing to recommend above every guide's range", G:Recommend() == nil)
    MOCK.log, MOCK.logOrder, MOCK.level = savedLog, savedOrder, savedLevel
    MOCK.fire("QUEST_LOG_UPDATE") settle()
end

do  -- a fly step to a flight point you haven't discovered: fly to the learned one nearest it, walk on
    local TR = W.Travel
    local savedTaxi, savedPos = MOCK.taxi, MOCK.pos
    MOCK.taxi = {
        { name = "Here Town", nodeID = 1, slotIndex = 1, state = 0, position = { x = 0.52, y = 0.52 } },
        { name = "Eastwatch", nodeID = 2, slotIndex = 2, state = 1, position = { x = 1.5, y = 0.5 } },
        { name = "Far Post", nodeID = 4, slotIndex = 4, state = 2, position = { x = 2.0, y = 0.5 } },
        { name = "Near Post", nodeID = 5, slotIndex = 5, state = 2, position = { x = 0.9, y = 0.5 } },
    }
    TR:Refresh(true)
    local learned = TR:FlightPlan({ verb = "fly", at = { map = 1415, x = 150, y = 50 }, from = { map = 1415, x = 52, y = 52 } })
    check("learned destination: fly it as usual", learned == nil)
    local far = TR:FlightPlan({ verb = "fly", at = { map = 1415, x = 200, y = 50 }, from = { map = 1415, x = 52, y = 52 } })
    check("undiscovered: via the learned point nearest it", far and far.via and far.via.name == "Eastwatch", far and far.via and far.via.name)
    local near = TR:FlightPlan({ verb = "fly", at = { map = 1415, x = 90, y = 50 }, from = { map = 1415, x = 52, y = 52 } })
    check("undiscovered and no flight gets you closer: walk", near and near.walk)

    MOCK.pos = { map = 1423, x = 0.52, y = 0.52 }
    W:RegisterGuide{ id = "flyplan", title = "Fly Plan (35-36)", levels = { 35, 36 }, faction = "", steps = [[
fly 1415 200.0,50.0 |from 1415 52.0,52.0 |npc Far Zone (Bob Wings)
note After
]]}
    W.Guide:Activate("flyplan") settle()
    check("undiscovered fly step: first to the departure flight master", W.Waypoint:Current() and W.Waypoint:Current().leg == "depart")
    local tgt = W.Waypoint:ArrowTarget()
    check("arrow says where it really flies", tgt and tgt.sub and tgt.sub:find("fly to Eastwatch", 1, true), tgt and tgt.sub)
    MOCK.calls = {} MOCK.fire("TAXIMAP_OPENED") settle()
    local took = called("TakeTaxiNode")
    check("flight master: takes the flight to the nearest learned point", took and took[2] == 2, took and took[2])
    MOCK.onTaxi = true MOCK.fire("PLAYER_CONTROL_LOST") MOCK.advance(2)
    MOCK.pos = { map = 1423, x = 1.5, y = 0.5 } MOCK.onTaxi = false
    MOCK.fire("PLAYER_CONTROL_GAINED") MOCK.advance(1)
    check("landed short of it: still the fly step", cur() and cur().verb == "fly", cur() and cur().verb)
    check("...now on foot to the destination's flight master", W.Waypoint:Current() and W.Waypoint:Current().leg == "walk")
    tgt = W.Waypoint:ArrowTarget()
    check("arrow: find the flight master", tgt and tgt.label and tgt.label:find("Find the flight master", 1, true), tgt and tgt.label)
    MOCK.pos = { map = 1423, x = 1.85, y = 0.5 } MOCK.advance(1)
    check("150 yd short isn't there yet (the path is learned at the flight master)", cur() and cur().verb == "fly")
    MOCK.pos = { map = 1423, x = 2.0, y = 0.5 } MOCK.advance(1)
    check("at the flight master: step done", cur() and cur().verb == "note", cur() and cur().verb)
    MOCK.taxi, MOCK.pos = savedTaxi, savedPos
    TR:Refresh(true)
end

do  -- a fly step to the other continent: first the boat, then fly from the near side
    local savedPos = MOCK.pos
    MOCK.mapOffset[1434], MOCK.mapOffset[1413], MOCK.mapOffset[1444], MOCK.mapOffset[1414] = 0, 0, 3000, 0
    MOCK.mapCont = { [1434] = 0 }                       -- Stranglethorn on the other continent
    W.Travel:Refresh(true)
    MOCK.pos = { map = 1434, x = 0.27, y = 0.77 }        -- in Booty Bay
    W:RegisterGuide{ id = "cross", title = "Cross (35-36)", levels = { 35, 36 }, faction = "", steps = [[
fly 1444 75.5,44.4 |from 1434 26.9,77.1 |npc Feralas (Shyn)
note After
]]}
    W.Guide:Activate("cross") settle()
    local c = W.Waypoint:Current()
    check("other continent: first to the boat", c and c.leg == "cross" and c.cross.to.name == "Ratchet", c and c.leg)
    local tgt = W.Waypoint:ArrowTarget()
    check("arrow: take the boat to Ratchet", tgt and tgt.label == "Take the boat to Ratchet", tgt and tgt.label)
    MOCK.calls = {} MOCK.fire("TAXIMAP_OPENED") settle()
    check("no flight taken toward the other continent", not called("TakeTaxiNode"))
    -- off the boat in Ratchet: fly from the nearest flight point on this side
    MOCK.pos = { map = 1413, x = 0.637, y = 0.386 }
    MOCK.fire("PLAYER_ENTERING_WORLD") MOCK.advance(3)
    c = W.Waypoint:Current()
    check("across: on to a flight master on this side", c and c.leg == "depart" and not c.cross, c and (tostring(c.leg) .. " " .. tostring(c.map) .. " " .. tostring(c.x)) or "no current")
    tgt = W.Waypoint:ArrowTarget()
    check("arrow no longer says boat", tgt and not tgt.label:find("boat", 1, true), tgt and tgt.label)
    -- far from the dock on this side: fly to the flight point nearest it, marked on the flight map
    local savedTaxi = MOCK.taxi
    MOCK.taxi = {
        { name = "Far Camp", nodeID = 11, slotIndex = 1, state = 0, position = { x = 2.6, y = 0.4 } },
        { name = "Dock Town", nodeID = 12, slotIndex = 2, state = 1, position = { x = 0.64, y = 0.39 } },
    }
    MOCK.pos = { map = 1415, x = 2.6, y = 0.4 }
    W.Travel:Refresh(true)
    W:RegisterGuide{ id = "cross2", title = "Cross back (35-36)", levels = { 35, 36 }, faction = "", steps = [[
goto 1434 30.0,70.0 |note Over there
note After
]]}
    W.Guide:Activate("cross2") settle()
    tgt = W.Waypoint:ArrowTarget()
    check("far from the dock: fly toward it first", tgt and tgt.label == "Fly: Far Camp" and tgt.sub:find("take the boat to Booty Bay", 1, true),
          tgt and (tgt.label .. " / " .. tostring(tgt.sub)))
    MOCK.calls = {} MOCK.fire("TAXIMAP_OPENED") settle()
    check("...and the flight to the dock's flight point is taken", called("TakeTaxiNode", 2))
    MOCK.taxi = savedTaxi
    MOCK.mapCont, MOCK.pos = nil, savedPos
    MOCK.mapOffset[1434], MOCK.mapOffset[1413], MOCK.mapOffset[1444], MOCK.mapOffset[1414] = nil, nil, nil, nil
    W.Travel:Refresh(true)
end

do  -- flight advice by travel time: a flight that saves ~100 s on foot, but under 30 s mounted
    local TR = W.Travel
    local savedTaxi, savedPos = MOCK.taxi, MOCK.pos
    MOCK.taxi = {
        { name = "Gate Camp", nodeID = 21, slotIndex = 1, state = 0, position = { x = 0.5, y = 0.5 } },
        { name = "Far Harbor", nodeID = 22, slotIndex = 2, state = 1, position = { x = 2.5, y = 0.5 } },
    }
    MOCK.pos = { map = 1415, x = 0.5, y = 0.5 }
    TR:Refresh(true)
    MOCK.mounted, MOCK.speed = true, 11.2
    check("travel speed: your mount's, once you've ridden", math.abs(TR.Speed() - 11.2) < 0.01, TR.Speed())
    MOCK.mounted, MOCK.speed = false, 7
    check("...and still on foot, since you'd ride to the flight master", math.abs(TR.Speed() - 11.2) < 0.01, TR.Speed())
    local adv = TR:Advice(1415, 240, 110)
    check("mounted: a flight that saves under 30 s isn't suggested", adv == nil, adv and adv.to.name)
    W.cdb.mountSpeed = nil MOCK.advance(4)
    adv = TR:Advice(1415, 240, 110)
    check("on foot: the same flight is suggested", adv and adv.to.name == "Far Harbor", adv and adv.to.name)
    check("travel speed on foot without a mount: 7", TR.Speed() == 7, TR.Speed())
    MOCK.taxi, MOCK.pos, MOCK.speed = savedTaxi, savedPos, nil
    TR:Refresh(true)
end

do  -- a flight point on a network of its own (Riverglades): the flight master's list is the truth
    local TR = W.Travel
    local savedTaxi, savedPos = MOCK.taxi, MOCK.pos
    W.cdb.mountSpeed, W.cdb.taxiNet = nil, nil
    MOCK.taxi = {
        { name = "Bay Post", nodeID = 31, slotIndex = 1, state = 0, position = { x = 0.5, y = 0.5 } },
        { name = "Hill Post", nodeID = 32, slotIndex = 2, state = 1, position = { x = 1.5, y = 0.5 } },
        { name = "Glade Keep", nodeID = 33, slotIndex = 3, state = 1, position = { x = 2.5, y = 0.5 } },
    }
    -- every list calls all three reachable; only the flight map's own type says the keep is
    -- DISTANT (discovered, no route from here)
    local TYPES = { "CURRENT", "REACHABLE", "DISTANT" }
    TaxiNodeGetType = function(i) return TYPES[i] end
    MOCK.pos = { map = 1415, x = 0.5, y = 0.5 }
    TR:Refresh(true)
    W:RegisterGuide{ id = "glade", title = "Glade (38-46)", levels = { 38, 46 }, faction = "", steps = [[
goto 1415 240.0,55.0 |note In the glades
note After
]]}
    W.Guide:Activate("glade") settle() MOCK.advance(4)
    local tgt = W.Waypoint:ArrowTarget()
    check("before the flight master: the far keep looks flyable", tgt and tgt.flight and tgt.sub:find("Glade Keep", 1, true), tgt and tgt.sub)
    MOCK.calls = {} MOCK.printed = {} MOCK.fire("TAXIMAP_OPENED") settle()
    local took = called("TakeTaxiNode")
    check("at the flight master: flies to the nearest point it reaches instead", took and took[2] == 2, took and took[2])
    check("...and remembers the keep is on another network", W.cdb.taxiNet["Glade Keep"] == "~Bay Post" and W.cdb.taxiNet["Hill Post"] == "Bay Post",
          tostring(W.cdb.taxiNet["Glade Keep"]))
    local said = 0
    for _, line in ipairs(MOCK.printed) do if line:find("Glade Keep is on your flight map, but no flight path links it", 1, true) then said = said + 1 end end
    check("...and says a connecting flight point is missing", said == 1, said)
    tgt = W.Waypoint:ArrowTarget()
    check("the arrow no longer offers the keep", tgt and not (tgt.sub or ""):find("Glade Keep", 1, true), tgt and tgt.sub)
    TaxiNodeGetType = nil
    MOCK.taxi, MOCK.pos, W.cdb.taxiNet = savedTaxi, savedPos, nil
    TR:Refresh(true)
end

do  -- dead and released: the arrow leads to your body, then back to the guide once you're alive
    local savedPos = MOCK.pos
    W:RegisterGuide{ id = "ghost", title = "Ghost (35-36)", levels = { 35, 36 }, faction = "", steps = [[
goto 1423 90.0,90.0 |note Far corner
note After
]]}
    W.Guide:Activate("ghost") settle() MOCK.advance(3)
    local before = W.Waypoint:ArrowTarget()
    check("ghost test starts on a step with an arrow", before ~= nil)
    MOCK.pos = { map = 1424, x = 0.5, y = 0.5 }              -- the graveyard, in the next zone
    MOCK.parents = { [1424] = 1423 }
    MOCK.corpse = { map = 1423, x = 0.2, y = 0.3 }
    MOCK.ghost = true MOCK.fire("PLAYER_ALIVE") settle()
    local tgt = W.Waypoint:ArrowTarget()
    local cc, cx, cy = W.Travel.World(1423, 20, 30)
    check("ghost: the arrow points at your body", tgt and tgt.corpse and tgt.label == "Back to your body" and math.abs(tgt.wx - cx) < 1 and math.abs(tgt.wy - cy) < 1,
          tgt and tgt.label)
    check("...and says what comes after", tgt and tgt.sub and tgt.sub:find("^then "), tgt and tgt.sub)
    check("...with the arrow shown", W.Arrow.frame == nil or W.Arrow.frame:IsShown())
    MOCK.ghost = false MOCK.corpse = nil MOCK.fire("PLAYER_UNGHOST") settle()
    tgt = W.Waypoint:ArrowTarget()
    check("alive again: back to the guide", tgt and not tgt.corpse and tgt.label == before.label, tgt and tgt.label)
    MOCK.pos, MOCK.parents = savedPos, nil
end

do  -- animations: each plays on its own change, never in combat, and the option turns them off
    local AN = W.Anim
    local played = {}
    local realPlay = AN.Play
    AN.Play = function(key, ...) played[key] = true return realPlay(key, ...) end
    local savedPos = MOCK.pos
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W.db.collapsed = false
    MOCK.addQuest(9601, "Shiny Things", {
        { text = "Shard: 0/2", finished = false, numFulfilled = 0, numRequired = 2 },
        { text = "Gem: 0/1", finished = false, numFulfilled = 0, numRequired = 1 },
    })
    W:RegisterGuide{ id = "anim", title = "Anim (35-36)", levels = { 35, 36 }, faction = "", steps = [[
complete 9601 |at 1423 50.0,50.0
turnin 9601 |npc Vell |at 1423 50.0,50.0
note After
]]}
    MOCK.fire("QUEST_LOG_UPDATE") W.Guide:Activate("anim") settle() W.UI:Render()
    played = {}
    local gem = MOCK.log[9601].objectives[2]
    gem.finished, gem.numFulfilled, gem.text = true, 1, "Gem: 1/1"
    MOCK.fire("QUEST_LOG_UPDATE") settle() W.UI:Render()
    check("an objective done ticks off", played.obj2, next(played))
    check("nothing else moves for it", not played.ready and not played.turn)
    played = {}
    MOCK.finish(9601) MOCK.fire("QUEST_LOG_UPDATE") settle() W.UI:Render()
    check("quest ready to turn in: the sheen", played.ready)
    check("on to the turn-in: the card turns", played.turn and cur() and cur().verb == "turnin")
    MOCK.advance(3)
    check("all settled afterwards", not AN.Running("ready") and not AN.Running("turn") and not W.UI.sweep.shown)
    -- arrival: walk up to the turn-in
    local AFr = W.Arrow.frame
    played = {}
    MOCK.pos = { map = 1423, x = 0.45, y = 0.45 } AFr.scripts.OnUpdate(AFr, 0.05)
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 } AFr.scripts.OnUpdate(AFr, 0.05)
    check("arriving pulses once", played.arrive)
    played = {}
    AFr.scripts.OnUpdate(AFr, 0.05)
    check("standing there: no second pulse", not played.arrive)
    -- the end of the guide
    played = {}
    MOCK.turnIn(9601) MOCK.fire("QUEST_TURNED_IN", 9601) MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("progress: the bar slides", played.bar)
    played = {}
    W.UI.card:GetScript("OnClick")(W.UI.card, "LeftButton") settle() W.UI:Render()
    check("guide finished: the header glows", played.finished, cur() and cur().verb)
    -- combat settles everything at once; nothing starts in combat
    W.UI.PlayReady()
    MOCK.fire("PLAYER_REGEN_DISABLED")
    check("combat finishes a running animation", not AN.Running("ready") and not W.UI.sweep.shown)
    MOCK.combat = true
    check("nothing starts in combat", W.UI.PlayReady() == false)
    MOCK.combat = false
    W.db.animations = false
    check("option off: nothing animates", W.UI.PlayReady() == false and not W.UI.sweep.shown)
    W.db.animations = true
    AN.Play = realPlay
    MOCK.pos = savedPos
end

-- quest and step logic (0.6.22) ---------------------------------------------------
-- A quest picked up early, skips that stay on their step, skipping a whole quest, and accepts
-- held until the game offers them.
do
    local G = W.Guide
    local oldGuide, oldMode, oldLevel = W.cdb.guide, W.db.questMode, MOCK.level
    local function at() local s = cur() return s and (s.verb .. " " .. tostring(s.quest or s.text)) or "end" end

    -- one quest picked up early doesn't move the guide on
    local lines = {}
    for q = 9001, 9009 do
        lines[#lines + 1] = "accept " .. q
        lines[#lines + 1] = "complete " .. q
        lines[#lines + 1] = "turnin " .. q
    end
    W:RegisterGuide{ id = "early", title = "Early", faction = "", steps = table.concat(lines, "\n") }
    G:Activate("early") settle()
    MOCK.addQuest(9001, "First") MOCK.fire("QUEST_ACCEPTED", 9001)
    MOCK.addQuest(9009, "Offered by the same NPC, taken last by the guide") MOCK.fire("QUEST_ACCEPTED", 9009) settle()
    check("early pickup: still on the first quest", at() == "complete 9001", at())
    MOCK.finish(9001) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.turnIn(9001) MOCK.fire("QUEST_TURNED_IN", 9001) settle()
    check("early pickup: the next quest in the guide comes next", at() == "accept 9002", at())
    check("early pickup: nothing counts as missed", #G:Missed() == 0, #G:Missed())
    -- ...and a quest finished out of order far ahead doesn't either
    MOCK.finish(9009) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.turnIn(9009) MOCK.fire("QUEST_TURNED_IN", 9009) settle()
    check("a quest handed in far ahead: still on the next quest", at() == "accept 9002", at())
    G:Resume() settle()
    check("/ow resume with one quest done ahead: stays put", at() == "accept 9002" and #G:Missed() == 0, at())
    MOCK.done[9001], MOCK.done[9009] = nil, nil

    -- the resume point is worked out once and kept
    W:RegisterGuide{ id = "keep", title = "Keep", faction = "", steps = "accept 9011\nturnin 9011\naccept 9012\nturnin 9012\naccept 9013\nturnin 9013\naccept 9014\nturnin 9014" }
    MOCK.done[9012], MOCK.done[9013] = true, true
    G:Activate("keep") settle()
    check("resume: past the quests done, the one before them is missed", at() == "accept 9014" and G:Missed()[1] == 9011, at())
    check("resume point saved as a quest", W.cdb.resume.keep == 9013, W.cdb.resume.keep)
    MOCK.done[9012], MOCK.done[9013] = nil, nil

    -- skips stay on their step when the quest mode changes the step numbers
    W.db.questMode = "efficient"
    W:RegisterGuide{ id = "keys", title = "Keys", faction = "", steps = "accept 9101 |value low\nnote Sell junk\naccept 9102\naccept 9103" }
    G:Activate("keys") settle()
    check("efficient: starts on the note", at() == "note Sell junk", at())
    G:MarkDone(cur()) settle()
    W.db.questMode = "all" G:Reload() settle()
    check("mode change: the low-value quest shows, the ticked note stays ticked", at() == "accept 9101", at())
    G:Skip(1) settle()
    check("...and the note is still done after it", at() == "accept 9102", at())
    W.cdb.skipped.keys[3] = true                                 -- a skip saved by step number (0.6.21)
    G:Activate("keys") settle()
    check("skips saved by step number are dropped", W.cdb.skipped.keys[3] == nil and at() == "accept 9102", at())
    W.db.questMode = oldMode

    -- skipping an accept skips the quest; picking it up anyway brings its steps back
    W:RegisterGuide{ id = "whole", title = "Whole", faction = "", steps = "accept 9201\ncomplete 9201\nturnin 9201\naccept 9202\ncomplete 9202" }
    G:Activate("whole") settle()
    G:Skip(1) settle()
    check("skip an accept: on to the next quest", at() == "accept 9202", at())
    MOCK.addQuest(9202, "Second") MOCK.fire("QUEST_ACCEPTED", 9202) settle()
    check("...its objectives next", at() == "complete 9202", at())
    MOCK.addQuest(9201, "Taken after all") MOCK.fire("QUEST_ACCEPTED", 9201) settle()
    check("picked up after all: back to its objectives", at() == "complete 9201", at())
    MOCK.turnIn(9201) MOCK.turnIn(9202) MOCK.done[9201], MOCK.done[9202] = nil, nil
    MOCK.fire("QUEST_REMOVED", 9201) MOCK.fire("QUEST_REMOVED", 9202) settle()

    -- accepts the game won't offer yet are held, with the reason, and come back by themselves
    W:RegisterGuide{ id = "held", title = "Held", faction = "", steps = [[
accept 9301
accept 9302 |pre 9301
complete 9302
accept 9303 |lvl 30
complete 9303
turnin 9301
turnin 9302
accept 9304 |preany 9777,9778
accept 9305
]] }
    MOCK.level = 20
    local p = G.ParseStep("accept 5 |lvl 12 |pre 3,4 |preany 8")
    check("parser reads |lvl, |pre and |preany", p.lvl == 12 and p.pre[2] == 4 and p.preAny[1] == 8)
    G:Activate("held") settle()
    check("held quests are still ahead: a fresh character's count starts at 0", (G:Progress()) == 0, (G:Progress()))
    MOCK.addQuest(9301, "Opener (a delivery: ready as soon as you have it)") MOCK.finish(9301)
    MOCK.fire("QUEST_ACCEPTED", 9301) settle()
    check("held: the follow-up and the level 30 quest are passed over", at() == "turnin 9301", at())
    local reason, kind = G:HeldReason(G:Active().steps[4])
    check("held: says why", reason == "needs level 30" and kind == "level", reason)
    MOCK.turnIn(9301) MOCK.fire("QUEST_TURNED_IN", 9301) settle()
    check("prerequisite handed in: the follow-up is on offer and comes back", at() == "accept 9302", at())
    MOCK.addQuest(9302, "Follow-up") MOCK.fire("QUEST_ACCEPTED", 9302) settle()
    MOCK.finish(9302) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.turnIn(9302) MOCK.fire("QUEST_TURNED_IN", 9302) settle()
    check("a quest that follows one the guide doesn't cover waits", at() == "accept 9305", at())
    MOCK.addQuest(9305, "Last") MOCK.fire("QUEST_ACCEPTED", 9305) settle()
    check("the wall: only held quests are left, so the first becomes the step", at() == "accept 9303", at())
    MOCK.level = 30 MOCK.fire("PLAYER_LEVEL_UP") settle()
    check("levelled: the same step, now open", at() == "accept 9303" and G:HeldReason(cur()) == nil, at())
    MOCK.addQuest(9303, "Level 30 one") MOCK.fire("QUEST_ACCEPTED", 9303) settle()
    MOCK.finish(9303) MOCK.fire("QUEST_LOG_UPDATE") settle()
    local why, _, first = G:HeldReason(G:Active().steps[8])
    check("then the quest that follows one outside the guide, naming it", at() == "accept 9304" and first == 9777 and why:find("^after "), at() .. " / " .. tostring(why))
    MOCK.done[9778] = true MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("one of its prerequisites done elsewhere: on offer", at() == "accept 9304" and G:HeldReason(cur()) == nil, at())
    MOCK.turnIn(9303) MOCK.done[9303], MOCK.done[9778] = nil, nil MOCK.fire("QUEST_REMOVED", 9303)

    MOCK.turnIn(9305) MOCK.done[9305], MOCK.done[9301], MOCK.done[9302] = nil, nil, nil
    MOCK.fire("QUEST_REMOVED", 9305)
    MOCK.level = oldLevel
    G:Activate(oldGuide) settle()
end

-- areas: a kill/loot step whose mobs sit in several camps -----------------------------
do
    local G, WP = W.Guide, W.Waypoint
    local oldGuide, savedPos = W.cdb.guide, MOCK.pos
    W:RegisterGuide{ id = "areas", title = "Areas", faction = "", steps = [[
accept 9401
complete 9401 |at 1423 20.0,20.0 |areas 20.0,20.0:40;60.0,60.0:12;90.0,20.0:8
turnin 9401
]] }
    local p = G.ParseStep("complete 5 |at 1423 20.0,20.0 |areas 20.0,20.0:40;60.5,61.0:12")
    check("parser reads |areas", p.areas and #p.areas == 2 and p.areas[2].x == 60.5 and p.areas[2].n == 12)
    check("one area is no choice", G.ParseStep("complete 5 |at 1423 20.0,20.0 |areas 20.0,20.0:40").areas == nil)
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    MOCK.addQuest(9401, "Reeds by the bundle") MOCK.fire("QUEST_ACCEPTED", 9401)
    G:Activate("areas") settle() MOCK.advance(3)
    local c = WP:Current()
    local list, chosen, pinned = WP:Areas()
    check("areas: three camps, the nearest is picked", list and #list == 3 and chosen.index == 2 and not pinned and c.x == 60, c and c.x)
    check("panel: the area line shows which one", W.UI.areaBtn:IsShown() and W.UI.areaBtn.text:GetText():find("Area 2 of 3", 1, true), W.UI.areaBtn.text:GetText())
    MOCK.pos = { map = 1423, x = 0.24, y = 0.24 }                 -- walk towards the first camp
    WP:ArrowTarget() MOCK.advance(1)
    check("areas: follows you to the camp that's now clearly nearer", WP:Current().x == 20, WP:Current().x)
    WorldMapFrame:Show() MOCK.advance(1)
    check("map: the other two camps are marked", W.Route.drawn and W.Route.drawn.areas == 2, W.Route.drawn and W.Route.drawn.areas)
    WorldMapFrame:Hide()
    local a, n = WP:NextArea()
    check("next area: on to the second camp", a.index == 2 and n == 3 and WP:Current().x == 60, WP:Current().x)
    WP:ArrowTarget() MOCK.advance(1)
    check("...and it stays there though the first is nearer", WP:Current().x == 60 and select(3, WP:Areas()) == true, WP:Current().x)
    check("panel follows", W.UI.areaBtn.text:GetText():find("Area 2 of 3", 1, true), W.UI.areaBtn.text:GetText())
    SlashCmdList.ONWARD("area")
    check("/ow area: the third", WP:Current().x == 90, WP:Current().x)
    MOCK.turnIn(9401) MOCK.done[9401] = nil MOCK.fire("QUEST_REMOVED", 9401)
    MOCK.pos = savedPos
    G:Activate(oldGuide) settle()
    check("no area line on other steps", not W.UI.areaBtn:IsShown())
end

-- quests with no known place to pick them up (|loose) ---------------------------------
do
    local G = W.Guide
    local oldGuide = W.cdb.guide
    local function at() local s = cur() return s and (s.verb .. " " .. tostring(s.quest or s.text)) or "end" end
    W:RegisterGuide{ id = "loose", title = "Loose", faction = "", steps = [[
accept 9501 |loose
turnin 9501 |npc Collector |at 1423 40.0,40.0
accept 9502 |note Starts from Gift Voucher |startitem 77001 |loose
turnin 9502 |npc Collector |at 1423 40.0,40.0
accept 9503 |npc Collector |at 1423 40.0,40.0
]] }
    G:Activate("loose") settle()
    check("no known start: the guide doesn't wait on it, or on its turn-in", at() == "accept 9503", at())
    check("...and says why when asked", select(2, G:HeldReason(G:Active().steps[1])) == "loose")
    check("both are listed as quests to find", #G:Loose() == 2 and G:Loose()[2].note == "Starts from Gift Voucher", #G:Loose())
    check("panel: a footer link for them", W.UI.looseBtn:IsShown() and W.UI.looseBtn.text:GetText():find("2 to find here", 1, true), W.UI.looseBtn.text:GetText())
    check("a fresh character's count still starts at 0", (G:Progress()) == 0, (G:Progress()))
    MOCK.bags[77001] = 1 MOCK.fire("BAG_UPDATE_DELAYED") settle()
    check("the item that starts a quest is in your bags: its accept comes up", at() == "accept 9502", at())
    MOCK.bags[77001] = nil
    MOCK.addQuest(9502, "Voucher") MOCK.finish(9502) MOCK.fire("QUEST_ACCEPTED", 9502) settle()
    check("accepted: its turn-in is next", at() == "turnin 9502", at())
    MOCK.addQuest(9501, "Scrap of scroll (a drop)") MOCK.finish(9501) MOCK.fire("QUEST_ACCEPTED", 9501) settle()
    MOCK.turnIn(9502) MOCK.fire("QUEST_TURNED_IN", 9502) settle()
    check("a dropped quest you happened to get: the guide takes it from there", #G:Waiting().ready == 1 or at() == "turnin 9501", at())
    check("once you have them they leave the list", #G:Loose() == 0, #G:Loose())
    MOCK.turnIn(9501) MOCK.done[9501], MOCK.done[9502] = nil, nil MOCK.fire("QUEST_REMOVED", 9501)
    G:Activate(oldGuide) settle()
end

-- reload in a party: finished quests already in the log are not announced again -----------
do
    local oldChat = W.db.partyChat
    W.db.partyChat = true
    local function count(q)
        local n = 0
        for _, s in ipairs(MOCK.sent) do if s[2] == "1|Q|" .. q .. "|r" then n = n + 1 end end
        return n
    end
    local chatBefore = #MOCK.chat
    MOCK.addQuest(9651, "Finished before the reload") MOCK.finish(9651)      -- first seen already finished
    MOCK.addQuest(9652, "Still working on it")
    MOCK.fire("PLAYER_LOGIN") MOCK.fire("QUEST_LOG_UPDATE") MOCK.advance(3)
    check("reload: a quest already finished is not announced", count(9651) == 0 and #MOCK.chat == chatBefore, count(9651) .. " / " .. (#MOCK.chat - chatBefore))
    MOCK.finish(9652) MOCK.fire("QUEST_LOG_UPDATE") MOCK.advance(2)
    check("finishing one now is announced, once", count(9652) == 1 and #MOCK.chat == chatBefore + 1
        and MOCK.chat[#MOCK.chat][1] == "[Onward] done: Still working on it", count(9652) .. " / " .. (#MOCK.chat - chatBefore))
    MOCK.fire("QUEST_LOG_UPDATE") MOCK.advance(2)
    check("...and not again on the next update", count(9652) == 1 and #MOCK.chat == chatBefore + 1)
    MOCK.turnIn(9651) MOCK.turnIn(9652) MOCK.done[9651], MOCK.done[9652] = nil, nil
    MOCK.fire("QUEST_REMOVED", 9651) MOCK.fire("QUEST_REMOVED", 9652) MOCK.advance(20)
    W.db.partyChat = oldChat
end

do  -- a flight out and back whose only errand is already done is passed over
    local prev = W.Guide:Active() and W.Guide:Active().id
    local oldPos = MOCK.pos
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W:RegisterGuide{ id = "roundtrip", title = "Round trip", levels = { 1, 60 }, steps = [[
accept 9701
fly 1424 50.0,50.0 |from 1423 52.0,52.0 |npc Eastwatch
accept 9702
fly 1423 52.0,52.0 |from 1424 50.0,50.0 |npc Home
accept 9703
fly 1424 50.0,50.0 |from 1423 52.0,52.0 |npc Eastwatch
]] }
    MOCK.addQuest(9701, "At home")
    MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("roundtrip") settle()
    check("round trip with an errand left: the flight stands", cur().verb == "fly", cur().verb)
    local rep = W.Guide:Report("flew me away for nothing")
    check("step report names the guide, the step and what the player said",
        rep:find("roundtrip", 1, true) and rep:find("> 2. fly 1424", 1, true) and rep:find("flew me away for nothing", 1, true) and true, rep)
    check("step report says why a step isn't open", rep:find("quest in log", 1, true) and true, rep)
    local why = W.Guide:TripReason(cur())
    check("a flight says what it is for", why and why.verb == "accept" and why.quest == 9702, why and why.verb)
    MOCK.addQuest(9702, "Picked up earlier") MOCK.fire("QUEST_ACCEPTED", 9702) settle()
    check("round trip with nothing left to do there: both flights are passed over",
        cur().verb == "accept" and cur().quest == 9703, cur().verb .. " " .. tostring(cur().quest))
    MOCK.addQuest(9703, "Next") MOCK.fire("QUEST_ACCEPTED", 9703) settle()
    check("the last flight of a guide always stands", cur() and cur().verb == "fly", cur() and cur().verb)
    -- a longer trip with a boat walk in it: the whole run goes, boat steps included
    W:RegisterGuide{ id = "roundtrip2", title = "Round trip 2", levels = { 1, 60 }, steps = [[
accept 9701
fly 1424 50.0,50.0 |from 1423 52.0,52.0 |npc Eastwatch
accept 9702
goto 1424 60.0,60.0 |note Take the boat
fly 1423 52.0,52.0 |from 1424 50.0,50.0 |npc Home
accept 9704
]] }
    W.Guide:Activate("roundtrip2") settle()
    check("idle trip with a boat walk: flights and the boat step are all passed over",
        cur().verb == "accept" and cur().quest == 9704, cur().verb .. " " .. tostring(cur().quest))
    MOCK.pos = { map = 1424, x = 0.5, y = 0.5 }
    W.Guide:Activate("roundtrip2") settle()
    check("...but at the far end, the way back stays", cur().verb == "goto", cur().verb)
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    for _, q in ipairs({ 9701, 9702, 9703 }) do MOCK.turnIn(q) MOCK.done[q] = nil MOCK.fire("QUEST_REMOVED", q) end
    MOCK.pos = oldPos
    if prev then W.Guide:Activate(prev) settle() end
end

do  -- talk steps: the target button targets the NPC you talk to
    local prev = W.Guide:Active() and W.Guide:Active().id
    W:RegisterGuide{ id = "talk", title = "Talk", levels = { 1, 60 }, steps = [[
accept 9801 |npc Marla Fipps |at 1423 50.0,50.0
complete 9801 |at 1423 51.0,51.0 |mobs Bog Lurker
turnin 9801 |npc Marla Fipps |at 1423 50.0,50.0
]] }
    W.Guide:Activate("talk") settle()
    local tb = W.Target.button
    local m = tb:GetAttribute("macrotext") or ""
    check("talk step: the button targets the NPC by name", m:find("/targetexact Marla Fipps", 1, true) and tb:IsShown(), m)
    check("talk step: marked with a star, not a skull", m:find("/tm [exists,nodead] 1", 1, true) and not m:find("/tm [exists,nodead] 8", 1, true), m)
    MOCK.addQuest(9801, "Bog work") MOCK.fire("QUEST_ACCEPTED", 9801) settle()
    m = tb:GetAttribute("macrotext") or ""
    check("kill step after it: back to the quest mob", m:find("Bog Lurker", 1, true) and not m:find("Marla Fipps", 1, true), m)
    MOCK.turnIn(9801) MOCK.done[9801] = nil MOCK.fire("QUEST_REMOVED", 9801)
    if prev then W.Guide:Activate(prev) settle() end
end

do  -- items to bring: a quest that wants something you have to buy or have made
    local prev = W.Guide:Active() and W.Guide:Active().id
    W:RegisterGuide{ id = "bring", title = "Bring", levels = { 1, 60 }, steps = [[
accept 9811 |npc Lotwil |at 1423 50.0,50.0
complete 9811 |need 3829:2:Frost Oil:made with Alchemy, so buy it at the auction house or ask a crafter;4389:1:Gyrochronatom:sold by Billibub in Stormwind City
turnin 9811 |npc Lotwil |at 1423 50.0,50.0
]] }
    W.Guide:Activate("bring") settle()
    local needs = W.Guide:Needs()
    check("items to bring: both listed before the quest is even picked up", #needs == 2 and needs[1].name == "Frost Oil" and needs[1].n == 2, #needs)
    check("...with where to get them", needs[1].where:find("Alchemy", 1, true) and needs[2].where:find("Billibub", 1, true))
    MOCK.bags[3829] = 2
    needs = W.Guide:Needs()
    check("an item in your bags drops off the list", #needs == 1 and needs[1].id == 4389, #needs)
    local title = W.UI.NeedLine(needs[1])
    check("the list names the item", title == "Gyrochronatom", title)
    MOCK.bags[4389] = 1
    check("everything in hand: nothing to bring", #W.Guide:Needs() == 0)
    MOCK.bags[3829], MOCK.bags[4389] = nil, nil
    if prev then W.Guide:Activate(prev) settle() end
end

do  -- on your way: a later kill step for a quest in your log, close to where you are
    local prev = W.Guide:Active() and W.Guide:Active().id
    local oldPos = MOCK.pos
    MOCK.pos = { map = 1423, x = 0.5, y = 0.5 }
    W:RegisterGuide{ id = "passing", title = "Passing", levels = { 1, 60 }, steps = [[
accept 9821 |npc Marla Fipps |at 1423 50.0,50.0
accept 9822 |npc Marla Fipps |at 1423 50.0,50.0
accept 9823 |npc Marla Fipps |at 1423 50.0,50.0
accept 9824 |npc Old Jeb |at 1423 52.0,52.0
goto 1423 80.0,20.0 |note Cross the bridge
complete 9821 |at 1423 50.5,50.5 |mobs Bog Lurker
goto 1423 20.0,80.0 |note Up the hill
complete 9822 |at 1423 50.6,50.6 |mobs Mire Toad
complete 9823 |at 1424 90.0,90.0 |mobs Far Beast
]] }
    for _, q in ipairs({ 9821, 9822, 9823 }) do MOCK.addQuest(q, "Quest " .. q) end
    MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("passing") settle()
    check("on your way: the step itself is a pickup", cur() and cur().verb == "accept" and cur().quest == 9824, cur() and cur().verb)
    local pass = W.Guide:Passing()
    check("on your way: nearby kill steps for quests in your log are listed, past travel steps",
        #pass == 2 and pass[1].quest == 9821 and pass[2].quest == 9822, #pass)
    W.db.passing = false
    check("on your way: off when the option is off", #W.Guide:Passing() == 0)
    W.db.passing = true
    for _, q in ipairs({ 9821, 9822, 9823 }) do MOCK.turnIn(q) MOCK.done[q] = nil MOCK.fire("QUEST_REMOVED", q) end
    MOCK.pos = oldPos
    if prev then W.Guide:Activate(prev) settle() end
end

do  -- an item you need in hand before the objective: its own step, done when it's in your bags
    local prev = W.Guide:Active() and W.Guide:Active().id
    W:RegisterGuide{ id = "pick", title = "Pick", levels = { 1, 60 }, steps = [[
accept 9831 |npc Novice Elreth |at 1423 50.0,50.0
complete 9831 |at 1423 60.0,60.0 |mobs Samuel Fipps@Remains |pick 16333 |note First get the Remains from Samuel Fipps
complete 9831 |at 1423 51.0,51.0
turnin 9831 |npc Novice Elreth |at 1423 50.0,50.0
]] }
    MOCK.addQuest(9831, "Last Wish") MOCK.fire("QUEST_LOG_UPDATE")
    W.Guide:Activate("pick") settle()
    check("needed item first: the step that gets it comes before the objective", cur().pick == 16333 and cur().at.x == 60, cur().pick)
    MOCK.bags[16333] = 1 MOCK.fire("BAG_UPDATE_DELAYED") settle()
    check("item in your bags: on to the objective itself", cur().verb == "complete" and not cur().pick and cur().at.x == 51, tostring(cur().pick))
    MOCK.bags[16333] = nil
    MOCK.turnIn(9831) MOCK.done[9831] = nil MOCK.fire("QUEST_REMOVED", 9831)
    if prev then W.Guide:Activate(prev) settle() end
end

do  -- recommendations never reach above your level, even for a quest in your log
    local oldLevel = MOCK.level
    W:RegisterGuide{ id = "toohigh", title = "Too high", levels = { 30, 35 }, steps = "accept 9841\nturnin 9841\n" }
    MOCK.level = 20
    MOCK.addQuest(9841, "Breadcrumb") MOCK.fire("QUEST_LOG_UPDATE") settle()
    local rec = W.Guide:Recommend()
    check("a guide ten levels up isn't recommended for one quest in your log", not rec or rec.id ~= "toohigh", rec and rec.id)
    MOCK.level = 29
    rec = W.Guide:Recommend()
    check("...but is once you're a level below its range", rec and rec.id == "toohigh", rec and rec.id)
    MOCK.level = oldLevel
    MOCK.turnIn(9841) MOCK.done[9841] = nil MOCK.fire("QUEST_REMOVED", 9841)
end

-- engine hardening tests: exclusive breadcrumbs, split |obj, unfinished turnin fallback,
-- resume rebuild safety, monotonic cursor on level-up, ready turn-in before next guide,
-- failed escort handling, hub grouping, and scoped auto-accept -----------------------------
do
    local G, WP = W.Guide, W.Waypoint
    local oldGuide, oldLevel = W.cdb.guide, MOCK.level
    local function at() local s = cur() return s and (s.verb .. " " .. tostring(s.quest or s.text)) or "end" end

    -- 1. |exclusive breadcrumb auto-completes and blocks its own turnin when target is taken/done
    W:RegisterGuide{ id = "excl", title = "Exclusive", levels = { 1, 60 }, steps = [[
accept 9901 |exclusive 9902
turnin 9901
accept 9902
complete 9902
turnin 9902
]] }
    MOCK.addQuest(9902, "Real Quest") MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("excl") settle()
    check("exclusive: skips breadcrumb accept and turnin when target is already in log", at() == "complete 9902", at())
    MOCK.turnIn(9902) MOCK.done[9902] = nil MOCK.fire("QUEST_REMOVED", 9902)

    -- 2. |obj <name> splits multi-location objectives by name without index mismatch
    W:RegisterGuide{ id = "splitobj", title = "Split Obj", levels = { 1, 60 }, steps = [[
accept 9905
complete 9905 |obj Riverweed |at 1423 50.0,50.0
complete 9905 |obj Sweetberry |at 1423 80.0,30.0
turnin 9905
]] }
    MOCK.addQuest(9905, "Herbs", {
        { text = "Sweetberry: 0/8", finished = false, numFulfilled = 0, numRequired = 8 },
        { text = "Riverweed: 0/6", finished = false, numFulfilled = 0, numRequired = 6 },
    })
    MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("splitobj") settle()
    check("split |obj: starts on Riverweed step", cur() and cur().objName == "Riverweed", cur() and cur().objName)
    MOCK.log[9905].objectives[2].finished = true MOCK.log[9905].objectives[2].numFulfilled = 6
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("split |obj: finishing Riverweed advances to Sweetberry", cur() and cur().objName == "Sweetberry", cur() and cur().objName)
    MOCK.log[9905].objectives[1].finished = true MOCK.log[9905].objectives[1].numFulfilled = 8
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    check("split |obj: finishing Sweetberry advances to turnin", at() == "turnin 9905", at())
    MOCK.turnIn(9905) MOCK.done[9905] = nil MOCK.fire("QUEST_REMOVED", 9905)

    -- 3. Unfinished turnin with NO `complete` step in the guide stays active (never forgotten)
    W:RegisterGuide{ id = "nocomp", title = "No Complete", levels = { 1, 60 }, steps = [[
accept 9910
turnin 9910 |npc Claire |at 1423 40.0,40.0
accept 9911
]] }
    MOCK.addQuest(9910, "Abominable Magics", { { text = "Samples absorbed: 0/25", finished = false, numFulfilled = 0, numRequired = 25 } })
    MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("nocomp") settle()
    check("unfinished turnin without complete step is NOT skipped/forgotten", at() == "turnin 9910" and G:IsUnfinishedTurnin(cur()), at())
    MOCK.finish(9910) MOCK.turnIn(9910) MOCK.done[9910] = nil MOCK.fire("QUEST_REMOVED", 9910)

    -- 4. Leveling up mid-complete step does NOT teleport cursor backward to an earlier |lvl accept
    W:RegisterGuide{ id = "noyank", title = "No Yank", levels = { 1, 60 }, steps = [[
accept 9920 |lvl 25
complete 9920
turnin 9920
accept 9921
complete 9921
turnin 9921
]] }
    MOCK.level = 24
    MOCK.addQuest(9921, "Active Grind") MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("noyank") settle()
    check("noyank: starts on active grind while 9920 needs level 25", at() == "complete 9921", at())
    MOCK.level = 25 MOCK.fire("PLAYER_LEVEL_UP") settle()
    check("noyank: leveling up does NOT interrupt active complete step", at() == "complete 9921", at())
    MOCK.finish(9921) MOCK.turnIn(9921) MOCK.fire("QUEST_TURNED_IN", 9921) settle()
    check("noyank: picks up unlocked 9920 once current step finishes", at() == "accept 9920", at())
    MOCK.done[9921] = nil MOCK.level = oldLevel

    -- 5. End of guide returns to ready Waiting turn-in BEFORE transitioning to `next` guide
    W:RegisterGuide{ id = "endnext", title = "Next Zone", levels = { 1, 60 }, steps = "accept 9935\nturnin 9935\n" }
    W:RegisterGuide{ id = "endwait", title = "End Wait", levels = { 1, 60 }, next = "endnext", steps = [[
complete 9930
turnin 9930
complete 9931
turnin 9931
]] }
    MOCK.addQuest(9930, "Boss Quest") MOCK.addQuest(9931, "Easy Quest")
    MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("endwait") settle()
    G:Skip(1) settle()                          -- skip complete 9930 -> turnin 9930 waits
    MOCK.finish(9930) MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.finish(9931) MOCK.turnIn(9931) MOCK.fire("QUEST_TURNED_IN", 9931) settle()
    check("end of guide: returns to ready waiting turn-in instead of abandoning it for next guide",
        G:Active().id == "endwait" and at() == "turnin 9930", G:Active().id .. " / " .. at())
    MOCK.turnIn(9930) MOCK.fire("QUEST_TURNED_IN", 9930) settle()
    check("...and advances to next guide once the ready turn-in is handed in", G:Active().id == "endnext", G:Active().id)
    MOCK.done[9930], MOCK.done[9931] = nil, nil

    -- 6. Guide rebuild invalidates stale resume frontier instead of hiding reordered steps
    W:RegisterGuide{ id = "rebuild", title = "Rebuild", levels = { 1, 60 }, steps = [[
accept 9941
turnin 9941
accept 9942
turnin 9942
accept 9943
turnin 9943
]] }
    MOCK.done[9941] = true MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("rebuild") settle()
    check("rebuild: saved frontier on 9941", W.cdb.resume.rebuild == 9941, W.cdb.resume.rebuild)
    -- simulate a guide rebuild that moves 9941 to the end
    W:RegisterGuide{ id = "rebuild", title = "Rebuild", levels = { 1, 60 }, steps = [[
accept 9942
turnin 9942
accept 9943
turnin 9943
accept 9941
turnin 9941
]] }
    G:Activate("rebuild") settle()
    check("rebuild: stale frontier does NOT hide 9942/9943 after 9941 moved to the end", at() == "accept 9942" and #G:Missed() == 0, at() .. " missed=" .. #G:Missed())
    MOCK.done[9941] = nil

    -- 7. Failed escort quest stays incomplete and points back to quest giver
    local realFailed = C_QuestLog.IsFailed
    C_QuestLog.IsFailed = function(q) return q == 19950 end
    W:RegisterGuide{ id = "escort", title = "Escort", levels = { 1, 60 }, steps = [[
accept 19950 |npc Wizzle |at 1423 25.0,25.0
complete 19950 |at 1423 60.0,60.0
turnin 19950 |npc Sputter |at 1423 70.0,70.0
]] }
    MOCK.addQuest(19950, "The Escape") MOCK.fire("QUEST_LOG_UPDATE")
    G:Activate("escort") settle()
    check("failed escort: marked failed and waypoint points back to giver",
        G:IsFailed(cur()) and WP:Current() and WP:Current().x == 25, WP:Current() and WP:Current().x)
    C_QuestLog.IsFailed = realFailed
    MOCK.turnIn(19950) MOCK.done[19950] = nil MOCK.fire("QUEST_REMOVED", 19950)

    -- 8. Scoped Auto.lua: accepts current hub quest, refuses skipped, Later, and far-ahead quests
    local lines = { "accept 19960 |npc Hub |at 1423 50.0,50.0", "accept 19961 |npc Hub |at 1423 50.0,50.0" }
    for q = 19962, 19980 do lines[#lines + 1] = "accept " .. q .. " |npc Far |at 1423 80.0,80.0" end
    W:RegisterGuide{ id = "autoscope", title = "Auto Scope", levels = { 1, 60 }, steps = table.concat(lines, "\n") }
    G:Activate("autoscope") settle()
    check("hub group bundles co-located hub accepts", #G:HubGroup() == 2, #G:HubGroup())
    MOCK.calls = {} MOCK.questId = 19960 MOCK.fire("QUEST_DETAIL")
    check("auto-accept: accepts current hub quest", called("AcceptQuest"))
    MOCK.calls = {} MOCK.questId = 19980 MOCK.fire("QUEST_DETAIL")
    check("auto-accept: refuses quest far ahead in the guide", not called("AcceptQuest"))
    G:Skip(1) settle()   -- skip 19960
    MOCK.calls = {} MOCK.questId = 19960 MOCK.fire("QUEST_DETAIL")
    check("auto-accept: refuses skipped quest", not called("AcceptQuest"))
    G:Later(19961) settle()
    MOCK.calls = {} MOCK.questId = 19961 MOCK.fire("QUEST_DETAIL")
    check("auto-accept: refuses Later quest", not called("AcceptQuest"))
    W.cdb.later[19961] = nil

    -- 8b. Auto-accept reliability: follow-up after turn-in before WF_REFRESH, stale gossip list after accept/turn-in, and out-of-order hub accept
    W:RegisterGuide{ id = "autoflow", title = "Auto Flow", levels = { 1, 60 }, steps = [[
accept 19981 |npc Elder |at 1423 50.0,50.0
accept 19982 |npc Elder |at 1423 50.0,50.0
complete 19981 |at 1423 55.0,55.0
turnin 19981 |npc Elder |at 1423 50.0,50.0
accept 19983 |npc Elder |at 1423 50.0,50.0 |pre 19981
]] }
    G:Activate("autoflow") settle()
    -- Multi-quest NPC: accept 19981, then GOSSIP_SHOW re-fires immediately with stale 19981 still in available list
    MOCK.now = 100
    local savedGossip = C_GossipInfo
    local availList = { { questID = 19981 }, { questID = 19982 } }
    local activeList = {}
    local selectedAvail, selectedActive = {}, {}
    C_GossipInfo = {
        GetAvailableQuests = function() return availList end,
        GetActiveQuests = function() return activeList end,
        SelectAvailableQuest = function(id) selectedAvail[#selectedAvail + 1] = id end,
        SelectActiveQuest = function(id) selectedActive[#selectedActive + 1] = id end,
    }
    MOCK.fire("GOSSIP_SHOW")
    check("auto-accept: selects first quest from gossip", selectedAvail[1] == 19981, tostring(selectedAvail[1]))
    MOCK.calls = {} MOCK.questId = 19981 MOCK.fire("QUEST_DETAIL")
    check("auto-accept: accepts first quest on QUEST_DETAIL", called("AcceptQuest"))
    -- Gossip re-fires immediately BEFORE QUEST_LOG_UPDATE removes 19981 from available list or marks IsOnQuest
    MOCK.fire("GOSSIP_SHOW")
    check("auto-accept: skips stale just-accepted quest and selects second quest immediately",
        selectedAvail[2] == 19982, tostring(selectedAvail[2]))
    -- Turn in 19981 -> NPC immediately offers follow-up 19983 (|pre 19981) BEFORE IsQuestFlaggedCompleted or WF_REFRESH updates
    MOCK.addQuest(19981, "First") MOCK.addQuest(19982, "Second")
    MOCK.log[19981].ready = true
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    MOCK.choices = 0 MOCK.questId = 19981 MOCK.fire("QUEST_COMPLETE")
    -- Stale gossip re-fires with 19981 still marked isComplete AND 19983 offered (before done[19981] flips!)
    activeList = { { questID = 19981, isComplete = true } }
    availList = { { questID = 19983 } }
    selectedAvail, selectedActive = {}, {}
    MOCK.fire("GOSSIP_SHOW")
    check("auto-accept: skips stale just-turned-in active quest", #selectedActive == 0, tostring(selectedActive[1]))
    check("auto-accept: selects immediate follow-up before WF_REFRESH/IsDone updates",
        selectedAvail[1] == 19983, tostring(selectedAvail[1]))
    MOCK.calls = {} MOCK.questId = 19983 MOCK.fire("QUEST_DETAIL")
    check("auto-accept: accepts immediate follow-up without needing re-click", called("AcceptQuest"))
    C_GossipInfo = savedGossip
    MOCK.turnIn(19981) MOCK.turnIn(19982) MOCK.done[19981] = nil MOCK.done[19982] = nil

    G:Activate(oldGuide) settle()
end

-- voluntary completed quest item cleanup ---------------------------------------------------
do
    local CL = W.Cleanup
    local saved = {
        C_Container = C_Container, GetItemInfoInstant = GetItemInfoInstant,
        GetItemNameByID = C_Item.GetItemNameByID, GetCursorInfo = GetCursorInfo,
        DeleteCursorItem = DeleteCursorItem, ClearCursor = ClearCursor,
        combat = MOCK.combat,
    }
    local bag = {}   -- [slot] = { itemID, stackCount, isLocked, iconFileID }
    local names = { [182] = "Garrick's Head", [921] = "Page of the Ledger", [16333] = "Samuel's Remains",
                    [9240] = "Mallet of Zul'Farrak", [5462] = "Dartol's Rod of Transformation" }
    local classes = { [182] = 12, [921] = 12, [16333] = 12, [9240] = 12, [5462] = 12 }
    local cursorItem, deleted = nil, {}

    C_Container = {
        GetContainerNumSlots = function(b) return b == 0 and #bag or 0 end,
        GetContainerItemInfo = function(b, s) return b == 0 and bag[s] or nil end,
        PickupContainerItem = function(b, s)
            if b == 0 and bag[s] then cursorItem = { bag = b, slot = s, id = bag[s].itemID } end
        end,
    }
    GetItemInfoInstant = function(id) return id, nil, nil, nil, nil, classes[id] end
    C_Item.GetItemNameByID = function(id) return names[id] end
    GetCursorInfo = function() if cursorItem then return "item", cursorItem.id end end
    ClearCursor = function() cursorItem = nil end
    DeleteCursorItem = function()
        if cursorItem then
            table.insert(deleted, cursorItem.id)
            bag[cursorItem.slot] = nil
            cursorItem = nil
        end
    end

    -- 1. Single-quest item (182 -> quest 6), multi-quest item (921 -> quests 75, 78),
    --    unlisted permanent item (9240 Mallet of ZF), reward item (5462 Dartol's Rod)
    bag[1] = { itemID = 182, stackCount = 1 }
    bag[2] = { itemID = 921, stackCount = 1 }
    bag[3] = { itemID = 9240, stackCount = 1 }
    bag[4] = { itemID = 5462, stackCount = 1 }
    MOCK.done[6] = true
    MOCK.done[75] = true   -- 78 NOT done yet!
    MOCK.fire("BAG_UPDATE_DELAYED") settle()

    local list = CL:Scan(true)
    check("cleanup: never deletes automatically on bag/quest events", #deleted == 0, #deleted)
    check("cleanup: flags ONLY completed single-quest item 182 (protects incomplete chain 921, Mallet 9240, Dartol's Rod 5462)",
        #list == 1 and list[1].id == 182, #list .. " / " .. tostring(list[1] and list[1].id))

    -- 2. Completing the rest of 921's chain (quest 78) makes 921 eligible
    MOCK.done[78] = true
    list = CL:Scan(true)
    check("cleanup: multi-quest item becomes eligible only after ALL chain quests are done", #list == 2, #list)

    -- 3. Active quest log text mentioning the item name blocks it even if DB quests are done
    MOCK.addQuest(19991, "Still needs Garrick's Head", { { text = "Bring Garrick's Head: 0/1", finished = false, numFulfilled = 0, numRequired = 1 } })
    MOCK.fire("QUEST_LOG_UPDATE") settle()
    list = CL:Scan(true)
    check("cleanup: active quest mentioning item name protects it", #list == 1 and list[1].id == 921, #list)
    MOCK.turnIn(19991) MOCK.done[19991] = nil MOCK.fire("QUEST_REMOVED", 19991) settle()

    -- 4. Keep button permanently hides an item for this character; Reset restores it
    CL:Keep(921)
    list = CL:Scan(true)
    check("cleanup: Keep hides item from cleanup list", #list == 1 and list[1].id == 182, #list)
    CL:ResetKept()
    list = CL:Scan(true)
    check("cleanup: ResetKept restores kept items", #list == 2, #list)

    -- 5. Voluntary DeleteEntry safety gates: refuses in combat, refuses with busy cursor, deletes cleanly otherwise
    local target = list[1]
    MOCK.combat = true
    local ok, why = CL:DeleteEntry(target)
    check("cleanup: refuses delete in combat", not ok and why == "combat" and #deleted == 0, why)
    MOCK.combat = false
    cursorItem = { id = 99999 }
    ok, why = CL:DeleteEntry(target)
    check("cleanup: refuses delete when cursor is holding something", not ok and why == "cursor" and #deleted == 0, why)
    cursorItem = nil
    ok = CL:DeleteEntry(target)
    check("cleanup: voluntary click deletes verified slot cleanly", ok and #deleted == 1 and deleted[1] == target.id and bag[target.slot] == nil, tostring(ok))

    -- 6. Window opens via /ow clean and renders remaining item
    SlashCmdList.ONWARD("clean")
    check("cleanup: /ow clean opens cleanup window", CL.win and CL.win:IsShown())
    CL:Hide()

    -- cleanup mock state
    MOCK.done[6], MOCK.done[75], MOCK.done[78] = nil, nil, nil
    C_Container, GetItemInfoInstant, C_Item.GetItemNameByID = saved.C_Container, saved.GetItemInfoInstant, saved.GetItemNameByID
    GetCursorInfo, DeleteCursorItem, ClearCursor = saved.GetCursorInfo, saved.DeleteCursorItem, saved.ClearCursor
    MOCK.combat = saved.combat
    CL:Invalidate()
end

-- UI/UX overhaul tests: interactive upcoming/grouped rows, popups, searchable picker, tabbed
-- options, Undo toast, clickable ready toast, collapsed 1-line mode, arrow quick menu & route pins
do
    W:RegisterGuide{ id = "uxtest", title = "UX Test Zone", zone = "UX Test Zone", faction = "", levels = { 30, 40 }, steps = [[
accept 19901 |at 1423 20.0,20.0 |npc Giver A
complete 19901 |at 1423 30.0,30.0 |mobs Boar
complete 19902 |at 1423 31.0,31.0 |mobs Wolf
turnin 19901 |at 1423 20.0,20.0 |npc Giver A
note Manual check step
accept 19903 |loose |note Drops from Rare Mob
]]}
    MOCK.addQuest(19901, "Boar Hunt")
    MOCK.addQuest(19902, "Wolf Hunt")
    MOCK.fire("QUEST_ACCEPTED", 19901) MOCK.fire("QUEST_ACCEPTED", 19902)
    W.Guide:Activate("uxtest") settle()
    W.UI.panel:Show() W.UI:Render()

    -- 1. Interactive grouped row (ALSO HERE): left-click focuses that quest
    local gr = W.UI.groupRows[1]
    check("ux: grouped row exists and is clickable", gr and gr:IsShown() and gr.step and gr.step.quest == 19902)
    gr:GetScript("OnClick")(gr, "LeftButton") settle()
    check("ux: clicking grouped row focuses that quest step", cur() and cur().quest == 19902, cur() and cur().quest)

    -- 2. Interactive upcoming row (NEXT): click jumps directly to that step
    W.Guide:GoToStep(W.Guide:Active().steps[2]) settle()
    W.UI:Render()
    local ur = W.UI.upcomingRows[1]
    check("ux: upcoming row is a clickable button with step attached", ur and ur:IsShown() and ur.step ~= nil)
    local targetStep = ur.step
    ur:GetScript("OnClick")(ur, "LeftButton") settle()
    check("ux: clicking upcoming row jumps to that step", cur() == targetStep)

    -- 3. Manual Done button + clickable Undo toast
    local noteStep = W.Guide:Active().steps[5]
    W.Guide:GoToStep(noteStep) settle()
    W.UI:Render()
    check("ux: manual note step shows explicit Done button", W.UI.doneStripBtn:IsShown())
    W.UI.doneStripBtn:GetScript("OnClick")(W.UI.doneStripBtn) settle()
    check("ux: Done button advances step and shows clickable Undo toast", cur() ~= noteStep and W.UI.toast:IsShown() and W.UI.toast.onClick ~= nil)
    W.UI.toast:GetScript("OnClick")(W.UI.toast, "LeftButton") settle()
    check("ux: clicking Undo toast restores the skipped step", cur() == noteStep)

    -- 4. Compact 1-line collapsed mode
    W.Guide:GoToStep(W.Guide:Active().steps[2]) settle()
    W.db.collapsed = false W.UI:Render()
    local expandedH = W.UI.panel:GetHeight()
    W.db.collapsed = true W.UI:Render()
    local collapsedH = W.UI.panel:GetHeight()
    check("ux: collapsed mode shrinks panel to compact 1-line summary", collapsedH < expandedH and collapsedH <= 90, collapsedH .. " vs " .. expandedH)
    W.db.collapsed = false W.UI:Render()

    -- 5. Footer links open glass popups instead of dumping to chat
    W.UI.looseBtn:GetScript("OnClick")(W.UI.looseBtn)
    check("ux: clicking loose footer opens OnwardLoose popup", W.Popups.looseWin and W.Popups.looseWin:IsShown())
    W.Popups.looseWin:Hide()
    W.Popups:ShowNeeds({ { name = "Bronze Tube", have = 0, n = 1, bank = 0, where = "Auction House", quest = 19901 } })
    check("ux: ShowNeeds opens OnwardNeeds popup", W.Popups.needsWin and W.Popups.needsWin:IsShown())
    W.Popups.needsWin:Hide()

    -- 6. Searchable Guide Picker & tab scroll reset
    W.UI:ShowPicker("zones")
    local allZonesCount = #(W.UI.pickerList or {})
    W.UI.pickerSearch:SetText("UX Test")
    W.UI.pickerSearch:GetScript("OnTextChanged")(W.UI.pickerSearch)
    check("ux: picker search filters guides live", #(W.UI.pickerList or {}) == 1 and W.UI.pickerList[1].id == "uxtest", #(W.UI.pickerList or {}))
    W.UI.pickerSearch:SetText("")
    W.UI.pickerSearch:GetScript("OnTextChanged")(W.UI.pickerSearch)
    check("ux: clearing picker search restores full list", #(W.UI.pickerList or {}) == allZonesCount)
    W.UI.picker:Hide()

    -- 7. Tabbed Options switching
    W.Options.SelectTab("appearance")
    check("ux: tabbed options switches pages cleanly", W.Options.tabs.appearance:IsShown() and not W.Options.tabs.questing:IsShown())
    W.Options.SelectTab("navigation")
    check("ux: navigation tab shows cleanly", W.Options.tabs.navigation:IsShown() and not W.Options.tabs.appearance:IsShown())
    W.Options.SelectTab("questing")

    -- 8. Arrow right-click quick menu & World Map rounded stop tooltips
    W.Arrow:ShowMenu()
    check("ux: arrow right-click opens glass quick menu", W.Popups.menu and W.Popups.menu:IsShown())
    W.Popups:HideMenu()
    WorldMapFrame:Show()
    W.Route:Draw()
    local m1 = W.Route.marks and W.Route.marks[1]
    check("ux: route stop markers use circle texture and carry tooltip data",
        m1 and m1:IsShown() and m1.bg.texture == W.Skin.MEDIA .. "circle" and m1.tipTitle and m1.tipTitle:find("Stop 1", 1, true),
        m1 and tostring(m1.tipTitle))
    WorldMapFrame:Hide()

    -- clean up test quests
    for _, q in ipairs({ 19901, 19902 }) do
        MOCK.finish(q) MOCK.turnIn(q) MOCK.done[q] = nil MOCK.fire("QUEST_REMOVED", q)
    end
    settle()
end

-- Regression tests: going back to skipped / unfinished steps + never hijacking manual guide picks
do
    local G = W.Guide
    W:RegisterGuide{ id = "skipnext", title = "Next Zone (57-62)", faction = "", levels = { 57, 62 }, steps = "accept 19929\nturnin 19929\n" }
    W:RegisterGuide{ id = "skipback", title = "Skip Back Test", faction = "", levels = { 43, 53 }, next = "skipnext", steps = [[
accept 19921 |at 1423 20.0,20.0
goto 1423 25.0,25.0
complete 19921 |at 1423 30.0,30.0
turnin 19921 |at 1423 20.0,20.0
complete 19922 |at 1423 35.0,35.0
turnin 19922 |at 1423 20.0,20.0
]]}
    MOCK.addQuest(19921, "Unfinished A", { { text = "Mobs: 0/5", finished = false, numFulfilled = 0, numRequired = 5 } })
    MOCK.addQuest(19922, "Unfinished B", { { text = "Items: 0/3", finished = false, numFulfilled = 0, numRequired = 3 } })
    MOCK.fire("QUEST_ACCEPTED", 19921) MOCK.fire("QUEST_ACCEPTED", 19922)
    G:Activate("skipback") settle()
    G:Skip(1) settle()   -- skip goto -> now on complete 19921
    check("skipback: starts on complete 19921", cur() and cur().verb == "complete" and cur().quest == 19921)

    -- 1. Skip unfinished complete 19921 -> moves to complete 19922, turnin 19921 waits
    G:Skip(1) settle()
    check("skipback: skipping unfinished 19921 advances to 19922", cur() and cur().quest == 19922)
    check("skipback: skipped unfinished step appears in G:SkippedSteps()", #G:SkippedSteps() >= 1)

    -- 2. Clicking waitBtn ("Turn-in waiting: Unfinished A") jumps straight back to complete 19921!
    W.UI.panel:Show() W.UI:Render()
    check("skipback: waitBtn shown for waiting unfinished quest", W.UI.waitBtn:IsShown())
    W.UI.waitBtn:GetScript("OnClick")(W.UI.waitBtn) settle()
    check("skipback: clicking waiting notice returns to unfinished complete 19921",
        cur() and cur().verb == "complete" and cur().quest == 19921, cur() and (cur().verb .. " " .. tostring(cur().quest)))

    -- 3. Skip complete 19921, then press Back (<): returns straight to complete 19921 (even past goto/turnin)
    G:Skip(1) settle()
    G:Skip(-1) settle()
    check("skipback: Skip(-1) returns directly to skipped unfinished 19921",
        cur() and cur().verb == "complete" and cur().quest == 19921, cur() and (cur().verb .. " " .. tostring(cur().quest)))

    -- 4. Later + Skip(-1): returns to deferred quest
    G:Later(19921) settle()
    check("skipback: Later moves past 19921", cur() and cur().quest == 19922)
    G:Skip(-1) settle()
    check("skipback: Skip(-1) restores quest deferred with Later",
        cur() and cur().verb == "complete" and cur().quest == 19921, cur() and (cur().verb .. " " .. tostring(cur().quest)))

    -- 5. Footer N skipped link + OnwardSkipped popup Go back button
    G:Skip(1) settle()
    W.UI:Render()
    check("skipback: footer shows skipped link", W.UI.skippedBtn:IsShown() and W.UI.skippedBtn.text:GetText():find("skipped", 1, true))
    W.UI.skippedBtn:GetScript("OnClick")(W.UI.skippedBtn)
    check("skipback: clicking skipped link opens OnwardSkipped popup", W.Popups.skipWin and W.Popups.skipWin:IsShown())
    local sr = W.Popups.skipRows[1]
    for _, row in ipairs(W.Popups.skipRows) do if row:IsShown() and row.step and row.step.quest == 19921 then sr = row break end end
    sr.goBtn:GetScript("OnClick")(sr.goBtn) settle()
    check("skipback: popup Go back button jumps back to skipped 19921",
        cur() and cur().verb == "complete" and cur().quest == 19921, cur() and (cur().verb .. " " .. tostring(cur().quest)))
    W.Popups.skipWin:Hide()

    -- 6. Skipping the last open step auto-switches to next guide; Skip(-1) brings you back to previous guide & step
    G:Skip(1) settle()
    G:Skip(1) settle()   -- skips 19922 -> auto-switches away from skipback
    check("skipback: skipping last step auto-switched guide", G:Active().id ~= "skipback", G:Active().id)
    G:Skip(-1) settle()
    check("skipback: Skip(-1) after auto-switch returns to skipback & restores 19922",
        G:Active().id == "skipback" and cur() and cur().quest == 19922, G:Active().id .. " / " .. tostring(cur() and cur().quest))

    -- 7. Tanaris->Hinterlands bug: manually picking a partially-done guide whose last quest is turned in
    --    MUST stay on that guide and open its remaining undone quests (never auto-jump to another zone!)
    W:RegisterGuide{ id = "tanaris_repro", title = "Tanaris Repro (43-53)", faction = "", levels = { 43, 53 }, next = "skipnext", steps = [[
accept 19925
turnin 19925
accept 19926
turnin 19926
]]}
    MOCK.done[19926] = true   -- end quest already turned in, earlier quest 19925 still undone (50% progress)
    MOCK.level = 48
    G:Activate("tanaris_repro") settle()
    check("manual guide pick: stays on tanaris_repro instead of jumping to next/recommended guide",
        G:Active().id == "tanaris_repro", G:Active().id)
    check("manual guide pick: opens remaining undone quest behind frontier instead of Guide complete",
        cur() and cur().verb == "accept" and cur().quest == 19925, cur() and (cur().verb .. " " .. tostring(cur().quest)))

    -- clean up
    MOCK.done[19926] = nil
    for _, q in ipairs({ 19921, 19922 }) do
        MOCK.finish(q) MOCK.turnIn(q) MOCK.done[q] = nil MOCK.fire("QUEST_REMOVED", q)
    end
    settle()
end

-- Multi-choice quest turn-in: highlight highest vendor sell value reward
do
    local A = W.Auto
    local saved = {
        choices = MOCK.choices,
        GetQuestItemLink = GetQuestItemLink,
        GetQuestItemInfo = GetQuestItemInfo,
        GetItemInfo = C_Item.GetItemInfo,
        QuestInfoRewardsFrame = _G.QuestInfoRewardsFrame,
        QuestFrameRewardPanel = _G.QuestFrameRewardPanel,
    }
    local prices = { ["item:7001"] = 1200, ["item:7002"] = 300, ["item:7003"] = 500 }
    local links  = { [1] = "|Hitem:7001|h[Sword]|h", [2] = "|Hitem:7002|h[Potions]|h", [3] = "|Hitem:7003|h[Ring]|h" }
    local counts = { [1] = 1, [2] = 5, [3] = 1 }   -- choice 2: 5 * 300c = 1500c > 1200c!
    GetQuestItemLink = function(kind, i) return kind == "choice" and links[i] or nil end
    GetQuestItemInfo = function(kind, i) return "Item" .. i, 0, counts[i] or 1 end
    C_Item.GetItemInfo = function(link)
        local key = link and link:match("(item:%d+)")
        if not key or prices[key] == nil then return nil end
        return "Name", link, 2, 30, 25, "Armor", "Cloth", 1, "", 0, prices[key]
    end
    local btns = {}
    for i = 1, 3 do
        local b = CreateFrame("Button")
        b.type = "choice"
        b.GetID = function() return i end
        btns[i] = b
    end
    _G.QuestInfoRewardsFrame = { RewardButtons = btns }
    _G.QuestFrameRewardPanel = CreateFrame("Frame")
    _G.QuestFrameRewardPanel:Show()

    -- 1. Stack count * sell price wins (5 * 300c = 15s beats 1 * 12s)
    MOCK.choices = 3
    MOCK.fire("QUEST_COMPLETE") settle()
    local hl1 = A.rewardHighlights[1]
    check("reward highlight: picks highest total sell value (stack * unit price)",
        hl1 and hl1:IsShown() and hl1.choiceIndex == 2 and hl1.sellValue == 1500, hl1 and tostring(hl1.choiceIndex))
    check("reward highlight: formats price badge cleanly", hl1.text:GetText():find("15s", 1, true), hl1.text:GetText())
    check("reward highlight: only one overlay shown when no tie", not (A.rewardHighlights[2] and A.rewardHighlights[2]:IsShown()))

    -- 2. Tie highlights both winners
    prices["item:7001"] = 1500
    A:HighlightBestReward()
    check("reward highlight: ties highlight both winning choices",
        A.rewardHighlights[1]:IsShown() and A.rewardHighlights[2]:IsShown()
        and A.rewardHighlights[1].choiceIndex == 1 and A.rewardHighlights[2].choiceIndex == 2)

    -- 3. Async item cache: nil price initially, then GET_ITEM_INFO_RECEIVED refreshes highlight
    prices["item:7001"] = 100
    prices["item:7002"] = 100
    prices["item:7003"] = nil   -- uncached!
    A:HighlightBestReward()
    check("reward highlight: handles uncached item without error", A.rewardHighlights[1]:IsShown() and A.rewardHighlights[1].choiceIndex == 2)
    prices["item:7003"] = 25000   -- 2g 50s arrives asynchronously
    MOCK.fire("GET_ITEM_INFO_RECEIVED", 7003, true)
    check("reward highlight: refreshes on GET_ITEM_INFO_RECEIVED to new winner",
        A.rewardHighlights[1]:IsShown() and A.rewardHighlights[1].choiceIndex == 3 and A.rewardHighlights[1].sellValue == 25000,
        tostring(A.rewardHighlights[1].choiceIndex))
    check("reward highlight: formats gold & silver", A.rewardHighlights[1].text:GetText():find("2g", 1, true)
        and A.rewardHighlights[1].text:GetText():find("50s", 1, true), A.rewardHighlights[1].text:GetText())

    -- 4. Unsellable rewards (all 0c) highlight nothing
    prices["item:7001"], prices["item:7002"], prices["item:7003"] = 0, 0, 0
    A:HighlightBestReward()
    check("reward highlight: all 0c rewards highlight nothing", not A.rewardHighlights[1]:IsShown())

    -- 5. Option off disables highlight; QUEST_FINISHED clears highlight
    prices["item:7003"] = 25000
    W.db.highlightBestReward = false
    A:HighlightBestReward()
    check("reward highlight: setting off hides highlight", not A.rewardHighlights[1]:IsShown())
    W.db.highlightBestReward = true
    A:HighlightBestReward()
    check("reward highlight: re-enabled shows highlight", A.rewardHighlights[1]:IsShown())
    MOCK.fire("QUEST_FINISHED")
    check("reward highlight: QUEST_FINISHED clears highlight", not A.rewardHighlights[1]:IsShown())

    -- 6. DialogueUI support: Blizzard QuestFrameRewardPanel is hidden, DUIQuestFrame holds choice buttons
    _G.QuestFrameRewardPanel:Hide()
    local dui = CreateFrame("Frame")
    dui:Show()
    local duiBtns = {}
    for i = 1, 3 do
        local b = CreateFrame("Button", nil, dui)
        b.type = "choice"
        b.index = i
        b:Show()
        duiBtns[i] = b
    end
    dui.itemButtonPool = {
        ProcessActiveObjects = function(_, fn)
            for _, b in ipairs(duiBtns) do fn(b) end
        end
    }
    _G.DUIQuestFrame = dui
    prices["item:7001"], prices["item:7002"], prices["item:7003"] = 5000, nil, 12000
    A:HighlightBestReward()
    check("reward highlight (DialogueUI): highlights DialogueUI button even when Blizzard panel is hidden",
        A.rewardHighlights[1]:IsShown() and A.rewardHighlights[1]:GetParent() == duiBtns[3]
        and A.rewardHighlights[1].choiceIndex == 3)
    prices["item:7002"] = 31500   -- 5 * 31500 = 157500c
    MOCK.fire("GET_ITEM_INFO_RECEIVED", 7002, true)
    check("reward highlight (DialogueUI): refreshes on GET_ITEM_INFO_RECEIVED while DUIQuestFrame is shown",
        A.rewardHighlights[1]:IsShown() and A.rewardHighlights[1]:GetParent() == duiBtns[2]
        and A.rewardHighlights[1].choiceIndex == 2 and A.rewardHighlights[1].sellValue == 157500)
    MOCK.fire("QUEST_FINISHED")
    check("reward highlight (DialogueUI): clears on QUEST_FINISHED", not A.rewardHighlights[1]:IsShown())
    _G.DUIQuestFrame = nil

    -- restore mock state
    MOCK.choices = saved.choices
    GetQuestItemLink, GetQuestItemInfo, C_Item.GetItemInfo = saved.GetQuestItemLink, saved.GetQuestItemInfo, saved.GetItemInfo
    _G.QuestInfoRewardsFrame, _G.QuestFrameRewardPanel = saved.QuestInfoRewardsFrame, saved.QuestFrameRewardPanel
end

-- Neutral town flight masters (Gadgetzan, Booty Bay, Everlook): never point to opposite-faction FM
do
    local T = W.Travel
    local savedFaction = UnitFactionGroup
    local savedEnum = Enum.FlightPathFaction
    local savedTaxi = MOCK.taxi
    Enum.FlightPathFaction = { Horde = 0, Alliance = 1, Neutral = 2 }
    UnitFactionGroup = function() return "Horde" end

    -- 1. With n.faction present: Alliance Gadgetzan (0.51, 0.29) is ignored; Horde Gadgetzan (0.52, 0.25) is used
    MOCK.taxi = {
        { name = "Gadgetzan, Tanaris", nodeID = 39, state = 2, faction = 1, position = { x = 0.51, y = 0.29 } },
        { name = "Gadgetzan, Tanaris", nodeID = 40, state = 1, faction = 0, position = { x = 0.52, y = 0.25 } },
    }
    T:Refresh(true)
    local _, hwx, hwy = T.World(1415, 52, 25)
    local gNode
    for _, n in ipairs(T:KnownNodes(1)) do if n.name == "Gadgetzan, Tanaris" then gNode = n break end end
    check("neutral hub taxi: Horde uses Horde flight master when faction is set",
        gNode and math.abs(gNode.wx - hwx) < 1 and math.abs(gNode.wy - hwy) < 1, gNode and (gNode.wx .. "," .. gNode.wy))

    -- 2. Even without n.faction (fallback): an unreachable opposite-faction node listed first
    --    must NOT steal the coordinates of the reachable same-name node listed second
    MOCK.taxi = {
        { name = "Booty Bay, Stranglethorn", nodeID = 19, state = 2, position = { x = 0.27, y = 0.77 } },
        { name = "Booty Bay, Stranglethorn", nodeID = 18, state = 1, position = { x = 0.26, y = 0.73 } },
    }
    T:Refresh(true)
    local _, bwx, bwy = T.World(1415, 26, 73)
    local bNode
    for _, n in ipairs(T:KnownNodes(1)) do if n.name == "Booty Bay, Stranglethorn" then bNode = n break end end
    check("neutral hub taxi: reachable node overwrites unreachable same-name node coords even without faction field",
        bNode and math.abs(bNode.wx - bwx) < 1 and math.abs(bNode.wy - bwy) < 1, bNode and (bNode.wx .. "," .. bNode.wy))

    UnitFactionGroup = savedFaction
    Enum.FlightPathFaction = savedEnum
    MOCK.taxi = savedTaxi
    T:Refresh(true)
end

-- Travel audit: Forever sea lanes (Powderfuse<->Steamwheedle, Stormwind Harbor, Southshore),
-- cross-continent Hearthstone priority, and flight-aware crossing selection
do
    local T, WP, H = W.Travel, W.Waypoint, W.Hearth
    local savedPos = MOCK.pos
    local savedCont = MOCK.mapCont
    local savedOff = {}
    for k, v in pairs(MOCK.mapOffset) do savedOff[k] = v end
    local savedFaction = UnitFactionGroup
    local savedBind = GetBindLocation
    local savedStone = MOCK.bags[6948]
    local savedHome = W.cdb.home

    -- Place Eastern Kingdoms (cont 0) and Kalimdor (cont 1) maps in mock world space
    MOCK.mapOffset[2548] = 0       -- Riverglades (EK)
    MOCK.mapOffset[1434] = 4000    -- Stranglethorn Vale (EK, far south of Riverglades)
    MOCK.mapOffset[1453] = 2000    -- Stormwind City (EK)
    MOCK.mapOffset[1437] = 5000    -- Wetlands / Menethil (EK, far from Stormwind in this layout)
    MOCK.mapOffset[1424] = 7000    -- Hillsbrad / Southshore (EK)
    MOCK.mapOffset[1446] = 0       -- Tanaris (Kalimdor)
    MOCK.mapOffset[1413] = 4000    -- Barrens / Ratchet (Kalimdor, far north of Tanaris)
    MOCK.mapOffset[1439] = 6000    -- Darkshore / Auberdine (Kalimdor)
    MOCK.mapOffset[1445] = 2000    -- Dustwallow (Kalimdor)
    MOCK.mapCont = { [2548] = 0, [1434] = 0, [1453] = 0, [1437] = 0, [1424] = 0, [1446] = 1, [1413] = 1, [1439] = 1, [1445] = 1 }

    -- 1. Horde in Riverglades heading to Tanaris -> takes Powderfuse Port -> Steamwheedle Port boat!
    UnitFactionGroup = function() return "Horde" end
    MOCK.pos = { map = 2548, x = 0.65, y = 0.50 }
    MOCK.advance(4)
    local tc, tx, ty = T.World(1446, 52, 27)
    local cx = T:Crossing(tc, tx, ty)
    check("travel: Riverglades -> Tanaris uses Powderfuse Port -> Steamwheedle Port boat",
        cx and cx.from.name == "Powderfuse Port" and cx.to.name == "Steamwheedle Port",
        cx and (cx.from.name .. " -> " .. cx.to.name))

    -- 2. Alliance in Stormwind heading to Darkshore -> takes Stormwind Harbor -> Auberdine!
    UnitFactionGroup = function() return "Alliance" end
    MOCK.pos = { map = 1453, x = 0.30, y = 0.55 }
    MOCK.advance(4)
    local dc, dx, dy = T.World(1439, 36, 44)
    cx = T:Crossing(dc, dx, dy)
    check("travel: Stormwind -> Darkshore uses Stormwind Harbor -> Auberdine boat",
        cx and cx.from.name == "Stormwind Harbor" and cx.to.name == "Auberdine",
        cx and (cx.from.name .. " -> " .. cx.to.name))

    -- 3. Alliance in Hillsbrad heading to Darkshore -> takes Southshore -> Auberdine!
    MOCK.pos = { map = 1424, x = 0.51, y = 0.65 }
    MOCK.advance(4)
    cx = T:Crossing(dc, dx, dy)
    check("travel: Hillsbrad -> Darkshore uses Southshore -> Auberdine boat",
        cx and cx.from.name == "Southshore" and cx.to.name == "Auberdine",
        cx and (cx.from.name .. " -> " .. cx.to.name))

    -- 4. Cross-continent Hearthstone bound in Tanaris beats taking the boat from Riverglades!
    UnitFactionGroup = function() return "Horde" end
    MOCK.pos = { map = 2548, x = 0.65, y = 0.50 }
    MOCK.bags[6948] = 1
    GetBindLocation = function() return "Gadgetzan" end
    local gc, gx, gy = T.World(1446, 52, 27)
    W.cdb.home = { name = "Gadgetzan", cont = gc, wx = gx, wy = gy }
    W:RegisterGuide{ id = "crosshs", title = "Cross HS", faction = "", steps = "goto 1446 52.0,27.0 |note Gadgetzan\n" }
    MOCK.advance(4)
    W.Guide:Activate("crosshs") settle()
    local tgt = WP:ArrowTarget()
    check("travel: cross-continent Hearthstone ready on target continent beats taking a boat",
        tgt and tgt.hearth and tgt.label == "Hearth to Gadgetzan", tgt and tgt.label)

    -- Without hearthstone ready, falls back to Powderfuse Port -> Steamwheedle Port boat
    MOCK.bags[6948] = 0
    tgt = WP:ArrowTarget()
    check("travel: without Hearthstone, points directly to Powderfuse Port -> Steamwheedle Port boat",
        tgt and tgt.crossing and tgt.label == "Take the boat to Steamwheedle Port", tgt and tgt.label)

    -- 5. Undercity -> Quel'Danil Lodge (3286 yd) via Tarren Mill (1988 yd flight + 1893 yd ride)
    --    must recommend flying to Tarren Mill for both 60% mount (11.2) and 100% mount (14.0)!
    local savedMount = W.cdb.mountSpeed
    local savedTaxi2 = MOCK.taxi
    MOCK.mapCont = { [1415] = 0, [1425] = 0 }
    MOCK.mapOffset[1415] = 0
    MOCK.mapOffset[1425] = 0
    -- Use coordinates matching exact UC (1580, 240), Tarren Mill (-38, -915), Quel'Danil (285, -2780)
    -- In mock: wx = (1 - y) * 1000, wy = (1 - x) * 1000  =>  x = 1 - wy/1000, y = 1 - wx/1000
    MOCK.taxi = {
        { name = "Undercity, Tirisfal", nodeID = 71, slotIndex = 1, state = 0, position = { x = 1 - 0.240, y = 1 - 1.580 } },
        { name = "Tarren Mill, Hillsbrad", nodeID = 72, slotIndex = 2, state = 1, position = { x = 1 - (-0.915), y = 1 - (-0.038) } },
    }
    MOCK.pos = { map = 1415, x = 1 - 0.240, y = 1 - 1.580 }
    T:Refresh(true)
    for _, spd in ipairs({ 11.2, 14.0 }) do
        W.cdb.mountSpeed = spd
        MOCK.advance(4)
        local adv = T:Advice(1425, (1 - (-2.780)) * 100, (1 - 0.285) * 100)
        check("travel: Undercity -> Quel'Danil suggests flying to Tarren Mill at mount speed " .. spd,
            adv and adv.from.name == "Undercity, Tirisfal" and adv.to.name == "Tarren Mill, Hillsbrad",
            adv and (adv.from.name .. " -> " .. adv.to.name) or "nil")
    end
    W.cdb.mountSpeed = savedMount
    MOCK.taxi = savedTaxi2

    -- restore mock state
    MOCK.pos = savedPos
    MOCK.mapCont = savedCont
    MOCK.mapOffset = savedOff
    UnitFactionGroup = savedFaction
    GetBindLocation = savedBind
    MOCK.bags[6948] = savedStone
    W.cdb.home = savedHome
    MOCK.advance(4)
end

-- Objective context lines (what to kill / loot for non-obvious objectives) & Target live mob fallback
do
    local UI, QB, TG = W.UI, W.QuestieBridge, W.Target
    local savedObjSrc = QB.ObjectiveSource
    local savedQMobs = QB.QuestMobs
    local mockSrc = {}
    QB.ObjectiveSource = function(_, q, name) return mockSrc[q .. ":" .. (name or "")] end
    QB.QuestMobs = function(_, q)
        if q == 4496 then return { "Gorishi Wasp", "Gorishi Worker", "Gorishi Reaver" } end
        return {}
    end

    local step = { verb = "complete", quest = 4496 }
    mockSrc["4496:Gorishi Scent Gland"] = {
        kind = "item", label = "Gorishi Scent Gland",
        mobs = { "Gorishi Wasp", "Gorishi Worker", "Gorishi Reaver", "Gorishi Stinger", "Gorishi Tunneler" },
        objs = {}, vendors = {},
    }
    mockSrc["4496:Un'Goro Soil"] = {
        kind = "item", label = "Un'Goro Soil",
        mobs = {}, objs = { "Un'Goro Dirt Pile" }, vendors = {},
    }
    mockSrc["4496:Vessel of Tainted Blood"] = {
        kind = "item", label = "Vessel of Tainted Blood",
        mobs = {}, objs = { "Vessel of Tainted Blood" }, vendors = {},
    }
    mockSrc["4496:Mixed Relic"] = {
        kind = "item", label = "Mixed Relic",
        mobs = { "Hive Drone", "Hive Guard" }, objs = { "Strange Mound" }, vendors = {},
    }

    local c1 = UI.ObjectiveContext({ text = "Gorishi Scent Gland: 0/1", type = "item", finished = false }, step)
    check("obj context: lists top 3 mob droppers + overflow count",
        c1 == "Kill: Gorishi Wasp, Gorishi Worker, Gorishi Reaver (+2)", tostring(c1))

    local c2 = UI.ObjectiveContext({ text = "Un'Goro Soil: 0/5", type = "item", finished = false }, step)
    check("obj context: names ground object when different from item name",
        c2 == "Loot: Un'Goro Dirt Pile", tostring(c2))

    local c3 = UI.ObjectiveContext({ text = "Vessel of Tainted Blood: 0/10", type = "item", finished = false }, step)
    check("obj context: labels same-name ground object clearly",
        c3 == "Loot ground object", tostring(c3))

    local c4 = UI.ObjectiveContext({ text = "Mixed Relic: 0/3", type = "item", finished = false }, step)
    check("obj context: combines ground object and mob droppers",
        c4 == "Loot: Strange Mound  ·  or kill Hive Drone, Hive Guard", tostring(c4))

    local c5 = UI.ObjectiveContext({ text = "Highvale Scout slain: 1/15", type = "monster", finished = false }, step)
    check("obj context: stays silent on already-obvious slain objectives", c5 == nil, tostring(c5))

    local c6 = UI.ObjectiveContext({ text = "Gorishi Scent Gland: 1/1", type = "item", finished = true }, step)
    check("obj context: hides once objective is finished", c6 == nil, tostring(c6))

    -- Fallback without Questie: reads step.mobItem / step.mobs
    local stepBaked = { verb = "complete", quest = 99999, mobs = { "Sand Crawler", "Crusty Crab" }, mobItem = { ["Sand Crawler"] = "Crawler Meat" } }
    local c7 = UI.ObjectiveContext({ text = "Crawler Meat: 0/6", type = "item", finished = false }, stepBaked)
    check("obj context: falls back to guide |mobs Mob@Item when Questie has no entry",
        c7 == "Kill: Sand Crawler", tostring(c7))

    -- Target.MobsFor live Questie fallback when step has no |mobs (e.g. out-of-zone Bungle in the Jungle)
    MOCK.addQuest(4496, "Bungle in the Jungle", { { text = "Gorishi Scent Gland: 0/1", finished = false } })
    MOCK.fire("QUEST_LOG_UPDATE")
    local mobs = TG.MobsFor(step)
    check("target button: pulls live Questie droppers when step has no |mobs",
        #mobs == 3 and mobs[1] == "Gorishi Wasp", table.concat(mobs, ","))
    MOCK.turnIn(4496) MOCK.done[4496] = nil

    QB.ObjectiveSource = savedObjSrc
    QB.QuestMobs = savedQMobs
end

-- Arrow centered medallions for Hearthstone and cross-continent states (no orphaned corner checkmark)
do
    local A, WP = W.Arrow, W.Waypoint
    local savedAT = WP.ArrowTarget
    local upd = A.frame:GetScript("OnUpdate")

    WP.ArrowTarget = function()
        return { cont = 0, wx = 100, wy = 100, label = "Hearth to Revantusk Village", sub = "hearthstone is ready", hearth = true }
    end
    upd(A.frame, 0.1)
    check("arrow hearth: shows centered hearth medallion instead of rotating arrow or corner checkmark",
        A.statusIcon:IsShown() and A.statusIcon.texture:find("hearth", 1, true)
        and not A.tex:IsShown() and not A.modeIcon:IsShown() and A.dist.text == "use hearthstone",
        tostring(A.statusIcon.texture) .. " / " .. tostring(A.dist.text))

    WP.ArrowTarget = function()
        return { cont = 99, wx = 100, wy = 100, label = "Accept Fresh Meat", sub = "" }
    end
    upd(A.frame, 0.1)
    check("arrow other continent: shows centered globe medallion",
        A.statusIcon:IsShown() and A.statusIcon.texture:find("continent", 1, true)
        and not A.tex:IsShown() and not A.modeIcon:IsShown() and A.dist.text == "other continent",
        tostring(A.statusIcon.texture) .. " / " .. tostring(A.dist.text))

    WP.ArrowTarget = function()
        return { cont = 99, wx = 100, wy = 100, label = "Take the boat to Steamwheedle Port", sub = "", crossing = true }
    end
    upd(A.frame, 0.1)
    check("arrow cross-continent boat: shows centered boat medallion",
        A.statusIcon:IsShown() and A.statusIcon.texture:find("boat", 1, true) and not A.modeIcon:IsShown(),
        tostring(A.statusIcon.texture))

    WP.ArrowTarget = savedAT
    upd(A.frame, 0.1)
end

-- Mountain-wall flight routing: never land on the wrong side of an impassable border
-- (e.g. Hammerfall, Arathi for Shadra'Alor in The Hinterlands instead of Tarren Mill, Hillsbrad)
do
    local TR = W.Travel
    local savedTaxi, savedPos = MOCK.taxi, MOCK.pos
    local savedMount, savedNet, savedKnown = W.cdb.mountSpeed, W.cdb.taxiNet, W.cdb.taxi
    W.cdb.mountSpeed, W.cdb.taxiNet, W.cdb.taxi = nil, nil, {}

    check("zone graph: Arathi -> Hinterlands is not directly walkable (2 hops via Hillsbrad)",
        TR.ZoneHops(1417, 1425) == 2, tostring(TR.ZoneHops(1417, 1425)))
    check("zone graph: Hillsbrad -> Hinterlands is directly walkable (1 hop)",
        TR.ZoneHops(1424, 1425) == 1, tostring(TR.ZoneHops(1424, 1425)))
    check("zone graph: Teldrassil -> Darkshore has no walkable path (island)",
        TR.ZoneHops(1438, 1439) == nil, tostring(TR.ZoneHops(1438, 1439)))
    check("nodeZone: resolves flight point zone suffixes",
        TR.NodeZone({ name = "Hammerfall, Arathi" }) == 1417
        and TR.NodeZone({ name = "Tarren Mill, Hillsbrad" }) == 1424
        and TR.NodeZone({ name = "Revantusk Village, The Hinterlands" }) == 1425,
        tostring(TR.NodeZone({ name = "Hammerfall, Arathi" })))

    -- Reproduce Swamp of Sorrows -> Shadra'Alor (The Hinterlands 34, 75) on a clean continent (9):
    -- Hammerfall is only 800 yd straight-line across the mountain wall; Tarren Mill is twice as
    -- far straight-line (1600 yd) but connects directly into The Hinterlands.
    local savedCont = MOCK.mapCont
    MOCK.mapCont = { [1414] = 9, [1435] = 9, [1417] = 9, [1424] = 9, [1425] = 9 }
    MOCK.mapOffset[1414] = 0       -- continent taxi map for cont 9
    MOCK.mapOffset[1435] = 8000    -- Swamp of Sorrows: (50,50) -> world (500, -7500)
    MOCK.mapOffset[1417] = 800     -- Arathi Highlands: (34,75) -> world (250, -140)
    MOCK.mapOffset[1424] = -1600   -- Hillsbrad Foothills: (34,75) -> world (250, 2260)
    MOCK.mapOffset[1425] = 0       -- The Hinterlands: (34,75) -> world (250, 660)
    -- Taxi nodes sit on map 1414 (off=0): pos.x = 1 - wy/1000, pos.y = 1 - wx/1000
    MOCK.taxi = {
        { name = "Stonard, Swamp of Sorrows", nodeID = 401, slotIndex = 1, state = 0, position = { x = 8.5,   y = 0.50 } },
        { name = "Hammerfall, Arathi",        nodeID = 402, slotIndex = 2, state = 1, position = { x = 1.14,  y = 0.75 } },
        { name = "Tarren Mill, Hillsbrad",    nodeID = 403, slotIndex = 3, state = 1, position = { x = -1.26, y = 0.75 } },
    }
    MOCK.pos = { map = 1435, x = 0.50, y = 0.50 }
    TR:Refresh(true)
    MOCK.advance(4)
    local adv = TR:Advice(1425, 34, 75)
    check("mountain wall: Swamp of Sorrows -> Hinterlands flies to Tarren Mill (Hillsbrad), not Hammerfall (Arathi)",
        adv and adv.to and adv.to.name == "Tarren Mill, Hillsbrad",
        adv and adv.to and adv.to.name or "nil")

    -- Standing in Arathi (Hammerfall) with target across the mountain wall in The Hinterlands:
    -- flying to Hillsbrad beats riding around the mountains.
    MOCK.pos = { map = 1417, x = 0.34, y = 0.75 }
    MOCK.advance(4)
    adv = TR:Advice(1425, 34, 75)
    check("mountain wall: standing in Arathi advises flying to Hillsbrad instead of running into the ridge",
        adv and adv.from and adv.from.name == "Hammerfall, Arathi"
        and adv.to and adv.to.name == "Tarren Mill, Hillsbrad",
        adv and (adv.from.name .. " -> " .. adv.to.name) or "nil")

    MOCK.mapCont = savedCont
    MOCK.mapOffset[1414], MOCK.mapOffset[1435], MOCK.mapOffset[1417], MOCK.mapOffset[1424], MOCK.mapOffset[1425] = nil, nil, nil, nil, nil
    MOCK.taxi, MOCK.pos = savedTaxi, savedPos
    W.cdb.mountSpeed, W.cdb.taxiNet, W.cdb.taxi = savedMount, savedNet, savedKnown
    TR:Refresh(true)
    MOCK.advance(4)
end

-- External prerequisite full 3-stage guidance (e.g. Lack of Surplus part 2 gated on part 1 from earlier band)
do
    local G, WP, UI, QB, TG, QS = W.Guide, W.Waypoint, W.UI, W.QuestieBridge, W.Target, W.QuestState
    local savedStart, savedEnd, savedSpots, savedQMobs = QB.StartLocation, QB.EndLocation, WP.ObjectiveSpots, QB.QuestMobs
    local savedTitleFn = QS.Title
    local savedAutoAccept, savedAutoAll = W.db.autoAccept, W.db.autoAcceptAll
    W.db.autoAccept, W.db.autoAcceptAll = true, false

    QS.Title = function(self, q)
        if q == 698 or q == 699 then return "Lack of Surplus" end
        return savedTitleFn(self, q)
    end
    QB.StartLocation = function(self, q)
        if q == 698 then return { map = 1435, x = 44.7, y = 57.2, name = "Dar" } end
        return savedStart(self, q)
    end
    QB.EndLocation = function(self, q)
        if q == 698 then return { map = 1435, x = 81.4, y = 80.8, name = "Tok'Kar" } end
        return savedEnd(self, q)
    end
    WP.ObjectiveSpots = function(q)
        if q == 698 then return { { map = 1435, x = 62.0, y = 45.0, name = "Sawtooth Crocolisk" } } end
        return savedSpots(q)
    end
    QB.QuestMobs = function(self, q)
        if q == 698 then return { "Sawtooth Crocolisk" } end
        return savedQMobs(self, q)
    end

    W:RegisterGuide{ id = "extpre_test", title = "Swamp of Sorrows (43-55)", levels = { 43, 55 }, faction = "", steps = [[
accept 699 |at 1435 81.4,80.8 |npc Tok'Kar |preany 698
complete 699 |at 1435 70.0,60.0
turnin 699 |at 1435 81.4,80.8 |npc Tok'Kar
]]}
    G:Activate("extpre_test")
    settle()

    -- Stage 1: prerequisite 698 not yet accepted
    local step = G:Current()
    local pre, state = G:ExternalPrereq(step)
    check("ext prereq stage 1: detects external prereq accept state", pre == 698 and state == "accept", tostring(pre) .. "/" .. tostring(state))
    local m, x, y, who = WP:Resolve(step)
    check("ext prereq stage 1: waypoint points to prereq giver (Dar)", m == 1435 and who == "Dar", tostring(m) .. "/" .. tostring(who))
    check("ext prereq stage 1: UI shows PREREQUISITE · ACCEPT without red (after ...) text",
        UI.verbText.text == "PREREQUISITE  ·  ACCEPT" and UI.mainText.text == "Accept Lack of Surplus",
        tostring(UI.verbText.text) .. " | " .. tostring(UI.mainText.text))
    check("ext prereq stage 1: StepText matches prereq accept", UI.StepText(step) == "Accept Lack of Surplus", tostring(UI.StepText(step)))
    check("ext prereq stage 1: talk target is prereq giver", TG.TalkName(step) == "Dar", tostring(TG.TalkName(step)))

    -- Auto-accept picks up external prerequisite 698 when offered
    MOCK.calls = {}
    MOCK.questId = 698
    MOCK.fire("QUEST_DETAIL")
    check("ext prereq stage 1: Auto.lua auto-accepts the external prerequisite", called("AcceptQuest", 698))
    MOCK.questId = nil

    -- Stage 2: prerequisite 698 accepted, objectives unfinished
    MOCK.addQuest(698, "Lack of Surplus", { { text = "Unprepared Sawtooth Snapper: 1/6", finished = false } })
    MOCK.fire("QUEST_LOG_UPDATE")
    settle()
    pre, state = G:ExternalPrereq(step)
    check("ext prereq stage 2: transitions to complete state once prereq is accepted", pre == 698 and state == "complete", tostring(pre) .. "/" .. tostring(state))
    m, x, y = WP:Resolve(step)
    check("ext prereq stage 2: waypoint routes to prereq objective area", m == 1435 and math.abs(x - 62.0) < 0.1 and math.abs(y - 45.0) < 0.1,
        tostring(m) .. " " .. tostring(x) .. "," .. tostring(y))
    check("ext prereq stage 2: UI shows PREREQUISITE · COMPLETE",
        UI.verbText.text == "PREREQUISITE  ·  COMPLETE" and UI.mainText.text == "Lack of Surplus",
        tostring(UI.verbText.text) .. " | " .. tostring(UI.mainText.text))
    local mobs = TG.MobsFor(step)
    check("ext prereq stage 2: Target button targets prereq mobs", #mobs == 1 and mobs[1] == "Sawtooth Crocolisk", table.concat(mobs, ","))

    -- Stage 3: prerequisite 698 ready to turn in
    MOCK.log[698].objectives[1] = { text = "Unprepared Sawtooth Snapper: 6/6", finished = true }
    MOCK.fire("QUEST_LOG_UPDATE")
    settle()
    pre, state = G:ExternalPrereq(step)
    check("ext prereq stage 3: transitions to turnin state once prereq is ready", pre == 698 and state == "turnin", tostring(pre) .. "/" .. tostring(state))
    m, x, y, who = WP:Resolve(step)
    check("ext prereq stage 3: waypoint routes to prereq finisher (Tok'Kar)", m == 1435 and who == "Tok'Kar", tostring(m) .. "/" .. tostring(who))
    check("ext prereq stage 3: UI shows PREREQUISITE · TURN IN",
        UI.verbText.text == "PREREQUISITE  ·  TURN IN" and UI.mainText.text == "Turn in Lack of Surplus",
        tostring(UI.verbText.text) .. " | " .. tostring(UI.mainText.text))

    -- Stage 4: prerequisite 698 turned in -> step 699 unlocks cleanly
    MOCK.turnIn(698)
    MOCK.fire("QUEST_TURNED_IN", 698)
    MOCK.fire("QUEST_LOG_UPDATE")
    settle()
    pre, state = G:ExternalPrereq(step)
    local held = G:HeldReason(step)
    check("ext prereq stage 4: unlocks target accept step once prereq is turned in",
        pre == nil and held == nil and UI.verbText.text == "ACCEPT",
        tostring(pre) .. " / " .. tostring(held) .. " / " .. tostring(UI.verbText.text))

    MOCK.done[698] = nil
    QS.Title = savedTitleFn
    QB.StartLocation, QB.EndLocation, WP.ObjectiveSpots, QB.QuestMobs = savedStart, savedEnd, savedSpots, savedQMobs
    W.db.autoAccept, W.db.autoAcceptAll = savedAutoAccept, savedAutoAll
end

-- Strict faction filtering: Horde never sees Alliance guides (or Alliance-only zone guides),
-- fails closed when UnitFactionGroup is nil, falls back to race ID, and rejects saved opposite-faction guides on login
do
    local G, UI = W.Guide, W.UI
    local savedFaction = UnitFactionGroup
    local savedRace = MOCK.race
    local savedLevel = MOCK.level

    -- 1. Horde character: picker has zero Alliance guides and zero Dun Morogh / Westfall guides
    UnitFactionGroup = function() return "Horde" end
    MOCK.race = { "Orc", "Orc", 2 }
    MOCK.level = 20
    UI:RenderPicker()
    local badAlliance, badHome = nil, nil
    for _, def in ipairs(UI.pickerList or {}) do
        if def.faction == "Alliance" then badAlliance = def.id break end
        if def.zone == "Dun Morogh" or def.zone == "Westfall" or def.zone == "Elwynn Forest" or def.zone == "Loch Modan" then
            badHome = def.id break
        end
    end
    check("faction picker: Horde sees zero Alliance guides", badAlliance == nil, badAlliance)
    check("faction picker: Horde sees zero Alliance-only starter zones (Dun Morogh / Westfall)", badHome == nil, badHome)

    -- 2. Transient nil UnitFactionGroup at login: falls back to race ID (Orc=2 -> Horde, SkyborneHorde=96 -> Horde)
    UnitFactionGroup = function() return nil end
    MOCK.race = { "Orc", "Orc", 2 }
    check("PlayerFaction: falls back to race ID when UnitFactionGroup is nil (Orc -> Horde)", W.PlayerFaction() == "Horde", tostring(W.PlayerFaction()))
    MOCK.race = { "Skyborne", "Skyborne", 96 }
    check("PlayerFaction: Skyborne Horde (96) resolves to Horde even if UnitFactionGroup is nil", W.PlayerFaction() == "Horde", tostring(W.PlayerFaction()))
    MOCK.race = { "Unknown", "Unknown", 999 }
    check("FactionMatches: fails closed when neither faction nor race is known",
        not G:FactionMatches({ faction = "Alliance" }) and not G:FactionMatches({ faction = "Horde" }))

    -- 3. Saved opposite-faction guide in W.cdb.guide is dropped on PLAYER_LOGIN
    UnitFactionGroup = function() return "Horde" end
    MOCK.race = { "Orc", "Orc", 2 }
    W.cdb.guide = "elwynn-forest-a"
    MOCK.fire("PLAYER_LOGIN")
    settle()
    check("PLAYER_LOGIN: refuses to restore a saved Alliance guide for a Horde character",
        G:Active() and G:Active().id ~= "elwynn-forest-a", G:Active() and G:Active().id)

    -- 4. QuestieBridge.NpcFriendly distinguishes Horde/Alliance/Neutral NPCs
    check("QuestieBridge.NpcFriendly: rejects Alliance-only NPC for Horde, allows Horde & Neutral",
        not W.QuestieBridge.NpcFriendly({ friendlyToFaction = "A" })
        and W.QuestieBridge.NpcFriendly({ friendlyToFaction = "H" })
        and W.QuestieBridge.NpcFriendly({ friendlyToFaction = "AH" }))

    UnitFactionGroup = savedFaction
    MOCK.race = savedRace
    MOCK.level = savedLevel
end

check("no runtime errors", #MOCK.errors == 0, MOCK.errors[1])
print(("%d passed, %d failed"):format(pass, fail))
return fail
