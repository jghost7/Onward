-- GENERATED Warlock (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_warlock_alliance_imp", title = "Summon Imp / Starter Trials", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 1, 4 },
  steps = [[
accept 1598 |npc Drusilla La Salle |at 1429 49.9,42.6 |exclusive 1599  -- The Stolen Tome (4)
complete 1598 |at 1429 56.7,44.0  -- The Stolen Tome (4)
turnin 1598 |npc Drusilla La Salle |at 1429 49.9,42.6  -- The Stolen Tome (4)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_voidwalker", title = "Summon Voidwalker", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 10, 10 },
  steps = [[
accept 1688 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- Surena Caledon (10)
complete 1688 |at 1429 71.0,80.8 |mobs Surena Caledon  -- Surena Caledon (10)
turnin 1688 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- Surena Caledon (10)
accept 1689 |npc Gakin the Darkbinder |at 1453 39.2,85.2 |preany 1688  -- The Binding (10)
complete 1689 |item 6928  -- The Binding (10)
turnin 1689 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- The Binding (10)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_succubus", title = "Summon Succubus", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 20, 20 },
  steps = [[
accept 1716 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- Devourer of Souls (20)
turnin 1716 |npc Takar the Seer |at 1413 49.3,57.1  -- Devourer of Souls (20)
accept 1738 |npc Takar the Seer |at 1413 49.3,57.1 |preany 1716  -- Heartswood (20)
complete 1738 |at 1440 31.6,31.6  -- Heartswood (20)
turnin 1738 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- Heartswood (20)
accept 1739 |npc Gakin the Darkbinder |at 1453 39.2,85.2 |preany 1738  -- The Binding (20)
complete 1739 |item 6913  -- The Binding (20)
turnin 1739 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- The Binding (20)
accept 65602 |npc Takar the Seer |at 1413 49.3,57.1 |preany 1716  -- What Is Love? (20)
complete 65602 |at 1440 26.6,22.0  -- What Is Love? (20)
turnin 65602 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- What Is Love? (20)
accept 65603 |npc Gakin the Darkbinder |at 1453 39.2,85.2 |preany 65602  -- The Binding (20)
complete 65603 |at 1453 39.2,84.4 |mobs Summoned Incubus  -- The Binding (20)
turnin 65603 |npc Gakin the Darkbinder |at 1453 39.2,85.2  -- The Binding (20)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_soranruk", title = "The Orb of Soran'ruk", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 20, 25 },
  steps = [[
accept 1740 |npc Doan Karhan |at 1413 49.3,57.2 |group dungeon  -- The Orb of Soran'ruk (25)
complete 1740 |group dungeon  -- The Orb of Soran'ruk (25)
turnin 1740 |npc Doan Karhan |at 1413 49.3,57.2 |group dungeon  -- The Orb of Soran'ruk (25)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_felhunter", title = "Summon Felhunter", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 30, 30 },
  steps = [[
accept 1758 |npc Strahad Farsan |at 1413 62.6,35.5  -- Tome of the Cabal (30)
turnin 1758 |npc Krom Stoutarm |at 1455 74.2,9.4  -- Tome of the Cabal (30)
accept 1802 |npc Krom Stoutarm |at 1455 74.2,9.4 |preany 1758  -- Tome of the Cabal (30)
complete 1802 |at 1424 27.8,72.8  -- Tome of the Cabal (30)
turnin 1802 |npc Krom Stoutarm |at 1455 74.2,9.4  -- Tome of the Cabal (30)
accept 1804 |npc Krom Stoutarm |at 1455 74.2,9.4 |preany 1802  -- Tome of the Cabal (30)
complete 1804 |at 1437 49.3,47.5 |item 7006 |mobs Dragonmaw Bonewarder;Dragonmaw Shadowwarder  -- Tome of the Cabal (30)
turnin 1804 |npc Strahad Farsan |at 1413 62.6,35.5  -- Tome of the Cabal (30)
accept 1795 |npc Strahad Farsan |at 1413 62.6,35.5 |preany 1804  -- The Binding (30)
complete 1795 |at 1413 62.6,35.3 |item 6999 |mobs Summoned Felhunter  -- The Binding (30)
turnin 1795 |npc Strahad Farsan |at 1413 62.6,35.5  -- The Binding (30)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_bloodrobe", title = "Enchanted Gold Bloodrobe", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 31, 38 },
  steps = [[
accept 1796 |npc Menara Voidrender |at 1413 62.5,35.5  -- Components for the Enchanted Gold Bloodrobe (31)
complete 1796  -- Components for the Enchanted Gold Bloodrobe (31)
turnin 1796 |npc Menara Voidrender |at 1413 62.5,35.5  -- Components for the Enchanted Gold Bloodrobe (31)
accept 4781 |npc Menara Voidrender |at 1413 62.5,35.5 |preany 1796  -- Components for the Enchanted Gold Bloodrobe (34)
complete 4781 |at 1413 51.3,54.9  -- Components for the Enchanted Gold Bloodrobe (34)
turnin 4781 |npc Xizk Goodstitch |at 1434 28.7,76.9  -- Components for the Enchanted Gold Bloodrobe (34)
accept 4782 |npc Xizk Goodstitch |at 1434 28.7,76.9 |preany 4781  -- Components for the Enchanted Gold Bloodrobe (34)
turnin 4782 |npc Menara Voidrender |at 1413 62.5,35.5  -- Components for the Enchanted Gold Bloodrobe (34)
accept 4783 |npc Menara Voidrender |at 1413 62.5,35.5 |preany 4782  -- Components for the Enchanted Gold Bloodrobe (37)
complete 4783 |at 1443 74.4,23.6 |mobs Demon Portal Guardian;Hatefury Hellcaller;Hatefury Betrayer;Hatefury Felsworn  -- Components for the Enchanted Gold Bloodrobe (37)
turnin 4783 |npc Menara Voidrender |at 1413 62.5,35.5  -- Components for the Enchanted Gold Bloodrobe (37)
accept 4784 |npc Menara Voidrender |at 1413 62.5,35.5 |preany 4783  -- Components for the Enchanted Gold Bloodrobe (37)
complete 4784 |at 1417 25.8,30.6 |mobs Burning Exile;Xizk Goodstitch  -- Components for the Enchanted Gold Bloodrobe (37)
turnin 4784 |npc Menara Voidrender |at 1413 62.5,35.5  -- Components for the Enchanted Gold Bloodrobe (37)
accept 4786 |npc Menara Voidrender |at 1413 62.5,35.5 |preany 4784  -- The Completed Robe (38)
complete 4786 |at 1413 62.5,35.5 |mobs Menara Voidrender  -- The Completed Robe (38)
turnin 4786 |npc Menara Voidrender |at 1413 62.5,35.5  -- The Completed Robe (38)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_orahil", title = "The Orb of Orahil", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 35, 40 },
  steps = [[
accept 1799 |npc Menara Voidrender |at 1413 62.5,35.5  -- Fragments of the Orb of Orahil (40)
complete 1799 |at 1443 80.3,77.0 |mobs Burning Blade Summoner  -- Fragments of the Orb of Orahil (40)
turnin 1799 |npc Tabetha |at 1445 46.1,57.1  -- Fragments of the Orb of Orahil (40)
accept 4962 |npc Acolyte Wytula |at 1413 62.6,35.3 |exclusive 4963  -- Shard of a Felhound (40)
complete 4962 |at 1443 51.4,68.0 |item 12647 |mobs Mana Eater  -- Shard of a Felhound (40)
turnin 4962 |npc Menara Voidrender |at 1413 62.5,35.5  -- Shard of a Felhound (40)
accept 4961 |npc Tabetha |at 1445 46.1,57.1 |group elite |pre 1799,4962  -- Cleansing of the Orb of Orahil (40)
complete 4961 |at 1445 45.8,57.0 |mobs Demon of the Orb |group elite  -- Cleansing of the Orb of Orahil (40)
turnin 4961 |npc Tabetha |at 1445 46.1,57.1 |group elite  -- Cleansing of the Orb of Orahil (40)
accept 4976 |npc Tabetha |at 1445 46.1,57.1 |group elite |preany 4961  -- Returning the Cleansed Orb (40)
turnin 4976 |npc Menara Voidrender |at 1413 62.5,35.5 |group elite  -- Returning the Cleansed Orb (40)
accept 4964 |npc Menara Voidrender |at 1413 62.5,35.5 |group elite |pre 4976,4962 |exclusive 4963  -- The Completed Orb of Dar'Orahil (40)
complete 4964 |at 1413 62.5,35.5 |mobs Menara Voidrender |group elite  -- The Completed Orb of Dar'Orahil (40)
turnin 4964 |npc Menara Voidrender |at 1413 62.5,35.5 |group elite  -- The Completed Orb of Dar'Orahil (40)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_felsteed", title = "Summon Felsteed", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 40, 40 },
  steps = [[
accept 4487 |npc Briarthorn |at 1455 50.4,5.7 |exclusive 3631,4488,4489  -- Summon Felsteed (40)
turnin 4487 |npc Strahad Farsan |at 1413 62.6,35.5  -- Summon Felsteed (40)
accept 4490 |npc Strahad Farsan |at 1413 62.6,35.5 |preany 4487  -- Summon Felsteed (40)
turnin 4490 |npc Strahad Farsan |at 1413 62.6,35.5  -- Summon Felsteed (40)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_st50", title = "Sunken Temple: Trolls of a Feather", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 50, 52 },
  steps = [[
accept 8419 |npc Demisette Cloyce |at 1453 39.2,85.0 |exclusive 8420  -- An Imp's Request (52)
complete 8419 |at 1448 36.8,56.7 |mobs Felguard Elite;Jadefire Felsworn;Hederine Initiate;Hederine Slayer  -- An Imp's Request (52)
turnin 8419 |npc Impsy |at 1448 41.4,45.0  -- An Imp's Request (52)
accept 8421 |npc Impsy |at 1448 41.4,45.0 |preany 8419  -- The Wrong Stuff (52)
complete 8421 |at 1448 42.2,46.5 |mobs Tainted Ooze;Irontree Stomper;Irontree Wanderer;Withered Protector  -- The Wrong Stuff (52)
turnin 8421 |npc Impsy |at 1448 41.4,45.0  -- The Wrong Stuff (52)
accept 8422 |npc Impsy |at 1448 41.4,45.0 |group dungeon |preany 8421  -- Trolls of a Feather (52)
complete 8422 |group dungeon  -- Trolls of a Feather (52)
turnin 8422 |npc Impsy |at 1448 41.4,45.0 |group dungeon  -- Trolls of a Feather (52)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_infernal", title = "Infernal: Kroshius' Infernal Core", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 50, 55 },
  steps = [[
accept 7601 |npc Niby the Almighty |at 1448 41.4,44.9  -- What Niby Commands (50)
turnin 7601 |npc Impsy |at 1448 41.4,45.0  -- What Niby Commands (50)
accept 7602 |npc Impsy |at 1448 41.4,45.0 |preany 7601  -- Flawless Fel Essence (55)
complete 7602 |at 1448 38.6,50.9 |mobs Legashi Hellraiser;Legashi Soulstealer;Legashi Blackguard;Legashi Rogue  -- Flawless Fel Essence (55)
turnin 7602 |npc Impsy |at 1448 41.4,45.0  -- Flawless Fel Essence (55)
accept 7603 |npc Impsy |at 1448 41.4,45.0 |group elite |preany 7602  -- Kroshius' Infernal Core (55)
complete 7603 |at 1448 45.7,34.8 |item 18626 |mobs Kroshius |group elite  -- Kroshius' Infernal Core (55)
turnin 7603 |npc Niby the Almighty |at 1448 41.4,44.9 |group elite  -- Kroshius' Infernal Core (55)
]]}

Onward:RegisterGuide{
  id = "class_warlock_alliance_dreadsteed", title = "Dreadsteed of Xoroth", kind = "class",
  class = "WARLOCK", faction = "Alliance", levels = { 60, 60 },
  steps = [[
accept 7563 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6  -- Rage of Blood (58)
complete 7563 |at 1452 59.8,31.7 |mobs Moontouched Owlbeast;Ragged Owlbeast;Crazed Owlbeast;Raging Owlbeast  -- Rage of Blood (58)
turnin 7563 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6  -- Rage of Blood (58)
accept 7564 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6 |preany 7563  -- Wildeyes (58)
turnin 7564 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Wildeyes (58)
accept 7623 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Lord Banehollow (58)
turnin 7623 |npc Lord Banehollow |at 1448 35.9,44.4  -- Lord Banehollow (58)
accept 7624 |npc Lord Banehollow |at 1448 35.9,44.4 |preany 7623  -- Ulathek the Traitor (58)
complete 7624 |at 1448 40.8,48.4 |mobs Ulathek  -- Ulathek the Traitor (58)
turnin 7624 |npc Lord Banehollow |at 1448 35.9,44.4  -- Ulathek the Traitor (58)
accept 7581 |npc Daio the Decrepit |at 1419 34.1,50.1 |group dungeon  -- The Prison's Bindings (60)
complete 7581 |group dungeon  -- The Prison's Bindings (60)
turnin 7581 |npc Daio the Decrepit |at 1419 34.1,50.1 |group dungeon  -- The Prison's Bindings (60)
accept 7582 |npc Daio the Decrepit |at 1419 34.1,50.1 |group elite  -- The Prison's Casing (60)
complete 7582 |at 1452 58.4,83.3 |mobs Hederine Manastalker;Hederine Initiate;Hederine Slayer;Incubus Enthraller |group elite  -- The Prison's Casing (60)
turnin 7582 |npc Daio the Decrepit |at 1419 34.1,50.1 |group elite  -- The Prison's Casing (60)
accept 7583 |npc Daio the Decrepit |at 1419 34.1,50.1 |group elite |pre 7581,7582  -- Suppression (60)
complete 7583 |at 1419 44.8,73.0 |item 18601 |group elite  -- Suppression (60)
turnin 7583 |npc Daio the Decrepit |at 1419 34.1,50.1 |group elite  -- Suppression (60)
accept 7625 |npc Lord Banehollow |at 1448 35.9,44.4 |preany 7624  -- Xorothian Stardust (60)
complete 7625  -- Xorothian Stardust (60)
turnin 7625 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Xorothian Stardust (60)
accept 7626 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6 |preany 7564  -- Bell of Dethmoora (60)
complete 7626  -- Bell of Dethmoora (60)
turnin 7626 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Bell of Dethmoora (60)
accept 7627 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6 |preany 7564  -- Wheel of the Black March (60)
complete 7627 |at 1428 61.0,45.9  -- Wheel of the Black March (60)
turnin 7627 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Wheel of the Black March (60)
accept 7628 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6 |preany 7564  -- Doomsday Candle (60)
complete 7628 |at 1428 87.2,39.8 |mobs Black Dragonspawn;Black Wyrmkin;Flamescale Wyrmkin;Black Broodling  -- Doomsday Candle (60)
turnin 7628 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Doomsday Candle (60)
accept 7629 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6 |group dungeon |preany 7625  -- Imp Delivery (60)
complete 7629 |item 18688 |group dungeon  -- Imp Delivery (60)
turnin 7629 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6 |group dungeon  -- Imp Delivery (60)
accept 7630 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6 |pre 7626,7627,7628  -- Arcanite (60)
complete 7630  -- Arcanite (60)
turnin 7630 |npc Gorzeeki Wildeyes |at 1428 12.4,31.6  -- Arcanite (60)
accept 7631 |npc Mor'zul Bloodbringer |at 1428 12.7,31.6 |group dungeon |pre 7629,7630  -- Dreadsteed of Xoroth (60)
complete 7631 |item 18818 |group dungeon  -- Dreadsteed of Xoroth (60)
turnin 7631 |group dungeon  -- Dreadsteed of Xoroth (60)
]]}
