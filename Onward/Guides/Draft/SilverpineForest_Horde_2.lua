-- DRAFT Silverpine Forest (Horde) generated 2026-11-21 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "silverpine-forest-h-2", title = "Silverpine Forest (18-24)", faction = "Horde", zone = "Silverpine Forest",
  levels = { 18, 24 },
  steps = [[
home |npc Innkeeper Bates |at 1421 43.2,41.3  -- set your hearthstone at the inn
accept 451 |npc Apothecary Renferrel |at 1421 42.8,40.9 |value mid |lvl 9 |preany 450  -- A Recipe For Death (18)
accept 493 |npc Apothecary Renferrel |at 1421 42.8,40.9 |lvl 19  -- Journey to Hillsbrad Foothills (20)
accept 516 |npc Shadow Priest Allister |at 1421 44.0,40.9 |lvl 16  -- Beren's Peril (21)
accept 95981 |npc Shadow Priest Allister |at 1421 44.0,40.9 |lvl 10 |preany 482  -- Watching the Roads (20)
accept 98299 |npc Dalar Dawnweaver |at 1421 44.2,39.8 |group chain |lvl 9 |preany 99  -- Stop the Spread (20)
accept 461 |npc Shallow Grave |at 1421 67.9,24.9 |lvl 12 |preany 460  -- The Hidden Niche (18)
turnin 461 |npc Dusty Shelf |at 1421 65.4,24.8  -- The Hidden Niche (18)
accept 491 |npc Dusty Shelf |at 1421 65.4,24.8 |lvl 12 |preany 461  -- Wand to Bethor (18)
complete 451 |at 1421 78.1,30.6 |areas 78.1,30.6:68;70.6,17.5:61 |mobs Vile Fin Lakestalker@Hardened Tumor;Vile Fin Shredder@Hardened Tumor;Vile Fin Tidecaller@Hardened Tumor;Vile Fin Tidehunter@Hardened Tumor |value mid  -- A Recipe For Death (18)
complete 95981 |at 1421 63.9,58.7 |areas 62.5,76.6:34;63.9,58.7:29 |mobs Dalaran Watcher;Dalaran Wizard  -- Watching the Roads (20)
turnin 95981 |npc Shadow Priest Allister |at 1421 44.0,40.9  -- Watching the Roads (20)
accept 480 |npc Shadow Priest Allister |at 1421 44.0,40.9 |lvl 10 |pre 479,95981  -- The Weaver (22)
accept 442 |npc High Executor Hadrec |at 1421 43.4,40.9 |value low |group elite |lvl 10 |preany 448  -- Assault on Fenris Isle (24)
complete 98299 |at 1421 46.1,85.6 |mobs Haggard Refugee;Sickly Refugee |group chain  -- Stop the Spread (20)
complete 516 |at 1421 58.7,71.3 |mobs Ravenclaw Drudger;Ravenclaw Guardian  -- Beren's Peril (21)
accept 95884 |at 1421 58.7,71.3 |mobs Ravenclaw Guardian;Ravenclaw Drudger |note Starts from the item Note Scrap, found on Ravenclaw Guardian, Ravenclaw Drudger. Hand it in to Offering Stone |startitem 271343 |loose |lvl 20  -- The Offering Stone (23)
complete 95884 |at 1421 58.7,71.3 |mobs Ravenclaw Guardian@Note Scrap;Ravenclaw Drudger@Note Scrap  -- The Offering Stone (23)
turnin 95884 |npc Offering Stone |at 1421 58.1,69.8  -- The Offering Stone (23)
accept 95883 |npc Offering Stone |at 1421 58.1,69.8 |lvl 20 |preany 95884  -- The Tortured Soul (23)
complete 95883 |at 1421 58.7,71.3 |mobs Ravenclaw Guardian@Tortured Soul;Ravenclaw Drudger@Tortured Soul  -- The Tortured Soul (23)
turnin 95883 |npc Offering Stone |at 1421 58.1,69.8  -- The Tortured Soul (23)
accept 95885 |npc Offering Stone |at 1421 58.1,69.8 |group elite |lvl 20 |preany 95883  -- The Offering of Blood (23)
complete 95885 |at 1421 58.2,69.8 |item 210713 |mobs Tortured Soul |group elite  -- The Offering of Blood (23)
turnin 95885 |npc Offering Stone |at 1421 58.1,69.8 |group elite  -- The Offering of Blood (23)
complete 480 |at 1421 63.4,64.3 |mobs Archmage Ataeric@Ataeric's Staff  -- The Weaver (22)
complete 442 |at 1421 65.7,23.7 |mobs Thule Ravenclaw@Thule's Head |value low |group elite  -- Assault on Fenris Isle (24)
turnin 98299 |npc Dalar Dawnweaver |at 1421 44.2,39.8 |group chain  -- Stop the Spread (20)
turnin 480 |npc Shadow Priest Allister |at 1421 44.0,40.9  -- The Weaver (22)
turnin 516 |npc Shadow Priest Allister |at 1421 44.0,40.9  -- Beren's Peril (21)
turnin 442 |npc High Executor Hadrec |at 1421 43.4,40.9 |value low |group elite  -- Assault on Fenris Isle (24)
turnin 451 |npc Master Apothecary Faranell |at 1458 48.8,69.3 |value mid  -- A Recipe For Death (18)
accept 530 |npc Raleigh Andrean |at 1458 62.0,42.8 |lvl 10 |preany 441  -- A Husband's Revenge (20)
turnin 491 |npc Bethor Iceshard |at 1458 84.1,17.4  -- Wand to Bethor (18)
turnin 493 |npc Apothecary Lydon |at 1424 61.4,19.1  -- Journey to Hillsbrad Foothills (20)
complete 530 |at 1421 45.0,84.9 |mobs Valdred Moray@Valdred's Hands  -- A Husband's Revenge (20)
turnin 530 |npc Raleigh Andrean |at 1458 62.0,42.8  -- A Husband's Revenge (20)
]]}
