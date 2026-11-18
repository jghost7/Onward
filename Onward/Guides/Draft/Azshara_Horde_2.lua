-- DRAFT Azshara (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "azshara-h-2", title = "Azshara (55-60)", faction = "Horde", zone = "Azshara",
  levels = { 55, 60 },
  steps = [[
accept 91500 |npc Sin'dorei Tome of Summoning |at 1447 59.5,31.3 |lvl 44 |preany 91497  -- An Explosive Gambit (55)
accept 91538 |npc Sin'dorei Tome of Summoning |at 1447 59.5,31.3 |lvl 44 |preany 91497  -- Sin'dorei Tome of Summoning (55)
complete 91500 |at 1447 59.5,31.4 |item 249390 |mobs Magus Rimtori@Head of Magus Rimtori  -- An Explosive Gambit (55)
accept 6805 |npc Duke Hydraxis |at 1447 79.3,73.7 |lvl 55  -- Stormers and Rumblers (57)
accept 6804 |npc Duke Hydraxis |at 1447 79.3,73.7 |lvl 55  -- Poisoned Water (56)
accept 3509 |npc Loramus Thalipedes |at 1447 60.8,66.3 |lvl 45 |preany 3508  -- The Name of the Beast (58)
complete 6805 |at 1447 11.9,78.1 |mobs Dust Stormer;Desert Rumbler  -- Stormers and Rumblers (57)
complete 6804 |at 1447 15.0,49.8 |item 17310 |mobs Azshara Sentinel;Moderate Manifestation of Water;Corrupt Moderate Manifestation of Water  -- Poisoned Water (56)
accept 91611 |npc Kurll |at 1447 21.8,52.1 |group elite |lvl 50  -- Deadliest Catch (56)
turnin 91500 |npc Ag'tor Bloodfist |at 1447 22.3,51.5  -- An Explosive Gambit (55)
turnin 91538 |npc Jediga |at 1447 22.6,51.4  -- Sin'dorei Tome of Summoning (55)
accept 91547 |npc Jediga |at 1447 22.6,51.4 |lvl 44 |preany 91538  -- Sin'dorei Tome of Summoning (55)
accept 92346 |npc Jediga |at 1447 22.6,51.4 |lvl 45  -- Beneath Nordrassil (55)
turnin 3509 |npc Lord Arkkoroc |at 1447 77.1,42.8  -- The Name of the Beast (58)
accept 3510 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group elite |lvl 45 |preany 3509  -- The Name of the Beast (58)
complete 3510 |at 1447 56.7,44.8 |mobs Hetaera@Hetaera's Beaten Head |group elite  -- The Name of the Beast (58)
turnin 3510 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group elite  -- The Name of the Beast (58)
accept 3511 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group chain |lvl 45 |preany 3510  -- The Name of the Beast (58)
turnin 6804 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Poisoned Water (56)
turnin 6805 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Stormers and Rumblers (57)
accept 6821 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon |lvl 56 |pre 6804,6805  -- Eye of the Emberseer (60)
turnin 3511 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- The Name of the Beast (58)
accept 3602 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain |lvl 45 |preany 3511  -- Azsharite (58)
complete 6821 |at 1447 11.9,78.1 |mobs Azshara Sentinel |group dungeon  -- Eye of the Emberseer (60)
complete 3602 |at 1447 54.6,82.0 |item 10834 |group chain  -- Azsharite (58)
complete 91611 |at 1447 76.3,74.9 |mobs Mammoth Shark@Mammoth Shark Steak |group elite  -- Deadliest Catch (56)
turnin 6821 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Eye of the Emberseer (60)
accept 6822 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon |lvl 57 |preany 6821  -- The Molten Core (60)
turnin 3602 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- Azsharite (58)
accept 3621 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain |lvl 45 |preany 3602  -- The Formation of Felbane (58)
turnin 91611 |npc Kurll |at 1447 21.8,52.1 |group elite  -- Deadliest Catch (56)
goto 1411 50.8,13.6 15 |note Take the zeppelin to Grom'gol  -- zeppelin Orgrimmar to Grom'gol
turnin 3621 |npc Galvan the Ancient |at 1434 50.6,20.5 |group chain  -- The Formation of Felbane (58)
goto 1434 31.3,29.2 15 |note Take the zeppelin to Orgrimmar  -- zeppelin Grom'gol to Orgrimmar
turnin 91547 |npc Zevrost |at 1454 48.5,45.4  -- Sin'dorei Tome of Summoning (55)
fly 1456 47.0,49.8 |from 1454 45.1,63.9 |npc Thunder Bluff (Tal)  -- flight master Doras
turnin 92346 |npc Nara Wildmane |at 1456 75.7,31.6  -- Beneath Nordrassil (55)
fly 1447 22.0,49.6 |from 1456 47.0,49.8 |npc Kroum  -- flight master Tal
complete 6822 |at 1447 11.9,78.1 |mobs Molten Giant;Firelord;Ancient Core Hound;Lava Surger |group dungeon  -- The Molten Core (60)
turnin 6822 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- The Molten Core (60)
accept 6823 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain |lvl 60 |preany 6822  -- Agent of Hydraxis (60)
complete 6823 |at 1447 11.9,78.1 |mobs Azshara Sentinel |group chain  -- Agent of Hydraxis (60)
turnin 6823 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- Agent of Hydraxis (60)
accept 6824 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon |lvl 60 |preany 6823  -- Hands of the Enemy (60)
fly 1446 51.6,25.4 |from 1447 22.0,49.6 |npc Tanaris (Bulkrek Ragefist)  -- flight master Kroum
accept 8729 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain |lvl 60 |preany 8728  -- The Wrath of Neptulon (60)
fly 1447 22.0,49.6 |from 1446 51.6,25.4 |npc Kroum  -- flight master Bulkrek Ragefist
complete 8729 |at 1447 11.9,78.1 |item 21136 |mobs Azshara Sentinel |group chain  -- The Wrath of Neptulon (60)
complete 6824 |at 1447 11.9,78.1 |mobs Azshara Sentinel |group dungeon  -- Hands of the Enemy (60)
accept 8575 |npc Spirit of Azuregos |at 1447 53.0,81.7 |group chain |lvl 60 |preany 8555  -- Azuregos's Magical Ledger (60)
turnin 6824 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Hands of the Enemy (60)
accept 7486 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain |lvl 60 |preany 6824  -- A Hero's Reward (60)
turnin 7486 |npc Hydraxis' Coffer |at 1447 79.2,74.9 |group chain  -- A Hero's Reward (60)
fly 1446 51.6,25.4 |from 1447 22.0,49.6 |npc Tanaris (Bulkrek Ragefist)  -- flight master Kroum
turnin 8575 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- Azuregos's Magical Ledger (60)
turnin 8729 |npc Anachronos |at 1446 65.3,50.0 |group chain  -- The Wrath of Neptulon (60)
]]}
