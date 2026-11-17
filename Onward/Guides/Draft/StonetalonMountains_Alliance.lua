-- DRAFT Stonetalon Mountains (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stonetalon-mountains-a", title = "Stonetalon Mountains (21-32)", faction = "Alliance", zone = "Stonetalon Mountains",
  levels = { 21, 32 },
  steps = [[
accept 1071 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- A Gnome's Respite (21)
accept 1093 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Super Reaper 6000 (21)
complete 1071 |at 1442 66.4,52.3 |mobs Venture Co. Logger;Venture Co. Deforester  -- A Gnome's Respite (21)
complete 1093 |at 1442 67.1,52.4 |mobs Venture Co. Operator  -- Super Reaper 6000 (21)
turnin 1093 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Super Reaper 6000 (21)
accept 1094 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Further Instructions (21)
turnin 1071 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- A Gnome's Respite (21)
accept 1075 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- A Scroll from Mauren (21)
accept 1072 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- An Old Colleague (21)
fly 1455 55.5,47.7 |from 1442 36.4,7.2 |npc Ironforge (Gryth Thurden)  -- flight master Teloren
turnin 1072 |npc Lomac Gearstrip |at 1455 72.1,51.9  -- An Old Colleague (21)
accept 1073 |npc Lomac Gearstrip |at 1455 72.1,51.9  -- Ineptitude + Chemicals = Fun (21)
fly 1413 63.1,37.2 |from 1455 55.5,47.7 |npc The Barrens (Bragok)  -- flight master Gryth Thurden
turnin 1094 |npc Sputtervalve |at 1413 63.0,37.2  -- Further Instructions (21)
accept 1095 |npc Sputtervalve |at 1413 63.0,37.2  -- Further Instructions (27)
fly 1453 71.3,72.2 |from 1413 63.1,37.2 |npc Stormwind City (Dungar Longdrink)  -- flight master Bragok
turnin 1075 |npc Collin Mauren |at 1453 53.0,86.6  -- A Scroll from Mauren (21)
accept 1076 |npc Collin Mauren |at 1453 53.0,86.6  -- Devils in Westfall (21)
accept 1078 |npc Collin Mauren |at 1453 53.0,86.6 |value mid  -- Retrieval for Mauren (26)
fly 1436 56.5,52.6 |from 1453 71.3,72.2 |npc Westfall (Thor)  -- flight master Dungar Longdrink
complete 1076 |at 1436 45.6,49.3  -- Devils in Westfall (21)
fly 1453 71.3,72.2 |from 1436 56.5,52.6 |npc Stormwind City (Dungar Longdrink)  -- flight master Thor
turnin 1076 |npc Collin Mauren |at 1453 53.0,86.6  -- Devils in Westfall (21)
accept 1077 |npc Collin Mauren |at 1453 53.0,86.6  -- Special Delivery for Gaxim (21)
fly 1442 36.4,7.2 |from 1453 71.3,72.2 |npc Teloren  -- flight master Dungar Longdrink
accept 1057 |npc Keeper Albagorm |at 1442 37.1,8.1 |value low  -- Reclaiming the Charred Vale (27)
accept 86574 |npc Night Elf Courier |at 1442 48.7,39.9 |value mid  -- Stonetalon Supply Run (24)
complete 86574 |at 1442 51.8,43.2 |mobs Pridewing Wyvern;Pridewing Consort;Pridewing Skyhunter;Young Pridewing |value mid  -- Stonetalon Supply Run (24)
complete 1073 |at 1442 62.7,55.3 |mobs Venture Co. Logger;Windshear Digger;Venture Co. Deforester;Grimtotem Mercenary  -- Ineptitude + Chemicals = Fun (21)
accept 79980 |npc Pocket Litter |at 1442 40.8,52.6  -- Scramble (24)
turnin 79980 |npc Mound of Dirt |at 1442 39.6,49.8  -- Scramble (24)
accept 79974 |npc Mound of Dirt |at 1442 39.6,49.8  -- Wet Job (32)
fly 1455 55.5,47.7 |from 1442 36.4,7.2 |npc Ironforge (Gryth Thurden)  -- flight master Teloren
turnin 1073 |npc Lomac Gearstrip |at 1455 72.1,51.9  -- Ineptitude + Chemicals = Fun (21)
accept 1074 |npc Lomac Gearstrip |at 1455 72.1,51.9  -- Ineptitude + Chemicals = Fun (21)
fly 1442 36.4,7.2 |from 1455 55.5,47.7 |npc Teloren  -- flight master Gryth Thurden
turnin 1077 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Special Delivery for Gaxim (21)
turnin 1074 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Ineptitude + Chemicals = Fun (21)
accept 1079 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Covert Ops - Alpha (22)
accept 1080 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Covert Ops - Beta (22)
turnin 1095 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Further Instructions (27)
accept 1096 |npc Ziz Fizziks |at 1442 59.0,62.6 |value mid  -- Gerenzo Wrenchwhistle (27)
complete 1096 |at 1442 64.5,40.2 |mobs Gerenzo Wrenchwhistle |value mid  -- Gerenzo Wrenchwhistle (27)
complete 1079 |at 1442 66.1,51.3  -- Covert Ops - Alpha (22)
complete 1080 |at 1442 74.5,59.3  -- Covert Ops - Beta (22)
accept 1092 |npc Piznik |at 1442 71.9,60.0  -- Gerenzo's Orders (22)
turnin 1080 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Covert Ops - Beta (22)
turnin 1079 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Covert Ops - Alpha (22)
accept 1091 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Kaela's Update (22)
turnin 1091 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Kaela's Update (22)
accept 1083 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Enraged Spirits (26)
accept 1084 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Wounded Ancients (28)
complete 1078 |at 1442 32.7,67.4 |mobs Scorched Basilisk;Blackened Basilisk;Singed Basilisk |value mid  -- Retrieval for Mauren (26)
complete 1057 |at 1442 31.9,66.5 |mobs Bloodfury Harpy;Bloodfury Ambusher;Bloodfury Slayer;Bloodfury Roguefeather |value low  -- Reclaiming the Charred Vale (27)
complete 1084 |at 1442 30.9,64.7 |mobs Charred Ancient;Blackened Ancient;Vengeful Ancient  -- Wounded Ancients (28)
complete 1083 |at 1442 34.1,63.7 |mobs Rogue Flame Spirit;Burning Destroyer;Burning Ravager  -- Enraged Spirits (26)
turnin 1083 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Enraged Spirits (26)
turnin 1084 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Wounded Ancients (28)
accept 1082 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Update for Sentinel Thenysil (22)
turnin 1092 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Gerenzo's Orders (22)
turnin 1096 |npc Ziz Fizziks |at 1442 59.0,62.6 |value mid  -- Gerenzo Wrenchwhistle (27)
turnin 1057 |npc Keeper Albagorm |at 1442 37.1,8.1 |value low  -- Reclaiming the Charred Vale (27)
accept 1059 |npc Keeper Albagorm |at 1442 37.1,8.1 |value low  -- Reclaiming the Charred Vale (27)
turnin 86574 |npc Innkeeper Faralia |at 1442 35.8,5.7 |value mid  -- Stonetalon Supply Run (24)
fly 1432 33.9,51.0 |from 1442 36.4,7.2 |npc Loch Modan (Thorgrum Borrelson)  -- flight master Teloren
turnin 79974 |npc Carved Figurine |at 1432 49.4,12.9  -- Wet Job (32)
fly 1453 71.3,72.2 |from 1432 33.9,51.0 |npc Stormwind City (Dungar Longdrink) |value mid  -- flight master Thorgrum Borrelson
turnin 1078 |npc Collin Mauren |at 1453 53.0,86.6 |value mid  -- Retrieval for Mauren (26)
fly 1440 34.4,48.0 |from 1453 71.3,72.2 |npc Ashenvale (Daelyshia)  -- flight master Dungar Longdrink
turnin 1082 |npc Sentinel Thenysil |at 1440 34.9,49.8  -- Update for Sentinel Thenysil (22)
accept 1081 |npc Sentinel Thenysil |at 1440 34.9,49.8  -- Reception from Tyrande (28)
turnin 1081 |npc Tyrande Whisperwind |at 1457 39.1,81.6  -- Reception from Tyrande (28)
turnin 1059 |npc Falfindel Waywarder |at 1444 89.6,46.6 |value low  -- Reclaiming the Charred Vale (27)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   80001  Rekindle (40)
