-- DRAFT Ashenvale (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "ashenvale-a-1", title = "Ashenvale (19-26)", faction = "Alliance", zone = "Ashenvale",
  levels = { 19, 26 },
  next = "ashenvale-a-2",
  steps = [[
home |npc Innkeeper Kimlya |at 1440 37.0,49.2  -- set your hearthstone at the inn
accept 991 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- Raene's Cleansing (19)
accept 1054 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- Culling the Threat (25)
accept 1056 |npc Faldreas Goeth'Shael |at 1440 35.8,49.1  -- Journey to Stonetalon Peak (18)
accept 1070 |npc Sentinel Thenysil |at 1440 34.9,49.8  -- On Guard in Stonetalon (21)
accept 1008 |npc Shindrell Swiftfire |at 1440 34.7,48.8 |value mid  -- The Zoram Strand (19)
turnin 1008 |npc Shindrell Swiftfire |at 1440 34.7,48.8 |value mid  -- The Zoram Strand (19)
accept 1134 |npc Shindrell Swiftfire |at 1440 34.7,48.8 |value mid  -- Pridewings of Stonetalon (21)
turnin 991 |npc Teronis' Corpse |at 1440 20.3,42.3  -- Raene's Cleansing (19)
accept 1023 |npc Teronis' Corpse |at 1440 20.3,42.3  -- Raene's Cleansing (21)
complete 1023 |at 1440 20.5,43.2 |mobs Saltspittle Puddlejumper;Saltspittle Warrior;Saltspittle Oracle;Saltspittle Muckdweller  -- Raene's Cleansing (21)
turnin 1007 |npc Talen |at 1440 14.8,31.3  -- The Ancient Statuette (20)
accept 1009 |npc Talen |at 1440 14.8,31.3  -- Ruuzel (25)
accept 1007 |npc Talen |at 1440 14.8,31.3  -- The Ancient Statuette (20)
fly 1442 36.4,7.2 |from 1440 34.4,48.0 |npc Stonetalon Mountains (Teloren)  -- flight master Daelyshia
turnin 1056 |npc Keeper Albagorm |at 1442 37.1,8.1  -- Journey to Stonetalon Peak (18)
turnin 1070 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- On Guard in Stonetalon (21)
accept 1085 |npc Kaela Shadowspear |at 1442 59.9,66.8  -- On Guard in Stonetalon (21)
complete 1134 |at 1442 51.8,43.2 |value mid  -- Pridewings of Stonetalon (21)
turnin 1085 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- On Guard in Stonetalon (21)
fly 1439 36.3,45.6 |from 1442 36.4,7.2 |npc Darkshore (Caylais Moonfeather)  -- flight master Teloren
accept 990 |npc Sentinel Selarin |at 1439 39.3,43.5  -- Trek to Ashenvale (19)
fly 1440 34.4,48.0 |from 1439 36.3,45.6 |npc Daelyshia  -- flight master Caylais Moonfeather
complete 1009 |at 1440 7.2,13.1 |mobs Ruuzel  -- Ruuzel (25)
complete 1007 |at 1440 14.2,20.6  -- The Ancient Statuette (20)
complete 1008 |at 1440 10.7,24.2 |mobs Wrathtail Sorceress;Wrathtail Priestess;Wrathtail Myrmidon;Wrathtail Razortail |value mid  -- The Zoram Strand (19)
turnin 1009 |npc Talen |at 1440 14.8,31.3  -- Ruuzel (25)
accept 1010 |npc Orendil Broadleaf |at 1440 26.4,38.6  -- Bathran's Hair (20)
complete 1054 |at 1440 39.6,36.3 |mobs Dal Bloodclaw  -- Culling the Threat (25)
complete 1010 |at 1440 31.9,22.9  -- Bathran's Hair (20)
turnin 1010 |npc Orendil Broadleaf |at 1440 26.4,38.6  -- Bathran's Hair (20)
accept 1020 |npc Orendil Broadleaf |at 1440 26.4,38.6  -- Orendil's Cure (20)
turnin 1134 |npc Shindrell Swiftfire |at 1440 34.7,48.8 |value mid  -- Pridewings of Stonetalon (21)
turnin 1023 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- Raene's Cleansing (21)
accept 1025 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- An Aggressive Defense (24)
turnin 1054 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- Culling the Threat (25)
accept 1024 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- Raene's Cleansing (21)
turnin 1020 |npc Pelturas Whitemoon |at 1440 37.4,51.8  -- Orendil's Cure (20)
accept 1033 |npc Pelturas Whitemoon |at 1440 37.4,51.8  -- Elune's Tear (22)
accept 1016 |npc Sentinel Velene Starstrike |at 1440 49.8,67.2  -- Elemental Bracers (24)
complete 1016 |at 1440 47.1,67.4 |mobs Befouled Water Elemental;Furious Astranaar Sentinel;Astranaar Sentinel;Silverwing Sentinel  -- Elemental Bracers (24)
turnin 1016 |npc Sentinel Velene Starstrike |at 1440 49.8,67.2  -- Elemental Bracers (24)
accept 1017 |npc Sentinel Velene Starstrike |at 1440 49.8,67.2  -- Mage Summoner (25)
complete 1025 |at 1440 53.8,62.0 |mobs Foulweald Den Watcher;Foulweald Ursa;Foulweald Totemic;Foulweald Warrior  -- An Aggressive Defense (24)
accept 98027 |npc Gleaming Crescent Pendant |at 1440 63.0,71.6  -- Gleaming Crescent Necklace (26)
turnin 1024 |npc Shael'dryn |at 1440 53.5,46.2  -- Raene's Cleansing (21)
complete 1033 |at 1440 46.1,46.3  -- Elune's Tear (22)
turnin 990 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- Trek to Ashenvale (19)
turnin 1025 |npc Raene Wolfrunner |at 1440 36.6,49.6  -- An Aggressive Defense (24)
turnin 98027 |npc Maliynn |at 1440 36.6,50.0  -- Gleaming Crescent Necklace (26)
complete 1017 |at 1440 36.1,50.8 |mobs Furious Astranaar Sentinel;Astranaar Sentinel;Silverwing Sentinel  -- Mage Summoner (25)
turnin 1033 |npc Pelturas Whitemoon |at 1440 37.4,51.8  -- Elune's Tear (22)
accept 1034 |npc Pelturas Whitemoon |at 1440 37.4,51.8 |value low  -- The Ruins of Stardust (23)
turnin 1017 |npc Sentinel Velene Starstrike |at 1440 49.8,67.2  -- Mage Summoner (25)
complete 1034 |at 1440 33.3,68.0 |value low  -- The Ruins of Stardust (23)
turnin 1034 |npc Pelturas Whitemoon |at 1440 37.4,51.8 |value low  -- The Ruins of Stardust (23)
]]}
