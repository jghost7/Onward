-- DRAFT Burning Steppes (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "burning-steppes-a", title = "Burning Steppes (52-60)", faction = "Alliance", zone = "Burning Steppes",
  levels = { 52, 60 },
  steps = [[
accept 4296 |npc Maxwort Uberglint |at 1428 65.2,23.9  -- Tablet of the Seven (50)
accept 4726 |npc Tinkee Steamboil |at 1428 65.2,24.0  -- Broodling Essence (52)
accept 4022 |npc Cyrus Therepentous |at 1428 95.1,31.6 |group elite  -- A Taste of Flame (54)
complete 4022 |at 1428 94.4,31.8 |mobs Cyrus Therepentous;Frenzied Black Drake@Black Dragonflight Molt |group elite  -- A Taste of Flame (54)
turnin 4022 |npc Cyrus Therepentous |at 1428 95.1,31.6 |group elite  -- A Taste of Flame (54)
accept 4182 |npc Helendis Riverhorn |at 1428 85.8,69.0 |group elite  -- Dragonkin Menace (54)
accept 3823 |npc Oralius |at 1428 84.6,68.7  -- Extinguish the Firegut (52)
complete 3823 |at 1428 80.0,44.6 |mobs Firegut Ogre Mage;Firegut Ogre;Firegut Brute  -- Extinguish the Firegut (52)
complete 4182 |at 1428 87.2,39.8 |mobs Black Broodling;Black Dragonspawn;Black Drake;Black Wyrmkin |group elite  -- Dragonkin Menace (54)
turnin 4182 |npc Helendis Riverhorn |at 1428 85.8,69.0 |group elite  -- Dragonkin Menace (54)
accept 4183 |npc Helendis Riverhorn |at 1428 85.8,69.0 |group chain  -- The True Masters (54)
turnin 3823 |npc Oralius |at 1428 84.6,68.7  -- Extinguish the Firegut (52)
accept 4283 |npc Oralius |at 1428 84.6,68.7 |value mid  -- FIFTY! YEP! (56)
accept 3824 |npc Oralius |at 1428 84.6,68.7  -- Gor'tesh the Brute Lord (53)
complete 4726 |at 1428 63.8,57.3 |item 12284  -- Broodling Essence (52)
complete 3824 |at 1428 54.2,52.6 |mobs Grubbub@Gor'tesh's Lopped Off Head;Gor'tesh@Gor'tesh's Lopped Off Head  -- Gor'tesh the Brute Lord (53)
complete 4283 |at 1428 45.0,51.1 |mobs Blackrock Slayer@Blackrock Medallion;Blackrock Warlock@Blackrock Medallion;Blackrock Soldier@Blackrock Medallion;Blackrock Sorcerer@Blackrock Medallion |value mid  -- FIFTY! YEP! (56)
complete 4296 |at 1428 54.1,40.8  -- Tablet of the Seven (50)
turnin 3824 |npc Oralius |at 1428 84.6,68.7  -- Gor'tesh the Brute Lord (53)
accept 3825 |npc Oralius |at 1428 84.6,68.7  -- Ogre Head On A Stick = Party (53)
turnin 4283 |npc Oralius |at 1428 84.6,68.7 |value mid  -- FIFTY! YEP! (56)
complete 3825 |at 1428 81.0,46.8 |item 11079  -- Ogre Head On A Stick = Party (53)
turnin 4296 |npc Maxwort Uberglint |at 1428 65.2,23.9  -- Tablet of the Seven (50)
turnin 4726 |npc Tinkee Steamboil |at 1428 65.2,24.0  -- Broodling Essence (52)
accept 5522 |npc Tinkee Steamboil |at 1428 65.2,24.0 |group chain  -- Leonid Barthalomew (60)
accept 4808 |npc Tinkee Steamboil |at 1428 65.2,24.0  -- Felnok Steelspring (54)
fly 1433 25.5,59.4 |from 1428 84.3,68.3 |npc Redridge Mountains (Ariena Stormfeather)  -- flight master Borgus Stoutarm
turnin 4183 |npc Magistrate Solomon |at 1433 24.9,44.5 |group chain  -- The True Masters (54)
fly 1453 71.3,72.2 |from 1433 25.5,59.4 |npc Stormwind City (Dungar Longdrink)  -- flight master Ariena Stormfeather
accept 4186 |npc Highlord Bolvar Fordragon |at 1453 80.2,38.4 |group chain  -- The True Masters (54)
fly 1433 25.5,59.4 |from 1453 71.3,72.2 |npc Redridge Mountains (Ariena Stormfeather)  -- flight master Dungar Longdrink
turnin 4186 |npc Magistrate Solomon |at 1433 24.9,44.5 |group chain  -- The True Masters (54)
accept 4223 |npc Magistrate Solomon |at 1433 24.9,44.5 |group chain  -- The True Masters (54)
accept 4184 |npc Magistrate Solomon |at 1433 24.9,44.5 |group chain  -- The True Masters (54)
fly 1423 71.8,49.6 |from 1433 25.5,59.4 |npc Eastern Plaguelands (Khaelyn Steelwing)  -- flight master Ariena Stormfeather
turnin 5522 |npc Leonid Barthalomew the Revered |at 1423 71.9,48.3 |group chain  -- Leonid Barthalomew (60)
fly 1453 71.3,72.2 |from 1423 71.8,49.6 |npc Stormwind City (Dungar Longdrink)  -- flight master Khaelyn Steelwing
turnin 4184 |npc Highlord Bolvar Fordragon |at 1453 80.2,38.4 |group chain  -- The True Masters (54)
fly 1434 27.5,77.8 |from 1453 71.3,72.2 |npc Stranglethorn Vale (Gyll)  -- flight master Dungar Longdrink
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1452 62.3,36.6 |from 1413 63.1,37.2 |npc Winterspring (Maethrya)  -- flight master Bragok
turnin 4808 |npc Felnok Steelspring |at 1452 61.6,38.6  -- Felnok Steelspring (54)
fly 1413 63.1,37.2 |from 1452 62.3,36.6 |npc The Barrens (Bragok)  -- flight master Maethrya
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1428 84.3,68.3 |from 1434 27.5,77.8 |npc Borgus Stoutarm  -- flight master Gyll
turnin 3825 |npc Oralius |at 1428 84.6,68.7  -- Ogre Head On A Stick = Party (53)
turnin 4223 |npc Marshal Maxwell |at 1428 84.7,69.0 |group chain  -- The True Masters (54)
]]}
