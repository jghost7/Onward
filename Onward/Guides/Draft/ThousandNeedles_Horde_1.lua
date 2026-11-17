-- DRAFT Thousand Needles (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "thousand-needles-h-1", title = "Thousand Needles (26-36)", faction = "Horde", zone = "Thousand Needles",
  levels = { 26, 36 },
  next = "thousand-needles-h-2",
  steps = [[
home |npc Innkeeper Abeqwa |at 1441 46.1,51.5  -- set your hearthstone at the inn
accept 4767 |npc Elu |at 1441 44.9,48.9 |value low  -- Wind Rider (29)
turnin 4821 |npc Hagar Lightninghoof |at 1441 44.6,50.3  -- Alien Egg (26)
accept 4865 |npc Hagar Lightninghoof |at 1441 44.6,50.3  -- Serpent Wild (26)
accept 4821 |npc Hagar Lightninghoof |at 1441 44.6,50.3  -- Alien Egg (26)
accept 4841 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7 |value mid  -- Pacify the Centaur (25)
accept 5147 |npc Wanted Poster - Arnak Grimtotem |at 1441 46.0,50.9  -- WANTED: Arnak Grimtotem (29)
complete 4841 |at 1441 43.6,39.3 |mobs Galak Scout;Galak Wrangler;Galak Windchaser |value mid  -- Pacify the Centaur (25)
accept 4881 |at 1441 39.4,33.1 |note Starts from Assassination Note  -- Assassination Plot (28)
complete 1151 |at 1441 17.1,38.1 |mobs Rok'Alim the Pounder@Fragments of Rok'Alim |group elite  -- Test of Strength (30)
complete 4767 |at 1441 12.2,36.1 |value low  -- Wind Rider (29)
accept 5151 |npc Wizlo Bearingshiner |at 1441 21.4,32.5 |group elite  -- Hypercapacitor Gizmo (30)
turnin 4865 |npc Motega Firemane |at 1441 21.5,32.4  -- Serpent Wild (26)
accept 5062 |npc Motega Firemane |at 1441 21.5,32.4 |value low  -- Sacred Fire (27)
turnin 4881 |npc Kanati Greycloud |at 1441 21.2,32.1  -- Assassination Plot (28)
complete 5151 |at 1441 22.8,24.6 |item 12942 |mobs Enraged Panther@Hypercapacitor Gizmo |group elite  -- Hypercapacitor Gizmo (30)
accept 4542 |npc Brave Moonhorn |at 1441 32.2,22.2  -- Message to Freewind Post (25)
complete 5147 |at 1441 38.1,26.9 |mobs Arnak Grimtotem@Arnak's Hoof  -- WANTED: Arnak Grimtotem (29)
accept 1150 |npc Dorn Plainstalker |at 1441 54.0,41.5  -- Test of Endurance (30)
turnin 1151 |npc Dorn Plainstalker |at 1441 54.0,41.5 |group elite  -- Test of Strength (30)
accept 1152 |npc Dorn Plainstalker |at 1441 54.0,41.5 |group chain  -- Test of Lore (30)
turnin 4767 |npc Elu |at 1441 44.9,48.9 |value low  -- Wind Rider (29)
turnin 4841 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7 |value mid  -- Pacify the Centaur (25)
turnin 5147 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7  -- WANTED: Arnak Grimtotem (29)
turnin 4542 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7  -- Message to Freewind Post (25)
accept 5064 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7 |value mid  -- Grimtotem Spying (28)
accept 98069 |npc Jandia |at 1441 46.2,51.5  -- Stolen Freewind Supplies (30)
accept 98070 |npc Jandia |at 1441 46.2,51.5  -- Stop the Screeching (30)
complete 98069  -- Stolen Freewind Supplies (30)
turnin 98069 |npc Jandia |at 1441 46.2,51.5  -- Stolen Freewind Supplies (30)
complete 4821 |at 1441 52.3,55.2  -- Alien Egg (26)
accept 1147 |npc Moktar Krin |at 1441 67.6,63.9  -- The Swarm Grows (35)
accept 1110 |npc Kravel Koalbeard |at 1441 77.8,77.3 |value low  -- Rocket Car Parts (31)
accept 1105 |npc Wizzle Brassbolts |at 1441 78.1,77.1  -- Hardened Shells (30)
accept 1104 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- Salt Flat Venom (30)
accept 1175 |npc Trackmaster Zherin |at 1441 81.6,78.0 |value mid  -- A Bump in the Road (33)
accept 1176 |npc Pozzik |at 1441 80.2,75.9 |value low  -- Load Lightening (30)
complete 1176 |at 1441 83.0,70.7 |mobs Salt Flats Scavenger@Hollow Vulture Bone;Salt Flats Vulture@Hollow Vulture Bone |value low  -- Load Lightening (30)
complete 1105 |at 1441 79.9,66.3 |mobs Sparkleshell Snapper@Hardened Tortoise Shell;Sparkleshell Tortoise@Hardened Tortoise Shell;Sparkleshell Borer@Hardened Tortoise Shell  -- Hardened Shells (30)
complete 1104 |at 1441 77.0,67.7 |mobs Scorpid Reaver@Salty Scorpid Venom;Scorpid Terror@Salty Scorpid Venom;Vile Sting@Salty Scorpid Venom  -- Salt Flat Venom (30)
complete 1110 |at 1441 73.2,68.7 |value low  -- Rocket Car Parts (31)
complete 1175 |at 1441 79.1,70.1 |mobs Saltstone Basilisk;Saltstone Crystalhide;Saltstone Gazer |value mid  -- A Bump in the Road (33)
turnin 1176 |npc Pozzik |at 1441 80.2,75.9 |value low  -- Load Lightening (30)
turnin 1175 |npc Trackmaster Zherin |at 1441 81.6,78.0 |value mid  -- A Bump in the Road (33)
turnin 1104 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- Salt Flat Venom (30)
turnin 1105 |npc Wizzle Brassbolts |at 1441 78.1,77.1  -- Hardened Shells (30)
accept 1107 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group elite  -- Encrusted Tail Fins (35)
accept 1111 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Wharfmaster Dizzywig (36)
turnin 1110 |npc Kravel Koalbeard |at 1441 77.8,77.3 |value low  -- Rocket Car Parts (31)
complete 1147 |at 1441 68.1,86.0 |mobs Silithid Searcher;Silithid Hive Drone;Silithid Invader  -- The Swarm Grows (35)
accept 1148 |at 1441 68.1,86.0 |note Starts from Cracked Silithid Carapace  -- Parts of the Swarm (35)
complete 1148 |at 1441 68.1,86.0 |item 5877 |mobs Silithid Hive Drone@Silithid Heart;Silithid Invader@Silithid Heart;Silithid Searcher@Silithid Heart;Silithid Ravager@Silithid Heart  -- Parts of the Swarm (35)
complete 1150 |at 1441 26.0,55.6 |mobs Grenka Bloodscreech@Grenka's Claw  -- Test of Endurance (30)
complete 98070 |at 1441 26.7,52.1 |mobs Screeching Harpy;Screeching Roguefeather;Screeching Windcaller  -- Stop the Screeching (30)
fly 1442 45.1,59.8 |from 1441 45.1,49.1 |npc Stonetalon Mountains (Tharm)  -- flight master Nyse
turnin 1152 |npc Braug Dimspirit |at 1442 78.8,45.7 |group chain  -- Test of Lore (30)
accept 1159 |npc Braug Dimspirit |at 1442 78.8,45.7 |group chain  -- Test of Lore (30)
accept 1154 |npc Braug Dimspirit |at 1442 78.8,45.7 |group chain  -- Test of Lore (30)
fly 1413 51.5,30.3 |from 1442 45.1,59.8 |npc The Barrens (Devrak)  -- flight master Tharm
turnin 1148 |npc Korran |at 1413 51.1,29.6  -- Parts of the Swarm (35)
accept 1184 |npc Korran |at 1413 51.1,29.6  -- Parts of the Swarm (35)
turnin 1111 |npc Wharfmaster Dizzywig |at 1413 63.4,38.5  -- Wharfmaster Dizzywig (36)
accept 1112 |npc Wharfmaster Dizzywig |at 1413 63.4,38.5  -- Parts for Kravel (36)
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 1184 |npc Belgrom Rockmaul |at 1454 75.2,34.2  -- Parts of the Swarm (35)
fly 1434 32.5,29.4 |from 1454 45.1,63.9 |npc Stranglethorn Vale (Thysta)  -- flight master Doras
complete 1107 |at 1434 25.0,25.2 |group elite  -- Encrusted Tail Fins (35)
fly 1434 26.9,77.1 |from 1434 32.5,29.4 |npc Stranglethorn Vale (Gringer)  -- flight master Thysta
accept 1117 |npc Krazek |at 1434 26.9,77.2  -- Rumors for Kravel (36)
fly 1458 63.2,48.6 |from 1434 26.9,77.1 |npc Undercity (Michael Garrett)  -- flight master Gringer
accept 1394 |npc Parqual Fintallas |at 1458 57.8,65.4 |group chain  -- Final Passage (36)
turnin 1159 |npc Parqual Fintallas |at 1458 57.8,65.4 |group chain  -- Test of Lore (30)
fly 1440 73.2,61.6 |from 1458 63.2,48.6 |npc Ashenvale (Vhulgra)  -- flight master Michael Garrett
complete 1154 |at 1440 75.6,74.4 |group chain  -- Test of Lore (30)
fly 1441 45.1,49.1 |from 1440 73.2,61.6 |npc Nyse  -- flight master Vhulgra
turnin 5151 |npc Wizlo Bearingshiner |at 1441 21.4,32.5 |group elite  -- Hypercapacitor Gizmo (30)
complete 5062 |at 1441 35.6,36.2 |value low  -- Sacred Fire (27)
complete 5064 |at 1441 33.8,40.0 |value mid  -- Grimtotem Spying (28)
turnin 5064 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7 |value mid  -- Grimtotem Spying (28)
accept 5361 |npc Cliffwatcher Longhorn |at 1441 45.7,50.7  -- Family Tree (35)
turnin 98070 |npc Jandia |at 1441 46.2,51.5  -- Stop the Screeching (30)
turnin 1117 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Rumors for Kravel (36)
turnin 1112 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Parts for Kravel (36)
accept 1114 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Delivery to the Gnomes (36)
turnin 1107 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group elite  -- Encrusted Tail Fins (35)
turnin 1114 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- Delivery to the Gnomes (36)
accept 1106 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- Martek the Exiled (35)
accept 5762 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Hemet Nesingwary (31)
accept 1115 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- The Rumormonger (36)
turnin 1147 |npc Moktar Krin |at 1441 67.6,63.9  -- The Swarm Grows (35)
turnin 1150 |npc Dorn Plainstalker |at 1441 54.0,41.5  -- Test of Endurance (30)
turnin 1394 |npc Dorn Plainstalker |at 1441 54.0,41.5 |group chain  -- Final Passage (36)
accept 1151 |npc Dorn Plainstalker |at 1441 54.0,41.5 |group elite  -- Test of Strength (30)
fly 1442 45.1,59.8 |from 1441 45.1,49.1 |npc Stonetalon Mountains (Tharm)  -- flight master Nyse
turnin 1154 |npc Braug Dimspirit |at 1442 78.8,45.7 |group chain  -- Test of Lore (30)
fly 1418 4.0,44.8 |from 1442 45.1,59.8 |npc Badlands (Gorrik)  -- flight master Tharm
turnin 1106 |npc Martek the Exiled |at 1418 42.2,52.7  -- Martek the Exiled (35)
fly 1434 32.5,29.4 |from 1418 4.0,44.8 |npc Stranglethorn Vale (Thysta)  -- flight master Gorrik
turnin 5762 |npc Hemet Nesingwary |at 1434 35.7,10.8  -- Hemet Nesingwary (31)
fly 1434 26.9,77.1 |from 1434 32.5,29.4 |npc Stranglethorn Vale (Gringer)  -- flight master Thysta
turnin 1115 |npc Krazek |at 1434 26.9,77.2  -- The Rumormonger (36)
fly 1443 21.6,74.1 |from 1434 26.9,77.1 |npc Desolace (Thalon)  -- flight master Gringer
turnin 5361 |npc Nataka Longhorn |at 1443 55.4,55.8  -- Family Tree (35)
fly 1456 47.0,49.8 |from 1443 21.6,74.1 |npc Thunder Bluff (Tal) |value low  -- flight master Thalon
turnin 5062 |npc Magatha Grimtotem |at 1456 69.8,30.9 |value low  -- Sacred Fire (27)
]]}
