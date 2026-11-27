-- GENERATED Rogue (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_rogue_horde_rogue10", title = "Level 10 Rogue Trials", kind = "class",
  class = "ROGUE", faction = "Horde", race = "Orc,Scourge,Troll", levels = { 10, 13 },
  steps = [[
accept 1886 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge  -- The Deathstalkers (13)
complete 1886 |at 1421 49.7,32.2 |mobs Astor Hadren |race Scourge  -- The Deathstalkers (13)
turnin 1886 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge  -- The Deathstalkers (13)
accept 1898 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge |preany 1886  -- The Deathstalkers (13)
turnin 1898 |npc Andron Gant |at 1458 54.8,76.3 |race Scourge  -- The Deathstalkers (13)
accept 1899 |npc Andron Gant |at 1458 54.8,76.3 |race Scourge |preany 1898  -- The Deathstalkers (13)
complete 1899 |at 1458 55.4,77.0 |race Scourge  -- The Deathstalkers (13)
turnin 1899 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge  -- The Deathstalkers (13)
accept 1978 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge |preany 1899  -- The Deathstalkers (13)
turnin 1978 |npc Varimathras |at 1458 56.2,92.2 |race Scourge  -- The Deathstalkers (13)
accept 1963 |npc Therzok |at 1454 42.7,53.5 |race Orc,Troll  -- The Shattered Hand (13)
complete 1963 |at 1413 63.1,44.3 |mobs Tazan |race Orc,Troll  -- The Shattered Hand (13)
turnin 1963 |npc Therzok |at 1454 42.7,53.5 |race Orc,Troll  -- The Shattered Hand (13)
accept 1858 |npc Therzok |at 1454 42.7,53.5 |race Orc,Troll |preany 1963  -- The Shattered Hand (13)
complete 1858 |item 7209 |race Orc,Troll  -- The Shattered Hand (13)
turnin 1858 |npc Therzok |at 1454 42.7,53.5 |race Orc,Troll  -- The Shattered Hand (13)
]]}

Onward:RegisterGuide{
  id = "class_rogue_horde_lockpick16", title = "Lockpicking: Plundering the Plunderers", kind = "class",
  class = "ROGUE", faction = "Horde", levels = { 16, 20 },
  steps = [[
accept 1998 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge  -- Fenwick Thatros (16)
complete 1998 |at 1421 59.6,33.9 |mobs Fenwick Thatros |race Scourge  -- Fenwick Thatros (16)
turnin 1998 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge  -- Fenwick Thatros (16)
accept 2378 |npc Mennet Carkad |at 1458 83.5,69.1 |exclusive 2380  -- Find the Shattered Hand (16)
turnin 2378 |npc Shenthul |at 1454 43.0,53.7  -- Find the Shattered Hand (16)
accept 2379 |npc Shenthul |at 1454 43.0,53.7  -- Zando'zan (16)
turnin 2379 |npc Zando'zan |at 1454 42.7,53.0  -- Zando'zan (16)
accept 2382 |npc Zando'zan |at 1454 42.7,53.0 |preany 2379  -- Wrenix of Ratchet (16)
turnin 2382 |npc Wrenix the Wretched |at 1413 63.1,36.3  -- Wrenix of Ratchet (16)
accept 2381 |npc Wrenix the Wretched |at 1413 63.1,36.3 |preany 2382  -- Plundering the Plunderers (18)
complete 2381 |at 1413 64.8,45.5 |mobs Polly  -- Plundering the Plunderers (18)
turnin 2381 |npc Wrenix the Wretched |at 1413 63.1,36.3  -- Plundering the Plunderers (18)
accept 1999 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge |preany 1998  -- Tools of the Trade (20)
complete 1999 |at 1421 63.7,65.2 |race Scourge  -- Tools of the Trade (20)
turnin 1999 |npc Mennet Carkad |at 1458 83.5,69.1 |race Scourge  -- Tools of the Trade (20)
]]}

Onward:RegisterGuide{
  id = "class_rogue_horde_poisons", title = "Poisons: Mission Possible", kind = "class",
  class = "ROGUE", faction = "Horde", levels = { 20, 26 },
  steps = [[
accept 2460 |npc Shenthul |at 1454 43.0,53.7  -- The Shattered Salute (20)
complete 2460 |at 1454 43.0,53.7 |mobs Shenthul  -- The Shattered Salute (20)
turnin 2460 |npc Shenthul |at 1454 43.0,53.7  -- The Shattered Salute (20)
accept 2458 |npc Shenthul |at 1454 43.0,53.7 |preany 2460  -- Deep Cover (20)
turnin 2458 |npc Taskmaster Fizzule |at 1413 55.4,5.6  -- Deep Cover (20)
accept 2478 |npc Taskmaster Fizzule |at 1413 55.4,5.6 |group elite |preany 2458  -- Mission: Possible But Not Probable (24)
complete 2478 |at 1413 54.7,5.7 |mobs Venture Co. Lookout;Mutated Venture Co. Drone;Venture Co. Patroller;Foreman Silixiz |group elite  -- Mission: Possible But Not Probable (24)
turnin 2478 |npc Shenthul |at 1454 43.0,53.7 |group elite  -- Mission: Possible But Not Probable (24)
accept 2479 |npc Shenthul |at 1454 43.0,53.7 |group elite |preany 2478  -- Hinott's Assistance (26)
turnin 2479 |npc Serge Hinott |at 1424 61.6,19.2 |group elite  -- Hinott's Assistance (26)
accept 2480 |npc Serge Hinott |at 1424 61.6,19.2 |group elite |preany 2479  -- Hinott's Assistance (20)
complete 2480 |at 1424 61.6,19.2 |group elite  -- Hinott's Assistance (20)
turnin 2480 |npc Serge Hinott |at 1424 61.6,19.2 |group elite  -- Hinott's Assistance (20)
]]}

Onward:RegisterGuide{
  id = "class_rogue_horde_xelthos", title = "The Horn of Xelthos & Eye of Bhossca", kind = "class",
  class = "ROGUE", faction = "Horde", levels = { 23, 35 },
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
  id = "class_rogue_horde_ravenholdt", title = "Ravenholdt & Syndicate", kind = "class",
  class = "ROGUE", faction = "Horde", levels = { 24, 36 },
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
  id = "class_rogue_horde_kazdor", title = "The Talisman of Kazdor", kind = "class",
  class = "ROGUE", faction = "Horde", levels = { 45, 50 },
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
  id = "class_rogue_horde_st50", title = "Sunken Temple: The Azure Key", kind = "class",
  class = "ROGUE", faction = "Horde", levels = { 50, 52 },
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
