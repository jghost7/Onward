-- DRAFT Desolace (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /sq rec running and fix what feels wrong. Coordinates are spawn medoids.
SloppyQuesting:RegisterGuide{
  id = "desolace-a-2", title = "Desolace (40-45)", faction = "Alliance", zone = "Desolace",
  levels = { 40, 45 },
  steps = [[
accept 1052 |npc Brother Anton |at 1443 66.5,7.9  -- Down the Scarlet Path (40)
fly 1424 49.3,52.3 |from 1443 64.7,10.5 |npc Hillsbrad Foothills (Darla Harris)  -- flight master Baritanas Skyriver
turnin 1052 |npc Raleigh the Devout |at 1424 51.5,58.4  -- Down the Scarlet Path (40)
fly 1443 64.7,10.5 |from 1424 49.3,52.3 |npc Baritanas Skyriver  -- flight master Darla Harris
accept 1466 |npc Kreldig Ungor |at 1443 66.2,9.6 |value mid  -- Reagents for Reclaimers Inc. (40)
accept 93224 |npc Captain Pentigast |at 1443 66.7,10.9 |value mid  -- Carved Centaur Totems (40)
accept 93226 |npc Captain Pentigast |at 1443 66.7,10.9 |value mid  -- Buying Friendship: Magram (45)
accept 1381 |npc Warug |at 1443 75.0,68.2 |group elite  -- Khan Hratha (42)
complete 1466 |at 1443 54.1,78.2 |mobs Nether Maiden;Mage Hunter;Ley Hunter;Doomwarder Captain |value mid  -- Reagents for Reclaimers Inc. (40)
accept 96222 |npc Umarak |at 1443 43.5,79.0 |group elite  -- Khan Hratha (42)
accept 1380 |npc Uthek the Wise |at 1443 36.2,79.2 |group elite  -- Khan Hratha (42)
complete 96222 |at 1443 29.6,52.0 |mobs Khan Hratha |group elite  -- Khan Hratha (42)
complete 1381 |at 1443 29.6,52.0 |mobs Khan Hratha |group elite  -- Khan Hratha (42)
complete 1380 |at 1443 29.6,52.0 |mobs Khan Hratha |group elite  -- Khan Hratha (42)
accept 79229 |npc Extinguished Campfire |at 1443 47.5,54.6  -- Highway Robbery (40)
turnin 1380 |npc Uthek the Wise |at 1443 36.2,79.2 |group elite  -- Khan Hratha (42)
turnin 96222 |npc Umarak |at 1443 43.5,79.0 |group elite  -- Khan Hratha (42)
accept 93196 |npc Orgrul |at 1443 65.4,84.2  -- Khan Jehn (42)
turnin 93226 |npc Gorhak |at 1443 66.2,79.4 |value mid  -- Buying Friendship: Magram (45)
complete 93224 |at 1443 65.1,75.9 |mobs Magram Guardian;Gelkis Windchaser;Gelkis Stamper;Magram Wrangler |value mid  -- Carved Centaur Totems (40)
turnin 93196 |npc Khan Jehn |at 1443 73.8,73.9  -- Khan Jehn (42)
turnin 1381 |npc Warug |at 1443 75.0,68.2 |group elite  -- Khan Hratha (42)
accept 92743 |npc Warug |at 1443 75.0,68.2  -- A Conqueror's Crown (40)
turnin 92743 |npc Warug |at 1443 75.0,68.2  -- A Conqueror's Crown (40)
turnin 79229 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0  -- Highway Robbery (40)
accept 79235 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0  -- On the Lam (40)
turnin 93224 |npc Captain Pentigast |at 1443 66.7,10.9 |value mid  -- Carved Centaur Totems (40)
turnin 1466 |npc Kreldig Ungor |at 1443 66.2,9.6 |value mid  -- Reagents for Reclaimers Inc. (40)
fly 1434 27.5,77.8 |from 1443 64.7,10.5 |npc Stranglethorn Vale (Gyll)  -- flight master Baritanas Skyriver
turnin 79235 |npc Tokal |at 1434 27.0,77.3  -- On the Lam (40)
accept 79236 |npc Tokal |at 1434 27.0,77.3  -- Cherry for Your Thoughts? (40)
fly 1443 64.7,10.5 |from 1434 27.5,77.8 |npc Baritanas Skyriver  -- flight master Gyll
accept 1467 |npc Kreldig Ungor |at 1443 66.2,9.6 |value mid  -- Reagents for Reclaimers Inc. (40)
complete 79236  -- Cherry for Your Thoughts? (40)
fly 1434 27.5,77.8 |from 1443 64.7,10.5 |npc Stranglethorn Vale (Gyll)  -- flight master Baritanas Skyriver
turnin 79236 |npc Tokal |at 1434 27.0,77.3  -- Cherry for Your Thoughts? (40)
accept 79242 |npc Tokal |at 1434 27.0,77.3  -- No Honor Among Thieves (40)
fly 1455 55.5,47.7 |from 1434 27.5,77.8 |npc Ironforge (Gryth Thurden) |value mid  -- flight master Gyll
turnin 1467 |npc Roetten Stonehammer |at 1455 70.0,21.3 |value mid  -- Reagents for Reclaimers Inc. (40)
fly 1417 45.7,46.1 |from 1455 55.5,47.7 |npc Arathi Highlands (Cedrik Prose)  -- flight master Gryth Thurden
turnin 79242 |npc Illari's Loot Cache |at 1417 94.2,69.3  -- No Honor Among Thieves (40)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   92811  Economic Warfare (60)
