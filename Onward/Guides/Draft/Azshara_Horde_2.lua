-- DRAFT Azshara (Horde) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "azshara-h-2", title = "Azshara (55-60)", faction = "Horde", zone = "Azshara",
  levels = { 55, 60 },
  steps = [[
accept 91500 |npc Sin'dorei Tome of Summoning |at 1447 59.5,31.3  -- An Explosive Gambit (55)
accept 91538 |npc Sin'dorei Tome of Summoning |at 1447 59.5,31.3  -- Sin'dorei Tome of Summoning (55)
complete 91500 |at 1447 59.5,31.4 |mobs Magus Rimtori  -- An Explosive Gambit (55)
accept 91611 |npc Kurll |at 1447 21.8,52.1 |value low |group elite  -- Deadliest Catch (56)
accept 3509 |npc Loramus Thalipedes |at 1447 60.8,66.3  -- The Name of the Beast (58)
complete 91611 |at 1447 76.3,74.9 |mobs Mammoth Shark |value low |group elite  -- Deadliest Catch (56)
accept 6805 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Stormers and Rumblers (57)
accept 6804 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Poisoned Water (56)
complete 6805 |at 1451 22.8,19.2 |mobs Dust Stormer;Desert Rumbler  -- Stormers and Rumblers (57)
turnin 3509 |npc Lord Arkkoroc |at 1447 77.1,42.8  -- The Name of the Beast (58)
accept 3510 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group elite  -- The Name of the Beast (58)
complete 3510 |at 1447 56.7,44.8 |mobs Hetaera |group elite  -- The Name of the Beast (58)
turnin 3510 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group elite  -- The Name of the Beast (58)
accept 3511 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group chain  -- The Name of the Beast (58)
turnin 3511 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- The Name of the Beast (58)
accept 3602 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- Azsharite (58)
complete 3602 |at 1447 54.6,82.0 |group chain  -- Azsharite (58)
turnin 3602 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- Azsharite (58)
accept 3621 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- The Formation of Felbane (58)
fly 1434 32.5,29.4 |from 1447 22.0,49.6 |npc Stranglethorn Vale (Thysta)  -- flight master Kroum
turnin 3621 |npc Galvan the Ancient |at 1434 50.6,20.5 |group chain  -- The Formation of Felbane (58)
fly 1447 22.0,49.6 |from 1434 32.5,29.4 |npc Kroum  -- flight master Thysta
turnin 91538 |npc Jediga |at 1447 22.6,51.4  -- Sin'dorei Tome of Summoning (55)
accept 91547 |npc Jediga |at 1447 22.6,51.4  -- Sin'dorei Tome of Summoning (55)
accept 92346 |npc Jediga |at 1447 22.6,51.4  -- Beneath Nordrassil (55)
fly 1454 45.1,63.9 |from 1447 22.0,49.6 |npc Orgrimmar (Doras)  -- flight master Kroum
turnin 91547 |npc Zevrost |at 1454 48.5,45.4  -- Sin'dorei Tome of Summoning (55)
fly 1456 47.0,49.8 |from 1454 45.1,63.9 |npc Thunder Bluff (Tal)  -- flight master Doras
turnin 92346 |npc Nara Wildmane |at 1456 75.7,31.6  -- Beneath Nordrassil (55)
fly 1447 22.0,49.6 |from 1456 47.0,49.8 |npc Kroum  -- flight master Tal
turnin 91500 |npc Ag'tor Bloodfist |at 1447 22.3,51.5  -- An Explosive Gambit (55)
complete 6804 |at 1423 53.4,66.0  -- Poisoned Water (56)
turnin 91611 |npc Kurll |at 1447 21.8,52.1 |value low |group elite  -- Deadliest Catch (56)
turnin 6805 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Stormers and Rumblers (57)
turnin 6804 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Poisoned Water (56)
accept 6821 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Eye of the Emberseer (60)
complete 6821 |group dungeon  -- Eye of the Emberseer (60)
turnin 6821 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Eye of the Emberseer (60)
accept 6822 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- The Molten Core (60)
complete 6822 |mobs Molten Giant;Firelord;Ancient Core Hound;Lava Surger |group dungeon  -- The Molten Core (60)
turnin 6822 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- The Molten Core (60)
accept 6823 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- Agent of Hydraxis (60)
complete 6823 |group chain  -- Agent of Hydraxis (60)
accept 8575 |npc Spirit of Azuregos |at 1447 53.0,81.7 |group chain  -- Azuregos's Magical Ledger (60)
fly 1446 51.6,25.4 |from 1447 22.0,49.6 |npc Tanaris (Bulkrek Ragefist)  -- flight master Kroum
accept 8729 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- The Wrath of Neptulon (60)
turnin 8575 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- Azuregos's Magical Ledger (60)
fly 1447 22.0,49.6 |from 1446 51.6,25.4 |npc Kroum  -- flight master Bulkrek Ragefist
turnin 6823 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- Agent of Hydraxis (60)
accept 6824 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Hands of the Enemy (60)
complete 6824 |group dungeon  -- Hands of the Enemy (60)
turnin 6824 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Hands of the Enemy (60)
accept 7486 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- A Hero's Reward (60)
turnin 7486 |npc Hydraxis' Coffer |at 1447 79.2,74.9 |group chain  -- A Hero's Reward (60)
complete 8729 |group chain  -- The Wrath of Neptulon (60)
fly 1446 51.6,25.4 |from 1447 22.0,49.6 |npc Tanaris (Bulkrek Ragefist)  -- flight master Kroum
turnin 8729 |npc Anachronos |at 1446 65.3,50.0 |group chain  -- The Wrath of Neptulon (60)
]]}
