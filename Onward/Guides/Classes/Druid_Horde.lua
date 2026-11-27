-- GENERATED Druid (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_druid_horde_bear", title = "Bear Form (Great Bear Spirit)", kind = "class",
  class = "DRUID", faction = "Horde", race = "Tauren,SkyborneHorde", levels = { 10, 10 },
  steps = [[
accept 5922 |npc Turak Runetotem |at 1456 76.5,27.2 |race Tauren  -- Moonglade (10)
turnin 5922 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race Tauren  -- Moonglade (10)
accept 5930 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race Tauren |preany 5922  -- Great Bear Spirit (10)
complete 5930 |at 1450 39.1,27.5 |mobs Great Bear Spirit |race Tauren  -- Great Bear Spirit (10)
turnin 5930 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race Tauren  -- Great Bear Spirit (10)
accept 5932 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race Tauren |preany 5930  -- Back to Thunder Bluff (10)
complete 5932 |race Tauren  -- Back to Thunder Bluff (10)
turnin 5932 |npc Turak Runetotem |at 1456 76.5,27.2 |race Tauren  -- Back to Thunder Bluff (10)
accept 6002 |npc Turak Runetotem |at 1456 76.5,27.2 |race Tauren |preany 5932  -- Body and Heart (10)
complete 6002 |item 15710 |race Tauren  -- Body and Heart (10)
turnin 6002 |npc Turak Runetotem |at 1456 76.5,27.2 |race Tauren  -- Body and Heart (10)
accept 94006 |npc Lotheluum Starbreeze |at 2521 64.0,75.1 |race SkyborneHorde  -- The Great Ursera Spirit (10)
turnin 94006 |npc Urs'endris |at 2521 69.8,61.7 |race SkyborneHorde  -- The Great Ursera Spirit (10)
accept 94638 |npc Urs'endris |at 2521 69.8,61.7 |race SkyborneHorde |preany 94006  -- Strength and Mercy (10)
complete 94638 |at 2521 53.7,65.2 |mobs Ur'endra |race SkyborneHorde  -- Strength and Mercy (10)
turnin 94638 |npc Urs'endris |at 2521 69.8,61.7 |race SkyborneHorde  -- Strength and Mercy (10)
accept 94911 |npc Muln Earthfury |at 1412 33.4,22.6 |race SkyborneHorde  -- Child of Nature (10)
turnin 94911 |npc Turak Runetotem |at 1456 76.5,27.2 |race SkyborneHorde  -- Child of Nature (10)
accept 94913 |npc Turak Runetotem |at 1456 76.5,27.2 |race SkyborneHorde  -- Moonglade (10)
turnin 94913 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race SkyborneHorde  -- Moonglade (10)
]]}

Onward:RegisterGuide{
  id = "class_druid_horde_curepoison", title = "Cure Poison (Power over Poison)", kind = "class",
  class = "DRUID", faction = "Horde", race = "Tauren", levels = { 14, 14 },
  steps = [[
accept 6126 |npc Hana Lighthoof |at 1412 33.4,22.1  -- Lessons Anew (14)
turnin 6126 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Lessons Anew (14)
accept 6127 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 6126  -- The Principal Source (14)
complete 6127 |at 1413 48.4,18.9 |item 15842  -- The Principal Source (14)
turnin 6127 |npc Tonga Runetotem |at 1413 52.3,31.9  -- The Principal Source (14)
accept 6128 |npc Tonga Runetotem |at 1413 52.3,31.9 |preany 6127  -- Gathering the Cure (14)
complete 6128 |at 1413 56.2,40.1 |mobs Lasher Sproutling;Wrathvine;Lost Barrens Kodo;Barrens Kodo  -- Gathering the Cure (14)
turnin 6128 |npc Tonga Runetotem |at 1413 52.3,31.9  -- Gathering the Cure (14)
accept 6129 |npc Tonga Runetotem |at 1413 52.3,31.9 |preany 6128  -- Curing the Sick (14)
complete 6129 |at 1413 50.2,23.3 |item 15826 |mobs Sickly Gazelle  -- Curing the Sick (14)
turnin 6129 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Curing the Sick (14)
accept 6130 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 6129  -- Power over Poison (14)
turnin 6130 |npc Turak Runetotem |at 1456 76.5,27.2  -- Power over Poison (14)
]]}

Onward:RegisterGuide{
  id = "class_druid_horde_aquatic", title = "Aquatic Form (Trial of the Sea Lion)", kind = "class",
  class = "DRUID", faction = "Horde", race = "Tauren", levels = { 16, 16 },
  steps = [[
accept 27 |npc Turak Runetotem |at 1456 76.5,27.2  -- A Lesson to Learn (16)
turnin 27 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- A Lesson to Learn (16)
accept 28 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 27  -- Trial of the Lake (16)
complete 28 |at 1450 36.0,41.4  -- Trial of the Lake (16)
turnin 28 |npc Tajarri |at 1450 36.5,40.1  -- Trial of the Lake (16)
accept 30 |npc Tajarri |at 1450 36.5,40.1 |preany 28  -- Trial of the Sea Lion (16)
complete 30 |at 1450 36.0,41.4  -- Trial of the Sea Lion (16)
turnin 30 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Trial of the Sea Lion (16)
accept 31 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 30  -- Aquatic Form (16)
turnin 31 |npc Turak Runetotem |at 1456 76.5,27.2  -- Aquatic Form (16)
]]}

Onward:RegisterGuide{
  id = "class_druid_horde_cat", title = "Cat Form (Great Cat Spirit)", kind = "class",
  class = "DRUID", faction = "Horde", race = "Tauren,SkyborneHorde", levels = { 20, 20 },
  steps = [[
accept 98340 |npc Turak Runetotem |at 1456 76.5,27.2 |exclusive 98393  -- The Great Cat Spirit (20)
turnin 98340 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- The Great Cat Spirit (20)
accept 98405 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race Tauren |preany 98340 |exclusive 98341,98394  -- The Great Cat Spirit (20)
turnin 98405 |npc Great Cat Spirit |at 1450 58.4,73.5 |race Tauren  -- The Great Cat Spirit (20)
accept 98342 |npc Great Cat Spirit |at 1450 58.4,73.5 |race Tauren |preany 98405 |exclusive 98396,98404  -- The Great Cat Spirit (20)
complete 98342 |at 1450 74.4,65.3 |race Tauren  -- The Great Cat Spirit (20)
turnin 98342 |npc Great Cat Spirit |at 1450 58.4,73.5 |race Tauren  -- The Great Cat Spirit (20)
accept 98739 |npc Great Cat Spirit |at 1450 58.4,73.5 |race Tauren |preany 98342 |exclusive 98731,98738  -- Blessings of the Great Cat Spirit (20)
turnin 98739 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race Tauren  -- Blessings of the Great Cat Spirit (20)
accept 98341 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race SkyborneHorde |preany 98340 |exclusive 98394,98405  -- The Great Windborne Cat Spirit (20)
turnin 98341 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneHorde  -- The Great Windborne Cat Spirit (20)
accept 98404 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneHorde |preany 98341 |exclusive 98342,98396  -- The Great Windborne Cat Spirit (20)
complete 98404 |at 1450 74.4,65.3 |race SkyborneHorde  -- The Great Windborne Cat Spirit (20)
turnin 98404 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneHorde  -- The Great Windborne Cat Spirit (20)
accept 98738 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneHorde |preany 98404 |exclusive 98731,98739  -- Blessings of the Great Windborne Cat Spirit (20)
turnin 98738 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race SkyborneHorde  -- Blessings of the Great Windborne Cat Spirit (20)
accept 98362 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 98738,98739 |exclusive 98397  -- To Thunder Bluff (20)
turnin 98362 |npc Turak Runetotem |at 1456 76.5,27.2  -- To Thunder Bluff (20)
]]}

Onward:RegisterGuide{
  id = "class_druid_horde_guardians", title = "Wisdom of the Guardians", kind = "class",
  class = "DRUID", faction = "Horde", race = "Tauren", levels = { 40, 50 },
  steps = [[
accept 81924 |npc Tyrisius |at 1444 57.2,68.9  -- Wisdom of the Guardians (50)
turnin 81924 |npc Tyrisius |at 1444 57.2,68.9  -- Wisdom of the Guardians (50)
]]}

Onward:RegisterGuide{
  id = "class_druid_horde_st50", title = "Sunken Temple: A Better Ingredient", kind = "class",
  class = "DRUID", faction = "Horde", levels = { 50, 52 },
  steps = [[
accept 9052 |npc Torwa Pathfinder |at 1449 71.6,76.0  -- Bloodpetal Poison (52)
complete 9052 |at 1449 43.2,58.5 |mobs Gorishi Wasp;Gorishi Stinger  -- Bloodpetal Poison (52)
turnin 9052 |npc Torwa Pathfinder |at 1449 71.6,76.0  -- Bloodpetal Poison (52)
accept 9051 |npc Torwa Pathfinder |at 1449 71.6,76.0 |group elite |preany 9052  -- Toxic Test (52)
complete 9051 |at 1449 57.3,23.7 |item 22432 |mobs Devilsaur;Tyrant Devilsaur;Ironhide Devilsaur |group elite  -- Toxic Test (52)
turnin 9051 |npc Torwa Pathfinder |at 1449 71.6,76.0 |group elite  -- Toxic Test (52)
accept 9053 |npc Torwa Pathfinder |at 1449 71.6,76.0 |group dungeon |preany 9051  -- A Better Ingredient (52)
complete 9053 |group dungeon  -- A Better Ingredient (52)
turnin 9053 |npc Torwa Pathfinder |at 1449 71.6,76.0 |group dungeon  -- A Better Ingredient (52)
]]}
