-- DRAFT Westfall (Horde) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "westfall-h", title = "Westfall (16-20)", faction = "Horde", zone = "Westfall",
  levels = { 16, 20 },
  steps = [[
accept 103 |npc Captain Grayson |at 1436 30.0,86.0 |lvl 10  -- Keeper of the Flame (16)
accept 152 |npc Captain Grayson |at 1436 30.0,86.0 |value mid |lvl 10  -- The Coast Isn't Clear (19)
accept 104 |npc Captain Grayson |at 1436 30.0,86.0 |lvl 15  -- The Coastal Menace (20)
complete 152 |obj Murloc Tidehunter |at 1436 34.9,84.5 |areas 26.8,72.1:14;34.9,84.5:8 |mobs Murloc Tidehunter |value mid  -- The Coast Isn't Clear (19)
complete 103 |at 1436 38.1,50.8 |areas 53.0,23.1:29;38.1,50.8:26;63.6,61.4:16;47.3,67.0:14 |mobs Foe Reaper 4000@Flask of Oil;Harvest Watcher@Flask of Oil;Harvest Golem@Flask of Oil;Rusty Harvest Golem@Flask of Oil  -- Keeper of the Flame (16)
accept 136 |at 1436 32.4,26.6 |mobs Murloc Hunter;Murloc Warrior;Murloc Netter;Murloc Oracle |note Starts from the item Captain Sander's Treasure Map, found on Murloc Coastrunner, Murloc Tidehunter, Murloc Warrior. Hand it in to Captain's Footlocker |startitem 1357 |loose |lvl 10  -- Captain Sander's Hidden Treasure (16)
turnin 136 |npc Captain's Footlocker |at 1436 25.9,47.8  -- Captain Sander's Hidden Treasure (16)
accept 138 |npc Captain's Footlocker |at 1436 25.9,47.8 |lvl 10 |preany 136  -- Captain Sander's Hidden Treasure (16)
complete 152 |obj Murloc Warrior |at 1436 25.0,48.9 |areas 28.4,33.0:16;25.0,48.9:9 |mobs Murloc Warrior |value mid  -- The Coast Isn't Clear (19)
turnin 138 |npc Broken Barrel |at 1436 40.5,47.8  -- Captain Sander's Hidden Treasure (16)
accept 139 |npc Broken Barrel |at 1436 40.5,47.8 |lvl 10 |preany 138  -- Captain Sander's Hidden Treasure (16)
complete 139 |item 1361  -- Captain Sander's Hidden Treasure (16)
turnin 139 |npc Old Jug |at 1436 40.6,17.0  -- Captain Sander's Hidden Treasure (16)
accept 140 |npc Old Jug |at 1436 40.6,17.0 |lvl 10 |preany 139  -- Captain Sander's Hidden Treasure (16)
complete 152 |obj Murloc Coastrunner |at 1436 47.4,9.4 |mobs Murloc Coastrunner |value mid  -- The Coast Isn't Clear (19)
complete 140 |item 1362  -- Captain Sander's Hidden Treasure (16)
turnin 140 |npc Locked Chest |at 1436 26.0,16.9  -- Captain Sander's Hidden Treasure (16)
complete 152 |obj Murloc Oracle |at 1436 27.0,55.3 |areas 27.0,55.3:12;27.1,72.7:11 |mobs Murloc Oracle |value mid  -- The Coast Isn't Clear (19)
complete 104 |at 1436 29.3,76.0 |mobs Old Murk-Eye@Scale of Old Murk-Eye  -- The Coastal Menace (20)
turnin 104 |npc Captain Grayson |at 1436 30.0,86.0  -- The Coastal Menace (20)
turnin 152 |npc Captain Grayson |at 1436 30.0,86.0 |value mid  -- The Coast Isn't Clear (19)
turnin 103 |npc Captain Grayson |at 1436 30.0,86.0  -- Keeper of the Flame (16)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   96337  More Valuable Than Gold (53)
