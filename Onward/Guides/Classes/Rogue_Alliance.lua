-- GENERATED Rogue (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_rogue_alliance_rogue10", title = "Level 10 Rogue Trials", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 10, 10 },
  steps = [[
accept 2205 |npc Keryn Sylvius |at 1429 43.9,65.9  -- Seek out SI: 7 (10)
turnin 2205 |npc Master Mathias Shaw |at 1453 78.3,70.7  -- Seek out SI: 7 (10)
accept 2206 |npc Master Mathias Shaw |at 1453 78.3,70.7 |preany 2205  -- Snatch and Grab (10)
complete 2206 |at 1429 48.1,87.0 |mobs Defias Dockmaster  -- Snatch and Grab (10)
turnin 2206 |npc Master Mathias Shaw |at 1453 78.3,70.7  -- Snatch and Grab (10)
accept 2218 |npc Hogral Bakkan |at 1426 47.6,52.6  -- Road to Salvation (10)
turnin 2218 |npc Hulfdan Blackbeard |at 1455 52.0,14.8  -- Road to Salvation (10)
accept 2238 |npc Hulfdan Blackbeard |at 1455 52.0,14.8 |preany 2218  -- Simple Subterfugin' (10)
turnin 2238 |npc Onin MacHammar |at 1426 25.2,44.5  -- Simple Subterfugin' (10)
accept 2239 |npc Onin MacHammar |at 1426 25.2,44.5 |preany 2238  -- Onin's Report (10)
turnin 2239 |npc Hulfdan Blackbeard |at 1455 52.0,14.8  -- Onin's Report (10)
accept 2241 |npc Jannok Breezesong |at 1438 56.4,60.1  -- The Apple Falls (10)
turnin 2241 |npc Syurna |at 1457 37.0,21.9  -- The Apple Falls (10)
accept 2242 |npc Syurna |at 1457 37.0,21.9 |preany 2241  -- Destiny Calls (10)
complete 2242 |at 1438 37.1,22.8 |mobs Sethir the Ancient  -- Destiny Calls (10)
turnin 2242 |npc Syurna |at 1457 37.0,21.9  -- Destiny Calls (10)
]]}

Onward:RegisterGuide{
  id = "class_rogue_alliance_lockpick16", title = "Lockpicking: Alther's Mill", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 16, 20 },
  steps = [[
accept 2260 |npc Erion Shadewhisper |at 1457 34.5,25.9  -- Erion's Behest (16)
turnin 2260 |npc Renzik "The Shiv" |at 1453 78.3,71.1  -- Erion's Behest (16)
accept 2281 |npc Renzik "The Shiv" |at 1453 78.3,71.1  -- Redridge Rendezvous (16)
turnin 2281 |npc Lucius |at 1433 23.0,52.0  -- Redridge Rendezvous (16)
accept 2298 |npc Hulfdan Blackbeard |at 1455 52.0,14.8  -- Kingly Shakedown (16)
turnin 2298 |npc Renzik "The Shiv" |at 1453 78.3,71.1  -- Kingly Shakedown (16)
accept 2300 |npc Keryn Sylvius |at 1429 43.9,65.9  -- SI:7 (16)
turnin 2300 |npc Renzik "The Shiv" |at 1453 78.3,71.1  -- SI:7 (16)
accept 2282 |npc Lucius |at 1433 23.0,52.0 |preany 2281  -- Alther's Mill (20)
complete 2282 |at 1433 47.0,44.7 |item 5060  -- Alther's Mill (20)
turnin 2282 |npc Lucius |at 1433 23.0,52.0  -- Alther's Mill (20)
]]}

Onward:RegisterGuide{
  id = "class_rogue_alliance_poisons", title = "Poisons: Klaven's Tower", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 20, 24 },
  steps = [[
accept 2360 |npc Master Mathias Shaw |at 1453 78.3,70.7  -- Mathias and the Defias (20)
turnin 2360 |npc Agent Kearnen |at 1436 68.5,70.1  -- Mathias and the Defias (20)
accept 2359 |npc Agent Kearnen |at 1436 68.5,70.1 |group elite |preany 2360  -- Klaven's Tower (24)
complete 2359 |at 1436 70.4,73.9 |item 8046 |mobs Malformed Defias Drone |group elite  -- Klaven's Tower (24)
turnin 2359 |npc Master Mathias Shaw |at 1453 78.3,70.7 |group elite  -- Klaven's Tower (24)
accept 2607 |npc Master Mathias Shaw |at 1453 78.3,70.7 |group elite |preany 2359  -- The Touch of Zanzil (20)
turnin 2607 |npc Doc Mixilpixil |at 1453 80.1,69.9 |group elite  -- The Touch of Zanzil (20)
accept 2608 |npc Doc Mixilpixil |at 1453 80.1,69.9 |group elite |preany 2607  -- The Touch of Zanzil (20)
complete 2608 |at 1453 80.1,70.1 |group elite  -- The Touch of Zanzil (20)
turnin 2608 |npc Doc Mixilpixil |at 1453 80.1,69.9 |group elite  -- The Touch of Zanzil (20)
accept 2609 |npc Doc Mixilpixil |at 1453 80.1,69.9 |group elite |preany 2608  -- The Touch of Zanzil (20)
complete 2609 |at 1453 69.2,71.8 |mobs Bernard Gump;Edna Mullby;Eldraeith;Felicia Gump |group elite  -- The Touch of Zanzil (20)
turnin 2609 |npc Doc Mixilpixil |at 1453 80.1,69.9 |group elite  -- The Touch of Zanzil (20)
]]}

Onward:RegisterGuide{
  id = "class_rogue_alliance_xelthos", title = "The Horn of Xelthos & Eye of Bhossca", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 23, 35 },
  steps = [[
accept 78261 |npc Dead Drop |at 1421 47.1,71.0  -- The Horn of Xelthos (23)
turnin 78261 |npc Dead Drop |at 1421 47.1,71.0  -- The Horn of Xelthos (23)
accept 78270 |npc Veenix |at 1442 58.2,51.7  -- Goblin Lockpicks (23)
complete 78270 |at 1442 66.7,51.3 |mobs Venture Co. Logger;Venture Co. Deforester;Venture Co. Operator;Venture Co. Engineer  -- Goblin Lockpicks (23)
turnin 78270 |npc Veenix |at 1442 58.2,51.7  -- Goblin Lockpicks (23)
accept 78307 |npc Dead Drop |at 1421 47.1,71.0 |preany 78261  -- The Horn of Xelthos (23)
turnin 78307 |npc Dead Drop |at 1421 47.1,71.0  -- The Horn of Xelthos (23)
accept 78676 |npc Dead Drop |at 1421 47.1,71.0 |preany 78307  -- The Eye of Bhossca (35)
complete 78676  -- The Eye of Bhossca (35)
turnin 78676 |npc Dead Drop |at 1421 47.1,71.0  -- The Eye of Bhossca (35)
accept 78699 |npc Dead Drop |at 1421 47.1,71.0 |preany 78676  -- The Eye of Bhossca (35)
turnin 78699 |npc Dead Drop |at 1421 47.1,71.0  -- The Eye of Bhossca (35)
]]}

Onward:RegisterGuide{
  id = "class_rogue_alliance_ravenholdt", title = "Ravenholdt & Syndicate", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 24, 36 },
  steps = [[
accept 6681  -- The Manor, Ravenholdt (24)
complete 6681 |at 1424 78.6,17.8 |item 17125 |mobs Ravenholdt  -- The Manor, Ravenholdt (24)
turnin 6681 |npc Fahrad |at 1416 84.5,80.3  -- The Manor, Ravenholdt (24)
accept 96779 |npc Myrokos Silentform |at 1416 84.9,80.4 |preany 6681  -- Syndicate Sabotage (24)
complete 96779 |at 1424 79.8,45.8 |mobs Lord Tomas  -- Syndicate Sabotage (24)
turnin 96779 |npc Myrokos Silentform |at 1416 84.9,80.4  -- Syndicate Sabotage (24)
accept 96781 |npc Myrokos Silentform |at 1416 84.9,80.4 |preany 6681  -- What's the Big Idea? (36)
complete 96781 |at 1416 62.5,45.8 |mobs Barton  -- What's the Big Idea? (36)
turnin 96781 |npc Myrokos Silentform |at 1416 84.9,80.4  -- What's the Big Idea? (36)
accept 96782 |npc Myrokos Silentform |at 1416 84.9,80.4 |preany 96781  -- Covert Extraction (36)
complete 96782 |at 1416 38.5,57.9  -- Covert Extraction (36)
turnin 96782 |npc Myrokos Silentform |at 1416 84.9,80.4  -- Covert Extraction (36)
accept 96783 |npc Myrokos Silentform |at 1416 84.9,80.4 |preany 6681  -- A Way In (36)
turnin 96783 |npc Syndicate Footlocker |at 1417 32.3,26.6  -- A Way In (36)
accept 96784 |npc Syndicate Footlocker |at 1417 32.3,26.6 |preany 96783  -- Master of Disguise (36)
turnin 96784 |npc Anastasia Miller |at 1417 26.8,64.4  -- Master of Disguise (36)
accept 96785 |npc Anastasia Miller |at 1417 26.8,64.4 |preany 96784  -- Ain't No Telling (36)
complete 96785 |at 1417 29.5,65.0 |item 275706  -- Ain't No Telling (36)
turnin 96785 |npc Anastasia Miller |at 1417 26.8,64.4  -- Ain't No Telling (36)
accept 96786 |npc Anastasia Miller |at 1417 26.8,64.4 |preany 96785  -- The Syndicate Sting (36)
complete 96786 |at 1417 15.5,42.9  -- The Syndicate Sting (36)
turnin 96786 |npc Myrokos Silentform |at 1416 84.9,80.4  -- The Syndicate Sting (36)
]]}

Onward:RegisterGuide{
  id = "class_rogue_alliance_kazdor", title = "The Talisman of Kazdor", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 45, 50 },
  steps = [[
accept 80453 |npc Fahrad |at 1416 84.5,80.3  -- Best Laid Plans (50)
turnin 80453 |npc Zan Shivsproket |at 1416 86.0,80.0  -- Best Laid Plans (50)
accept 80454 |npc Zan Shivsproket |at 1416 86.0,80.0  -- One Last Drop (50)
turnin 80454 |npc Dead Drop |at 1421 47.1,71.0  -- One Last Drop (50)
accept 80455 |npc Dead Drop |at 1421 47.1,71.0  -- Biding Our Time (50)
turnin 80455 |npc Fahrad |at 1416 84.5,80.3  -- Biding Our Time (50)
accept 80526 |npc Fahrad |at 1416 84.5,80.3  -- Fool Me Twice (50)
turnin 80526 |npc Fahrad |at 1416 84.5,80.3  -- Fool Me Twice (50)
accept 80411 |npc Fahrad |at 1416 84.5,80.3 |preany 80526  -- The Talisman of Kazdor (50)
complete 80411  -- The Talisman of Kazdor (50)
turnin 80411 |npc Fahrad |at 1416 84.5,80.3  -- The Talisman of Kazdor (50)
]]}

Onward:RegisterGuide{
  id = "class_rogue_alliance_st50", title = "Sunken Temple: The Azure Key", kind = "class",
  class = "ROGUE", faction = "Alliance", levels = { 50, 52 },
  steps = [[
accept 8234 |npc Lord Jorach Ravenholdt |at 1416 86.0,78.9  -- Sealed Azure Bag (52)
complete 8234 |at 1447 45.2,25.6 |mobs Blackmaw Shaman;Timbermaw Shaman  -- Sealed Azure Bag (52)
turnin 8234 |npc Archmage Xylem |at 1447 29.2,40.2  -- Sealed Azure Bag (52)
accept 8235 |npc Archmage Xylem |at 1447 29.2,40.2 |preany 8234  -- Encoded Fragments (52)
complete 8235 |at 1447 71.7,29.5 |mobs Forest Ooze  -- Encoded Fragments (52)
turnin 8235 |npc Archmage Xylem |at 1447 29.2,40.2  -- Encoded Fragments (52)
accept 8236 |npc Archmage Xylem |at 1447 29.2,40.2 |group dungeon |preany 8235  -- The Azure Key (52)
complete 8236 |group dungeon  -- The Azure Key (52)
turnin 8236 |npc Lord Jorach Ravenholdt |at 1416 86.0,78.9 |group dungeon  -- The Azure Key (52)
]]}
