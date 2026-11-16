-- DRAFT Stonetalon Mountains (Horde) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stonetalon-mountains-h-1", title = "Stonetalon Mountains (18-25)", faction = "Horde", zone = "Stonetalon Mountains",
  levels = { 18, 25 },
  next = "stonetalon-mountains-h-2",
  steps = [[
accept 6461 |npc Xen'Zilla |at 1442 71.2,95.0 |value mid  -- Blood Feeders (19)
accept 6284 |npc Wanted Poster: Besseleth |at 1442 59.1,75.7 |group elite  -- Arachnophobia (21)
complete 6461 |at 1442 54.7,72.8 |mobs Deepmoss Creeper;Deepmoss Venomspitter |value mid  -- Blood Feeders (19)
complete 6284 |at 1442 53.6,72.6 |mobs Besseleth |group elite  -- Arachnophobia (21)
accept 6481 |npc Mor'rogal |at 1442 47.2,64.0 |group elite  -- Earthen Arise (20)
fly 1454 45.1,63.9 |from 1442 45.1,59.8 |npc Orgrimmar (Doras)  -- flight master Tharm
accept 1061 |npc Zor Lonetree |at 1454 38.9,38.4  -- The Spirits of Stonetalon (17)
fly 1413 51.5,30.3 |from 1454 45.1,63.9 |npc The Barrens (Devrak)  -- flight master Doras
accept 1062 |npc Seereth Stonebreak |at 1413 35.3,27.9  -- Goblin Invaders (19)
accept 6548 |npc Makaba Flathoof |at 1413 35.2,27.8  -- Avenge My Village (18)
fly 1442 45.1,59.8 |from 1413 51.5,30.3 |npc Tharm  -- flight master Devrak
accept 6301 |npc Tammra Windfield |at 1442 47.5,58.4 |value low  -- Cycle of Rebirth (23)
accept 1093 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Super Reaper 6000 (21)
accept 1092 |npc Piznik |at 1442 71.9,60.0  -- Gerenzo's Orders (22)
complete 1093 |at 1442 67.1,52.4 |mobs Venture Co. Operator  -- Super Reaper 6000 (21)
complete 1062 |at 1442 66.3,51.8 |mobs Venture Co. Logger  -- Goblin Invaders (19)
fly 1413 51.5,30.3 |from 1442 45.1,59.8 |npc The Barrens (Devrak)  -- flight master Tharm
turnin 1062 |npc Seereth Stonebreak |at 1413 35.3,27.9  -- Goblin Invaders (19)
accept 1063 |npc Seereth Stonebreak |at 1413 35.3,27.9  -- The Elder Crone (18)
accept 1068 |npc Seereth Stonebreak |at 1413 35.3,27.9  -- Shredding Machines (23)
fly 1456 47.0,49.8 |from 1413 51.5,30.3 |npc Thunder Bluff (Tal)  -- flight master Devrak
turnin 1063 |npc Magatha Grimtotem |at 1456 69.8,30.9  -- The Elder Crone (18)
fly 1442 45.1,59.8 |from 1456 47.0,49.8 |npc Tharm  -- flight master Tal
complete 1068 |at 1442 67.2,46.7 |mobs XT:4;XT:9  -- Shredding Machines (23)
fly 1413 51.5,30.3 |from 1442 45.1,59.8 |npc The Barrens (Devrak)  -- flight master Tharm
turnin 1068 |npc Seereth Stonebreak |at 1413 35.3,27.9  -- Shredding Machines (23)
fly 1442 45.1,59.8 |from 1413 51.5,30.3 |npc Tharm  -- flight master Devrak
complete 6301 |at 1442 48.0,39.8 |value low  -- Cycle of Rebirth (23)
turnin 1093 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Super Reaper 6000 (21)
turnin 1092 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Gerenzo's Orders (22)
accept 1094 |npc Ziz Fizziks |at 1442 59.0,62.6  -- Further Instructions (21)
complete 6548 |at 1442 82.3,86.9 |mobs Grimtotem Ruffian;Grimtotem Mercenary  -- Avenge My Village (18)
fly 1413 51.5,30.3 |from 1442 45.1,59.8 |npc The Barrens (Devrak)  -- flight master Tharm
turnin 6548 |npc Makaba Flathoof |at 1413 35.2,27.8  -- Avenge My Village (18)
accept 6629 |npc Makaba Flathoof |at 1413 35.2,27.8  -- Kill Grundig Darkcloud (18)
fly 1442 45.1,59.8 |from 1413 51.5,30.3 |npc Tharm  -- flight master Devrak
complete 6629 |at 1442 77.7,85.9 |mobs Grundig Darkcloud;Grimtotem Brute  -- Kill Grundig Darkcloud (18)
fly 1413 51.5,30.3 |from 1442 45.1,59.8 |npc The Barrens (Devrak)  -- flight master Tharm
turnin 6629 |npc Makaba Flathoof |at 1413 35.2,27.8  -- Kill Grundig Darkcloud (18)
accept 6401 |npc Makaba Flathoof |at 1413 35.2,27.8  -- Kaya's Alive (18)
turnin 1094 |npc Sputtervalve |at 1413 63.0,37.2  -- Further Instructions (21)
fly 1442 45.1,59.8 |from 1413 63.1,37.2 |npc Tharm  -- flight master Bragok
accept 6542 |npc Darn Talongrip |at 1442 73.2,94.9  -- Report to Kadrak (19)
turnin 6461 |npc Xen'Zilla |at 1442 71.2,95.0 |value mid  -- Blood Feeders (19)
complete 6481 |at 1442 57.4,89.4 |mobs Goggeroc |group elite  -- Earthen Arise (20)
accept 6393 |npc Tsunaman |at 1442 47.4,64.2  -- Elemental War (25)
turnin 6301 |npc Tammra Windfield |at 1442 47.5,58.4 |value low  -- Cycle of Rebirth (23)
accept 6381 |npc Tammra Windfield |at 1442 47.5,58.4 |value low  -- New Life (25)
accept 1087 |npc Braelyn Firehand |at 1442 45.9,60.4 |value mid  -- Cenarius' Legacy (25)
turnin 1087 |npc Braelyn Firehand |at 1442 45.9,60.4 |value mid  -- Cenarius' Legacy (25)
complete 6393 |at 1442 34.1,63.7 |mobs Rogue Flame Spirit;Burning Destroyer;Burning Ravager  -- Elemental War (25)
complete 6381 |at 1442 32.2,68.2 |value low  -- New Life (25)
turnin 6393 |npc Tsunaman |at 1442 47.4,64.2  -- Elemental War (25)
turnin 6481 |npc Mor'rogal |at 1442 47.2,64.0 |group elite  -- Earthen Arise (20)
fly 1413 51.5,30.3 |from 1442 45.1,59.8 |npc The Barrens (Devrak)  -- flight master Tharm
turnin 6542 |npc Kadrak |at 1413 48.1,5.4  -- Report to Kadrak (19)
turnin 1061 |npc Seereth Stonebreak |at 1413 35.3,27.9  -- The Spirits of Stonetalon (17)
fly 1442 45.1,59.8 |from 1413 51.5,30.3 |npc Tharm  -- flight master Devrak
turnin 6284 |npc Maggran Earthbinder |at 1442 47.2,61.2 |group elite  -- Arachnophobia (21)
turnin 6381 |npc Tammra Windfield |at 1442 47.5,58.4 |value low  -- New Life (25)
turnin 6401 |npc Tammra Windfield |at 1442 47.5,58.4  -- Kaya's Alive (18)
accept 79980 |npc Pocket Litter |at 1442 40.8,52.6  -- Scramble (24)
turnin 79980 |npc Mound of Dirt |at 1442 39.6,49.8  -- Scramble (24)
complete 1087 |at 1442 36.5,13.1 |mobs Son of Cenarius;Daughter of Cenarius;Cenarion Botanist |value mid  -- Cenarius' Legacy (25)
]]}
