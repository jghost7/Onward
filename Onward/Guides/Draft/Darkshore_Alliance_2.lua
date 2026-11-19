-- DRAFT Darkshore (Alliance) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "darkshore-a-2", title = "Darkshore (19-24)", faction = "Alliance", zone = "Darkshore",
  levels = { 19, 24 },
  steps = [[
accept 4731 |npc Beached Sea Turtle |at 1439 31.7,83.7 |lvl 13 |preany 4681  -- Beached Sea Turtle (19)
accept 4732 |npc Beached Sea Turtle |at 1439 31.2,85.6 |lvl 13 |preany 4681  -- Beached Sea Turtle (19)
accept 4733 |npc Beached Sea Creature |at 1439 31.3,87.4 |lvl 13 |preany 4681  -- Beached Sea Creature (19)
accept 98013 |npc Arbal |at 1439 43.6,76.4 |value low |lvl 12 |preany 950  -- Swelling Forces (20)
accept 951 |npc Onu |at 1439 43.5,76.3 |lvl 12 |preany 950  -- Mathystra Relics (20)
home |npc Innkeeper Shaussiy |at 1439 37.0,44.1  -- set your hearthstone at the inn
turnin 4731 |npc Gwennyth Bly'Leggonde |at 1439 36.6,45.6  -- Beached Sea Turtle (19)
turnin 4732 |npc Gwennyth Bly'Leggonde |at 1439 36.6,45.6  -- Beached Sea Turtle (19)
turnin 4733 |npc Gwennyth Bly'Leggonde |at 1439 36.6,45.6  -- Beached Sea Creature (19)
accept 87760 |npc Gwennyth Bly'Leggonde |at 1439 36.6,45.6 |lvl 15 |pre 4722,4723,4725,4727,4728,4730,4731,4732,4733  -- Holy Diver (20)
accept 986 |npc Terenthis |at 1439 39.4,43.5 |value mid |lvl 10 |preany 985  -- A Lost Master (20)
accept 98028 |at 1439 59.2,22.8 |note Starts from Clouded Water Globe |startitem 279275 |lvl 17  -- Baron Marinous (21)
complete 951 |at 1439 60.3,21.7  -- Mathystra Relics (20)
complete 98013 |at 1439 58.9,20.9 |mobs Stormscale Myrmidon;Stormscale Sorceress;Stormscale Warrior |value low  -- Swelling Forces (20)
accept 2098 |npc Gelkak Gyromast |at 1439 56.7,13.5 |value mid |lvl 14  -- Gyromast's Retrieval (20)
complete 2098 |at 1439 56.0,14.9 |areas 31.4,87.5:53;38.7,29.2:35;56.0,14.9:32 |mobs Giant Foreststrider@Top of Gelkak's Key;Greymist Coastrunner@Middle of Gelkak's Key;Raging Reef Crawler@Bottom of Gelkak's Key;Greymist Seer@Middle of Gelkak's Key |value mid  -- Gyromast's Retrieval (20)
turnin 2098 |npc Gelkak Gyromast |at 1439 56.7,13.5 |value mid  -- Gyromast's Retrieval (20)
accept 2078 |npc Gelkak Gyromast |at 1439 56.7,13.5 |value mid |lvl 14 |preany 2098  -- Gyromast's Revenge (20)
complete 2078 |at 1439 55.8,18.3 |item 7442 |mobs The Threshwackonator 4100 |value mid  -- Gyromast's Revenge (20)
turnin 2078 |npc Gelkak Gyromast |at 1439 56.7,13.5 |value mid  -- Gyromast's Revenge (20)
complete 986 |at 1439 61.0,11.9 |areas 38.5,90.5:14;61.0,11.9:7 |mobs Moonstalker Sire@Fine Moonstalker Pelt;Moonstalker Matriarch@Fine Moonstalker Pelt |value mid  -- A Lost Master (20)
complete 87760 |at 1439 49.9,12.2 |mobs Stormscale Beastmistress@Rod of Deep Dominion  -- Holy Diver (20)
accept 741 |npc Archaeologist Hollee |at 1439 37.4,41.8 |lvl 15 |preany 731  -- The Absent Minded Prospector (20)
accept 729 |npc Archaeologist Hollee |at 1439 37.4,41.8 |lvl 15  -- The Absent Minded Prospector (20)
turnin 986 |npc Terenthis |at 1439 39.4,43.5 |value mid  -- A Lost Master (20)
accept 993 |npc Terenthis |at 1439 39.4,43.5 |value mid |lvl 10 |preany 986  -- A Lost Master (20)
turnin 87760 |npc Gwennyth Bly'Leggonde |at 1439 36.6,45.6  -- Holy Diver (20)
turnin 741 |npc Chief Archaeologist Greywhisker |at 1457 31.2,84.5  -- The Absent Minded Prospector (20)
accept 942 |npc Chief Archaeologist Greywhisker |at 1457 31.2,84.5 |lvl 15 |preany 741  -- The Absent Minded Prospector (20)
accept 970 |npc Delgren the Purifier |at 1440 26.2,38.7 |lvl 13 |preany 967  -- The Tower of Althalaxx (21)
complete 970 |at 1440 31.3,31.0  -- The Tower of Althalaxx (21)
turnin 970 |npc Delgren the Purifier |at 1440 26.2,38.7  -- The Tower of Althalaxx (21)
accept 973 |npc Delgren the Purifier |at 1440 26.2,38.7 |lvl 13 |preany 970  -- The Tower of Althalaxx (24)
complete 973 |at 1440 25.3,60.7  -- The Tower of Althalaxx (24)
turnin 973 |npc Delgren the Purifier |at 1440 26.2,38.7  -- The Tower of Althalaxx (24)
fly 1439 36.3,45.6 |from 1440 34.4,48.0 |npc Caylais Moonfeather  -- flight master Daelyshia
goto 1439 32.4,43.8 15 |note Take the boat to Menethil Harbor  -- boat Auberdine to Menethil Harbor
turnin 942 |npc Archaeologist Flagongut |at 1437 10.8,60.4  -- The Absent Minded Prospector (20)
accept 943 |npc Archaeologist Flagongut |at 1437 10.8,60.4 |lvl 15 |preany 942  -- The Absent Minded Prospector (24)
goto 1437 4.8,63.6 15 |note Take the boat to Auberdine  -- boat Menethil Harbor to Auberdine
turnin 729 |npc Prospector Remtravel |at 1439 35.7,83.7  -- The Absent Minded Prospector (20)
complete 943 |at 1439 36.2,85.9 |mobs Stone Behemoth  -- The Absent Minded Prospector (24)
turnin 993 |npc Volcor |at 1439 45.0,85.3 |value mid  -- A Lost Master (20)
turnin 98013 |npc Arbal |at 1439 43.6,76.4 |value low  -- Swelling Forces (20)
turnin 951 |npc Onu |at 1439 43.5,76.3  -- Mathystra Relics (20)
turnin 98028 |npc Onu |at 1439 43.5,76.3  -- Baron Marinous (21)
goto 1439 32.4,43.8 15 |note Take the boat to Menethil Harbor  -- boat Auberdine to Menethil Harbor
turnin 943 |npc Archaeologist Flagongut |at 1437 10.8,60.4  -- The Absent Minded Prospector (24)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   1140  The Tower of Althalaxx (28)
--   1167  The Tower of Althalaxx (28)
--   981  The Tower of Althalaxx (31)
--   1143  The Tower of Althalaxx (31)
