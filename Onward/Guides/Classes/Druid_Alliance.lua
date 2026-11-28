-- GENERATED Druid (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_druid_alliance_bear", title = "Bear Form (Great Bear Spirit)", kind = "class",
  class = "DRUID", faction = "Alliance", race = "NightElf,SkyborneAlliance", levels = { 10, 10 },
  steps = [[
accept 5921 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4 |race NightElf  -- Moonglade (10)
turnin 5921 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf  -- Moonglade (10)
accept 5929 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf |preany 5921  -- Great Bear Spirit (10)
complete 5929 |at 1450 39.1,27.5 |mobs Great Bear Spirit |race NightElf  -- Great Bear Spirit (10)
turnin 5929 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf  -- Great Bear Spirit (10)
accept 5931 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf |preany 5929  -- Back to Darnassus (10)
complete 5931 |at 1450 44.1,45.2 |mobs Silva Fil'naveth |race NightElf  -- Back to Darnassus (10)
turnin 5931 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4 |race NightElf  -- Back to Darnassus (10)
accept 6001 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4 |race NightElf |preany 5931  -- Body and Heart (10)
complete 6001 |at 1413 42.0,60.9 |item 15208 |race NightElf  -- Body and Heart (10)
turnin 6001 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4 |race NightElf  -- Body and Heart (10)
accept 94006 |npc Lotheluum Starbreeze |at 2521 64.0,75.1 |race SkyborneAlliance  -- The Great Ursera Spirit (10)
turnin 94006 |npc Urs'endris |at 2521 69.8,61.7 |race SkyborneAlliance  -- The Great Ursera Spirit (10)
accept 94638 |npc Urs'endris |at 2521 69.8,61.7 |race SkyborneAlliance |preany 94006  -- Strength and Mercy (10)
complete 94638 |at 2521 53.7,65.2 |mobs Ur'endra |race SkyborneAlliance  -- Strength and Mercy (10)
turnin 94638 |npc Urs'endris |at 2521 69.8,61.7 |race SkyborneAlliance  -- Strength and Mercy (10)
accept 94912 |npc Alfina Nightgaze |at 1416 11.8,56.6 |race SkyborneAlliance  -- Child of Nature (10)
turnin 94912 |npc Sheldras Moontree |at 1453 35.8,67.4 |race SkyborneAlliance  -- Child of Nature (10)
accept 94914 |npc Sheldras Moontree |at 1453 35.8,67.4 |race SkyborneAlliance  -- Moonglade (10)
turnin 94914 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race SkyborneAlliance  -- Moonglade (10)
]]}

Onward:RegisterGuide{
  id = "class_druid_alliance_curepoison", title = "Cure Poison (Power over Poison)", kind = "class",
  class = "DRUID", faction = "Alliance", race = "NightElf,SkyborneAlliance", levels = { 14, 14 },
  steps = [[
accept 6121 |npc Alfina Nightgaze |at 1416 11.8,56.6  -- Lessons Anew (14)
turnin 6121 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Lessons Anew (14)
accept 6122 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 6121  -- The Principal Source (14)
complete 6122 |at 1439 54.9,33.3 |item 15844  -- The Principal Source (14)
turnin 6122 |npc Alanndarian Nightsong |at 1439 37.7,40.7  -- The Principal Source (14)
accept 6123 |npc Alanndarian Nightsong |at 1439 37.7,40.7 |preany 6122  -- Gathering the Cure (14)
complete 6123 |at 1439 44.0,50.5 |mobs Lasher Sproutling;Wrathvine  -- Gathering the Cure (14)
turnin 6123 |npc Alanndarian Nightsong |at 1439 37.7,40.7  -- Gathering the Cure (14)
accept 6124 |npc Alanndarian Nightsong |at 1439 37.7,40.7 |preany 6123  -- Curing the Sick (14)
complete 6124 |at 1439 43.8,48.2 |item 15826 |mobs Sickly Deer  -- Curing the Sick (14)
turnin 6124 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Curing the Sick (14)
accept 6125 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf |preany 6124  -- Power over Poison (14)
turnin 6125 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4 |race NightElf  -- Power over Poison (14)
]]}

Onward:RegisterGuide{
  id = "class_druid_alliance_aquatic", title = "Aquatic Form (Trial of the Sea Lion)", kind = "class",
  class = "DRUID", faction = "Alliance", race = "NightElf", levels = { 16, 16 },
  steps = [[
accept 26 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4  -- A Lesson to Learn (16)
turnin 26 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- A Lesson to Learn (16)
accept 29 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 26  -- Trial of the Lake (16)
complete 29 |at 1450 36.0,41.4  -- Trial of the Lake (16)
turnin 29 |npc Tajarri |at 1450 36.5,40.1  -- Trial of the Lake (16)
accept 272 |npc Tajarri |at 1450 36.5,40.1 |preany 29  -- Trial of the Sea Lion (16)
complete 272 |at 1450 36.0,41.4  -- Trial of the Sea Lion (16)
turnin 272 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Trial of the Sea Lion (16)
accept 5061 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 272  -- Aquatic Form (16)
turnin 5061 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4  -- Aquatic Form (16)
]]}

Onward:RegisterGuide{
  id = "class_druid_alliance_cat", title = "Cat Form (Great Cat Spirit)", kind = "class",
  class = "DRUID", faction = "Alliance", race = "NightElf,SkyborneAlliance", levels = { 20, 20 },
  steps = [[
accept 98393 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4 |exclusive 98340  -- The Great Cat Spirit (20)
turnin 98393 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- The Great Cat Spirit (20)
accept 98394 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf |preany 98393 |exclusive 98341,98405  -- The Great Cat Spirit (20)
turnin 98394 |npc Great Cat Spirit |at 1450 58.4,73.5 |race NightElf  -- The Great Cat Spirit (20)
accept 98396 |npc Great Cat Spirit |at 1450 58.4,73.5 |race NightElf |preany 98394 |exclusive 98342,98404  -- The Great Cat Spirit (20)
complete 98396 |at 1450 74.4,65.3 |race NightElf  -- The Great Cat Spirit (20)
turnin 98396 |npc Great Cat Spirit |at 1450 58.4,73.5 |race NightElf  -- The Great Cat Spirit (20)
accept 98731 |npc Great Cat Spirit |at 1450 58.4,73.5 |race NightElf |preany 98396 |exclusive 98738,98739  -- Blessings of the Great Cat Spirit (20)
turnin 98731 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race NightElf  -- Blessings of the Great Cat Spirit (20)
accept 98341 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race SkyborneAlliance |preany 98393 |exclusive 98394,98405  -- The Great Windborne Cat Spirit (20)
turnin 98341 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneAlliance  -- The Great Windborne Cat Spirit (20)
accept 98404 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneAlliance |preany 98341 |exclusive 98342,98396  -- The Great Windborne Cat Spirit (20)
complete 98404 |at 1450 74.4,65.3 |race SkyborneAlliance  -- The Great Windborne Cat Spirit (20)
turnin 98404 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneAlliance  -- The Great Windborne Cat Spirit (20)
accept 98738 |npc Avatar of Saeyleenan |at 1450 43.9,73.4 |race SkyborneAlliance |preany 98404 |exclusive 98731,98739  -- Blessings of the Great Windborne Cat Spirit (20)
turnin 98738 |npc Dendrite Starblaze |at 1450 56.2,30.6 |race SkyborneAlliance  -- Blessings of the Great Windborne Cat Spirit (20)
accept 98397 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 98731,98738 |exclusive 98362  -- To Darnassus (20)
turnin 98397 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4  -- To Darnassus (20)
]]}

Onward:RegisterGuide{
  id = "class_druid_alliance_guardians", title = "Wisdom of the Guardians", kind = "class",
  class = "DRUID", faction = "Alliance", race = "NightElf", levels = { 40, 50 },
  steps = [[
accept 81924 |npc Tyrisius |at 1444 57.2,68.9  -- Wisdom of the Guardians (50)
turnin 81924 |npc Tyrisius |at 1444 57.2,68.9  -- Wisdom of the Guardians (50)
]]}

Onward:RegisterGuide{
  id = "class_druid_alliance_st50", title = "Sunken Temple: A Better Ingredient", kind = "class",
  class = "DRUID", faction = "Alliance", levels = { 50, 52 },
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
