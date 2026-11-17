-- DRAFT Badlands (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "badlands-a-2", title = "Badlands (44-50)", faction = "Alliance", zone = "Badlands",
  levels = { 44, 50 },
  steps = [[
accept 706 |npc Sigrun Ironhew |at 1418 53.8,43.3 |value low  -- Fiery Blaze Enchantments (45)
accept 717 |npc Garek |at 1418 61.9,54.3 |value mid |group elite  -- Tremors of the Earth (50)
complete 706 |at 1418 79.7,47.9 |mobs Scalding Whelp;Scorched Guardian |value low  -- Fiery Blaze Enchantments (45)
complete 717 |at 1418 81.9,49.5 |mobs Blacklash;Hematus |value mid |group elite  -- Tremors of the Earth (50)
turnin 717 |npc Garek |at 1418 61.9,54.3 |value mid |group elite  -- Tremors of the Earth (50)
turnin 706 |npc Sigrun Ironhew |at 1418 53.8,43.3 |value low  -- Fiery Blaze Enchantments (45)
accept 778 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- This Is Going to Be Hard (45)
complete 778 |at 1418 26.0,45.8 |mobs Fam'retor Guardian  -- This Is Going to Be Hard (45)
turnin 778 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- This Is Going to Be Hard (45)
accept 735 |npc Gerrig Bonegrip |at 1455 50.8,5.6 |value mid |group elite  -- The Star, the Hand and the Heart (44)
accept 762 |npc Historian Karnik |at 1455 77.5,11.8 |group elite  -- An Ambassador of Evil (44)
complete 762 |at 1418 42.1,28.9 |mobs Ambassador Infernus |group elite  -- An Ambassador of Evil (44)
turnin 762 |npc Advisor Belgrum |at 1455 77.3,9.7 |group elite  -- An Ambassador of Evil (44)
accept 1139 |npc Advisor Belgrum |at 1455 77.3,9.7 |group dungeon  -- The Lost Tablets of Will (45)
accept 2204 |group dungeon  -- Restoring the Necklace (44)
accept 2279  -- The Platinum Discs (47)
turnin 2279 |npc High Explorer Magellas |at 1455 69.9,18.6  -- The Platinum Discs (47)
complete 735 |value mid |group elite  -- The Star, the Hand and the Heart (44)
turnin 735 |npc Gerrig Bonegrip |at 1455 50.8,5.6 |value mid |group elite  -- The Star, the Hand and the Heart (44)
complete 1139 |group dungeon  -- The Lost Tablets of Will (45)
turnin 1139 |npc Advisor Belgrum |at 1455 77.3,9.7 |group dungeon  -- The Lost Tablets of Will (45)
complete 2204 |group dungeon  -- Restoring the Necklace (44)
turnin 2204 |npc Talvash del Kissel |at 1455 36.4,3.6 |group dungeon  -- Restoring the Necklace (44)
accept 2361 |npc Talvash del Kissel |at 1455 36.4,3.6 |group chain  -- Restoring the Necklace (44)
turnin 2361 |npc Talvash del Kissel |at 1455 36.4,3.6 |group chain  -- Restoring the Necklace (44)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   81900  The Burning Beast (54)
