-- DRAFT Stonetalon Mountains (Alliance) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stonetalon-mountains-a", title = "Stonetalon Mountains (21-32)", faction = "Alliance", zone = "Stonetalon Mountains",
  levels = { 21, 32 },
  steps = [[
accept 1071 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 17 |preany 1085  -- A Gnome's Respite (21)
accept 1093 |npc Ziz Fizziks |at 1442 59.0,62.6 |lvl 16  -- Super Reaper 6000 (21)
complete 1071 |at 1442 66.4,52.3 |mobs Venture Co. Logger;Venture Co. Deforester  -- A Gnome's Respite (21)
complete 1093 |at 1442 67.1,52.4 |mobs Venture Co. Operator@Super Reaper 6000 Blueprints  -- Super Reaper 6000 (21)
turnin 1071 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- A Gnome's Respite (21)
accept 1072 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 17 |preany 1071  -- An Old Colleague (21)
accept 1075 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 17 |preany 1071  -- A Scroll from Mauren (21)
turnin 1093 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Super Reaper 6000 (21)
accept 1094 |npc Ziz Fizziks |at 1442 59.0,62.6 |lvl 16 |preany 1093  -- Further Instructions (21)
accept 86574 |npc Night Elf Courier |at 1442 48.7,39.9 |value low |lvl 20  -- Stonetalon Supply Run (24)
complete 86574 |at 1442 51.8,43.2 |item 277915 |mobs Pridewing Wyvern@Stonetalon Supply Bundle;Pridewing Consort@Stonetalon Supply Bundle;Pridewing Skyhunter@Stonetalon Supply Bundle;Young Pridewing@Stonetalon Supply Bundle |value low  -- Stonetalon Supply Run (24)
accept 1057 |npc Keeper Albagorm |at 1442 37.1,8.1 |value mid |lvl 20  -- Reclaiming the Charred Vale (27)
turnin 86574 |npc Innkeeper Faralia |at 1442 35.8,5.7 |value low  -- Stonetalon Supply Run (24)
fly 1413 63.1,37.2 |from 1442 36.4,7.2 |npc The Barrens (Bragok)  -- flight master Teloren
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1455 55.5,47.7 |from 1434 27.5,77.8 |npc Ironforge (Gryth Thurden)  -- flight master Gyll
turnin 1072 |npc Lomac Gearstrip |at 1455 72.1,51.9  -- An Old Colleague (21)
accept 1073 |npc Lomac Gearstrip |at 1455 72.1,51.9 |lvl 17 |preany 1072  -- Ineptitude + Chemicals = Fun (21)
fly 1453 71.3,72.2 |from 1455 55.5,47.7 |npc Stormwind City (Dungar Longdrink)  -- flight master Gryth Thurden
turnin 1075 |npc Collin Mauren |at 1453 53.0,86.6  -- A Scroll from Mauren (21)
accept 1076 |npc Collin Mauren |at 1453 53.0,86.6 |lvl 17 |preany 1075  -- Devils in Westfall (21)
accept 1078 |npc Collin Mauren |at 1453 53.0,86.6 |value mid |lvl 17  -- Retrieval for Mauren (26)
fly 1436 56.5,52.6 |from 1453 71.3,72.2 |npc Westfall (Thor)  -- flight master Dungar Longdrink
complete 1076 |at 1436 45.6,49.3  -- Devils in Westfall (21)
fly 1434 27.5,77.8 |from 1436 56.5,52.6 |npc Stranglethorn Vale (Gyll)  -- flight master Thor
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1442 36.4,7.2 |from 1413 63.1,37.2 |npc Teloren  -- flight master Bragok
complete 1057 |at 1442 31.9,66.5 |mobs Bloodfury Harpy;Bloodfury Ambusher;Bloodfury Slayer;Bloodfury Roguefeather |value mid  -- Reclaiming the Charred Vale (27)
accept 79980 |npc Pocket Litter |at 1442 40.8,52.6 |lvl 14 |preany 79192  -- Scramble (24)
turnin 79980 |npc Mound of Dirt |at 1442 39.6,49.8  -- Scramble (24)
accept 79974 |npc Mound of Dirt |at 1442 39.6,49.8 |lvl 14 |preany 79980  -- Wet Job (32)
complete 1078 |at 1442 36.1,49.2 |areas 32.0,68.7:15;36.1,49.2:4 |mobs Scorched Basilisk@Crystalized Scales;Blackened Basilisk@Crystalized Scales;Singed Basilisk@Crystalized Scales |value mid  -- Retrieval for Mauren (26)
turnin 1057 |npc Keeper Albagorm |at 1442 37.1,8.1 |value mid  -- Reclaiming the Charred Vale (27)
accept 1059 |npc Keeper Albagorm |at 1442 37.1,8.1 |value mid |lvl 20 |preany 1057  -- Reclaiming the Charred Vale (27)
complete 1073 |at 1442 28.3,13.5 |areas 73.1,59.9:108;81.3,87.3:88;32.6,65.6:80;28.3,13.5:58 |mobs Venture Co. Logger@Minor Mana Potion;Windshear Digger@Minor Mana Potion;Venture Co. Deforester@Minor Mana Potion;Grimtotem Mercenary@Minor Mana Potion |need 2458:1:Elixir of Minor Fortitude:made with Alchemy, so buy it at the auction house or ask a crafter  -- Ineptitude + Chemicals = Fun (21)
fly 1413 63.1,37.2 |from 1442 36.4,7.2 |npc The Barrens (Bragok)  -- flight master Teloren
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1455 55.5,47.7 |from 1434 27.5,77.8 |npc Ironforge (Gryth Thurden)  -- flight master Gyll
turnin 1073 |npc Lomac Gearstrip |at 1455 72.1,51.9  -- Ineptitude + Chemicals = Fun (21)
accept 1074 |npc Lomac Gearstrip |at 1455 72.1,51.9 |lvl 17 |preany 1073  -- Ineptitude + Chemicals = Fun (21)
fly 1453 71.3,72.2 |from 1455 55.5,47.7 |npc Stormwind City (Dungar Longdrink)  -- flight master Gryth Thurden
turnin 1076 |npc Collin Mauren |at 1453 53.0,86.6  -- Devils in Westfall (21)
accept 1077 |npc Collin Mauren |at 1453 53.0,86.6 |lvl 17 |preany 1076  -- Special Delivery for Gaxim (21)
fly 1434 27.5,77.8 |from 1453 71.3,72.2 |npc Stranglethorn Vale (Gyll)  -- flight master Dungar Longdrink
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
turnin 1094 |npc Sputtervalve |at 1413 63.0,37.2  -- Further Instructions (21)
accept 1095 |npc Sputtervalve |at 1413 63.0,37.2 |lvl 16 |preany 1094  -- Further Instructions (27)
fly 1442 36.4,7.2 |from 1413 63.1,37.2 |npc Teloren  -- flight master Bragok
turnin 1074 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Ineptitude + Chemicals = Fun (21)
turnin 1077 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Special Delivery for Gaxim (21)
accept 1080 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 17 |pre 1077,1074  -- Covert Ops - Beta (22)
accept 1079 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 17 |pre 1077,1074  -- Covert Ops - Alpha (22)
accept 1092 |npc Piznik |at 1442 71.9,60.0 |lvl 17 |preany 1090  -- Gerenzo's Orders (22)
complete 1080 |at 1442 74.5,59.3 |item 5738  -- Covert Ops - Beta (22)
complete 1079 |at 1442 66.1,51.3 |item 5738  -- Covert Ops - Alpha (22)
turnin 1095 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Further Instructions (27)
accept 1096 |npc Ziz Fizziks |at 1442 59.0,62.6 |value low |lvl 16 |preany 1095  -- Gerenzo Wrenchwhistle (27)
turnin 1092 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Gerenzo's Orders (22)
turnin 1080 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Covert Ops - Beta (22)
turnin 1079 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Covert Ops - Alpha (22)
accept 1091 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 17 |pre 1079,1080  -- Kaela's Update (22)
turnin 1091 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Kaela's Update (22)
accept 1084 |npc Kaela Shadowspear |at 1442 59.9,66.8 |lvl 22 |preany 1091  -- Wounded Ancients (28)
accept 1083 |npc Kaela Shadowspear |at 1442 59.9,66.8 |lvl 20 |preany 1091  -- Enraged Spirits (26)
complete 1084 |at 1442 30.9,64.7 |mobs Charred Ancient@Corroded Shrapnel;Blackened Ancient@Corroded Shrapnel;Vengeful Ancient@Corroded Shrapnel  -- Wounded Ancients (28)
complete 1083 |at 1442 36.5,51.4 |areas 31.6,70.8:11;36.5,51.4:4 |mobs Rogue Flame Spirit@Smoldering Embers;Burning Destroyer@Smoldering Embers;Burning Ravager@Smoldering Embers  -- Enraged Spirits (26)
complete 1096 |at 1442 63.4,39.7 |mobs Gerenzo Wrenchwhistle@Gerenzo's Mechanical Arm |value low  -- Gerenzo Wrenchwhistle (27)
turnin 1096 |npc Ziz Fizziks |at 1442 59.0,62.6 |value low  -- Gerenzo Wrenchwhistle (27)
turnin 1084 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Wounded Ancients (28)
turnin 1083 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- Enraged Spirits (26)
accept 1082 |npc Kaela Shadowspear |at 1442 59.9,66.8 |lvl 17 |pre 1083,1084  -- Update for Sentinel Thenysil (22)
fly 1440 34.4,48.0 |from 1442 36.4,7.2 |npc Ashenvale (Daelyshia)  -- flight master Teloren
turnin 1082 |npc Sentinel Thenysil |at 1440 34.9,49.8  -- Update for Sentinel Thenysil (22)
accept 1081 |npc Sentinel Thenysil |at 1440 34.9,49.8 |lvl 17 |preany 1082  -- Reception from Tyrande (28)
turnin 1081 |npc Tyrande Whisperwind |at 1457 39.1,81.6  -- Reception from Tyrande (28)
turnin 1059 |npc Falfindel Waywarder |at 1444 89.6,46.6 |value mid  -- Reclaiming the Charred Vale (27)
fly 1413 63.1,37.2 |from 1444 89.5,45.9 |npc The Barrens (Bragok)  -- flight master Thyssiana
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1432 33.9,51.0 |from 1434 27.5,77.8 |npc Loch Modan (Thorgrum Borrelson)  -- flight master Gyll
turnin 79974 |npc Carved Figurine |at 1432 49.4,12.9  -- Wet Job (32)
fly 1453 71.3,72.2 |from 1432 33.9,51.0 |npc Stormwind City (Dungar Longdrink) |value mid  -- flight master Thorgrum Borrelson
turnin 1078 |npc Collin Mauren |at 1453 53.0,86.6 |value mid  -- Retrieval for Mauren (26)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   80001  Rekindle (40)
