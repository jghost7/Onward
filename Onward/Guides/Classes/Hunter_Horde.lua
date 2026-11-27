-- GENERATED Hunter (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_hunter_horde_taming", title = "Taming the Beast", kind = "class",
  class = "HUNTER", faction = "Horde", race = "Orc,Tauren,Troll,SkyborneHorde", levels = { 10, 10 },
  steps = [[
accept 6061 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren  -- Taming the Beast (10)
complete 6061 |at 1412 42.1,62.9 |item 15914 |mobs Adult Plainstrider |race Tauren  -- Taming the Beast (10)
turnin 6061 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren  -- Taming the Beast (10)
accept 6087 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren |preany 6061  -- Taming the Beast (10)
complete 6087 |at 1412 48.2,52.5 |item 15915 |mobs Prairie Stalker |race Tauren  -- Taming the Beast (10)
turnin 6087 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren  -- Taming the Beast (10)
accept 6088 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren |preany 6087  -- Taming the Beast (10)
complete 6088 |at 1412 47.6,50.0 |item 15916 |mobs Swoop |race Tauren  -- Taming the Beast (10)
turnin 6088 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren  -- Taming the Beast (10)
accept 6089 |npc Yaw Sharpmane |at 1412 46.9,59.6 |race Tauren |preany 6088  -- Training the Beast (10)
turnin 6089 |npc Holt Thunderhorn |at 1456 57.3,89.8 |race Tauren  -- Training the Beast (10)
accept 6062 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll  -- Taming the Beast (10)
complete 6062 |at 1411 48.3,45.9 |item 15917 |mobs Dire Mottled Boar |race Orc,Troll  -- Taming the Beast (10)
turnin 6062 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll  -- Taming the Beast (10)
accept 6083 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll |preany 6062  -- Taming the Beast (10)
complete 6083 |at 1411 64.2,78.8 |item 15919 |mobs Surf Crawler |race Orc,Troll  -- Taming the Beast (10)
turnin 6083 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll  -- Taming the Beast (10)
accept 6082 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll |preany 6083  -- Taming the Beast (10)
complete 6082 |at 1411 46.8,35.5 |item 15920 |mobs Armored Scorpid |race Orc,Troll  -- Taming the Beast (10)
turnin 6082 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll  -- Taming the Beast (10)
accept 6081 |npc Thotar |at 1411 51.9,43.5 |race Orc,Troll |preany 6082  -- Training the Beast (10)
turnin 6081 |npc Ormak Grimshot |at 1454 66.0,18.5 |race Orc,Troll  -- Training the Beast (10)
accept 94007 |npc Elayaa Easewind |at 2521 45.3,44.2 |race SkyborneHorde  -- Taming the Beast (10)
turnin 94007 |npc Quel'ana Quickgale |at 2521 59.6,72.6 |race SkyborneHorde  -- Taming the Beast (10)
]]}

Onward:RegisterGuide{
  id = "class_hunter_horde_st50", title = "Sunken Temple: The Green Drake", kind = "class",
  class = "HUNTER", faction = "Horde", levels = { 50, 52 },
  steps = [[
accept 8151 |npc Ormak Grimshot |at 1454 66.0,18.5  -- The Hunter's Charm (52)
turnin 8151 |npc Ogtinc |at 1447 42.4,42.6  -- The Hunter's Charm (52)
accept 8153 |npc Ogtinc |at 1447 42.4,42.6 |preany 8151  -- Courser Antlers (52)
complete 8153 |at 1447 48.0,74.7 |mobs Mosshoof Courser  -- Courser Antlers (52)
turnin 8153 |npc Ogtinc |at 1447 42.4,42.6  -- Courser Antlers (52)
accept 8231 |npc Ogtinc |at 1447 42.4,42.6 |preany 8153  -- Wavethrashing (52)
complete 8231 |at 1447 69.2,73.0 |mobs Great Wavethrasher;Wavethrasher;Young Wavethrasher  -- Wavethrashing (52)
turnin 8231 |npc Ogtinc |at 1447 42.4,42.6  -- Wavethrashing (52)
accept 8232 |npc Ogtinc |at 1447 42.4,42.6 |group dungeon |preany 8231  -- The Green Drake (52)
complete 8232 |group dungeon  -- The Green Drake (52)
turnin 8232 |npc Ogtinc |at 1447 42.4,42.6 |group dungeon  -- The Green Drake (52)
]]}

Onward:RegisterGuide{
  id = "class_hunter_horde_rhokdelar", title = "Rhok'delar: The Ancient Leaf", kind = "class",
  class = "HUNTER", faction = "Horde", levels = { 60, 60 },
  steps = [[
accept 7632  -- The Ancient Leaf (60)
turnin 7632 |npc Vartrus the Ancient |at 1448 47.8,24.1  -- The Ancient Leaf (60)
accept 7633 |npc Vartrus the Ancient |at 1448 47.8,24.1 |preany 7632  -- An Introduction (60)
turnin 7633 |npc Vartrus the Ancient |at 1448 47.8,24.1  -- An Introduction (60)
accept 7634 |npc Hastat the Ancient |at 1448 46.7,24.1 |group dungeon |preany 7632  -- Ancient Sinew Wrapped Lamina (60)
complete 7634 |at 1452 56.7,51.7 |mobs Cobalt Wyrmkin;Cobalt Mageweaver;Cobalt Scalebane;General Colbatann |group dungeon  -- Ancient Sinew Wrapped Lamina (60)
turnin 7634 |npc Hastat the Ancient |at 1448 46.7,24.1 |group dungeon  -- Ancient Sinew Wrapped Lamina (60)
accept 7635 |npc Stoma the Ancient |at 1448 48.4,22.3 |group dungeon |preany 7632  -- A Proper String (60)
complete 7635 |group dungeon  -- A Proper String (60)
turnin 7635 |npc Stoma the Ancient |at 1448 48.4,22.3 |group dungeon  -- A Proper String (60)
accept 7636 |npc Vartrus the Ancient |at 1448 47.8,24.1 |group elite |preany 7632  -- Stave of the Ancients (60)
complete 7636 |at 1428 24.8,65.9 |item 18708 |mobs Artorius the Amiable;Franklin the Friendly;Nelson the Nice;Simone the Inconspicuous |group elite  -- Stave of the Ancients (60)
turnin 7636 |npc Vartrus the Ancient |at 1448 47.8,24.1 |group elite  -- Stave of the Ancients (60)
]]}
