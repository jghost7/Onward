-- DRAFT Thousand Needles (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "thousand-needles-a-1", title = "Thousand Needles (30-38)", faction = "Alliance", zone = "Thousand Needles",
  levels = { 30, 38 },
  next = "thousand-needles-a-2",
  steps = [[
accept 1104 |npc Fizzle Brassbolts |at 1441 78.1,77.1 |lvl 28  -- Salt Flat Venom (30)
accept 1105 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |lvl 28  -- Hardened Shells (30)
accept 1110 |npc Kravel Koalbeard |at 1441 77.8,77.3 |value low |lvl 28  -- Rocket Car Parts (31)
accept 1111 |npc Kravel Koalbeard |at 1441 77.8,77.3 |lvl 30  -- Wharfmaster Dizzywig (36)
accept 5762 |npc Kravel Koalbeard |at 1441 77.8,77.3 |lvl 28  -- Hemet Nesingwary (31)
accept 1176 |npc Pozzik |at 1441 80.2,75.9 |lvl 29  -- Load Lightening (30)
complete 1176 |at 1441 83.0,70.7 |mobs Salt Flats Scavenger@Hollow Vulture Bone;Salt Flats Vulture@Hollow Vulture Bone  -- Load Lightening (30)
complete 1105 |at 1441 82.9,70.0 |areas 82.1,54.8:21;82.9,70.0:10 |mobs Sparkleshell Snapper@Hardened Tortoise Shell;Sparkleshell Tortoise@Hardened Tortoise Shell;Sparkleshell Borer@Hardened Tortoise Shell  -- Hardened Shells (30)
turnin 1176 |npc Pozzik |at 1441 80.2,75.9  -- Load Lightening (30)
accept 1178 |npc Pozzik |at 1441 80.2,75.9 |lvl 29 |preany 1176  -- Goblin Sponsorship (37)
accept 1175 |npc Trackmaster Zherin |at 1441 81.6,78.0 |value mid |lvl 28  -- A Bump in the Road (33)
complete 1175 |at 1441 77.8,87.8 |areas 77.8,87.8:31;77.4,59.6:16 |mobs Saltstone Basilisk;Saltstone Crystalhide;Saltstone Gazer |value mid  -- A Bump in the Road (33)
turnin 1178 |npc Gazlowe |at 1413 62.7,36.2  -- Goblin Sponsorship (37)
turnin 1111 |npc Wharfmaster Dizzywig |at 1413 63.4,38.5  -- Wharfmaster Dizzywig (36)
accept 1112 |npc Wharfmaster Dizzywig |at 1413 63.4,38.5 |lvl 30 |preany 1111  -- Parts for Kravel (36)
accept 1180 |npc Gazlowe |at 1413 62.7,36.2 |lvl 29 |preany 1178  -- Goblin Sponsorship (37)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 1180 |npc Wharfmaster Lozgil |at 1434 26.4,73.6  -- Goblin Sponsorship (37)
accept 1181 |npc Wharfmaster Lozgil |at 1434 26.4,73.6 |lvl 29 |preany 1180  -- Goblin Sponsorship (37)
turnin 5762 |npc Hemet Nesingwary |at 1434 35.7,10.8  -- Hemet Nesingwary (31)
turnin 1181 |npc Baron Revilgaz |at 1434 27.2,76.9  -- Goblin Sponsorship (37)
accept 1117 |npc Krazek |at 1434 26.9,77.2 |lvl 30 |preany 1116  -- Rumors for Kravel (36)
accept 1182 |npc Baron Revilgaz |at 1434 27.2,76.9 |lvl 29 |preany 1181  -- Goblin Sponsorship (37)
fly 1455 55.5,47.7 |from 1434 27.5,77.8 |npc Ironforge (Gryth Thurden)  -- flight master Gyll
accept 1179 |npc Pilot Longbeard |at 1455 72.7,94.0 |lvl 28  -- The Brassbolts Brothers (30)
accept 1137 |npc Martek the Exiled |at 1418 42.2,52.7 |lvl 28 |preany 1108  -- News for Fizzle (38)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1444 89.5,45.9 |from 1413 63.1,37.2 |npc Feralas (Thyssiana)  -- flight master Bragok
accept 98155 |npc Kristy Grant |at 1444 89.4,46.0 |lvl 24  -- Pristine Pesterhide Pelts (29)
complete 1104 |at 1441 71.8,73.0 |areas 76.1,55.1:14;71.8,73.0:13;86.6,68.6:9 |mobs Scorpid Reaver@Salty Scorpid Venom;Scorpid Terror@Salty Scorpid Venom;Vile Sting@Salty Scorpid Venom  -- Salt Flat Venom (30)
complete 1110 |at 1441 72.3,74.4 |areas 73.4,57.9:85;79.4,86.7:62;72.3,74.4:43;87.5,71.3:41 |value low  -- Rocket Car Parts (31)
turnin 1112 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Parts for Kravel (36)
accept 1114 |npc Kravel Koalbeard |at 1441 77.8,77.3 |lvl 30 |preany 1112  -- Delivery to the Gnomes (36)
turnin 1137 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- News for Fizzle (38)
turnin 1114 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- Delivery to the Gnomes (36)
turnin 1105 |npc Wizzle Brassbolts |at 1441 78.1,77.1  -- Hardened Shells (30)
turnin 1104 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- Salt Flat Venom (30)
accept 1106 |npc Fizzle Brassbolts |at 1441 78.1,77.1 |lvl 26 |pre 1104,1105  -- Martek the Exiled (35)
accept 1107 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group elite |lvl 28 |pre 1104,1105  -- Encrusted Tail Fins (35)
accept 1115 |npc Kravel Koalbeard |at 1441 77.8,77.3 |lvl 30 |preany 1114  -- The Rumormonger (36)
turnin 1110 |npc Kravel Koalbeard |at 1441 77.8,77.3 |value low  -- Rocket Car Parts (31)
turnin 1117 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Rumors for Kravel (36)
complete 1182 |at 1441 79.7,77.0 |mobs Goblin Racer;Goblin Drag Car  -- Goblin Sponsorship (37)
complete 98155 |at 1441 63.8,56.5 |areas 63.8,56.5:11;12.2,15.3:7;20.1,33.3:4 |mobs Pesterhide Snarler@Pristine Pesterhide Pelt  -- Pristine Pesterhide Pelts (29)
accept 1100 |at 1441 30.7,24.4 |note Starts from Henrig Lonebrow's Journal |startitem 5791 |lvl 29  -- Lonebrow's Journal (34)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
complete 1107 |at 1434 25.0,25.2 |group elite  -- Encrusted Tail Fins (35)
turnin 1182 |npc Baron Revilgaz |at 1434 27.2,76.9  -- Goblin Sponsorship (37)
turnin 1115 |npc Krazek |at 1434 26.9,77.2  -- The Rumormonger (36)
accept 1183 |npc Baron Revilgaz |at 1434 27.2,76.9 |lvl 29 |preany 1182  -- Goblin Sponsorship (37)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1444 89.5,45.9 |from 1413 63.1,37.2 |npc Feralas (Thyssiana)  -- flight master Bragok
turnin 98155 |npc Kristy Grant |at 1444 89.4,46.0  -- Pristine Pesterhide Pelts (29)
accept 98156 |npc Kristy Grant |at 1444 89.4,46.0 |lvl 24 |preany 98155  -- Packaged Pristine Pelts (29)
turnin 1100 |npc Falfindel Waywarder |at 1444 89.6,46.6  -- Lonebrow's Journal (34)
fly 1413 63.1,37.2 |from 1444 89.5,45.9 |npc The Barrens (Bragok)  -- flight master Thyssiana
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 1106 |npc Martek the Exiled |at 1418 42.2,52.7  -- Martek the Exiled (35)
turnin 98156 |npc Kimberly Grant |at 1453 37.8,64.8  -- Packaged Pristine Pelts (29)
fly 1434 27.5,77.8 |from 1453 71.3,72.2 |npc Stranglethorn Vale (Gyll)  -- flight master Dungar Longdrink
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
turnin 1179 |npc Wizzle Brassbolts |at 1441 78.1,77.1  -- The Brassbolts Brothers (30)
turnin 1107 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group elite  -- Encrusted Tail Fins (35)
turnin 1183 |npc Pozzik |at 1441 80.2,75.9  -- Goblin Sponsorship (37)
accept 1186 |npc Pozzik |at 1441 80.2,75.9 |lvl 29 |preany 1183  -- The Eighteenth Pilot (37)
turnin 1186 |npc Razzeric |at 1441 80.3,76.1  -- The Eighteenth Pilot (37)
turnin 1175 |npc Trackmaster Zherin |at 1441 81.6,78.0 |value mid  -- A Bump in the Road (33)
]]}
