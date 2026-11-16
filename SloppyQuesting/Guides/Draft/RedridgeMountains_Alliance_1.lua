-- DRAFT Redridge Mountains (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /sq rec running and fix what feels wrong. Coordinates are spawn medoids.
SloppyQuesting:RegisterGuide{
  id = "redridge-mountains-a-1", title = "Redridge Mountains (14-20)", faction = "Alliance", zone = "Redridge Mountains",
  levels = { 14, 20 },
  next = "redridge-mountains-a-2",
  steps = [[
accept 116 |npc Barkeep Daniels |at 1433 21.4,44.0  -- Dry Times (15)
accept 129 |npc Darcy |at 1433 21.5,44.3  -- A Free Lunch (15)
accept 120 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Stormwind (14)
accept 118 |npc Verner Osgood |at 1433 25.9,47.3  -- The Price of Shoes (18)
accept 3741 |npc Shawn |at 1433 24.2,53.6  -- Hilary's Necklace (15)
complete 3741 |at 1433 24.4,53.7  -- Hilary's Necklace (15)
turnin 3741 |npc Hilary |at 1433 24.1,53.6  -- Hilary's Necklace (15)
turnin 129 |npc Guard Parker |at 1433 10.4,71.3  -- A Free Lunch (15)
accept 244 |npc Guard Parker |at 1433 10.4,71.3  -- Encroaching Gnolls (16)
accept 130 |npc Guard Parker |at 1433 10.4,71.3  -- Visit the Herbalist (15)
fly 1453 71.3,72.2 |from 1433 25.5,59.4 |npc Stormwind City (Dungar Longdrink)  -- flight master Ariena Stormfeather
turnin 120 |npc General Marcus Jonathan |at 1453 69.2,82.7  -- Messenger to Stormwind (14)
accept 121 |npc General Marcus Jonathan |at 1453 69.2,82.7  -- Messenger to Stormwind (14)
fly 1433 25.5,59.4 |from 1453 71.3,72.2 |npc Ariena Stormfeather  -- flight master Dungar Longdrink
turnin 244 |npc Deputy Feldon |at 1433 25.6,60.0  -- Encroaching Gnolls (16)
accept 98407 |npc Deputy Feldon |at 1433 25.6,60.0 |value mid  -- Show of Force (17)
accept 246 |npc Deputy Feldon |at 1433 25.6,60.0 |value mid  -- Assessing the Threat (17)
turnin 118 |npc Smith Argus |at 1429 41.7,65.5  -- The Price of Shoes (18)
accept 119 |npc Smith Argus |at 1429 41.7,65.5  -- Return to Verner (18)
complete 98407 |at 1433 10.4,66.3 |mobs Redridge Thrasher |value mid  -- Show of Force (17)
complete 246 |at 1433 26.2,81.1 |mobs Redridge Mongrel;Redridge Poacher |value mid  -- Assessing the Threat (17)
complete 122 |at 1433 31.5,65.3 |mobs Black Dragon Whelp;Snarlflare  -- Underbelly Scales (18)
turnin 246 |npc Deputy Feldon |at 1433 25.6,60.0 |value mid  -- Assessing the Threat (17)
turnin 98407 |npc Deputy Feldon |at 1433 25.6,60.0 |value mid  -- Show of Force (17)
turnin 119 |npc Verner Osgood |at 1433 25.9,47.3  -- Return to Verner (18)
accept 124 |npc Verner Osgood |at 1433 25.9,47.3 |value mid  -- A Baying of Gnolls (20)
accept 122 |npc Verner Osgood |at 1433 25.9,47.3  -- Underbelly Scales (18)
turnin 122 |npc Verner Osgood |at 1433 25.9,47.3  -- Underbelly Scales (18)
complete 116  -- Dry Times (15)
turnin 121 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Stormwind (14)
accept 143 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Westfall (14)
fly 1436 56.5,52.6 |from 1433 25.5,59.4 |npc Westfall (Thor)  -- flight master Ariena Stormfeather
turnin 143 |npc Gryan Stoutmantle |at 1436 56.3,47.5  -- Messenger to Westfall (14)
accept 144 |npc Gryan Stoutmantle |at 1436 56.3,47.5  -- Messenger to Westfall (14)
fly 1433 25.5,59.4 |from 1436 56.5,52.6 |npc Ariena Stormfeather  -- flight master Thor
turnin 130 |npc Martie Jainrose |at 1433 16.8,46.3  -- Visit the Herbalist (15)
accept 131 |npc Martie Jainrose |at 1433 16.8,46.3  -- Delivering Daffodils (15)
accept 92 |npc Chef Breanna |at 1433 17.6,43.8  -- Redridge Goulash (18)
turnin 116 |npc Barkeep Daniels |at 1433 21.4,44.0  -- Dry Times (15)
turnin 131 |npc Darcy |at 1433 21.5,44.3  -- Delivering Daffodils (15)
turnin 144 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Westfall (14)
accept 145 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Darkshire (18)
fly 1431 77.5,44.3 |from 1433 25.5,59.4 |npc Duskwood (Felicia Maline)  -- flight master Ariena Stormfeather
turnin 145 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4  -- Messenger to Darkshire (18)
accept 146 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4  -- Messenger to Darkshire (18)
fly 1433 25.5,59.4 |from 1431 77.5,44.3 |npc Ariena Stormfeather  -- flight master Felicia Maline
turnin 146 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Darkshire (18)
accept 150 |npc Dockmaster Baren |at 1433 22.6,47.4  -- Murloc Poachers (20)
accept 125 |npc Foreman Oslow |at 1433 27.1,48.6  -- The Lost Tools (16)
accept 89 |npc Foreman Oslow |at 1433 27.1,48.6  -- The Everstill Bridge (20)
complete 125 |at 1433 36.4,54.7  -- The Lost Tools (16)
complete 150 |at 1433 46.3,56.3 |mobs Murloc Flesheater;Murloc Minor Tidecaller;Murloc Tidecaller;Murloc Scout  -- Murloc Poachers (20)
complete 92 |at 1433 47.5,42.1 |mobs Greater Tarantula;Great Goretusk;Tarantula;Dire Condor  -- Redridge Goulash (18)
complete 124 |at 1433 23.0,28.9 |mobs Redridge Brute;Redridge Mystic |value mid  -- A Baying of Gnolls (20)
complete 89 |at 1433 22.4,27.4 |mobs Redridge Basher;Redridge Mystic;Redridge Brute;Redridge Drudger  -- The Everstill Bridge (20)
turnin 92 |npc Chef Breanna |at 1433 17.6,43.8  -- Redridge Goulash (18)
turnin 150 |npc Dockmaster Baren |at 1433 22.6,47.4  -- Murloc Poachers (20)
turnin 124 |npc Verner Osgood |at 1433 25.9,47.3 |value mid  -- A Baying of Gnolls (20)
turnin 89 |npc Foreman Oslow |at 1433 27.1,48.6  -- The Everstill Bridge (20)
turnin 125 |npc Foreman Oslow |at 1433 27.1,48.6  -- The Lost Tools (16)
]]}
