-- DRAFT Wetlands (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "wetlands-a-2", title = "Wetlands (29-35)", faction = "Alliance", zone = "Wetlands",
  levels = { 29, 35 },
  steps = [[
home |npc Innkeeper Helbrek |at 1437 10.7,61.0  -- set your hearthstone at the inn
accept 289 |npc First Mate Fitzsimmons |at 1437 10.9,59.6 |value mid |lvl 22 |preany 288  -- The Cursed Crew (29)
accept 465 |npc Captain Stoutfist |at 1437 9.9,57.5 |lvl 23 |pre 464,98221  -- Nek'rosh's Gambit (31)
complete 289 |at 1437 13.9,28.7 |mobs Cursed Sailor;Cursed Marine;First Mate Snellig@Snellig's Snuffbox |value mid  -- The Cursed Crew (29)
turnin 465 |npc Dragonmaw Catapult |at 1437 47.5,47.0  -- Nek'rosh's Gambit (31)
accept 474 |npc Dragonmaw Catapult |at 1437 47.5,47.0 |group elite |lvl 23 |preany 465  -- Defeat Nek'rosh (32)
accept 98246 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid |lvl 21  -- Trying Times (29)
accept 98245 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid |lvl 21  -- Razormaw Needling (29)
accept 304 |npc Longbraid the Grim |at 1437 49.8,18.3 |group elite |lvl 26  -- A Grim Task (34)
accept 631 |npc Rhag Garmason |at 1437 49.9,18.2 |lvl 28  -- The Thandol Span (31)
accept 303 |npc Motley Garmason |at 1437 49.7,18.2 |value low |group elite |lvl 22  -- The Dark Iron War (30)
accept 87318 |npc Comar Villard |at 1437 49.9,12.6 |lvl 28  -- Hearts of the Lost (33)
turnin 87318 |npc Essene Villard |at 1437 51.5,9.0  -- Hearts of the Lost (33)
accept 88757 |npc Essene Villard |at 1437 51.5,9.0 |lvl 28 |preany 87318  -- Accessories of the Lost (33)
complete 88757  -- Accessories of the Lost (33)
turnin 88757 |npc Essene Villard |at 1437 51.5,9.0  -- Accessories of the Lost (33)
accept 88758 |npc Essene Villard |at 1437 51.5,9.0 |lvl 28 |preany 88757  -- Sentiments of the Lost (33)
turnin 631 |npc Ebenezer Rustlocke's Corpse |at 1437 51.3,8.0  -- The Thandol Span (31)
accept 632 |npc Ebenezer Rustlocke's Corpse |at 1437 51.3,8.0 |lvl 28 |preany 631  -- The Thandol Span (31)
turnin 88758 |npc Comar Villard |at 1437 49.9,12.6  -- Sentiments of the Lost (33)
turnin 632 |npc Rhag Garmason |at 1437 49.9,18.2  -- The Thandol Span (31)
accept 633 |npc Rhag Garmason |at 1437 49.9,18.2 |lvl 28 |preany 632  -- The Thandol Span (31)
accept 88756 |npc Ashlan Stonesmirk |at 1437 50.0,18.2 |lvl 27  -- Bring Back a Bang (31)
complete 304 |at 1437 60.0,26.0 |mobs Balgaras the Foul@Ear of Balgaras |group elite  -- A Grim Task (34)
complete 98246 |at 1437 66.5,31.9 |mobs Highland Razormaw;Elder Razormaw;Mottled Razormaw;Razormaw Matriarch |value mid  -- Trying Times (29)
accept 98293 |npc Dragonmaw Armaments |at 1437 58.9,45.1 |value low |lvl 22  -- Forced Disarmament (30)
accept 98223 |npc Tattered Spellbook |at 1437 53.5,54.6 |lvl 23  -- Old Habits (31)
complete 474 |at 1437 53.5,54.7 |mobs Chieftain Nek'rosh@Nek'rosh's Head |group elite  -- Defeat Nek'rosh (32)
accept 98216 |npc Prospector Whelgar |at 1437 38.8,52.4 |group elite |lvl 23 |preany 299  -- Understanding Our Present (31)
complete 98216 |at 1437 34.8,48.5 |item 279996 |mobs Goaz Warder@Titanic Keystone |group elite  -- Understanding Our Present (31)
accept 296 |npc Ormer Ironbraid |at 1437 38.2,50.9 |lvl 22 |preany 295  -- Ormer's Revenge (29)
turnin 98216 |npc Prospector Whelgar |at 1437 38.8,52.4 |group elite  -- Understanding Our Present (31)
accept 98310 |npc Prospector Whelgar |at 1437 38.8,52.4 |group elite |lvl 24 |preany 98216  -- Gleaning Our Future (32)
complete 296 |at 1437 33.3,51.5 |mobs Sarltooth@Sarltooth's Talon  -- Ormer's Revenge (29)
turnin 289 |npc First Mate Fitzsimmons |at 1437 10.9,59.6 |value mid  -- The Cursed Crew (29)
accept 290 |npc First Mate Fitzsimmons |at 1437 10.9,59.6 |value mid |lvl 22 |preany 289  -- Lifting the Curse (30)
accept 1132 |npc Red Jack Flint |at 1437 10.0,58.0 |lvl 30  -- Fiora Longears (30)
turnin 98223 |npc Captain Stoutfist |at 1437 9.9,57.5  -- Old Habits (31)
complete 98293 |value low  -- Forced Disarmament (30)
turnin 98293 |npc Captain Stoutfist |at 1437 9.9,57.5 |value low  -- Forced Disarmament (30)
turnin 474 |npc Captain Stoutfist |at 1437 9.9,57.5 |group elite  -- Defeat Nek'rosh (32)
accept 98230 |npc Captain Stoutfist |at 1437 9.9,57.5 |group chain |lvl 22 |pre 474,98223  -- This Land Was Their Land (29)
accept 98240 |npc James Halloran |at 1437 8.6,55.7 |lvl 19 |preany 98072  -- Crimson Crate Delivery (29)
accept 98208 |npc Sylessa Duskwhisper |at 1437 7.9,55.8  -- Bloom of the Heavens (29)
complete 98208  -- Bloom of the Heavens (29)
turnin 98208 |npc Sylessa Duskwhisper |at 1437 7.9,55.8  -- Bloom of the Heavens (29)
accept 98209 |npc Sylessa Duskwhisper |at 1437 7.9,55.8 |lvl 22 |preany 98208  -- Bloom of the Heavens (29)
goto 1437 4.6,57.1 15 |note Take the boat to Theramore  -- boat Menethil Harbor to Theramore
turnin 1132 |npc Fiora Longears |at 1445 66.5,45.1  -- Fiora Longears (30)
goto 1445 71.6,56.4 15 |note Take the boat to Menethil Harbor  -- boat Theramore to Menethil Harbor
fly 1417 45.7,46.1 |from 1437 9.5,59.7 |npc Arathi Highlands (Cedrik Prose)  -- flight master Shellei Brondir
complete 633 |at 1417 48.8,88.0  -- The Thandol Span (31)
fly 1437 9.5,59.7 |from 1417 45.7,46.1 |npc Shellei Brondir  -- flight master Cedrik Prose
complete 290 |at 1437 15.4,23.6 |mobs Captain Halyndor@Intrepid Strongbox Key |value mid  -- Lifting the Curse (30)
turnin 290 |npc Intrepid's Locked Strongbox |at 1437 14.4,24.0 |value mid  -- Lifting the Curse (30)
accept 292 |npc Intrepid's Locked Strongbox |at 1437 14.4,24.0 |value mid |lvl 22 |preany 290  -- The Eye of Paleth (30)
complete 98245 |at 1437 38.2,15.9 |areas 68.7,31.3:43;38.2,15.9:13 |mobs Highland Razormaw@Razormaw Incisor;Elder Razormaw@Razormaw Incisor |value mid  -- Razormaw Needling (29)
accept 87491 |npc Captive Fire Elemental |at 1437 45.7,16.7 |lvl 27  -- Spark of Freedom (30)
complete 303 |at 1437 47.1,17.1 |areas 47.1,17.1:37;61.5,26.2:28 |mobs Dark Iron Dwarf;Dark Iron Tunneler;Dark Iron Saboteur;Dark Iron Demolitionist |value low |group elite  -- The Dark Iron War (30)
complete 88756 |at 1437 48.9,17.4 |mobs Dark Iron Dwarf  -- Bring Back a Bang (31)
turnin 303 |npc Motley Garmason |at 1437 49.7,18.2 |value low |group elite  -- The Dark Iron War (30)
turnin 304 |npc Longbraid the Grim |at 1437 49.8,18.3 |group elite  -- A Grim Task (34)
turnin 633 |npc Rhag Garmason |at 1437 49.9,18.2  -- The Thandol Span (31)
turnin 87491 |npc Roggo Harlbarrow |at 1437 49.9,18.1  -- Spark of Freedom (30)
turnin 88756 |npc Ashlan Stonesmirk |at 1437 50.0,18.2  -- Bring Back a Bang (31)
accept 634 |npc Rhag Garmason |at 1437 49.9,18.2 |lvl 28 |preany 633  -- Plea To The Alliance (31)
turnin 98230 |npc Howin Kindfeather |at 1437 49.4,42.1 |group chain  -- This Land Was Their Land (29)
turnin 98245 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid  -- Razormaw Needling (29)
turnin 98246 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid  -- Trying Times (29)
accept 98291 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid |group elite |lvl 22 |pre 98245,98246  -- Death to the Dragonmaw (30)
turnin 98240 |npc Howin Kindfeather |at 1437 49.4,42.1  -- Crimson Crate Delivery (29)
accept 98283 |npc Rethiel the Greenwarden |at 1437 56.4,40.4 |group elite |lvl 22 |preany 275  -- Carnage (30)
complete 98283 |at 1437 61.8,39.7 |mobs Maddened Rotclaw@Malignant Rotclaw Flesh;Carnage@Carnage's Head |group elite  -- Carnage (30)
complete 98291 |at 1437 65.7,46.7 |mobs Dragonmaw Reclaimer;Dragonmaw Soulbinder;Dragonmaw Infiltrator |value mid |group elite  -- Death to the Dragonmaw (30)
turnin 98283 |npc Rethiel the Greenwarden |at 1437 56.4,40.4 |group elite  -- Carnage (30)
turnin 98291 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid |group elite  -- Death to the Dragonmaw (30)
accept 98297 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid |group elite |lvl 24 |preany 98291  -- Stopping the Cycle (34)
complete 98310 |at 1437 76.6,45.7 |areas 66.1,71.2:48;50.3,17.6:47;76.6,45.7:37 |item 280394 |mobs Modr@Heart of Modr;Golm@Heart of Golm;Ados@Heart of Ados;Neru@Heart of Neru |group elite  -- Gleaning Our Future (32)
complete 98297 |at 1437 76.5,44.7 |mobs Subdued Dragonspawn |value mid |group elite  -- Stopping the Cycle (34)
turnin 98297 |npc Howin Kindfeather |at 1437 49.4,42.1 |value mid |group elite  -- Stopping the Cycle (34)
turnin 296 |npc Ormer Ironbraid |at 1437 38.2,50.9  -- Ormer's Revenge (29)
turnin 98310 |npc Prospector Whelgar |at 1437 38.8,52.4 |group elite  -- Gleaning Our Future (32)
accept 1302 |npc Vincent Hyal |at 1437 10.8,60.4 |lvl 30  -- James Hyal (35)
turnin 292 |npc Glorin Steelbrow |at 1437 10.6,60.6 |value mid  -- The Eye of Paleth (30)
accept 293 |npc Glorin Steelbrow |at 1437 10.6,60.6 |value mid |lvl 22 |preany 292  -- Cleansing the Eye (30)
goto 1437 4.6,57.1 15 |note Take the boat to Theramore  -- boat Menethil Harbor to Theramore
turnin 1302 |npc Clerk Lendry |at 1445 67.9,48.2  -- James Hyal (35)
goto 1445 71.6,56.4 15 |note Take the boat to Menethil Harbor  -- boat Theramore to Menethil Harbor
fly 1417 45.7,46.1 |from 1437 9.5,59.7 |npc Arathi Highlands (Cedrik Prose)  -- flight master Shellei Brondir
turnin 634 |npc Captain Nials |at 1417 45.8,47.6  -- Plea To The Alliance (31)
accept 647 |npc Foggy MacKreel |at 1417 43.2,92.6 |lvl 28  -- MacKreel's Moonshine (30)
fly 1424 49.3,52.3 |from 1417 45.7,46.1 |npc Hillsbrad Foothills (Darla Harris)  -- flight master Cedrik Prose
turnin 647 |npc Brewmeister Bilger |at 1424 52.1,58.7  -- MacKreel's Moonshine (30)
fly 1437 9.5,59.7 |from 1424 49.3,52.3 |npc Shellei Brondir  -- flight master Darla Harris
goto 1437 4.8,63.6 15 |note Take the boat to Auberdine  -- boat Menethil Harbor to Auberdine
turnin 98209 |npc Thundris Windweaver |at 1439 37.4,40.1  -- Bloom of the Heavens (29)
goto 1439 32.4,43.8 15 |note Take the boat to Menethil Harbor  -- boat Auberdine to Menethil Harbor
fly 1453 71.3,72.2 |from 1437 9.5,59.7 |npc Stormwind City (Dungar Longdrink) |value mid  -- flight master Shellei Brondir
turnin 293 |npc Archbishop Benedictus |at 1453 50.3,45.5 |value mid  -- Cleansing the Eye (30)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   97171  Your First Horse (40)
