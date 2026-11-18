-- DRAFT Mulgore (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "mulgore-h-2", title = "Mulgore (11-14)", faction = "Horde", zone = "Mulgore",
  levels = { 11, 14 },
  steps = [[
home |npc Innkeeper Kauth |at 1412 45.9,64.2  -- set your hearthstone at the inn
accept 99080 |npc Baine Bloodhoof |at 1412 46.7,63.4 |value mid |race Scourge,Tauren |lvl 4 |preany 99101  -- Drive Them Out (11)
accept 98427 |npc Morin Cloudstalker |at 1412 54.8,64.3 |group elite |lvl 5 |preany 98424  -- Ceasing Operations (12)
accept 765 |npc Morin Cloudstalker |at 1412 54.8,64.3 |lvl 5 |preany 751  -- Supervisor Fizsprocket (12)
accept 76160 |npc Boarton Shadetotem |at 1456 39.4,65.8 |race Orc,Tauren,Troll |lvl 4 |preany 76156  -- Stalk With The Earthmother (11)
accept 776 |npc Cairne Bloodhoof |at 1456 60.3,51.7 |lvl 3 |preany 775  -- Rites of the Earthmother (14)
accept 770 |at 1412 34.7,34.2 |note Starts from Demon Scarred Cloak |startitem 4854 |lvl 6  -- The Demon Scarred Cloak (12)
complete 76160 |at 1412 39.4,36.2 |item 206176 |race Orc,Tauren,Troll  -- Stalk With The Earthmother (11)
complete 776 |at 1412 51.2,24.8 |mobs Arra'chea@Horn of Arra'chea  -- Rites of the Earthmother (14)
complete 98427 |at 1412 56.8,42.8 |mobs Venture Co. Clearclutter@Clearcutter Key |group elite  -- Ceasing Operations (12)
complete 765 |at 1412 61.2,49.3 |mobs Supervisor Fizsprocket@Fizsprocket's Clipboard  -- Supervisor Fizsprocket (12)
complete 99080 |at 1412 61.6,61.5 |mobs Galak Centaur;Galak Outrunner;Herak the Pillager@Herak's Head |value mid |race Scourge,Tauren  -- Drive Them Out (11)
turnin 98427 |npc Morin Cloudstalker |at 1412 54.8,64.3 |group elite  -- Ceasing Operations (12)
turnin 765 |npc Morin Cloudstalker |at 1412 54.8,64.3  -- Supervisor Fizsprocket (12)
turnin 99080 |npc Baine Bloodhoof |at 1412 46.7,63.4 |value mid |race Scourge,Tauren  -- Drive Them Out (11)
accept 99082 |npc Baine Bloodhoof |at 1412 46.7,63.4 |value mid |race Scourge,Tauren |lvl 4 |preany 99080  -- The High Chieftain (11)
turnin 770 |npc Skorn Whitecloud |at 1412 46.0,63.4  -- The Demon Scarred Cloak (12)
turnin 776 |npc Cairne Bloodhoof |at 1456 60.3,51.7  -- Rites of the Earthmother (14)
turnin 76160 |npc Boarton Shadetotem |at 1456 39.4,65.8 |race Orc,Tauren,Troll  -- Stalk With The Earthmother (11)
accept 76240 |npc Boarton Shadetotem |at 1456 39.4,65.8 |race Orc,Tauren,Troll |lvl 4 |preany 76160  -- Stalk With The Earthmother (11)
fly 1413 44.5,59.1 |from 1456 47.0,49.8 |npc The Barrens (Omusa Thunderhorn)  -- flight master Tal
accept 854 |npc Kirge Sternhorn |at 1413 44.9,58.6 |race Tauren |lvl 9  -- Journey to the Crossroads (12)
fly 1413 51.5,30.3 |from 1413 44.5,59.1 |npc The Barrens (Devrak)  -- flight master Omusa Thunderhorn
turnin 854 |npc Thork |at 1413 51.5,30.9 |race Tauren  -- Journey to the Crossroads (12)
complete 76240 |at 1412 39.4,36.2 |item 206344 |race Orc,Tauren,Troll  -- Stalk With The Earthmother (11)
turnin 76240 |npc Boarton Shadetotem |at 1456 39.4,65.8 |race Orc,Tauren,Troll  -- Stalk With The Earthmother (11)
turnin 99082 |npc Cairne Bloodhoof |at 1456 60.3,51.7 |value mid |race Scourge,Tauren  -- The High Chieftain (11)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   96241  Talkin' bout Toxins, Mon (29)
--   96259  Defending the Dead (29)
--   96260  Stronger than Steel (29)
--   96261  The Broodmother (30)
--   96294  A Darker Truth (30)
--   96774  Ancient Gurubashi Idol (40)
--   96982  Your First Riding Kodo (40)
--   97204  Learning to Ride (40)
--   97198  Blackmaw Magic (59)
--   98477  Unstable Magic (60)
--   99196  A Donation of Wool (60)
--   99197  A Donation of Silk (60)
--   99198  A Donation of Mageweave (60)
