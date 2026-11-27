-- GENERATED Shaman (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_shaman_alliance_earth", title = "Call of Earth (Earth Totem)", kind = "class",
  class = "SHAMAN", faction = "Alliance", race = "Dwarf,Gnome", levels = { 4, 4 },
  steps = [[
accept 94373 |npc Teo Hammerstorm |at 1426 28.8,66.2 |race Dwarf  -- Call of Earth (4)
complete 94373 |at 1426 28.1,80.2 |mobs Frostmane Troll Whelp;Frostmane Novice |race Dwarf  -- Call of Earth (4)
turnin 94373 |npc Teo Hammerstorm |at 1426 28.8,66.2 |race Dwarf  -- Call of Earth (4)
accept 94374 |npc Teo Hammerstorm |at 1426 28.8,66.2 |race Dwarf |preany 94373  -- Call of Earth (4)
turnin 94374 |npc Minor Manifestation of Earth |at 1426 24.8,61.9 |race Dwarf  -- Call of Earth (4)
accept 94375 |npc Minor Manifestation of Earth |at 1411 44.0,76.2 |race Dwarf |preany 94374  -- Call of Earth (4)
turnin 94375 |npc Teo Hammerstorm |at 1426 28.8,66.2 |race Dwarf  -- Call of Earth (4)
accept 96243 |npc Ingrid Dunwald |at 1426 47.6,52.0  -- Call of Earth (4)
turnin 96243 |npc Teo Hammerstorm |at 1426 28.8,66.2  -- Call of Earth (4)
]]}

Onward:RegisterGuide{
  id = "class_shaman_alliance_fire", title = "Call of Fire (Fire Totem)", kind = "class",
  class = "SHAMAN", faction = "Alliance", levels = { 10, 14 },
  steps = [[
accept 94449 |npc Teo Hammerstorm |at 1426 28.8,66.2 |race Dwarf  -- Call of Fire (10)
turnin 94449 |npc Bruegs Kindleborn |at 1426 87.9,44.8 |race Dwarf  -- Call of Fire (10)
accept 94465 |npc Bruegs Kindleborn |at 1426 87.9,44.8  -- Call of Fire (11)
turnin 94465 |npc Braldir Ashmantle |at 1432 32.2,66.0  -- Call of Fire (11)
accept 94466 |npc Braldir Ashmantle |at 1432 32.2,66.0 |preany 94465  -- Call of Fire (14)
complete 94466 |at 1432 35.5,80.1 |mobs Stonesplinter Seer;Razormane Seer;Razormane Water Seeker;Razormane Geomancer  -- Call of Fire (14)
turnin 94466 |npc Braldir Ashmantle |at 1432 32.2,66.0  -- Call of Fire (14)
accept 94467 |npc Braldir Ashmantle |at 1432 32.2,66.0 |preany 94466  -- Call of Fire (14)
complete 94467 |at 1432 32.0,64.4 |item 6653 |mobs Manifestation of Flames;Minor Manifestation of Fire  -- Call of Fire (14)
turnin 94467 |npc Brazier of the Dormant Flame |at 1432 31.8,64.5  -- Call of Fire (14)
accept 94468 |npc Brazier of the Dormant Flame |at 1411 39.0,58.2 |race Dwarf |preany 94467  -- Call of Fire (14)
turnin 94468 |npc Bruegs Kindleborn |at 1426 87.9,44.8 |race Dwarf  -- Call of Fire (14)
]]}

Onward:RegisterGuide{
  id = "class_shaman_alliance_water", title = "Call of Water (Water Totem)", kind = "class",
  class = "SHAMAN", faction = "Alliance", levels = { 20, 23 },
  steps = [[
accept 94494 |npc Ingrid Dunwald |at 1426 47.6,52.0  -- Call of Water (20)
turnin 94494 |npc Norric Lochthane |at 1432 41.8,19.1  -- Call of Water (20)
accept 94495 |npc Norric Lochthane |at 1432 41.8,19.1 |preany 94494  -- Call of Water (22)
turnin 94495 |npc Hervdana Saegrund |at 1437 65.8,76.5  -- Call of Water (22)
accept 94497 |npc Hervdana Saegrund |at 1437 65.8,76.5 |preany 94495  -- Call of Water (22)
complete 94497 |item 265732  -- Call of Water (22)
turnin 94497 |npc Hervdana Saegrund |at 1437 65.8,76.5  -- Call of Water (22)
accept 94499 |npc Hervdana Saegrund |at 1437 65.8,76.5 |preany 94497  -- Call of Water (22)
complete 94499 |item 265747  -- Call of Water (22)
turnin 94499 |npc Hervdana Saegrund |at 1437 65.8,76.5  -- Call of Water (22)
accept 94500 |npc Hervdana Saegrund |at 1437 65.8,76.5 |preany 94499  -- Call of Water (23)
complete 94500 |item 265772  -- Call of Water (23)
turnin 94500 |npc Hervdana Saegrund |at 1437 65.8,76.5  -- Call of Water (23)
accept 94501 |npc Hervdana Saegrund |at 1437 65.8,76.5 |preany 94500  -- Call of Water (23)
turnin 94501 |npc Norric Lochthane |at 1432 41.8,19.1  -- Call of Water (23)
accept 94502 |npc Norric Lochthane |at 1432 41.8,19.1 |preany 94501  -- Call of Water (23)
complete 94502 |at 1421 38.8,44.3 |item 7811 |mobs Corrupt Minor Manifestation of Water  -- Call of Water (23)
turnin 94502 |npc Forgotten Shrine |at 1436 45.6,59.9  -- Call of Water (23)
accept 94503 |npc Forgotten Shrine |at 1436 45.6,59.9 |race Dwarf |preany 94502  -- Call of Water (23)
turnin 94503 |npc Minor Manifestation of Water |at 1421 38.6,44.6 |race Dwarf  -- Call of Water (23)
accept 94505 |npc Minor Manifestation of Water |at 1421 38.6,44.6 |race Dwarf |preany 94503  -- Call of Water (23)
turnin 94505 |npc Norric Lochthane |at 1432 41.8,19.1 |race Dwarf  -- Call of Water (23)
]]}

Onward:RegisterGuide{
  id = "class_shaman_alliance_air", title = "Call of Air & Tempest's Weapons", kind = "class",
  class = "SHAMAN", faction = "Alliance", levels = { 30, 43 },
  steps = [[
accept 94789 |npc Eldrun Stormbreaker |at 1455 47.1,13.8  -- Call of Air (30)
turnin 94789 |npc Veyric Thunderhame |at 1455 47.1,13.8  -- Call of Air (30)
accept 96264 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group dungeon |preany 94789  -- Elemental Aid (33)
complete 96264 |group dungeon  -- Elemental Aid (33)
turnin 96264 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group dungeon  -- Elemental Aid (33)
accept 79358 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group dungeon |preany 96264  -- Storm, Earth, and Fire (43)
complete 79358 |at 1445 58.4,15.3 |item 274483 |mobs Mirefin Warrior;Mirefin Murloc;Mirefin Coastrunner;Mirefin Muckdweller |group dungeon  -- Storm, Earth, and Fire (43)
turnin 79358 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group dungeon  -- Storm, Earth, and Fire (43)
accept 96135 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group elite |preany 79358 |exclusive 79366  -- Heed My Call (40)
complete 96135 |at 1441 37.4,39.6 |item 268582 |mobs Ravaging Tempest |group elite  -- Heed My Call (40)
turnin 96135 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group elite  -- Heed My Call (40)
accept 96016 |npc Veyric Thunderhame |at 1417 59.8,27.6 |group elite |preany 96135 |exclusive 79442  -- The Tempest's Weapons (40)
turnin 96016 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group elite  -- The Tempest's Weapons (40)
]]}

Onward:RegisterGuide{
  id = "class_shaman_alliance_desertwolf", title = "Challenge of the Desert Wolf", kind = "class",
  class = "SHAMAN", faction = "Alliance", levels = { 37, 45 },
  steps = [[
accept 95753 |npc Odd Totem |at 1446 43.0,41.3  -- Challenge of the Desert Wolf (45)
complete 95753 |at 1446 45.7,37.8  -- Challenge of the Desert Wolf (45)
turnin 95753 |npc Odd Totem |at 1446 45.8,37.7  -- Challenge of the Desert Wolf (45)
]]}

Onward:RegisterGuide{
  id = "class_shaman_alliance_darkreaver", title = "The Darkreaver Menace", kind = "class",
  class = "SHAMAN", faction = "Alliance", levels = { 58, 60 },
  steps = [[
accept 97168 |npc Eldrun Stormbreaker |at 1455 47.1,13.8  -- Material Assistance (60)
complete 97168 |at 1428 61.0,45.9 |mobs Fallen Hero;Felguard Elite;Scarlet Praetorian;Cliff Breaker  -- Material Assistance (60)
turnin 97168 |npc Eldrun Stormbreaker |at 1455 47.1,13.8  -- Material Assistance (60)
]]}
