-- DRAFT Badlands (Alliance) generated 2026-11-18 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "badlands-a-2", title = "Badlands (44-50)", faction = "Alliance", zone = "Badlands",
  levels = { 44, 50 },
  steps = [[
accept 706 |npc Sigrun Ironhew |at 1418 53.8,43.3 |value low |lvl 40  -- Fiery Blaze Enchantments (45)
accept 717 |npc Garek |at 1418 61.9,54.3 |value mid |group elite |lvl 40 |preany 732  -- Tremors of the Earth (50)
complete 706 |at 1418 80.4,53.6 |areas 83.2,32.7:14;80.4,53.6:12 |mobs Scalding Whelp@Black Drake's Heart;Scorched Guardian@Black Drake's Heart |value low  -- Fiery Blaze Enchantments (45)
complete 717 |at 1418 81.9,49.5 |item 4640 |mobs Blacklash@Blacklash's Bindings;Hematus@Chains of Hematus |value mid |group elite  -- Tremors of the Earth (50)
turnin 717 |npc Garek |at 1418 61.9,54.3 |value mid |group elite  -- Tremors of the Earth (50)
turnin 706 |npc Sigrun Ironhew |at 1418 53.8,43.3 |value low  -- Fiery Blaze Enchantments (45)
accept 778 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35 |preany 777  -- This Is Going to Be Hard (45)
complete 778 |at 1418 26.0,45.8 |mobs Fam'retor Guardian@Lotwil's Shackles of Elemental Binding  -- This Is Going to Be Hard (45)
turnin 778 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- This Is Going to Be Hard (45)
accept 735 |npc Gerrig Bonegrip |at 1455 50.8,5.6 |value mid |group elite |lvl 30 |preany 727  -- The Star, the Hand and the Heart (44)
accept 762 |npc Historian Karnik |at 1455 77.5,11.8 |group elite |lvl 35 |preany 726  -- An Ambassador of Evil (44)
complete 762 |at 1418 42.1,28.9 |mobs Ambassador Infernus@Ambassador Infernus' Bracer |group elite  -- An Ambassador of Evil (44)
turnin 762 |npc Advisor Belgrum |at 1455 77.3,9.7 |group elite  -- An Ambassador of Evil (44)
accept 1139 |npc Advisor Belgrum |at 1455 77.3,9.7 |group dungeon |lvl 35 |preany 762  -- The Lost Tablets of Will (45)
accept 2204 |note Starts from Talvash's Scrying Bowl, whose place isn't on record. Hand it in to Talvash del Kissel |loose |group dungeon |lvl 37 |preany 2201  -- Restoring the Necklace (44)
accept 2279 |note Starts from The Discs of Norgannon, whose place isn't on record. Hand it in to High Explorer Magellas |loose |lvl 40 |preany 2278  -- The Platinum Discs (47)
turnin 2279 |npc High Explorer Magellas |at 1455 69.9,18.6  -- The Platinum Discs (47)
complete 735 |item 4649 |value mid |group elite  -- The Star, the Hand and the Heart (44)
turnin 735 |npc Gerrig Bonegrip |at 1455 50.8,5.6 |value mid |group elite  -- The Star, the Hand and the Heart (44)
complete 1139 |group dungeon  -- The Lost Tablets of Will (45)
turnin 1139 |npc Advisor Belgrum |at 1455 77.3,9.7 |group dungeon  -- The Lost Tablets of Will (45)
complete 2204 |group dungeon  -- Restoring the Necklace (44)
turnin 2204 |npc Talvash del Kissel |at 1455 36.4,3.6 |group dungeon  -- Restoring the Necklace (44)
accept 2361 |npc Talvash del Kissel |at 1455 36.4,3.6 |group chain |lvl 37 |preany 2204  -- Restoring the Necklace (44)
turnin 2361 |npc Talvash del Kissel |at 1455 36.4,3.6 |group chain  -- Restoring the Necklace (44)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   81900  The Burning Beast (54)
