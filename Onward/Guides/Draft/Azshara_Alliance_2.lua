-- DRAFT Azshara (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "azshara-a-2", title = "Azshara (55-60)", faction = "Alliance", zone = "Azshara",
  levels = { 55, 60 },
  steps = [[
home |npc Berdun Cliffbrew |at 1447 12.6,77.4  -- set your hearthstone at the inn
accept 88812 |npc Commander Truesong |at 1447 11.8,78.4  -- Reclaiming Ravencrest (55)
turnin 88812 |npc Commander Truesong |at 1447 11.8,78.4  -- Reclaiming Ravencrest (55)
accept 88813 |npc Commander Truesong |at 1447 11.8,78.4  -- The Head of the Serpent (55)
accept 3509 |npc Loramus Thalipedes |at 1447 60.8,66.3  -- The Name of the Beast (58)
accept 6804 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Poisoned Water (56)
accept 6805 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Stormers and Rumblers (57)
turnin 3509 |npc Lord Arkkoroc |at 1447 77.1,42.8  -- The Name of the Beast (58)
accept 3510 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group elite  -- The Name of the Beast (58)
complete 3510 |at 1447 56.7,44.8 |mobs Hetaera@Hetaera's Beaten Head |group elite  -- The Name of the Beast (58)
accept 89038 |npc Saria Fairmoon |at 1447 50.6,42.7  -- A Monumental Task (55)
complete 88813 |at 1447 41.0,53.0 |mobs Warlord Krellian@Krellian's Head  -- The Head of the Serpent (55)
accept 89015 |npc Berdun Cliffbrew |at 1447 12.6,77.4 |group elite  -- Deadliest Catch (56)
complete 6805 |at 1447 11.9,78.1 |mobs Dust Stormer;Desert Rumbler  -- Stormers and Rumblers (57)
complete 89038 |at 1447 11.9,78.1 |mobs Azshara Sentinel  -- A Monumental Task (55)
complete 6804 |at 1447 15.0,49.8 |item 17310 |mobs Azshara Sentinel;Moderate Manifestation of Water;Corrupt Moderate Manifestation of Water  -- Poisoned Water (56)
turnin 89038 |npc Saria Fairmoon |at 1447 50.6,42.7  -- A Monumental Task (55)
accept 89053 |npc Saria Fairmoon |at 1447 50.6,42.7  -- Your Final Reward (55)
turnin 89053 |npc Saria's Knapsack |at 1447 49.4,41.9  -- Your Final Reward (55)
accept 89470 |npc Saria's Knapsack |at 1447 49.4,41.9  -- Ill Tidings (55)
turnin 3510 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group elite  -- The Name of the Beast (58)
accept 3511 |npc Lord Arkkoroc |at 1447 77.1,42.8 |group chain  -- The Name of the Beast (58)
turnin 6804 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Poisoned Water (56)
turnin 6805 |npc Duke Hydraxis |at 1447 79.3,73.7  -- Stormers and Rumblers (57)
accept 6821 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Eye of the Emberseer (60)
complete 89015 |at 1447 76.3,74.9 |mobs Mammoth Shark@Mammoth Shark Steak |group elite  -- Deadliest Catch (56)
turnin 3511 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- The Name of the Beast (58)
accept 3602 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- Azsharite (58)
turnin 89015 |npc Berdun Cliffbrew |at 1447 12.6,77.4 |group elite  -- Deadliest Catch (56)
complete 6821 |at 1447 11.9,78.1 |mobs Azshara Sentinel |group dungeon  -- Eye of the Emberseer (60)
turnin 88813 |npc Commander Truesong |at 1447 11.8,78.4  -- The Head of the Serpent (55)
turnin 89470 |npc Commander Truesong |at 1447 11.8,78.4  -- Ill Tidings (55)
accept 92345 |npc Commander Truesong |at 1447 11.8,78.4  -- Beneath Nordrassil (55)
complete 3602 |at 1447 54.6,82.0 |item 10834 |group chain  -- Azsharite (58)
turnin 6821 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Eye of the Emberseer (60)
accept 6822 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- The Molten Core (60)
turnin 3602 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- Azsharite (58)
accept 3621 |npc Loramus Thalipedes |at 1447 60.8,66.3 |group chain  -- The Formation of Felbane (58)
fly 1413 63.1,37.2 |from 1447 11.9,77.6 |npc The Barrens (Bragok)  -- flight master Jarrodenus
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 3621 |npc Galvan the Ancient |at 1434 50.6,20.5 |group chain  -- The Formation of Felbane (58)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
turnin 92345 |npc Mathrengyl Bearwalker |at 1457 35.4,8.4  -- Beneath Nordrassil (55)
accept 8729 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- The Wrath of Neptulon (60)
fly 1447 11.9,77.6 |from 1446 51.0,29.3 |npc Jarrodenus  -- flight master Bera Stonehammer
complete 6822 |at 1447 11.9,78.1 |mobs Molten Giant;Firelord;Ancient Core Hound;Lava Surger |group dungeon  -- The Molten Core (60)
turnin 6822 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- The Molten Core (60)
accept 6823 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- Agent of Hydraxis (60)
complete 6823 |at 1447 11.9,78.1 |mobs Azshara Sentinel |group chain  -- Agent of Hydraxis (60)
turnin 6823 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- Agent of Hydraxis (60)
accept 6824 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Hands of the Enemy (60)
complete 6824 |at 1447 11.9,78.1 |mobs Azshara Sentinel |group dungeon  -- Hands of the Enemy (60)
complete 8729 |at 1447 11.9,78.1 |item 21136 |mobs Azshara Sentinel |group chain  -- The Wrath of Neptulon (60)
accept 8575 |npc Spirit of Azuregos |at 1447 53.0,81.7 |group chain  -- Azuregos's Magical Ledger (60)
turnin 6824 |npc Duke Hydraxis |at 1447 79.3,73.7 |group dungeon  -- Hands of the Enemy (60)
accept 7486 |npc Duke Hydraxis |at 1447 79.3,73.7 |group chain  -- A Hero's Reward (60)
turnin 7486 |npc Hydraxis' Coffer |at 1447 79.2,74.9 |group chain  -- A Hero's Reward (60)
fly 1446 51.0,29.3 |from 1447 11.9,77.6 |npc Tanaris (Bera Stonehammer)  -- flight master Jarrodenus
turnin 8729 |npc Anachronos |at 1446 65.3,50.0 |group chain  -- The Wrath of Neptulon (60)
turnin 8575 |npc Narain Soothfancy |at 1446 65.2,18.6 |group chain  -- Azuregos's Magical Ledger (60)
]]}
