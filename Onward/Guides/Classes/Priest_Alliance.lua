-- GENERATED Priest (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_priest_alliance_garments", title = "Garments of the Light", kind = "class",
  class = "PRIEST", faction = "Alliance", race = "Human,Dwarf,NightElf,Gnome", levels = { 5, 5 },
  steps = [[
accept 5624 |npc Priestess Josetta |at 1429 43.3,65.7 |race Human  -- Garments of the Light (4)
complete 5624 |at 1429 48.1,68.0 |mobs Guard Roberts |race Human  -- Garments of the Light (4)
turnin 5624 |npc Priestess Josetta |at 1429 43.3,65.7 |race Human  -- Garments of the Light (4)
accept 5621 |npc Laurna Morninglight |at 1438 55.6,56.8 |race NightElf  -- Garments of the Moon (4)
complete 5621 |at 1438 57.2,63.5 |mobs Sentinel Shaya |race NightElf  -- Garments of the Moon (4)
turnin 5621 |npc Laurna Morninglight |at 1438 55.6,56.8 |race NightElf  -- Garments of the Moon (4)
accept 5625 |npc Maxan Anvol |at 1426 47.3,52.2 |race Dwarf,Gnome  -- Garments of the Light (4)
complete 5625 |at 1426 45.8,54.6 |mobs Mountaineer Dolf |race Dwarf,Gnome  -- Garments of the Light (4)
turnin 5625 |npc Maxan Anvol |at 1426 47.3,52.2 |race Dwarf,Gnome  -- Garments of the Light (4)
]]}

Onward:RegisterGuide{
  id = "class_priest_alliance_racial10", title = "Level 10 Racial Spell", kind = "class",
  class = "PRIEST", faction = "Alliance", race = "Human,Dwarf,NightElf,Gnome", levels = { 10, 10 },
  steps = [[
accept 94773 |npc High Priestess Laurena |at 1453 49.5,44.6 |race Human |exclusive 94774,94775,94776,94777,94778,94779  -- Divine Grace (10)
turnin 94773 |npc High Priestess Laurena |at 1453 49.5,44.6 |race Human  -- Divine Grace (10)
accept 5634 |npc High Priestess Laurena |at 1453 49.5,44.6 |race Dwarf |exclusive 5635,5636,5637,5638,5639,5640  -- Desperate Prayer (10)
turnin 5634 |npc High Priestess Laurena |at 1453 49.5,44.6 |race Dwarf  -- Desperate Prayer (10)
accept 5628 |npc Priestess Josetta |at 1429 43.3,65.7 |race NightElf |exclusive 5627,5629,5630,5631,5632,5633  -- Returning Home (10)
turnin 5628 |npc Priestess Alathea |at 1457 39.5,81.2 |race NightElf  -- Returning Home (10)
accept 94817 |npc High Priestess Mims |at 1426 55.0,22.4 |race Gnome |exclusive 94821,94822,94823,94824,94825,94826  -- Confounding Flash (10)
turnin 94817 |npc High Priestess Mims |at 1426 55.0,22.4 |race Gnome  -- Confounding Flash (10)
]]}

Onward:RegisterGuide{
  id = "class_priest_alliance_racial20", title = "Level 20 Racial Spell", kind = "class",
  class = "PRIEST", faction = "Alliance", race = "Human,Dwarf,NightElf,Gnome", levels = { 20, 20 },
  steps = [[
accept 5676 |npc High Priestess Laurena |at 1453 49.5,44.6 |race Human |exclusive 5677,5678  -- Arcane Feedback (20)
turnin 5676 |npc High Priestess Laurena |at 1453 49.5,44.6 |race Human  -- Arcane Feedback (20)
accept 5641 |npc High Priest Rohan |at 1455 24.7,8.2 |race Dwarf |exclusive 5645,5647  -- A Lack of Fear (20)
turnin 5641 |npc High Priest Rohan |at 1455 24.7,8.2 |race Dwarf  -- A Lack of Fear (20)
accept 5672 |npc Priestess Alathea |at 1457 39.5,81.2 |race NightElf |exclusive 5673,5674,5675  -- Elune's Grace (20)
turnin 5672 |npc Priestess Alathea |at 1457 39.5,81.2 |race NightElf  -- Elune's Grace (20)
accept 94818 |npc High Priestess Mims |at 1426 55.0,22.4 |race Gnome |exclusive 94819,94820  -- Contingency Plan (20)
turnin 94818 |npc High Priestess Mims |at 1426 55.0,22.4 |race Gnome  -- Contingency Plan (20)
]]}

Onward:RegisterGuide{
  id = "class_priest_alliance_trollscroll", title = "The Troll Scroll", kind = "class",
  class = "PRIEST", faction = "Alliance", levels = { 35, 35 },
  steps = [[
accept 79731  -- The Troll Scroll (35)
turnin 79731 |npc Hemet Nesingwary |at 1434 35.7,10.8  -- The Troll Scroll (35)
]]}

Onward:RegisterGuide{
  id = "class_priest_alliance_st50", title = "Sunken Temple: Blood of Morphaz", kind = "class",
  class = "PRIEST", faction = "Alliance", levels = { 50, 52 },
  steps = [[
accept 8254 |npc Brother Joshua |at 1453 49.5,45.2  -- Cenarion Aid (52)
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
  id = "class_priest_alliance_benediction", title = "Benediction / Anathema", kind = "class",
  class = "PRIEST", faction = "Alliance", levels = { 60, 60 },
  steps = [[
accept 7621 |npc Eris Havenfire |at 1423 17.2,12.8  -- A Warning (60)
turnin 7621 |npc Eris Havenfire |at 1423 17.2,12.8  -- A Warning (60)
accept 7622 |npc Eris Havenfire |at 1423 17.2,12.8  -- The Balance of Light and Shadow (60)
complete 7622 |at 1423 17.4,12.2  -- The Balance of Light and Shadow (60)
turnin 7622 |npc Eris Havenfire |at 1423 17.2,12.8  -- The Balance of Light and Shadow (60)
]]}
