-- DRAFT Stonetalon Mountains (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stonetalon-mountains-h-2", title = "Stonetalon Mountains (26-32)", faction = "Horde", zone = "Stonetalon Mountains",
  levels = { 26, 32 },
  steps = [[
home |npc Innkeeper Jayka |at 1442 47.5,62.1  -- set your hearthstone at the inn
accept 1088 |npc Braelyn Firehand |at 1442 45.9,60.4  -- Ordanus (29)
accept 5881 |npc Maggran Earthbinder |at 1442 47.2,61.2  -- Calling in the Reserves (28)
accept 86576 |npc Maggran Earthbinder |at 1442 47.2,61.2 |value mid  -- Bloodfury Trinkets (26)
accept 6282 |npc Maggran Earthbinder |at 1442 47.2,61.2  -- Harpies Threaten (26)
complete 86576 |at 1442 32.2,64.9 |mobs Bloodfury Windcaller@Glittering Sunstone;Bloodfury Storm Witch@Glittering Sunstone;Bloodfury Harpy@Glittering Sunstone;Bloodfury Roguefeather@Glittering Sunstone |value mid  -- Bloodfury Trinkets (26)
complete 6282 |at 1442 31.9,66.5 |mobs Bloodfury Harpy;Bloodfury Ambusher;Bloodfury Slayer;Bloodfury Roguefeather  -- Harpies Threaten (26)
fly 1413 63.1,37.2 |from 1442 45.1,59.8 |npc The Barrens (Bragok)  -- flight master Tharm
accept 1095 |npc Sputtervalve |at 1413 63.0,37.2  -- Further Instructions (27)
fly 1440 73.2,61.6 |from 1413 63.1,37.2 |npc Ashenvale (Vhulgra)  -- flight master Bragok
complete 1088 |at 1440 62.0,51.4  -- Ordanus (29)
fly 1441 45.1,49.1 |from 1440 73.2,61.6 |npc Thousand Needles (Nyse)  -- flight master Vhulgra
turnin 5881 |npc Grish Longrunner |at 1441 31.9,21.7  -- Calling in the Reserves (28)
fly 1456 47.0,49.8 |from 1441 45.1,49.1 |npc Thunder Bluff (Tal) |value low  -- flight master Nyse
accept 97538 |npc Tah Winterhoof |at 1456 54.1,47.0 |value low  -- Pigments for Paints (26)
fly 1442 45.1,59.8 |from 1456 47.0,49.8 |npc Tharm |value low  -- flight master Tal
accept 1058 |npc Witch Doctor Jin'Zil |at 1442 74.5,97.9 |value mid  -- Jin'Zil's Forest Magic (26)
turnin 1095 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Further Instructions (27)
accept 1096 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Gerenzo Wrenchwhistle (27)
turnin 6282 |npc Maggran Earthbinder |at 1442 47.2,61.2  -- Harpies Threaten (26)
accept 6283 |npc Maggran Earthbinder |at 1442 47.2,61.2 |group elite  -- Bloodfury Bloodline (26)
turnin 1088 |npc Braelyn Firehand |at 1442 45.9,60.4  -- Ordanus (29)
accept 1089 |npc Braelyn Firehand |at 1442 45.9,60.4  -- The Den (29)
complete 6283 |at 1442 30.8,61.9 |mobs Bloodfury Ripper@Bloodfury Ripper's Remains |group elite  -- Bloodfury Bloodline (26)
accept 79974 |npc Mound of Dirt |at 1442 39.6,49.8  -- Wet Job (32)
complete 1089 |at 1442 28.0,13.8  -- The Den (29)
turnin 1089 |npc Talon Den Hoard |at 1442 26.6,10.9  -- The Den (29)
complete 1058 |at 1442 38.2,15.4 |mobs Antlered Courser@Courser Eye;Sap Beast@Stonetalon Sap;Twilight Runner@Twilight Whisker;Great Courser@Courser Eye |value mid  -- Jin'Zil's Forest Magic (26)
complete 97538 |at 1442 47.6,40.3 |value low  -- Pigments for Paints (26)
complete 1096 |at 1442 64.5,40.2 |mobs Gerenzo Wrenchwhistle@Gerenzo's Mechanical Arm  -- Gerenzo Wrenchwhistle (27)
turnin 1096 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Gerenzo Wrenchwhistle (27)
turnin 1058 |npc Witch Doctor Jin'Zil |at 1442 74.5,97.9 |value mid  -- Jin'Zil's Forest Magic (26)
turnin 86576 |npc Mor'rogal |at 1442 47.2,64.0 |value mid  -- Bloodfury Trinkets (26)
turnin 6283 |npc Maggran Earthbinder |at 1442 47.2,61.2 |group elite  -- Bloodfury Bloodline (26)
fly 1456 47.0,49.8 |from 1442 45.1,59.8 |npc Thunder Bluff (Tal)  -- flight master Tharm
turnin 97538 |npc Tah Winterhoof |at 1456 54.1,47.0 |value low  -- Pigments for Paints (26)
turnin 79974 |npc Carved Figurine |at 1432 49.4,12.9  -- Wet Job (32)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   80001  Rekindle (40)
--   97446  Your First Riding Kodo (40)
