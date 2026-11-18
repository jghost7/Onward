-- DRAFT Badlands (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "badlands-h", title = "Badlands (37-54)", faction = "Horde", zone = "Badlands",
  levels = { 37, 54 },
  steps = [[
accept 703 |npc Rigglefuzz |at 1418 42.4,52.9 |value mid |lvl 33  -- Barbecued Buzzard Wings (40)
accept 705 |npc Rigglefuzz |at 1418 42.4,52.9 |value mid |lvl 30  -- Pearl Diving (37)
accept 2418 |npc Rigglefuzz |at 1418 42.4,52.9 |value mid |lvl 30  -- Power Stones (36)
accept 710 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35  -- Study of the Elements: Rock (37)
home |npc Innkeeper Shul'kar |at 1418 2.8,45.9  -- set your hearthstone at the inn
accept 1419 |npc Neeka Bloodscar |at 1418 6.5,47.2 |value low |lvl 30  -- Coyote Thieves (40)
accept 2258 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |value mid |lvl 36  -- Badlands Reagent Run (39)
complete 710 |at 1418 18.8,43.0 |mobs Lesser Rock Elemental@Small Stone Shard  -- Study of the Elements: Rock (37)
turnin 710 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- Study of the Elements: Rock (37)
accept 713 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35  -- Coolant Heads Prevail (37)
accept 711 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35 |preany 710  -- Study of the Elements: Rock (39)
complete 713  -- Coolant Heads Prevail (37)
turnin 713 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- Coolant Heads Prevail (37)
accept 714 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35 |preany 713  -- Gyro... What? (37)
complete 714  -- Gyro... What? (37)
turnin 714 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- Gyro... What? (37)
complete 1419 |at 1418 53.0,56.6 |mobs Elder Crag Coyote@Coyote Jawbone;Feral Crag Coyote@Coyote Jawbone;Crag Coyote@Coyote Jawbone;Rabid Crag Coyote@Coyote Jawbone |value low  -- Coyote Thieves (40)
accept 709 |npc Theldurin the Lost |at 1418 51.4,76.9 |lvl 30  -- Solution to Doom (40)
accept 692 |npc Theldurin the Lost |at 1418 51.4,76.9 |value mid |lvl 30 |preany 687  -- The Lost Fragments (41)
complete 711 |at 1418 40.5,78.3 |mobs Rock Elemental@Large Stone Slab  -- Study of the Elements: Rock (39)
complete 2258 |at 1418 37.6,63.0 |mobs Elder Crag Coyote@Crag Coyote Fang;Feral Crag Coyote@Crag Coyote Fang;Rock Elemental@Rock Elemental Shard;Crag Coyote@Crag Coyote Fang |value mid  -- Badlands Reagent Run (39)
complete 703 |at 1418 33.4,59.8 |mobs Giant Buzzard@Buzzard Wing;Buzzard@Buzzard Wing;Starving Buzzard@Buzzard Wing;Zaricotl@Buzzard Wing |value mid  -- Barbecued Buzzard Wings (40)
turnin 711 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- Study of the Elements: Rock (39)
accept 712 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35 |preany 711  -- Study of the Elements: Rock (42)
turnin 1419 |npc Neeka Bloodscar |at 1418 6.5,47.2 |value low  -- Coyote Thieves (40)
accept 1420 |npc Neeka Bloodscar |at 1418 6.5,47.2 |lvl 30  -- Report to Helgrum (40)
turnin 2258 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |value mid  -- Badlands Reagent Run (39)
accept 2202 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |value mid |lvl 36 |preany 2258  -- Uldaman Reagent Run (42)
accept 782 |npc Gorn |at 1418 2.9,45.6 |lvl 40  -- Broken Alliances (43)
fly 1458 63.2,48.6 |from 1418 4.0,44.8 |npc Undercity (Michael Garrett)  -- flight master Gorrik
accept 2342 |npc Patrick Garrett |at 1458 62.3,48.6 |lvl 33  -- Reclaimed Treasures (43)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
accept 2283 |npc Dran Droffers |at 1454 59.5,36.6 |group elite |lvl 37  -- Necklace Recovery (41)
accept 78823 |lvl 26  -- Terror of the Desert Skies (40)
fly 1413 63.1,37.2 |from 1454 45.1,63.9 |npc The Barrens (Bragok)  -- flight master Doras
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1418 4.0,44.8 |from 1434 26.9,77.1 |npc Gorrik  -- flight master Gringer
complete 712 |at 1418 5.5,82.3 |mobs Greater Rock Elemental@Bracers of Rock Binding  -- Study of the Elements: Rock (42)
complete 782 |at 1418 12.6,75.5 |mobs Boss Tho'grun@Sign of the Earth  -- Broken Alliances (43)
complete 78823 |at 1418 13.9,76.0 |mobs Stonevault Bonesnapper@Primitive Drawing;Dustbelcher Mauler@Primitive Drawing;Dustbelcher Ogre Mage@Primitive Drawing;Dustbelcher Wyrmhunter@Primitive Drawing  -- Terror of the Desert Skies (40)
turnin 712 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- Study of the Elements: Rock (42)
accept 734 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35 |pre 712,714  -- This Is Going to Be Hard (42)
accept 715 |npc Lucien Tosselwrench |at 1418 25.8,44.2 |lvl 35 |preany 714  -- Liquid Stone (37)
turnin 734 |npc Lucien Tosselwrench |at 1418 25.8,44.2  -- This Is Going to Be Hard (42)
accept 716 |npc Lucien Tosselwrench |at 1418 25.8,44.2 |lvl 35 |preany 712  -- Stone Is Better than Cloth (42)
complete 716 |at 1418 41.6,28.2 |mobs Stone Golem  -- Stone Is Better than Cloth (42)
complete 2283 |at 1418 47.8,12.2 |mobs Shadowforge Digger@Shattered Necklace;Shadowforge Surveyor@Shattered Necklace;Shadowforge Ruffian@Shattered Necklace;Stonevault Rockchewer@Shattered Necklace |group elite  -- Necklace Recovery (41)
complete 2418 |at 1418 47.6,12.4 |mobs Shadowforge Digger@Dentrium Power Stone;Shadowforge Surveyor@Dentrium Power Stone;Shadowforge Ruffian@Dentrium Power Stone |value mid  -- Power Stones (36)
complete 709 |at 1418 39.3,18.8  -- Solution to Doom (40)
complete 2202 |at 1418 37.6,15.3 |value mid  -- Uldaman Reagent Run (42)
complete 2342 |at 1418 34.2,18.6  -- Reclaimed Treasures (43)
fly 1434 32.5,29.4 |from 1418 4.0,44.8 |npc Stranglethorn Vale (Thysta)  -- flight master Gorrik
complete 705 |at 1434 26.3,26.1 |value mid  -- Pearl Diving (37)
turnin 78823 |npc Hemet Nesingwary |at 1434 35.7,10.8  -- Terror of the Desert Skies (40)
accept 78830 |npc Hemet Nesingwary |at 1434 35.7,10.8 |class HUNTER |lvl 26 |preany 78823  -- Terror of the Desert Skies (40)
fly 1435 46.1,54.8 |from 1434 32.5,29.4 |npc Swamp of Sorrows (Breyk)  -- flight master Thysta
turnin 1420 |npc Helgrum the Swift |at 1435 47.7,55.2  -- Report to Helgrum (40)
fly 1434 26.9,77.1 |from 1435 46.1,54.8 |npc Stranglethorn Vale (Gringer)  -- flight master Breyk
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 2283 |npc Dran Droffers |at 1454 59.5,36.6 |group elite  -- Necklace Recovery (41)
accept 2284 |npc Dran Droffers |at 1454 59.5,36.6 |group chain |lvl 37 |preany 2283  -- Necklace Recovery, Take 2 (41)
fly 1413 63.1,37.2 |from 1454 45.1,63.9 |npc The Barrens (Bragok)  -- flight master Doras
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
accept 737 |npc Gerrig Bonegrip |at 1455 50.8,5.6 |group chain |lvl 30 |preany 735,736  -- Forbidden Knowledge (40)
accept 2280 |lvl 40 |preany 2278  -- The Platinum Discs (47)
turnin 2284 |group chain  -- Necklace Recovery, Take 2 (41)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1456 47.0,49.8 |from 1413 63.1,37.2 |npc Thunder Bluff (Tal)  -- flight master Bragok
turnin 2280 |npc Sage Truthseeker |at 1456 34.4,46.9  -- The Platinum Discs (47)
accept 2318 |group chain |lvl 37 |preany 2284  -- Translating the Journal (42)
fly 1413 63.1,37.2 |from 1456 47.0,49.8 |npc The Barrens (Bragok)  -- flight master Tal
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1418 4.0,44.8 |from 1434 26.9,77.1 |npc Gorrik  -- flight master Gringer
turnin 2318 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group chain  -- Translating the Journal (42)
turnin 2202 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |value mid  -- Uldaman Reagent Run (42)
accept 2338 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group chain |lvl 37 |preany 2318  -- Translating the Journal (42)
turnin 2338 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group chain  -- Translating the Journal (42)
accept 2339 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group dungeon |lvl 37 |preany 2338  -- Find the Gems and Power Source (44)
complete 2339 |item 7668 |group dungeon  -- Find the Gems and Power Source (44)
turnin 2339 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group dungeon  -- Find the Gems and Power Source (44)
accept 2340 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group chain |lvl 37 |preany 2339  -- Deliver the Gems (44)
turnin 782 |npc Gorn |at 1418 2.9,45.6  -- Broken Alliances (43)
accept 793 |npc Gorn |at 1418 2.9,45.6 |value mid |group elite |lvl 40 |preany 782  -- Broken Alliances (50)
turnin 2418 |npc Rigglefuzz |at 1418 42.4,52.9 |value mid  -- Power Stones (36)
turnin 703 |npc Rigglefuzz |at 1418 42.4,52.9 |value mid  -- Barbecued Buzzard Wings (40)
turnin 705 |npc Rigglefuzz |at 1418 42.4,52.9 |value mid  -- Pearl Diving (37)
complete 715 |at 1418 44.5,47.6 |mobs Ridge Huntress@Healing Potion;Shadowforge Warrior@Healing Potion;Shadowforge Chanter@Healing Potion;Stonevault Bonesnapper@Healing Potion  -- Liquid Stone (37)
complete 793 |at 1418 81.9,49.5 |item 4640 |mobs Blacklash@Blacklash's Bindings;Hematus@Chains of Hematus |value mid |group elite  -- Broken Alliances (50)
complete 692 |at 1418 53.9,83.9 |mobs Enraged Rock Elemental@Torn Scroll Fragment |value mid  -- The Lost Fragments (41)
turnin 709 |npc Theldurin the Lost |at 1418 51.4,76.9  -- Solution to Doom (40)
accept 728 |npc Theldurin the Lost |at 1418 51.4,76.9 |lvl 30 |preany 709  -- To the Undercity for Yagyin's Digest (40)
turnin 692 |npc Theldurin the Lost |at 1418 51.4,76.9 |value mid  -- The Lost Fragments (41)
turnin 737 |npc Theldurin the Lost |at 1418 51.4,76.9 |group chain  -- Forbidden Knowledge (40)
complete 78830 |at 1418 23.0,67.0 |item 211272 |mobs Gharrik@Crimson Trophy Quill |class HUNTER  -- Terror of the Desert Skies (40)
accept 3821 |npc Thal'trak Proudtusk |at 1418 3.4,48.1 |lvl 48  -- Dreadmaul Rock (52)
fly 1427 34.8,30.9 |from 1418 4.0,44.8 |npc Searing Gorge (Grisha)  -- flight master Gorrik
accept 81900 |npc Weathered Etching |at 1427 14.5,35.8 |lvl 45  -- The Burning Beast (54)
fly 1458 63.2,48.6 |from 1427 34.8,30.9 |npc Undercity (Michael Garrett)  -- flight master Grisha
turnin 728 |npc Keeper Bel'dugur |at 1458 53.7,54.5  -- To the Undercity for Yagyin's Digest (40)
turnin 2342 |npc Patrick Garrett |at 1458 62.3,48.6  -- Reclaimed Treasures (43)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 2340 |npc Dran Droffers |at 1454 59.5,36.6 |group chain  -- Deliver the Gems (44)
accept 2341 |npc Dran Droffers |at 1454 59.5,36.6 |group chain |lvl 40 |preany 2340  -- Necklace Recovery, Take 3 (44)
fly 1413 63.1,37.2 |from 1454 45.1,63.9 |npc The Barrens (Bragok)  -- flight master Doras
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 81900 |npc Bloodmage Lynnore |at 1419 50.6,14.3  -- The Burning Beast (54)
turnin 3821 |npc Sha'ni Proudtusk |at 1428 80.0,45.4  -- Dreadmaul Rock (52)
fly 1434 32.5,29.4 |from 1428 65.7,24.2 |npc Stranglethorn Vale (Thysta)  -- flight master Vahgruk
turnin 78830 |npc Hemet Nesingwary |at 1434 35.7,10.8 |class HUNTER  -- Terror of the Desert Skies (40)
fly 1418 4.0,44.8 |from 1434 32.5,29.4 |npc Gorrik  -- flight master Thysta
turnin 2341 |npc Jarkal Mossmeld |at 1418 2.4,46.1 |group chain  -- Necklace Recovery, Take 3 (44)
turnin 793 |npc Gorn |at 1418 2.9,45.6 |value mid |group elite  -- Broken Alliances (50)
accept 4062 |npc Hierophant Theodora Mulvadania |at 1418 3.0,47.8 |lvl 52 |preany 4061  -- The Rise of the Machines (54)
turnin 716 |npc Lucien Tosselwrench |at 1418 25.8,44.2  -- Stone Is Better than Cloth (42)
accept 777 |npc Lucien Tosselwrench |at 1418 25.8,44.2 |lvl 35 |preany 734  -- This Is Going to Be Hard (42)
turnin 715 |npc Lucien Tosselwrench |at 1418 25.8,44.2  -- Liquid Stone (37)
turnin 4062 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- The Rise of the Machines (54)
turnin 777 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- This Is Going to Be Hard (42)
accept 778 |npc Lotwil Veriatus |at 1418 25.9,44.9 |lvl 35 |preany 777  -- This Is Going to Be Hard (45)
complete 778 |at 1418 26.0,45.8 |mobs Fam'retor Guardian@Lotwil's Shackles of Elemental Binding  -- This Is Going to Be Hard (45)
turnin 778 |npc Lotwil Veriatus |at 1418 25.9,44.9  -- This Is Going to Be Hard (45)
]]}
