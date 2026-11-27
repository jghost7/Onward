-- GENERATED Shaman (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_shaman_horde_earth", title = "Call of Earth (Earth Totem)", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 4, 4 },
  steps = [[
accept 1516 |npc Canaga Earthcaller |at 1411 42.4,69.2 |exclusive 1519,92466  -- Call of Earth (4)
complete 1516 |at 1411 44.3,54.2 |mobs Felstalker  -- Call of Earth (4)
turnin 1516 |npc Canaga Earthcaller |at 1411 42.4,69.2  -- Call of Earth (4)
accept 1517 |npc Canaga Earthcaller |at 1411 42.4,69.2 |preany 1516  -- Call of Earth (4)
turnin 1517 |npc Minor Manifestation of Earth |at 1411 44.0,76.2  -- Call of Earth (4)
accept 1518 |npc Minor Manifestation of Earth |at 1411 44.0,76.2 |preany 1517  -- Call of Earth (4)
turnin 1518 |npc Canaga Earthcaller |at 1411 42.4,69.2  -- Call of Earth (4)
accept 1520 |npc Seer Ravenfeather |at 1412 44.4,76.8 |preany 1516  -- Call of Earth (4)
turnin 1520 |npc Minor Manifestation of Earth |at 1412 52.0,80.4  -- Call of Earth (4)
accept 1521 |npc Minor Manifestation of Earth |at 1411 44.0,76.2 |preany 1520  -- Call of Earth (4)
turnin 1521 |npc Seer Ravenfeather |at 1412 44.4,76.8  -- Call of Earth (4)
]]}

Onward:RegisterGuide{
  id = "class_shaman_horde_fire", title = "Call of Fire (Fire Totem)", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 10, 13 },
  steps = [[
accept 1524 |npc Kranal Fiss |at 1413 56.0,19.9 |exclusive 97243  -- Call of Fire (11)
turnin 1524 |npc Telf Joolam |at 1411 38.5,59.0  -- Call of Fire (11)
accept 1525 |npc Telf Joolam |at 1411 38.5,59.0 |preany 1524  -- Call of Fire (12)
complete 1525 |at 1411 52.7,25.4 |mobs Stonesplinter Seer;Razormane Seer;Razormane Water Seeker;Razormane Geomancer  -- Call of Fire (12)
turnin 1525 |npc Telf Joolam |at 1411 38.5,59.0  -- Call of Fire (12)
accept 1526 |npc Telf Joolam |at 1411 38.5,59.0 |preany 1525  -- Call of Fire (13)
complete 1526 |at 1411 38.7,58.3 |item 6653 |mobs Manifestation of Flames;Minor Manifestation of Fire  -- Call of Fire (13)
turnin 1526 |npc Brazier of the Dormant Flame |at 1411 39.0,58.2  -- Call of Fire (13)
accept 1527 |npc Brazier of the Dormant Flame |at 1411 39.0,58.2 |preany 1526  -- Call of Fire (13)
turnin 1527 |npc Kranal Fiss |at 1413 56.0,19.9  -- Call of Fire (13)
]]}

Onward:RegisterGuide{
  id = "class_shaman_horde_water", title = "Call of Water (Water Totem)", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 20, 23 },
  steps = [[
accept 1530 |npc Islen Waterseer |at 1413 65.8,43.8  -- Call of Water (22)
turnin 1530 |npc Brine |at 1413 43.4,77.4  -- Call of Water (22)
accept 1535 |npc Brine |at 1413 43.4,77.4 |preany 1530  -- Call of Water (22)
complete 1535 |at 1413 44.3,76.8 |item 7766  -- Call of Water (22)
turnin 1535 |npc Brine |at 1413 43.4,77.4  -- Call of Water (22)
accept 1536 |npc Brine |at 1413 43.4,77.4 |preany 1535  -- Call of Water (22)
complete 1536 |at 1424 62.2,20.8 |item 7768  -- Call of Water (22)
turnin 1536 |npc Brine |at 1413 43.4,77.4  -- Call of Water (22)
accept 1534 |npc Brine |at 1413 43.4,77.4 |preany 1536  -- Call of Water (23)
complete 1534 |at 1440 33.5,67.5 |item 7767  -- Call of Water (23)
turnin 1534 |npc Brine |at 1413 43.4,77.4  -- Call of Water (23)
accept 220 |npc Brine |at 1413 43.4,77.4 |preany 1534  -- Call of Water (23)
turnin 220 |npc Islen Waterseer |at 1413 65.8,43.8  -- Call of Water (23)
accept 63 |npc Islen Waterseer |at 1413 65.8,43.8 |preany 220  -- Call of Water (23)
complete 63 |at 1421 38.8,44.3 |item 7811 |mobs Corrupt Minor Manifestation of Water  -- Call of Water (23)
turnin 63 |npc Brazier of Everfount |at 1421 38.3,44.6  -- Call of Water (23)
accept 100 |npc Brazier of Everfount |at 1421 38.3,44.6 |preany 63  -- Call of Water (23)
turnin 100 |npc Minor Manifestation of Water |at 1421 38.6,44.6  -- Call of Water (23)
accept 96 |npc Minor Manifestation of Water |at 1421 38.6,44.6 |preany 100  -- Call of Water (23)
turnin 96 |npc Islen Waterseer |at 1413 65.8,43.8  -- Call of Water (23)
]]}

Onward:RegisterGuide{
  id = "class_shaman_horde_air", title = "Call of Air & Tempest's Weapons", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 30, 43 },
  steps = [[
accept 1531 |npc Searn Firewarder |at 1454 38.0,37.7 |exclusive 1532,96136  -- Call of Air (30)
turnin 1531 |npc Prate Cloudseer |at 1441 53.5,42.6  -- Call of Air (30)
accept 79360 |npc Rau Cliffrunner |at 1441 46.1,51.7 |group dungeon |preany 1531  -- Elemental Aid (33)
complete 79360 |group dungeon  -- Elemental Aid (33)
turnin 79360 |npc Rau Cliffrunner |at 1441 46.1,51.7 |group dungeon  -- Elemental Aid (33)
accept 79364 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group dungeon |preany 79360 |exclusive 98338  -- Eyes on the Sky (33)
turnin 79364 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group dungeon  -- Eyes on the Sky (33)
accept 79365 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |race Orc,Tauren  -- With Wind Beneath Your Wings (40)
turnin 79365 |npc Rau Cliffrunner |at 1441 46.1,51.7 |race Orc,Tauren  -- With Wind Beneath Your Wings (40)
accept 79361 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group dungeon |preany 79364  -- Storm, Earth, and Fire (43)
complete 79361 |at 1445 58.4,15.3 |item 274483 |mobs Mirefin Warrior;Mirefin Murloc;Mirefin Coastrunner;Mirefin Muckdweller |group dungeon  -- Storm, Earth, and Fire (43)
turnin 79361 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group dungeon  -- Storm, Earth, and Fire (43)
accept 79366 |npc Rau Cliffrunner |at 1441 46.1,51.7 |group elite |preany 79361 |exclusive 96135  -- Heed My Call (40)
complete 79366 |at 1441 37.4,39.6 |item 268582 |mobs Ravaging Tempest |group elite  -- Heed My Call (40)
turnin 79366 |npc Rau Cliffrunner |at 1441 46.1,51.7 |group elite  -- Heed My Call (40)
accept 79442 |npc Rau Cliffrunner |at 1441 46.1,51.7 |group elite |preany 79366 |exclusive 96016  -- The Tempest's Weapons (40)
turnin 79442 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group elite  -- The Tempest's Weapons (40)
]]}

Onward:RegisterGuide{
  id = "class_shaman_horde_desertwolf", title = "Challenge of the Desert Wolf", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 37, 45 },
  steps = [[
accept 95753 |npc Odd Totem |at 1446 43.0,41.3  -- Challenge of the Desert Wolf (45)
complete 95753 |at 1446 45.7,37.8  -- Challenge of the Desert Wolf (45)
turnin 95753 |npc Odd Totem |at 1446 45.8,37.7  -- Challenge of the Desert Wolf (45)
]]}

Onward:RegisterGuide{
  id = "class_shaman_horde_st50", title = "Sunken Temple: Da Voodoo", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 50, 52 },
  steps = [[
accept 8410 |npc Sagorne Creststrider |at 1454 38.7,35.9 |exclusive 8411  -- Elemental Mastery (50)
complete 8410 |at 1451 31.4,34.4 |mobs Stonelash Pincer;Dust Stormer;Desert Rumbler;Sea Spray  -- Elemental Mastery (50)
turnin 8410 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9  -- Elemental Mastery (50)
accept 8412 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |preany 8410  -- Spirit Totem (52)
complete 8412 |at 1422 54.4,51.9 |mobs Diseased Grizzly;Plague Lurker;Carrion Lurker;Diseased Black Bear  -- Spirit Totem (52)
turnin 8412 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9  -- Spirit Totem (52)
accept 8413 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group dungeon |preany 8412  -- Da Voodoo (52)
complete 8413 |group dungeon  -- Da Voodoo (52)
turnin 8413 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group dungeon  -- Da Voodoo (52)
]]}

Onward:RegisterGuide{
  id = "class_shaman_horde_darkreaver", title = "The Darkreaver Menace", kind = "class",
  class = "SHAMAN", faction = "Horde", levels = { 58, 60 },
  steps = [[
accept 7667 |npc Sagorne Creststrider |at 1454 38.7,35.9  -- Material Assistance (60)
complete 7667 |at 1428 61.0,45.9 |mobs Fallen Hero;Felguard Elite;Scarlet Praetorian;Cliff Breaker  -- Material Assistance (60)
turnin 7667 |npc Sagorne Creststrider |at 1454 38.7,35.9  -- Material Assistance (60)
accept 8258 |npc Sagorne Creststrider |at 1454 38.7,35.9 |group dungeon |preany 7667 |exclusive 7668  -- The Darkreaver Menace (60)
complete 8258 |item 18746 |group dungeon  -- The Darkreaver Menace (60)
turnin 8258 |npc Sagorne Creststrider |at 1454 38.7,35.9 |group dungeon  -- The Darkreaver Menace (60)
]]}
