-- DRAFT Tanaris (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "tanaris-h-2", title = "Tanaris (54-60)", faction = "Horde", zone = "Tanaris",
  levels = { 54, 60 },
  steps = [[
home |npc Innkeeper Fizzgrimble |at 1446 52.5,27.9  -- set your hearthstone at the inn
accept 2741 |npc Egg-O-Matic |at 1446 52.4,27.0 |lvl 42  -- The Super Egg-O-Matic (60)
accept 8921 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain |lvl 58 |preany 8922,8923  -- The Ectoplasmic Distiller (60)
accept 4504 |npc Tran'rek |at 1446 51.6,26.8 |value mid |lvl 48  -- Super Sticky (54)
accept 4496 |npc Alchemist Pestlezugg |at 1446 50.9,27.0 |lvl 50 |preany 4493,4494  -- Bungle in the Jungle (53)
fly 1413 63.1,37.2 |from 1446 51.6,25.4 |npc The Barrens (Bragok)  -- flight master Bulkrek Ragefist
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1428 65.7,24.2 |from 1434 26.9,77.1 |npc Burning Steppes (Vahgruk) |value mid  -- flight master Gringer
complete 8921 |at 1428 60.1,40.4 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- The Ectoplasmic Distiller (60)
fly 1434 26.9,77.1 |from 1428 65.7,24.2 |npc Stranglethorn Vale (Gringer)  -- flight master Vahgruk
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1449 45.2,5.8 |from 1413 63.1,37.2 |npc Un'Goro Crater (Gryfe)  -- flight master Bragok
complete 4496 |at 1449 48.2,77.1  -- Bungle in the Jungle (53)
complete 4504 |at 1449 51.8,25.1 |value mid  -- Super Sticky (54)
fly 1446 51.6,25.4 |from 1449 45.2,5.8 |npc Bulkrek Ragefist  -- flight master Gryfe
accept 8576 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain |lvl 60 |preany 8575  -- Translating the Ledger (60)
turnin 8576 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- Translating the Ledger (60)
accept 8584 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain |lvl 60 |preany 8576  -- Never Ask Me About My Business (60)
accept 8597 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain |lvl 60 |preany 8576  -- Draconic for Dummies (60)
turnin 8921 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- The Ectoplasmic Distiller (60)
accept 8924 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain |lvl 58 |preany 8921  -- Hunting for Ectoplasm (60)
turnin 8584 |npc Dirge Quikcleave |at 1446 52.6,28.1 |group chain  -- Never Ask Me About My Business (60)
accept 8585 |npc Dirge Quikcleave |at 1446 52.6,28.1 |value mid |group elite |lvl 60 |preany 8584  -- The Isle of Dread! (60)
accept 5802 |npc Krinkle Goodsteel |at 1446 51.5,28.8 |lvl 55 |preany 5514  -- Fire Plume Forged (57)
turnin 4496 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Bungle in the Jungle (53)
accept 4507 |npc Alchemist Pestlezugg |at 1446 50.9,27.0 |lvl 50 |preany 4496  -- Pawn Captures Queen (54)
fly 1454 45.1,63.9 |from 1446 51.6,25.4 |npc Orgrimmar (Doras)  -- flight master Bulkrek Ragefist
accept 8923 |npc Mokvar |at 1454 35.0,38.3 |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain |lvl 58 |preany 8913,8914,8915,8916,8917,8918,8919,8920  -- A Supernatural Device (60)
fly 1444 75.5,44.4 |from 1454 45.1,63.9 |npc Feralas (Shyn)  -- flight master Doras
complete 8585 |at 1444 29.2,78.1 |value mid |group elite  -- The Isle of Dread! (60)
complete 2741 |at 1444 58.0,76.3  -- The Super Egg-O-Matic (60)
turnin 8597 |npc Freshly Dug Dirt |at 947 30.0,89.2 |group chain  -- Draconic for Dummies (60)
accept 8598 |npc Freshly Dug Dirt |at 947 30.0,89.2 |group chain |lvl 60 |preany 8597  -- rAnS0m (60)
complete 5802 |at 1449 48.9,47.0 |item 14644  -- Fire Plume Forged (57)
complete 4507 |at 1449 43.9,81.4 |item 11833  -- Pawn Captures Queen (54)
fly 1446 51.6,25.4 |from 1449 45.2,5.8 |npc Bulkrek Ragefist  -- flight master Gryfe
complete 8924 |at 1446 54.1,93.0 |item 21946 |mobs Treasure Hunting Pirate;Treasure Hunting Swashbuckler;Treasure Hunting Buccaneer |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- Hunting for Ectoplasm (60)
accept 8599 |npc Meridith the Mermaiden |at 1446 59.4,96.0 |lvl 60  -- Love Song for Narain (60)
accept 8182 |npc Prospector Ironboot |at 1446 66.9,24.0 |group chain |lvl 40 |preany 8181  -- The Hand of Rastakhan (58)
accept 8577 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain |lvl 60 |preany 8576  -- Stewvul, Ex-B.F.F. (60)
turnin 8598 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- rAnS0m (60)
accept 8606 |npc Narain Soothfancy |at 1446 65.2,18.6 |group elite |lvl 60 |preany 8598  -- Decoy! (60)
turnin 8585 |npc Dirge Quikcleave |at 1446 52.6,28.1 |value mid |group elite  -- The Isle of Dread! (60)
accept 8586 |npc Dirge Quikcleave |at 1446 52.6,28.1 |value mid |group chain |lvl 60 |preany 8585  -- Dirge's Kickin' Chimaerok Chops (60)
turnin 8924 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- Hunting for Ectoplasm (60)
accept 8925 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain |lvl 58 |preany 8924  -- A Portable Power Source (60)
turnin 2741 |npc Egg-O-Matic |at 1446 52.4,27.0  -- The Super Egg-O-Matic (60)
turnin 4504 |npc Tran'rek |at 1446 51.6,26.8 |value mid  -- Super Sticky (54)
turnin 4507 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Pawn Captures Queen (54)
accept 4509 |npc Alchemist Pestlezugg |at 1446 50.9,27.0 |lvl 50 |preany 4507  -- Calm Before the Storm (54)
fly 1413 63.1,37.2 |from 1446 51.6,25.4 |npc The Barrens (Bragok)  -- flight master Bulkrek Ragefist
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1421 45.6,42.6 |from 1434 26.9,77.1 |npc Silverpine Forest (Karos Razok)  -- flight master Gringer
turnin 8577 |npc Inconspicuous Crate |at 1421 46.2,86.7 |group chain  -- Stewvul, Ex-B.F.F. (60)
fly 1434 26.9,77.1 |from 1421 45.6,42.6 |npc Stranglethorn Vale (Gringer)  -- flight master Karos Razok
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1452 60.5,36.3 |from 1413 63.1,37.2 |npc Winterspring (Yugrek)  -- flight master Bragok
complete 8606 |at 1452 67.2,72.6 |item 21042 |mobs Number Two |group elite  -- Decoy! (60)
fly 1413 63.1,37.2 |from 1452 60.5,36.3 |npc The Barrens (Bragok)  -- flight master Yugrek
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1428 65.7,24.2 |from 1434 26.9,77.1 |npc Burning Steppes (Vahgruk) |value mid  -- flight master Gringer
complete 8925 |at 1428 35.4,57.8 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- A Portable Power Source (60)
fly 1434 26.9,77.1 |from 1428 65.7,24.2 |npc Stranglethorn Vale (Gringer)  -- flight master Vahgruk
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 4509 |npc Zilzibin Drumlore |at 1454 56.3,46.7  -- Calm Before the Storm (54)
goto 1411 50.6,12.6 15 |note Take the zeppelin to Undercity  -- zeppelin Orgrimmar to Undercity
turnin 5802 |npc Apothecary Dithers |at 1420 83.3,69.2  -- Fire Plume Forged (57)
turnin 8182 |npc Molthor |at 1434 15.0,15.1 |group chain  -- The Hand of Rastakhan (58)
goto 1434 31.3,29.2 15 |note Take the zeppelin to Orgrimmar  -- zeppelin Grom'gol to Orgrimmar
complete 8586 |at 1446 44.5,58.7 |mobs Dune Smasher@Deeprock Salt;Land Rager@Deeprock Salt;Ground Pounder@Deeprock Salt |value mid |group chain  -- Dirge's Kickin' Chimaerok Chops (60)
turnin 8586 |npc Dirge Quikcleave |at 1446 52.6,28.1 |value mid |group chain  -- Dirge's Kickin' Chimaerok Chops (60)
accept 8587 |npc Dirge Quikcleave |at 1446 52.6,28.1 |value mid |group chain |lvl 60 |preany 8586  -- Return to Narain (60)
turnin 8925 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- A Portable Power Source (60)
accept 8928 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain |lvl 58 |preany 8925  -- A Shifty Merchant (60)
complete 8928 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- A Shifty Merchant (60)
turnin 8928 |npc Mux Manascrambler |at 1446 52.5,27.2 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- A Shifty Merchant (60)
turnin 8923 |npc Mux Manascrambler |at 1446 52.5,27.2 |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- A Supernatural Device (60)
turnin 8587 |npc Narain Soothfancy |at 1446 65.2,18.6 |value mid |group chain  -- Return to Narain (60)
turnin 8606 |npc Narain Soothfancy |at 1446 65.2,18.6 |group elite  -- Decoy! (60)
accept 8620 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain |lvl 60 |preany 8606  -- The Only Prescription (60)
complete 8620 |item 21112 |group chain  -- The Only Prescription (60)
turnin 8620 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- The Only Prescription (60)
turnin 8599 |npc Narain Soothfancy |at 1446 65.2,18.6  -- Love Song for Narain (60)
accept 8728 |npc Narain Soothfancy |at 1446 65.2,18.6 |value low |group dungeon |lvl 60 |pre 8578,8587,8620  -- The Good News and The Bad News (60)
accept 8747 |npc Anachronos |at 1446 65.3,50.0 |lvl 60  -- The Path of the Protector (60)
accept 8758 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8757  -- The Path of the Invoker (60)
accept 8753 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8752  -- The Path of the Conqueror (60)
complete 8753  -- The Path of the Conqueror (60)
turnin 8753 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Conqueror (60)
accept 8754 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8753  -- The Path of the Conqueror (60)
complete 8758  -- The Path of the Invoker (60)
turnin 8758 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Invoker (60)
accept 8759 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8758  -- The Path of the Invoker (60)
turnin 8747 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Protector (60)
complete 8754  -- The Path of the Conqueror (60)
turnin 8754 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Conqueror (60)
accept 8755 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8754  -- The Path of the Conqueror (60)
accept 8748 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8747  -- The Path of the Protector (60)
accept 8555 |npc Anachronos |at 1446 65.3,50.0 |group chain |lvl 60 |preany 8519  -- The Charge of the Dragonflights (60)
turnin 8555 |npc Anachronos |at 1446 65.3,50.0 |group chain  -- The Charge of the Dragonflights (60)
complete 8755  -- The Path of the Conqueror (60)
turnin 8755 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Conqueror (60)
complete 8759  -- The Path of the Invoker (60)
turnin 8759 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Invoker (60)
complete 8748  -- The Path of the Protector (60)
turnin 8748 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Protector (60)
accept 8760 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8759  -- The Path of the Invoker (60)
accept 8749 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8748  -- The Path of the Protector (60)
complete 8749  -- The Path of the Protector (60)
turnin 8749 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Protector (60)
accept 8750 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8749  -- The Path of the Protector (60)
complete 8760  -- The Path of the Invoker (60)
turnin 8760 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Invoker (60)
accept 8761 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8760  -- The Grand Invoker (60)
complete 8750  -- The Path of the Protector (60)
turnin 8750 |npc Anachronos |at 1446 65.3,50.0  -- The Path of the Protector (60)
accept 8742 |npc Anachronos |at 1446 65.3,50.0 |group chain |lvl 60 |pre 8729,8730,8741  -- The Might of Kalimdor (60)
turnin 8742 |npc Anachronos |at 1446 65.3,50.0 |group chain  -- The Might of Kalimdor (60)
accept 8756 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8755  -- The Qiraji Conqueror (60)
accept 8751 |npc Anachronos |at 1446 65.3,50.0 |lvl 60 |preany 8750  -- The Protector of Kalimdor (60)
complete 8756  -- The Qiraji Conqueror (60)
turnin 8756 |npc Anachronos |at 1446 65.3,50.0  -- The Qiraji Conqueror (60)
complete 8751  -- The Protector of Kalimdor (60)
turnin 8751 |npc Anachronos |at 1446 65.3,50.0  -- The Protector of Kalimdor (60)
complete 8761  -- The Grand Invoker (60)
turnin 8761 |npc Anachronos |at 1446 65.3,50.0  -- The Grand Invoker (60)
complete 8728 |at 1446 62.7,48.5 |mobs Southsea Pirate@Blue Sapphire;Dunemaul Enforcer@Blue Sapphire;Wastewander Shadow Mage@Blue Sapphire;Gor'marok the Ravager@Blue Sapphire |value low |group dungeon  -- The Good News and The Bad News (60)
turnin 8728 |npc Narain Soothfancy |at 1446 65.2,18.6 |value low |group dungeon  -- The Good News and The Bad News (60)
]]}
