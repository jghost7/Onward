-- DRAFT The Barrens (Horde) generated 2026-11-18 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "the-barrens-h-3", title = "The Barrens (27-34)", faction = "Horde", zone = "The Barrens",
  levels = { 27, 34 },
  steps = [[
accept 874 |npc Jorn Skyseer |at 1413 44.9,59.1 |lvl 9 |preany 913  -- Mahren Skyseer (27)
accept 1153 |npc Tatternack Steelforge |at 1413 45.1,57.7 |lvl 25 |preany 893  -- A New Ore Sample (29)
fly 1413 63.1,37.2 |from 1413 44.5,59.1 |npc Bragok  -- flight master Omusa Thunderhorn
turnin 874 |npc Mahren Skyseer |at 1413 65.8,43.9  -- Mahren Skyseer (27)
accept 873 |npc Mahren Skyseer |at 1413 65.8,43.9 |value low |lvl 10 |preany 874  -- Isha Awak (27)
complete 873 |at 1413 64.1,50.9 |mobs Isha Awak@Heart of Isha Awak |value low  -- Isha Awak (27)
turnin 873 |npc Mahren Skyseer |at 1413 65.8,43.9 |value low  -- Isha Awak (27)
accept 3514 |npc Kadrak |at 1413 48.1,5.4 |group elite |lvl 15 |preany 3513  -- Horde Presence (29)
fly 1442 45.1,59.8 |from 1413 51.5,30.3 |npc Stonetalon Mountains (Tharm)  -- flight master Devrak
complete 3514 |at 1442 29.7,16.9 |item 10622 |mobs Rynthariel the Keymaster |group elite  -- Horde Presence (29)
fly 1456 47.0,49.8 |from 1442 45.1,59.8 |npc Thunder Bluff (Tal)  -- flight master Tharm
accept 1102 |npc Auld Stonespire |at 1456 36.0,59.9 |group dungeon |lvl 29  -- A Vengeful Fate (34)
fly 1413 51.5,30.3 |from 1456 47.0,49.8 |npc Devrak  -- flight master Tal
turnin 3514 |npc Kadrak |at 1413 48.1,5.4 |group elite  -- Horde Presence (29)
accept 1145 |npc Korran |at 1413 51.1,29.6 |lvl 29  -- The Swarm Grows (33)
complete 1102 |at 1413 51.4,29.9 |mobs Vengeful Guard |group dungeon  -- A Vengeful Fate (34)
complete 1153 |at 1413 49.2,40.9 |mobs Barrens Giraffe;Wandering Barrens Giraffe;Lost Barrens Kodo;Barrens Guard  -- A New Ore Sample (29)
turnin 1153 |npc Tatternack Steelforge |at 1413 45.1,57.7  -- A New Ore Sample (29)
accept 857 |npc Feegly the Exiled |at 1413 49.0,86.3 |lvl 22  -- The Tear of the Moons (30)
complete 857 |at 1413 49.1,84.2  -- The Tear of the Moons (30)
turnin 857 |npc Feegly the Exiled |at 1413 49.0,86.3  -- The Tear of the Moons (30)
fly 1456 47.0,49.8 |from 1413 44.5,59.1 |npc Thunder Bluff (Tal)  -- flight master Omusa Thunderhorn
turnin 1102 |npc Auld Stonespire |at 1456 36.0,59.9 |group dungeon  -- A Vengeful Fate (34)
fly 1413 63.1,37.2 |from 1456 47.0,49.8 |npc Bragok  -- flight master Tal
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1458 63.2,48.6 |from 1434 26.9,77.1 |npc Undercity (Michael Garrett)  -- flight master Gringer
accept 1109 |npc Master Apothecary Faranell |at 1458 48.8,69.3 |group dungeon |lvl 30  -- Going, Going, Guano! (33)
complete 1109 |group dungeon  -- Going, Going, Guano! (33)
turnin 1109 |npc Master Apothecary Faranell |at 1458 48.8,69.3 |group dungeon  -- Going, Going, Guano! (33)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 1145 |npc Belgrom Rockmaul |at 1454 75.2,34.2  -- The Swarm Grows (33)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   98890  Conflict at Darkspear Islands (49)
--   93862  Crate Return (60)
--   95819  Sign Me Up! (60)
--   96339  Legacy Reward: Replica Ironforge Air Rifle (60)
--   96383  Legacy Reward: Spectral Bear Cub (60)
--   98248  Shipping Label (60)
