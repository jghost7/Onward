-- DRAFT Redridge Mountains (Alliance) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "redridge-mountains-a-1", title = "Redridge Mountains (14-20)", faction = "Alliance", zone = "Redridge Mountains",
  levels = { 14, 20 },
  next = "redridge-mountains-a-2",
  steps = [[
home |npc Innkeeper Brianna |at 1433 21.9,44.8  -- set your hearthstone at the inn
accept 116 |npc Barkeep Daniels |at 1433 21.4,44.0 |lvl 12  -- Dry Times (15)
complete 116  -- Dry Times (15)
turnin 116 |npc Barkeep Daniels |at 1433 21.4,44.0  -- Dry Times (15)
accept 129 |npc Darcy |at 1433 21.5,44.3 |lvl 12  -- A Free Lunch (15)
accept 150 |npc Dockmaster Baren |at 1433 22.6,47.4 |lvl 20  -- Murloc Poachers (20)
accept 120 |npc Magistrate Solomon |at 1433 24.9,44.5 |lvl 14  -- Messenger to Stormwind (14)
accept 118 |npc Verner Osgood |at 1433 25.9,47.3 |lvl 14  -- The Price of Shoes (18)
accept 125 |npc Foreman Oslow |at 1433 27.1,48.6 |lvl 15  -- The Lost Tools (16)
complete 150 |at 1433 37.1,50.5 |areas 43.6,69.4:30;37.1,50.5:27 |mobs Murloc Flesheater@Murloc Fin;Murloc Minor Tidecaller@Murloc Fin;Murloc Tidecaller@Murloc Fin;Murloc Scout@Murloc Fin  -- Murloc Poachers (20)
complete 125 |at 1433 36.4,54.7  -- The Lost Tools (16)
turnin 129 |npc Guard Parker |at 1433 10.4,71.3  -- A Free Lunch (15)
accept 244 |npc Guard Parker |at 1433 10.4,71.3 |lvl 11  -- Encroaching Gnolls (16)
accept 130 |npc Guard Parker |at 1433 10.4,71.3 |lvl 12 |preany 129  -- Visit the Herbalist (15)
turnin 118 |npc Smith Argus |at 1429 41.7,65.5  -- The Price of Shoes (18)
accept 119 |npc Smith Argus |at 1429 41.7,65.5 |lvl 13 |preany 118  -- Return to Verner (18)
turnin 120 |npc General Marcus Jonathan |at 1453 69.2,82.7  -- Messenger to Stormwind (14)
accept 121 |npc General Marcus Jonathan |at 1453 69.2,82.7 |lvl 14 |preany 120  -- Messenger to Stormwind (14)
fly 1433 25.5,59.4 |from 1453 71.3,72.2 |npc Ariena Stormfeather  -- flight master Dungar Longdrink
accept 92 |npc Chef Breanna |at 1433 17.6,43.8 |value mid |lvl 15  -- Redridge Goulash (18)
turnin 121 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Stormwind (14)
accept 143 |npc Magistrate Solomon |at 1433 24.9,44.5 |lvl 14 |preany 121  -- Messenger to Westfall (14)
turnin 119 |npc Verner Osgood |at 1433 25.9,47.3  -- Return to Verner (18)
accept 122 |npc Verner Osgood |at 1433 25.9,47.3 |lvl 14 |preany 119  -- Underbelly Scales (18)
accept 124 |npc Verner Osgood |at 1433 25.9,47.3 |lvl 15 |preany 119  -- A Baying of Gnolls (20)
turnin 125 |npc Foreman Oslow |at 1433 27.1,48.6  -- The Lost Tools (16)
accept 89 |npc Foreman Oslow |at 1433 27.1,48.6 |lvl 15 |preany 125  -- The Everstill Bridge (20)
complete 92 |at 1433 47.8,42.7 |mobs Greater Tarantula@Crisp Spider Meat;Great Goretusk@Great Goretusk Snout;Tarantula@Crisp Spider Meat;Dire Condor@Tough Condor Meat |value mid  -- Redridge Goulash (18)
complete 122 |at 1433 39.1,33.3 |areas 29.8,68.4:13;39.1,33.3:11;48.7,76.2:8 |mobs Black Dragon Whelp@Underbelly Whelp Scale;Snarlflare@Underbelly Whelp Scale  -- Underbelly Scales (18)
complete 89 |at 1433 22.4,27.4 |mobs Redridge Basher@Iron Pike;Redridge Mystic@Iron Pike;Redridge Brute@Iron Pike;Redridge Drudger@Iron Pike  -- The Everstill Bridge (20)
complete 124 |at 1433 19.0,32.6 |areas 19.0,32.6:19;33.8,31.8:11 |mobs Redridge Brute;Redridge Mystic  -- A Baying of Gnolls (20)
fly 1436 56.5,52.6 |from 1433 25.5,59.4 |npc Westfall (Thor)  -- flight master Ariena Stormfeather
turnin 143 |npc Gryan Stoutmantle |at 1436 56.3,47.5  -- Messenger to Westfall (14)
accept 144 |npc Gryan Stoutmantle |at 1436 56.3,47.5 |lvl 14 |preany 143  -- Messenger to Westfall (14)
fly 1433 25.5,59.4 |from 1436 56.5,52.6 |npc Ariena Stormfeather  -- flight master Thor
turnin 130 |npc Martie Jainrose |at 1433 16.8,46.3  -- Visit the Herbalist (15)
accept 131 |npc Martie Jainrose |at 1433 16.8,46.3 |lvl 12 |preany 130  -- Delivering Daffodils (15)
turnin 92 |npc Chef Breanna |at 1433 17.6,43.8 |value mid  -- Redridge Goulash (18)
turnin 131 |npc Darcy |at 1433 21.5,44.3  -- Delivering Daffodils (15)
turnin 144 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Westfall (14)
accept 145 |npc Magistrate Solomon |at 1433 24.9,44.5 |lvl 18 |preany 144  -- Messenger to Darkshire (18)
turnin 150 |npc Dockmaster Baren |at 1433 22.6,47.4  -- Murloc Poachers (20)
accept 3741 |npc Shawn |at 1433 24.2,53.6 |lvl 12  -- Hilary's Necklace (15)
complete 3741 |at 1433 24.4,53.7  -- Hilary's Necklace (15)
turnin 3741 |npc Hilary |at 1433 24.1,53.6  -- Hilary's Necklace (15)
turnin 244 |npc Deputy Feldon |at 1433 25.6,60.0  -- Encroaching Gnolls (16)
accept 246 |npc Deputy Feldon |at 1433 25.6,60.0 |value mid |lvl 11 |preany 244  -- Assessing the Threat (17)
accept 98407 |npc Deputy Feldon |at 1433 25.6,60.0 |lvl 11 |preany 244  -- Show of Force (17)
fly 1431 77.5,44.3 |from 1433 25.5,59.4 |npc Duskwood (Felicia Maline)  -- flight master Ariena Stormfeather
turnin 145 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4  -- Messenger to Darkshire (18)
accept 146 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4 |lvl 18 |preany 145  -- Messenger to Darkshire (18)
fly 1433 25.5,59.4 |from 1431 77.5,44.3 |npc Ariena Stormfeather  -- flight master Felicia Maline
complete 98407 |at 1433 10.4,66.3 |mobs Redridge Thrasher@Spiked Collar  -- Show of Force (17)
complete 246 |at 1433 10.2,63.9 |areas 26.9,82.7:20;10.2,63.9:8;38.2,71.3:7 |mobs Redridge Mongrel;Redridge Poacher |value mid  -- Assessing the Threat (17)
turnin 246 |npc Deputy Feldon |at 1433 25.6,60.0 |value mid  -- Assessing the Threat (17)
turnin 98407 |npc Deputy Feldon |at 1433 25.6,60.0  -- Show of Force (17)
turnin 89 |npc Foreman Oslow |at 1433 27.1,48.6  -- The Everstill Bridge (20)
turnin 124 |npc Verner Osgood |at 1433 25.9,47.3  -- A Baying of Gnolls (20)
turnin 122 |npc Verner Osgood |at 1433 25.9,47.3  -- Underbelly Scales (18)
turnin 146 |npc Magistrate Solomon |at 1433 24.9,44.5  -- Messenger to Darkshire (18)
]]}
