-- DRAFT Searing Gorge (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "searing-gorge-h", title = "Searing Gorge (46-52)", faction = "Horde", zone = "Searing Gorge",
  levels = { 46, 52 },
  steps = [[
accept 4449 |npc Wooden Outhouse |at 1427 65.6,62.2 |value mid  -- Caught! (45)
accept 7722 |npc Master Smith Burninate |at 1427 38.8,28.5  -- What the Flux? (50)
accept 7723 |npc Hansel Heavyhands |at 1427 38.6,27.8  -- Curse These Fat Fingers (49)
accept 7724 |npc Hansel Heavyhands |at 1427 38.6,27.8  -- Fiery Menace! (49)
accept 7727 |npc Hansel Heavyhands |at 1427 38.6,27.8 |value mid  -- Incendosaurs? Whateverosaur is More Like It (49)
accept 7729 |npc Wanted/Missing/Lost & Found |at 1427 37.6,26.5 |value mid  -- JOB OPPORTUNITY: Culling the Competition (48)
accept 7701 |npc Wanted/Missing/Lost & Found |at 1427 37.6,26.5 |group elite  -- WANTED: Overseer Maltorius (50)
accept 7728 |npc Wanted/Missing/Lost & Found |at 1427 37.6,26.5  -- STOLEN: Smithing Tuyere and Lookout's Spyglass (48)
complete 7727 |at 1427 48.5,26.5 |mobs Incendosaur |value mid  -- Incendosaurs? Whateverosaur is More Like It (49)
complete 4449 |at 1427 45.5,38.8 |mobs Dark Iron Geologist |value mid  -- Caught! (45)
accept 3454 |npc Kalaran Windblade |at 1427 39.1,39.0 |group chain  -- The Torch of Retribution (50)
accept 3442 |npc Kalaran Windblade |at 1427 39.1,39.0  -- The Flawless Flame (48)
turnin 3454 |npc Torch of Retribution |at 1427 39.1,39.1 |group chain  -- The Torch of Retribution (50)
accept 3462 |npc Kalaran Windblade |at 1427 39.1,39.0 |group chain  -- Squire Maltrake (50)
turnin 3462 |npc Squire Maltrake |at 1427 39.2,39.0 |group chain  -- Squire Maltrake (50)
accept 3463 |npc Squire Maltrake |at 1427 39.2,39.0 |group chain  -- Set Them Ablaze! (52)
accept 4451 |at 1427 41.0,43.8 |note Starts from Grimesilt Outhouse Key  -- The Key to Freedom (47)
complete 3463 |at 1427 44.0,60.9 |item 10515 |group chain  -- Set Them Ablaze! (52)
turnin 4449 |npc Wooden Outhouse |at 1427 65.6,62.2 |value mid  -- Caught! (45)
accept 4450 |npc Wooden Outhouse |at 1427 65.6,62.2 |value mid  -- Ledger from Tanaris (46)
turnin 4451 |npc Wooden Outhouse |at 1427 65.6,62.2  -- The Key to Freedom (47)
complete 4450 |at 1427 63.5,50.8 |mobs Glassweb Spider@Solid Crystal Leg Shaft |value mid  -- Ledger from Tanaris (46)
complete 3442 |at 1427 48.0,49.4 |mobs Magma Elemental@Heart of Flame;Heavy War Golem@Golem Oil;Blazing Elemental@Heart of Flame;Tempered War Golem@Golem Oil  -- The Flawless Flame (48)
complete 7729 |at 1427 42.8,40.5 |mobs Dark Iron Taskmaster;Dark Iron Slaver |value mid  -- JOB OPPORTUNITY: Culling the Competition (48)
turnin 3463 |npc Squire Maltrake |at 1427 39.2,39.0 |group chain  -- Set Them Ablaze! (52)
turnin 3442 |npc Kalaran Windblade |at 1427 39.1,39.0  -- The Flawless Flame (48)
accept 3443 |npc Kalaran Windblade |at 1427 39.1,39.0  -- Forging the Shaft (48)
complete 3443 |at 1427 42.2,43.7 |mobs Slave Worker@Thorium Plated Dagger;Dark Iron Taskmaster@Thorium Plated Dagger;Dark Iron Slaver@Thorium Plated Dagger;Dark Iron Lookout@Thorium Plated Dagger  -- Forging the Shaft (48)
turnin 3443 |npc Kalaran Windblade |at 1427 39.1,39.0  -- Forging the Shaft (48)
accept 3452 |npc Kalaran Windblade |at 1427 39.1,39.0 |group elite  -- The Flame's Casing (50)
complete 7723 |at 1427 38.3,48.0 |mobs Heavy War Golem  -- Curse These Fat Fingers (49)
complete 7728 |at 1427 38.1,51.4 |mobs Dark Iron Lookout@Lookout's Spyglass;Dark Iron Steamsmith@Smithing Tuyere  -- STOLEN: Smithing Tuyere and Lookout's Spyglass (48)
complete 7724 |at 1427 29.3,62.4 |mobs Greater Lava Spider  -- Fiery Menace! (49)
accept 7704 |note Starts from Chambermaid Pillaclencher's Pillow  -- Look at the Size of It! (50)
fly 1434 26.9,77.1 |from 1427 34.8,30.9 |npc Stranglethorn Vale (Gringer)  -- flight master Grisha
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1446 51.6,25.4 |from 1413 63.1,37.2 |npc Tanaris (Bulkrek Ragefist) |value mid  -- flight master Bragok
turnin 4450 |npc Krinkle Goodsteel |at 1446 51.5,28.8 |value mid  -- Ledger from Tanaris (46)
fly 1413 63.1,37.2 |from 1446 51.6,25.4 |npc The Barrens (Bragok)  -- flight master Bulkrek Ragefist
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1427 34.8,30.9 |from 1434 26.9,77.1 |npc Grisha  -- flight master Gringer
complete 3452 |at 1427 20.8,35.9 |mobs Twilight Fire Guard@Symbol of Ragnaros;Twilight Geomancer@Symbol of Ragnaros;Twilight Dark Shaman@Symbol of Ragnaros;Twilight Idolater@Symbol of Ragnaros |group elite  -- The Flame's Casing (50)
accept 3481 |npc Hoard of the Black Dragonflight |at 1427 38.9,39.0 |group chain  -- Trinkets... (50)
turnin 3481 |npc Hoard of the Black Dragonflight |at 1427 38.9,39.0 |group chain  -- Trinkets... (50)
turnin 3452 |npc Kalaran Windblade |at 1427 39.1,39.0 |group elite  -- The Flame's Casing (50)
complete 7701 |at 1427 40.8,35.9 |mobs Overseer Maltorius@Head of Overseer Maltorius |group elite  -- WANTED: Overseer Maltorius (50)
complete 7722 |at 1427 40.5,35.7  -- What the Flux? (50)
turnin 7722 |npc Master Smith Burninate |at 1427 38.8,28.5  -- What the Flux? (50)
turnin 7729 |npc Taskmaster Scrange |at 1427 39.0,27.5 |value mid  -- JOB OPPORTUNITY: Culling the Competition (48)
turnin 7728 |npc Taskmaster Scrange |at 1427 39.0,27.5  -- STOLEN: Smithing Tuyere and Lookout's Spyglass (48)
turnin 7723 |npc Hansel Heavyhands |at 1427 38.6,27.8  -- Curse These Fat Fingers (49)
turnin 7727 |npc Hansel Heavyhands |at 1427 38.6,27.8 |value mid  -- Incendosaurs? Whateverosaur is More Like It (49)
turnin 7724 |npc Hansel Heavyhands |at 1427 38.6,27.8  -- Fiery Menace! (49)
turnin 7704 |npc Evonice Sootsmoker |at 1427 38.4,27.7  -- Look at the Size of It! (50)
turnin 7701 |npc Lookout Captain Lolo Longstriker |at 1427 37.7,26.6 |group elite  -- WANTED: Overseer Maltorius (50)
]]}
