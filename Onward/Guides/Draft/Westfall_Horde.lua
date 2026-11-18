-- DRAFT Westfall (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "westfall-h", title = "Westfall (16-20)", faction = "Horde", zone = "Westfall",
  levels = { 16, 20 },
  steps = [[
accept 103 |npc Captain Grayson |at 1436 30.0,86.0 |value mid |lvl 10  -- Keeper of the Flame (16)
accept 104 |npc Captain Grayson |at 1436 30.0,86.0 |lvl 15  -- The Coastal Menace (20)
accept 152 |npc Captain Grayson |at 1436 30.0,86.0 |lvl 10  -- The Coast Isn't Clear (19)
complete 103 |at 1436 46.9,35.5 |mobs Foe Reaper 4000@Flask of Oil;Harvest Watcher@Flask of Oil;Harvest Golem@Flask of Oil;Rusty Harvest Golem@Flask of Oil |value mid  -- Keeper of the Flame (16)
accept 136 |at 1436 32.4,26.6 |note Starts from Captain Sander's Treasure Map |lvl 10  -- Captain Sander's Hidden Treasure (16)
turnin 136 |npc Captain's Footlocker |at 1436 25.9,47.8  -- Captain Sander's Hidden Treasure (16)
accept 138 |npc Captain's Footlocker |at 1436 25.9,47.8 |lvl 10 |preany 136  -- Captain Sander's Hidden Treasure (16)
complete 152 |at 1436 27.4,52.5 |mobs Murloc Coastrunner;Murloc Warrior;Murloc Tidehunter;Murloc Oracle  -- The Coast Isn't Clear (19)
complete 104 |at 1436 29.3,76.0 |mobs Old Murk-Eye@Scale of Old Murk-Eye  -- The Coastal Menace (20)
turnin 103 |npc Captain Grayson |at 1436 30.0,86.0 |value mid  -- Keeper of the Flame (16)
turnin 152 |npc Captain Grayson |at 1436 30.0,86.0  -- The Coast Isn't Clear (19)
turnin 104 |npc Captain Grayson |at 1436 30.0,86.0  -- The Coastal Menace (20)
turnin 138 |npc Broken Barrel |at 1436 40.5,47.8  -- Captain Sander's Hidden Treasure (16)
accept 139 |npc Broken Barrel |at 1436 40.5,47.8 |lvl 10 |preany 138  -- Captain Sander's Hidden Treasure (16)
turnin 139 |npc Old Jug |at 1436 40.6,17.0  -- Captain Sander's Hidden Treasure (16)
accept 140 |npc Old Jug |at 1436 40.6,17.0 |lvl 10 |preany 139  -- Captain Sander's Hidden Treasure (16)
turnin 140 |npc Locked Chest |at 1436 26.0,16.9  -- Captain Sander's Hidden Treasure (16)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   96337  More Valuable Than Gold (53)
