-- GENERATED Priest (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_priest_horde_garments", title = "Garments of Faith", kind = "class",
  class = "PRIEST", faction = "Horde", race = "Scourge,Troll", levels = { 5, 5 },
  steps = [[
accept 5650 |npc Dark Cleric Beryl |at 1420 61.6,52.2 |race Scourge  -- Garments of Darkness (4)
complete 5650 |at 1420 59.2,46.5 |mobs Deathguard Kel |race Scourge  -- Garments of Darkness (4)
turnin 5650 |npc Dark Cleric Beryl |at 1420 61.6,52.2 |race Scourge  -- Garments of Darkness (4)
accept 5648 |npc Tai'jin |at 1411 54.3,42.9 |race Troll  -- Garments of Spirituality (4)
complete 5648 |at 1411 53.1,46.5 |mobs Grunt Kor'ja |race Troll  -- Garments of Spirituality (4)
turnin 5648 |npc Tai'jin |at 1411 54.3,42.9 |race Troll  -- Garments of Spirituality (4)
]]}

Onward:RegisterGuide{
  id = "class_priest_horde_racial10", title = "Level 10 Racial Spell", kind = "class",
  class = "PRIEST", faction = "Horde", race = "Scourge,Troll", levels = { 10, 10 },
  steps = [[
accept 5658 |npc Aelthalyste |at 1458 49.3,17.1 |race Scourge |exclusive 5660,5661,5662,5663  -- Touch of Weakness (10)
turnin 5658 |npc Aelthalyste |at 1458 49.3,17.1 |race Scourge  -- Touch of Weakness (10)
accept 5652 |npc Ur'kyo |at 1454 35.6,87.8 |race Troll |exclusive 5654,5655,5656,5657  -- Hex of Weakness (10)
turnin 5652 |npc Ur'kyo |at 1454 35.6,87.8 |race Troll  -- Hex of Weakness (10)
]]}

Onward:RegisterGuide{
  id = "class_priest_horde_racial20", title = "Level 20 Racial Spell", kind = "class",
  class = "PRIEST", faction = "Horde", race = "Scourge,Troll", levels = { 20, 20 },
  steps = [[
accept 5644 |npc Miles Welsh |at 1456 25.3,15.3 |race Scourge |exclusive 5646,5679  -- Dark Sacrifice (20)
turnin 5644 |npc Aelthalyste |at 1458 49.3,17.1 |race Scourge  -- Dark Sacrifice (20)
accept 5642 |npc Miles Welsh |at 1456 25.3,15.3 |race Troll |exclusive 5643,5680  -- Shadowguard (20)
turnin 5642 |npc Ur'kyo |at 1454 35.6,87.8 |race Troll  -- Shadowguard (20)
]]}

Onward:RegisterGuide{
  id = "class_priest_horde_trollscroll", title = "The Troll Scroll", kind = "class",
  class = "PRIEST", faction = "Horde", levels = { 35, 35 },
  steps = [[
accept 79731  -- The Troll Scroll (35)
turnin 79731 |npc Hemet Nesingwary |at 1434 35.7,10.8  -- The Troll Scroll (35)
]]}

Onward:RegisterGuide{
  id = "class_priest_horde_st50", title = "Sunken Temple: Blood of Morphaz", kind = "class",
  class = "PRIEST", faction = "Horde", levels = { 50, 52 },
  steps = [[
accept 8254 |npc Ur'kyo |at 1454 35.6,87.8  -- Cenarion Aid (52)
turnin 8254 |npc Ogtinc |at 1447 42.4,42.6  -- Cenarion Aid (52)
accept 8255 |npc Ogtinc |at 1447 42.4,42.6 |preany 8254  -- Of Coursers We Know (52)
complete 8255 |at 1447 48.0,74.7 |mobs Mosshoof Courser  -- Of Coursers We Know (52)
turnin 8255 |npc Ogtinc |at 1447 42.4,42.6  -- Of Coursers We Know (52)
accept 8256 |npc Ogtinc |at 1447 42.4,42.6 |preany 8255  -- The Ichor of Undeath (52)
complete 8256 |at 1447 17.3,68.5 |mobs Diseased Flayer;Skeletal Acolyte;Skeletal Flayer;Slavering Ghoul  -- The Ichor of Undeath (52)
turnin 8256 |npc Ogtinc |at 1447 42.4,42.6  -- The Ichor of Undeath (52)
accept 8257 |npc Ogtinc |at 1447 42.4,42.6 |group dungeon |preany 8256  -- Blood of Morphaz (52)
complete 8257 |group dungeon  -- Blood of Morphaz (52)
turnin 8257 |npc Greta Mosshoof |at 1448 51.2,82.1 |group dungeon  -- Blood of Morphaz (52)
]]}

Onward:RegisterGuide{
  id = "class_priest_horde_benediction", title = "Benediction / Anathema", kind = "class",
  class = "PRIEST", faction = "Horde", levels = { 60, 60 },
  steps = [[
accept 7621 |npc Eris Havenfire |at 1423 17.2,12.8  -- A Warning (60)
turnin 7621 |npc Eris Havenfire |at 1423 17.2,12.8  -- A Warning (60)
accept 7622 |npc Eris Havenfire |at 1423 17.2,12.8  -- The Balance of Light and Shadow (60)
complete 7622 |at 1423 17.4,12.2  -- The Balance of Light and Shadow (60)
turnin 7622 |npc Eris Havenfire |at 1423 17.2,12.8  -- The Balance of Light and Shadow (60)
]]}
