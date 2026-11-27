-- GENERATED Paladin (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_paladin_horde_horde_start", title = "Path of the Forsaken Paladin", kind = "class",
  class = "PALADIN", faction = "Horde", race = "Scourge", levels = { 4, 12 },
  steps = [[
accept 91208 |npc Aramis Hammerhand |at 1420 31.0,66.2  -- Coming to Terms (4)
complete 91208 |at 1420 27.7,63.8 |mobs Frightened Paladin  -- Coming to Terms (4)
turnin 91208 |npc Aramis Hammerhand |at 1420 31.0,66.2  -- Coming to Terms (4)
accept 91209 |npc Aramis Hammerhand |at 1420 31.0,66.2  -- Continue Your Training (4)
complete 91209 |at 1420 60.2,52.7 |mobs Shari Stilwell  -- Continue Your Training (4)
turnin 91209 |npc Shari Stilwell |at 1420 60.2,52.7  -- Continue Your Training (4)
accept 91285 |npc Breton Samuels |at 1420 21.9,45.2  -- Murlocs at the Gates (11)
complete 91285 |at 1420 17.6,55.9 |mobs Vile Fin Seer;Vile Fin Attacker  -- Murlocs at the Gates (11)
turnin 91285 |npc Breton Samuels |at 1420 21.9,45.2  -- Murlocs at the Gates (11)
accept 91282 |npc Shari Stilwell |at 1420 60.2,52.7  -- A Second Home (11)
turnin 91282 |npc Breton Samuels |at 1420 21.9,45.2  -- A Second Home (11)
accept 91294 |npc Breton Samuels |at 1420 21.9,45.2 |preany 91285  -- Touring the Grounds (11)
complete 91294 |at 1420 22.7,44.7 |mobs Ander Solliden;Danitha Morr;Hilda the Breaker;Jorin Croge  -- Touring the Grounds (11)
turnin 91294 |npc Danitha Morr |at 1420 22.1,44.7  -- Touring the Grounds (11)
accept 91316 |npc Jorin Croge |at 1420 22.7,44.7 |preany 91294  -- Making Repairs (11)
complete 91316 |at 1420 9.9,66.4  -- Making Repairs (11)
turnin 91316 |npc Jorin Croge |at 1420 22.7,44.7  -- Making Repairs (11)
accept 91317 |npc Danitha Morr |at 1420 22.1,44.7 |preany 91294  -- The Tarnished (12)
complete 91317 |at 1420 14.6,63.7 |mobs Tarnished Zealot;Tarnished Drudge;Rudolph Gelhardt  -- The Tarnished (12)
turnin 91317 |npc Danitha Morr |at 1420 22.1,44.7  -- The Tarnished (12)
accept 95803 |npc Danitha Morr |at 1420 22.1,44.7 |preany 91317  -- A Token of Good Faith (12)
turnin 95803 |npc Lady Sylvanas Windrunner |at 1458 58.0,91.8  -- A Token of Good Faith (12)
]]}

Onward:RegisterGuide{
  id = "class_paladin_horde_redemption", title = "Redemption: Lesson in Divinity", kind = "class",
  class = "PALADIN", faction = "Horde", race = "Scourge", levels = { 12, 12 },
  steps = [[
accept 94427 |npc Danitha Morr |at 1420 22.1,44.7  -- A Lesson in Divinity (12)
turnin 94427 |npc Tanis Alderwood |at 1458 65.5,37.5  -- A Lesson in Divinity (12)
accept 94434 |npc Tanis Alderwood |at 1458 65.5,37.5 |preany 94427  -- A Lesson in Divinity (12)
complete 94434 |at 1429 55.7,67.0  -- A Lesson in Divinity (12)
turnin 94434 |npc Tanis Alderwood |at 1458 65.5,37.5  -- A Lesson in Divinity (12)
accept 94435 |npc Tanis Alderwood |at 1458 65.5,37.5 |preany 94434  -- A Lesson in Divinity (12)
turnin 94435 |npc Danitha Morr |at 1420 22.1,44.7  -- A Lesson in Divinity (12)
accept 94436 |npc Danitha Morr |at 1420 22.1,44.7 |preany 94435  -- A Lesson in Divinity (12)
turnin 94436 |npc Deathguard Billmuth |at 1420 21.9,44.5  -- A Lesson in Divinity (12)
accept 94438 |npc Deathguard Billmuth |at 1420 21.9,44.5 |preany 94436  -- A Lesson in Divinity (12)
turnin 94438 |npc Deathguard Falgan |at 1420 86.7,47.7  -- A Lesson in Divinity (12)
accept 94440 |npc Deathguard Falgan |at 1420 86.7,47.7 |preany 94438  -- A Lesson in Divinity (12)
complete 94440 |at 1420 16.5,62.6 |mobs Tarnished Zealot;Scarlet Zealot;Scarlet Friar  -- A Lesson in Divinity (12)
turnin 94440 |npc Deathguard Billmuth |at 1420 21.9,44.5  -- A Lesson in Divinity (12)
accept 94441 |npc Deathguard Billmuth |at 1420 21.9,44.5 |preany 94440  -- A Lesson in Divinity (12)
turnin 94441 |npc Danitha Morr |at 1420 22.1,44.7  -- A Lesson in Divinity (12)
]]}

Onward:RegisterGuide{
  id = "class_paladin_horde_verigan", title = "The Moonsilver Blade", kind = "class",
  class = "PALADIN", faction = "Horde", race = "Scourge", levels = { 18, 26 },
  steps = [[
accept 91858 |npc Danitha Morr |at 1420 22.1,44.7  -- Diplomatic Incident (22)
turnin 91858 |npc Trevan Rol |at 1421 43.4,41.1  -- Diplomatic Incident (22)
accept 91859 |npc Trevan Rol |at 1421 43.4,41.1 |preany 91858  -- A Curious Pair (22)
turnin 91859 |npc Deathguard Baldren |at 1421 45.8,41.9  -- A Curious Pair (22)
accept 91860 |npc Deathguard Baldren |at 1421 45.8,41.9 |preany 91859  -- A Grim Fate (22)
complete 91860 |at 1421 65.0,34.1  -- A Grim Fate (22)
turnin 91860 |npc Charred Remains |at 1421 65.0,34.1  -- A Grim Fate (22)
accept 91861 |npc Charred Remains |at 1421 65.0,34.1 |preany 91860  -- Into Fenris Keep (22)
turnin 91861 |npc Lumina Windsinger |at 1421 65.5,23.3  -- Into Fenris Keep (22)
accept 91862 |npc Lumina Windsinger |at 1421 65.5,23.3 |preany 91861  -- Lumina Windsinger (22)
complete 91862 |at 1421 65.7,24.0 |mobs Raging Rot Hide;Rot Hide Savage;Rot Hide Bruiser;Snarlmane  -- Lumina Windsinger (22)
turnin 91862 |npc Lumina Windsinger |at 1421 65.5,23.3  -- Lumina Windsinger (22)
accept 96204 |npc Lumina Windsinger |at 1421 65.5,23.3 |preany 91862  -- The Windshaper's Wrath (22)
complete 96204 |at 1421 65.5,23.3 |mobs Lumina Windsinger  -- The Windshaper's Wrath (22)
turnin 96204 |npc Lumina Windsinger |at 1421 43.4,41.0  -- The Windshaper's Wrath (22)
accept 95034 |npc Lumina Windsinger |at 1421 43.4,41.0 |preany 96204  -- The Debt (24)
complete 95034 |at 1421 43.4,41.0 |mobs Lumina Windsinger  -- The Debt (24)
turnin 95034 |npc Lumina Windsinger |at 1421 43.4,41.0  -- The Debt (24)
accept 95036 |npc Lumina Windsinger |at 1421 43.4,41.0 |group dungeon |preany 95034  -- A Moon-Kissed Blade (25)
complete 95036 |group dungeon  -- A Moon-Kissed Blade (25)
turnin 95036 |npc Trevan Rol |at 1421 43.4,41.1 |group dungeon  -- A Moon-Kissed Blade (25)
accept 95111 |npc Trevan Rol |at 1421 43.4,41.1 |group dungeon |preany 95036  -- An Underrated Talent (25)
turnin 95111 |npc Ott |at 1424 60.4,26.2 |group dungeon  -- An Underrated Talent (25)
accept 95125 |npc Ott |at 1424 60.4,26.2 |group dungeon |preany 95111  -- Ott's Masterwork (25)
complete 95125 |at 1424 60.4,26.2 |mobs Ott |group dungeon  -- Ott's Masterwork (25)
turnin 95125 |npc Ott |at 1424 60.4,26.2 |group dungeon  -- Ott's Masterwork (25)
accept 95126 |npc Ott |at 1424 60.4,26.2 |group dungeon |preany 95125  -- The Moonsilver Blade (25)
turnin 95126 |npc Trevan Rol |at 1424 60.4,26.3 |group dungeon  -- The Moonsilver Blade (25)
accept 95140 |npc Lumina Windsinger |at 1421 43.4,41.0 |group elite |preany 95126  -- Old Fire-Eye (26)
complete 95140 |at 1421 49.4,85.6 |mobs Old Fire-Eye |group elite  -- Old Fire-Eye (26)
turnin 95140 |npc Lumina Windsinger |at 1421 43.4,41.0 |group elite  -- Old Fire-Eye (26)
]]}

Onward:RegisterGuide{
  id = "class_paladin_horde_warhorse", title = "Summon Warhorse", kind = "class",
  class = "PALADIN", faction = "Horde", race = "Scourge,Tauren", levels = { 40, 40 },
  steps = [[
accept 94971 |npc Danitha Morr |at 1420 22.1,44.7  -- A Paladin's Steed (40)
turnin 94971 |npc Danitha Morr |at 1420 22.1,44.7  -- A Paladin's Steed (40)
]]}

Onward:RegisterGuide{
  id = "class_paladin_horde_st50", title = "The Reliquary of Tyr", kind = "class",
  class = "PALADIN", faction = "Horde", levels = { 50, 58 },
  steps = [[
accept 99187 |npc Knight of Mourning |at 1420 17.6,67.6 |group dungeon  -- The Reliquary of Tyr (58)
complete 99187 |group dungeon  -- The Reliquary of Tyr (58)
turnin 99187 |npc Knight of Mourning |at 1420 17.6,67.6 |group dungeon  -- The Reliquary of Tyr (58)
]]}

Onward:RegisterGuide{
  id = "class_paladin_horde_thane54", title = "A Thane's Gratitude", kind = "class",
  class = "PALADIN", faction = "Horde", levels = { 54, 59 },
  steps = [[
accept 84332 |npc Mysterious Chest |at 1423 23.1,73.5  -- A Thane's Gratitude (59)
turnin 84332 |npc Mysterious Chest |at 1423 23.1,73.5  -- A Thane's Gratitude (59)
accept 84414 |npc Rotting Dwarf Corpse |at 1423 23.1,73.5  -- Send Me On Me Way (59)
turnin 84414 |npc Mysterious Chest |at 1423 23.1,73.5  -- Send Me On Me Way (59)
]]}

Onward:RegisterGuide{
  id = "class_paladin_horde_charger", title = "Summon Charger", kind = "class",
  class = "PALADIN", faction = "Horde", levels = { 60, 60 },
  steps = [[
accept 97174 |npc Breton Samuels |at 1420 21.9,45.2  -- A Worthy Endeavor (60)
turnin 97174 |npc Danitha Morr |at 1420 22.1,44.7  -- A Worthy Endeavor (60)
accept 97175 |npc Danitha Morr |at 1420 22.1,44.7  -- Due Sacrifice (60)
turnin 97175 |npc Zayus |at 1454 35.7,86.9  -- Due Sacrifice (60)
accept 97176 |npc Danitha Morr |at 1420 22.1,44.7  -- Exorcising Terrordale (60)
complete 97176 |at 1423 11.4,20.8 |item 18752 |mobs Terrordale Spirit  -- Exorcising Terrordale (60)
turnin 97176 |npc Danitha Morr |at 1420 22.1,44.7  -- Exorcising Terrordale (60)
accept 97177 |npc Zayus |at 1454 35.7,86.9  -- Acts of Mercy (60)
turnin 97177 |npc Danitha Morr |at 1420 22.1,44.7  -- Acts of Mercy (60)
accept 97179 |npc Ott |at 1424 60.4,26.2 |group dungeon  -- Collection of Goods (60)
complete 97179 |at 1422 47.8,61.0 |group dungeon  -- Collection of Goods (60)
turnin 97179 |npc Ott |at 1424 60.4,26.2 |group dungeon  -- Collection of Goods (60)
accept 97180 |npc Ott |at 1424 60.4,26.2  -- Ott's Finest Work (60)
turnin 97180 |npc Danitha Morr |at 1420 22.1,44.7  -- Ott's Finest Work (60)
accept 97184 |npc Danitha Morr |at 1420 22.1,44.7  -- The Divination Scryer (60)
complete 97184 |at 1420 83.0,71.5 |mobs Fallen Hero;Felguard Elite;Scarlet Praetorian;Cliff Breaker  -- The Divination Scryer (60)
turnin 97184 |npc Danitha Morr |at 1420 22.1,44.7  -- The Divination Scryer (60)
accept 97186 |npc Nathanos Blightcaller |at 1423 22.2,63.5  -- Manna-Enriched Horse Feed (60)
complete 97186  -- Manna-Enriched Horse Feed (60)
turnin 97186 |npc Nathanos Blightcaller |at 1423 22.2,63.5  -- Manna-Enriched Horse Feed (60)
]]}
