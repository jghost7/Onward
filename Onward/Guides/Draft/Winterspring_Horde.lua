-- DRAFT Winterspring (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "winterspring-h", title = "Winterspring (54-60)", faction = "Horde", zone = "Winterspring",
  levels = { 54, 60 },
  steps = [[
home |npc Innkeeper Vizzie |at 1452 61.4,38.8  -- set your hearthstone at the inn
accept 969 |npc Witch Doctor Mau'ari |at 1452 61.9,38.3 |lvl 55  -- Luck Be With You (60)
accept 5054 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group elite |lvl 53  -- Ursius of the Shardtooth (56)
complete 5054 |at 1452 60.9,32.9 |mobs Ursius |group elite  -- Ursius of the Shardtooth (56)
accept 3783 |npc Umi Rumplesnicker |at 1452 60.9,37.6 |lvl 52  -- Are We There, Yeti? (56)
turnin 5054 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group elite  -- Ursius of the Shardtooth (56)
accept 5055 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group elite |lvl 53 |preany 5054  -- Brumeran of the Chillwind (58)
accept 6606 |npc Harlo Wigglesworth |at 1452 61.1,38.4 |lvl 55  -- A Little Luck (60)
accept 6605 |npc Harlo Wigglesworth |at 1452 61.1,38.4 |lvl 49  -- A Strange One (54)
accept 6603 |npc Meggi Peppinrocker |at 1452 60.7,38.2 |lvl 52  -- Trouble in Winterspring! (56)
complete 3783 |at 1452 54.4,36.3 |mobs Ice Thistle Yeti@Thick Yeti Fur;Rogue Ice Thistle@Thick Yeti Fur  -- Are We There, Yeti? (56)
accept 8471 |at 1452 42.3,42.6 |note Starts from Winterfall Ritual Totem |lvl 50  -- Winterfall Ritual Totem (56)
accept 5083 |at 1452 41.6,42.6 |note Starts from Empty Firewater Flask |lvl 52  -- Winterfall Firewater (56)
turnin 6603 |npc Donova Snowden |at 1452 31.3,45.2  -- Trouble in Winterspring! (56)
turnin 5083 |npc Donova Snowden |at 1452 31.3,45.2  -- Winterfall Firewater (56)
accept 5084 |npc Donova Snowden |at 1452 31.3,45.2 |lvl 52 |preany 5083  -- Falling to Corruption (56)
fly 1448 34.4,54.0 |from 1452 60.5,36.3 |npc Felwood (Brakkar)  -- flight master Yugrek
turnin 5084 |npc Deadwood Cauldron |at 1448 60.2,5.8  -- Falling to Corruption (56)
accept 5085 |npc Deadwood Cauldron |at 1448 60.2,5.8 |lvl 52 |preany 5084  -- Mystery Goo (56)
accept 97264 |value mid |lvl 55  -- Shardtooth Pulling (58)
fly 1452 60.5,36.3 |from 1448 34.4,54.0 |npc Yugrek  -- flight master Brakkar
turnin 5085 |npc Donova Snowden |at 1452 31.3,45.2  -- Mystery Goo (56)
accept 5086 |npc Donova Snowden |at 1452 31.3,45.2 |lvl 52 |preany 5085  -- Toxic Horrors (56)
complete 969 |at 1452 61.5,67.4 |mobs Hailspite@Frostmaul Shards;Frostmaul Preserver@Frostmaul Shards;Frostmaul Giant@Frostmaul Shards;Kashoch the Reaver@Frostmaul Shards  -- Luck Be With You (60)
complete 5055 |at 1452 62.5,57.9 |mobs Brumeran |group elite  -- Brumeran of the Chillwind (58)
accept 6029 |npc Gregor Greystone |at 1452 61.4,39.0 |lvl 50  -- The Everlook Report (52)
accept 6030 |npc Gregor Greystone |at 1452 61.4,39.0 |lvl 50  -- Duke Nicholas Zverenhoff (52)
accept 4809 |npc Felnok Steelspring |at 1452 61.6,38.6 |value mid |lvl 50 |preany 4808  -- Chillwind Horns (54)
turnin 5055 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group elite  -- Brumeran of the Chillwind (58)
accept 5056 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group elite |lvl 53 |preany 5055  -- Shy-Rotam (60)
turnin 969 |npc Witch Doctor Mau'ari |at 1452 61.9,38.3  -- Luck Be With You (60)
turnin 6606 |npc Witch Doctor Mau'ari |at 1452 61.9,38.3  -- A Little Luck (60)
turnin 3783 |npc Umi Rumplesnicker |at 1452 60.9,37.6  -- Are We There, Yeti? (56)
accept 977 |npc Umi Rumplesnicker |at 1452 60.9,37.6 |lvl 52 |preany 3783  -- Are We There, Yeti? (58)
complete 5086 |at 1452 60.9,33.9 |mobs Winterspring Owl;Winterspring Screecher  -- Toxic Horrors (56)
complete 4809 |at 1452 58.5,25.5 |mobs Chillwind Ravager@Uncracked Chillwind Horn;Chillwind Chimaera@Uncracked Chillwind Horn;Fledgling Chillwind@Uncracked Chillwind Horn |value mid  -- Chillwind Horns (54)
accept 4882 |at 1452 65.2,23.6 |note Starts from Blue-feathered Necklace |lvl 52 |preany 4741  -- Guarding Secrets (59)
complete 97264 |at 1452 59.0,21.3 |mobs Elder Shardtooth |value mid  -- Shardtooth Pulling (58)
turnin 97264 |value mid  -- Shardtooth Pulling (58)
accept 97403 |value low |lvl 55  -- Two-Headed Ravagers (59)
complete 97403 |at 1452 58.6,21.5 |mobs Chillwind Ravager |value low  -- Two-Headed Ravagers (59)
turnin 97403 |value low  -- Two-Headed Ravagers (59)
accept 97404 |lvl 55  -- Too Bad to Bear (59)
complete 97404 |at 1452 59.0,10.6 |mobs Kuroma@Kuroma's Head;Kamuro@Kamuro's Head  -- Too Bad to Bear (59)
turnin 97404  -- Too Bad to Bear (59)
complete 5056 |at 1452 49.8,9.8 |mobs Shy-Rotam |group elite  -- Shy-Rotam (60)
turnin 5086 |npc Donova Snowden |at 1452 31.3,45.2  -- Toxic Horrors (56)
accept 5082 |npc Donova Snowden |at 1452 31.3,45.2 |value low |lvl 52  -- Threat of the Winterfall (56)
accept 5087 |npc Donova Snowden |at 1452 31.3,45.2 |lvl 52 |preany 5086  -- Winterfall Runners (57)
complete 5087 |at 1452 27.9,34.5 |mobs Winterfall Runner@Winterfall Crate  -- Winterfall Runners (57)
turnin 5087 |npc Donova Snowden |at 1452 31.3,45.2  -- Winterfall Runners (57)
accept 5121 |npc Donova Snowden |at 1452 31.3,45.2 |group elite |lvl 52 |preany 5087  -- High Chief Winterfall (59)
accept 5161 |npc Haleh |at 1452 54.5,51.2 |lvl 57 |preany 5160  -- Wrath of the Blue Flight (60)
turnin 5161 |npc Haleh |at 1452 54.5,51.2  -- Wrath of the Blue Flight (60)
complete 977 |at 1452 70.3,40.6 |mobs Ice Thistle Matriarch@Pristine Yeti Horn;Ice Thistle Patriarch@Pristine Yeti Horn  -- Are We There, Yeti? (58)
complete 5121 |at 1452 69.6,38.3 |mobs High Chief Winterfall |group elite  -- High Chief Winterfall (59)
accept 5123 |at 1452 69.6,38.3 |note Starts from Crudely-written Log |lvl 52 |preany 5087  -- The Final Piece (59)
turnin 5056 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group elite  -- Shy-Rotam (60)
accept 5057 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group chain |lvl 53 |preany 5056  -- Past Endeavors (60)
turnin 5057 |npc Storm Shadowhoof |at 1452 61.9,38.4 |group chain  -- Past Endeavors (60)
turnin 977 |npc Umi Rumplesnicker |at 1452 60.9,37.6  -- Are We There, Yeti? (58)
accept 5163 |npc Umi Rumplesnicker |at 1452 60.9,37.6 |lvl 52 |preany 977  -- Are We There, Yeti? (58)
complete 5163 |at 1452 61.5,38.6 |item 12928 |mobs Legacki;Sprinkle;Quixxil  -- Are We There, Yeti? (58)
turnin 4809 |npc Felnok Steelspring |at 1452 61.6,38.6 |value mid  -- Chillwind Horns (54)
accept 4810 |npc Felnok Steelspring |at 1452 61.6,38.6 |value mid |lvl 50 |preany 4809  -- Return to Tinkee (54)
turnin 5163 |npc Umi Rumplesnicker |at 1452 60.9,37.6  -- Are We There, Yeti? (58)
complete 5082 |at 1452 39.8,42.7 |mobs Winterfall Pathfinder;Winterfall Den Watcher;Winterfall Totemic |value low  -- Threat of the Winterfall (56)
turnin 5123 |npc Donova Snowden |at 1452 31.3,45.2  -- The Final Piece (59)
turnin 5082 |npc Donova Snowden |at 1452 31.3,45.2 |value low  -- Threat of the Winterfall (56)
accept 5128 |npc Donova Snowden |at 1452 31.3,45.2 |lvl 52 |preany 5123  -- Words of the High Chief (59)
turnin 5121 |npc Donova Snowden |at 1452 31.3,45.2 |group elite  -- High Chief Winterfall (59)
fly 1413 63.1,37.2 |from 1452 60.5,36.3 |npc The Barrens (Bragok)  -- flight master Yugrek
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1428 65.7,24.2 |from 1434 26.9,77.1 |npc Burning Steppes (Vahgruk) |value mid  -- flight master Gringer
turnin 4810 |npc Tinkee Steamboil |at 1428 65.2,24.0 |value mid  -- Return to Tinkee (54)
fly 1434 26.9,77.1 |from 1428 65.7,24.2 |npc Stranglethorn Vale (Gringer)  -- flight master Vahgruk
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1448 34.4,54.0 |from 1413 63.1,37.2 |npc Felwood (Brakkar)  -- flight master Bragok
turnin 4882 |npc Trull Failbane |at 1448 34.7,52.8  -- Guarding Secrets (59)
complete 8471 |item 20742  -- Winterfall Ritual Totem (56)
turnin 8471 |npc Kernda |at 1448 65.5,3.5  -- Winterfall Ritual Totem (56)
turnin 6605 |npc Winna Hazzard |at 1448 34.2,52.3  -- A Strange One (54)
accept 4883 |npc Trull Failbane |at 1448 34.7,52.8 |lvl 52 |preany 4882  -- Guarding Secrets (59)
turnin 5128 |npc Kelek Skykeeper |at 1448 51.1,81.8  -- Words of the High Chief (59)
fly 1413 63.1,37.2 |from 1448 34.4,54.0 |npc The Barrens (Bragok)  -- flight master Brakkar
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1423 70.5,47.5 |from 1434 26.9,77.1 |npc Eastern Plaguelands (Georgia)  -- flight master Gringer
turnin 6030 |npc Duke Nicholas Zverenhoff |at 1423 71.6,50.1  -- Duke Nicholas Zverenhoff (52)
turnin 6029 |npc Argent Officer Garush |at 1420 83.2,68.5  -- The Everlook Report (52)
goto 1420 60.8,58.8 15 |note Take the zeppelin to Orgrimmar  -- zeppelin Undercity to Orgrimmar
turnin 4883 |npc Nara Wildmane |at 1456 75.7,31.6  -- Guarding Secrets (59)
]]}
