-- DRAFT Desolace (Alliance) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "desolace-a-2", title = "Desolace (40-45)", faction = "Alliance", zone = "Desolace",
  levels = { 40, 45 },
  steps = [[
home |npc Innkeeper Lyshaerya |at 1443 66.3,6.5  -- set your hearthstone at the inn
accept 1052 |npc Brother Anton |at 1443 66.5,7.9 |lvl 34 |preany 261  -- Down the Scarlet Path (40)
accept 1466 |npc Kreldig Ungor |at 1443 66.2,9.6 |lvl 30 |preany 1459  -- Reagents for Reclaimers Inc. (40)
accept 93224 |npc Captain Pentigast |at 1443 66.7,10.9 |lvl 30  -- Carved Centaur Totems (40)
accept 93465 |npc Azore Aldamort |at 1443 38.9,27.2 |lvl 30 |preany 93464  -- Notes on Draenethyst (40)
accept 79229 |npc Extinguished Campfire |at 1443 47.5,54.6 |lvl 30  -- Highway Robbery (40)
accept 96222 |npc Umarak |at 1443 43.5,79.0 |group elite |lvl 35  -- Khan Hratha (42)
complete 93465 |at 1443 80.9,76.5 |mobs Gimashi@Gimashi's Findings  -- Notes on Draenethyst (40)
complete 1466 |at 1443 80.1,77.1 |areas 51.7,82.5:25;80.1,77.1:5 |mobs Nether Maiden@Nether Wing;Mage Hunter@Felhound Brain;Ley Hunter@Felhound Brain;Doomwarder Captain@Doomwarder Blood  -- Reagents for Reclaimers Inc. (40)
complete 93224 |at 1443 71.5,45.5 |areas 68.9,78.0:125;36.5,85.0:78;71.5,45.5:56;30.8,55.7:48 |mobs Magram Guardian@Carved Centaur Totem;Gelkis Windchaser@Carved Centaur Totem;Gelkis Stamper@Carved Centaur Totem;Gelkis Guardian@Carved Centaur Totem  -- Carved Centaur Totems (40)
turnin 79229 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0  -- Highway Robbery (40)
accept 79235 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0 |lvl 30 |preany 79229  -- On the Lam (40)
turnin 93224 |npc Captain Pentigast |at 1443 66.7,10.9  -- Carved Centaur Totems (40)
turnin 1466 |npc Kreldig Ungor |at 1443 66.2,9.6  -- Reagents for Reclaimers Inc. (40)
accept 1467 |npc Kreldig Ungor |at 1443 66.2,9.6 |lvl 30 |preany 1466  -- Reagents for Reclaimers Inc. (40)
accept 93226 |npc Captain Pentigast |at 1443 66.7,10.9 |value low |lvl 30 |preany 93224 |exclusive 93227  -- Buying Friendship: Magram (45)
turnin 93465 |npc Azore Aldamort |at 1443 38.9,27.2  -- Notes on Draenethyst (40)
accept 93678 |npc Azore Aldamort |at 1443 38.9,27.2 |lvl 30 |preany 93465  -- Abridged Notes on Draenethyst (40)
complete 96222 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
turnin 93226 |npc Gorhak |at 1443 66.2,79.4 |value low  -- Buying Friendship: Magram (45)
turnin 96222 |npc Umarak |at 1443 43.5,79.0 |group elite  -- Khan Hratha (42)
turnin 1467 |npc Roetten Stonehammer |at 1455 70.0,21.3  -- Reagents for Reclaimers Inc. (40)
turnin 1052 |npc Raleigh the Devout |at 1424 51.5,58.4  -- Down the Scarlet Path (40)
turnin 93678 |npc Magtoor |at 1435 26.0,31.4  -- Abridged Notes on Draenethyst (40)
turnin 79235 |npc Tokal |at 1434 27.0,77.3  -- On the Lam (40)
accept 79236 |npc Tokal |at 1434 27.0,77.3 |lvl 30 |preany 79235  -- Cherry for Your Thoughts? (40)
complete 79236 |need 4600:1:Cherry Grog:sold by Barkeep Kelly in Hillsbrad Foothills and other vendors  -- Cherry for Your Thoughts? (40)
turnin 79236 |npc Tokal |at 1434 27.0,77.3  -- Cherry for Your Thoughts? (40)
accept 79242 |npc Tokal |at 1434 27.0,77.3 |lvl 30 |preany 79236  -- No Honor Among Thieves (40)
complete 79242  -- No Honor Among Thieves (40)
turnin 79242 |npc Illari's Loot Cache |at 1417 94.2,69.3  -- No Honor Among Thieves (40)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   92811  Economic Warfare (60)
