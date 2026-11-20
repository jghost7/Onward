-- DRAFT Desolace (Alliance) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "desolace-a-2", title = "Desolace (40-45)", faction = "Alliance", zone = "Desolace",
  levels = { 40, 45 },
  steps = [[
home |npc Innkeeper Lyshaerya |at 1443 66.3,6.5  -- set your hearthstone at the inn
accept 1052 |npc Brother Anton |at 1443 66.5,7.9 |lvl 34 |preany 261  -- Down the Scarlet Path (40)
accept 1466 |npc Kreldig Ungor |at 1443 66.2,9.6 |value mid |lvl 30 |preany 1459  -- Reagents for Reclaimers Inc. (40)
accept 93226 |npc Captain Pentigast |at 1443 66.7,10.9 |value mid |lvl 30 |preany 93224,93225  -- Buying Friendship: Magram (45)
accept 93224 |npc Captain Pentigast |at 1443 66.7,10.9 |value mid |lvl 30  -- Carved Centaur Totems (40)
complete 93224 |at 1443 71.5,45.5 |areas 68.5,77.4:121;36.5,85.0:75;71.5,45.5:56;30.8,55.7:48 |mobs Magram Guardian@Carved Centaur Totem;Gelkis Windchaser@Carved Centaur Totem;Gelkis Stamper@Carved Centaur Totem;Magram Wrangler@Carved Centaur Totem |value mid  -- Carved Centaur Totems (40)
accept 1381 |npc Warug |at 1443 75.0,68.2 |group elite |lvl 30 |preany 1375  -- Khan Hratha (42)
complete 1466 |at 1443 80.1,77.1 |areas 51.7,82.5:25;80.1,77.1:5 |mobs Nether Maiden@Nether Wing;Mage Hunter@Felhound Brain;Ley Hunter@Felhound Brain;Doomwarder Captain@Doomwarder Blood |value mid  -- Reagents for Reclaimers Inc. (40)
turnin 93226 |npc Gorhak |at 1443 66.2,79.4 |value mid  -- Buying Friendship: Magram (45)
accept 93196 |npc Orgrul |at 1443 65.4,84.2 |lvl 35 |preany 93188  -- Khan Jehn (42)
accept 96222 |npc Umarak |at 1443 43.5,79.0 |group elite |lvl 35  -- Khan Hratha (42)
accept 1380 |npc Uthek the Wise |at 1443 36.2,79.2 |group elite |lvl 30 |preany 1374  -- Khan Hratha (42)
complete 1380 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
complete 1381 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
complete 96222 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
accept 79229 |npc Extinguished Campfire |at 1443 47.5,54.6 |lvl 30  -- Highway Robbery (40)
turnin 1466 |npc Kreldig Ungor |at 1443 66.2,9.6 |value mid  -- Reagents for Reclaimers Inc. (40)
accept 1467 |npc Kreldig Ungor |at 1443 66.2,9.6 |value mid |lvl 30 |preany 1466  -- Reagents for Reclaimers Inc. (40)
turnin 93224 |npc Captain Pentigast |at 1443 66.7,10.9 |value mid  -- Carved Centaur Totems (40)
turnin 79229 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0  -- Highway Robbery (40)
accept 79235 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0 |lvl 30 |preany 79229  -- On the Lam (40)
turnin 1381 |npc Warug |at 1443 75.0,68.2 |group elite  -- Khan Hratha (42)
accept 92743 |npc Warug |at 1443 75.0,68.2 |lvl 30 |preany 1369  -- A Conqueror's Crown (40)
turnin 92743 |npc Warug |at 1443 75.0,68.2  -- A Conqueror's Crown (40)
turnin 93196 |npc Khan Jehn |at 1443 73.8,73.9  -- Khan Jehn (42)
turnin 96222 |npc Umarak |at 1443 43.5,79.0 |group elite  -- Khan Hratha (42)
turnin 1380 |npc Uthek the Wise |at 1443 36.2,79.2 |group elite  -- Khan Hratha (42)
fly 1413 63.1,37.2 |from 1443 64.7,10.5 |npc The Barrens (Bragok)  -- flight master Baritanas Skyriver
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1455 55.5,47.7 |from 1434 27.5,77.8 |npc Ironforge (Gryth Thurden) |value mid  -- flight master Gyll
turnin 1467 |npc Roetten Stonehammer |at 1455 70.0,21.3 |value mid  -- Reagents for Reclaimers Inc. (40)
fly 1424 49.3,52.3 |from 1455 55.5,47.7 |npc Hillsbrad Foothills (Darla Harris)  -- flight master Gryth Thurden
turnin 1052 |npc Raleigh the Devout |at 1424 51.5,58.4  -- Down the Scarlet Path (40)
fly 1434 27.5,77.8 |from 1424 49.3,52.3 |npc Stranglethorn Vale (Gyll)  -- flight master Darla Harris
turnin 79235 |npc Tokal |at 1434 27.0,77.3  -- On the Lam (40)
accept 79236 |npc Tokal |at 1434 27.0,77.3 |lvl 30 |preany 79235  -- Cherry for Your Thoughts? (40)
complete 79236  -- Cherry for Your Thoughts? (40)
turnin 79236 |npc Tokal |at 1434 27.0,77.3  -- Cherry for Your Thoughts? (40)
accept 79242 |npc Tokal |at 1434 27.0,77.3 |lvl 30 |preany 79236  -- No Honor Among Thieves (40)
fly 1417 45.7,46.1 |from 1434 27.5,77.8 |npc Arathi Highlands (Cedrik Prose)  -- flight master Gyll
turnin 79242 |npc Illari's Loot Cache |at 1417 94.2,69.3  -- No Honor Among Thieves (40)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   92811  Economic Warfare (60)
