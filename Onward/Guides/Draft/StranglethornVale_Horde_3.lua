-- DRAFT Stranglethorn Vale (Horde) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stranglethorn-vale-h-3", title = "Stranglethorn Vale (50-55)", faction = "Horde", zone = "Stranglethorn Vale",
  levels = { 50, 55 },
  steps = [[
home |npc Innkeeper Skindle |at 1434 27.0,77.3  -- set your hearthstone at the inn
accept 580 |npc Whiskey Slim |at 1434 27.1,77.5 |lvl 40  -- Whiskey Slim's Lost Grog (50)
accept 3721 |npc Oglethorpe Obnoticus |at 1434 28.4,76.3 |lvl 45 |pre 648,836,2767  -- An OOX of Your Own (50)
turnin 3721 |npc Oglethorpe Obnoticus |at 1434 28.4,76.3  -- An OOX of Your Own (50)
accept 96379 |npc Rix Xizzix |at 1434 28.5,75.8 |lvl 48  -- State Secrets (53)
turnin 96379 |npc Rix Xizzix |at 1434 28.5,75.8  -- State Secrets (53)
accept 8552 |at 1434 23.2,72.1 |mobs Mok'rash |note Starts from the item Monogrammed Sash, found on Mok'rash. Hand it in to Captain Hecklebury Smotts |startitem 3985 |loose |lvl 40  -- The Monogrammed Sash (50)
turnin 8552 |npc Captain Hecklebury Smotts |at 1434 26.7,73.6  -- The Monogrammed Sash (50)
accept 8553 |npc Captain Hecklebury Smotts |at 1434 26.7,73.6 |lvl 40 |preany 8552 |exclusive 615  -- The Captain's Cutlass (50)
turnin 8553 |npc Sprogger |at 1434 26.7,73.6  -- The Captain's Cutlass (50)
accept 8554 |npc Sprogger |at 1434 26.7,73.6 |value mid |group elite |lvl 40 |preany 615,8553 |exclusive 618  -- Facing Negolash (50)
accept 7810 |at 1434 30.5,47.9 |note Starts from Arena Master |startitem 18706 |value low  -- Arena Master (55)
turnin 7810 |npc Short John Mithril |at 1434 29.6,47.4 |value low  -- Arena Master (55)
accept 630 |npc Princess Poobah |at 1434 38.5,80.6 |group elite |lvl 45 |preany 594  -- Message in a Bottle (51)
complete 630 |at 1434 41.0,83.9 |mobs King Mukla@Shackle Key |group elite  -- Message in a Bottle (51)
turnin 630 |npc Princess Poobah |at 1434 38.5,80.6 |group elite  -- Message in a Bottle (51)
complete 8554 |at 1434 32.5,81.6 |mobs Negolash@Smotts' Cutlass |value mid |group elite  -- Facing Negolash (50)
turnin 8554 |npc Captain Hecklebury Smotts |at 1434 26.7,73.6 |value mid |group elite  -- Facing Negolash (50)
accept 9272 |npc Fleet Master Firallon |at 1434 30.6,90.6 |lvl 49  -- Dressing the Part (55)
turnin 9272 |npc Fleet Master Firallon |at 1434 30.6,90.6  -- Dressing the Part (55)
complete 580 |at 1425 77.4,70.3  -- Whiskey Slim's Lost Grog (50)
turnin 580 |npc Whiskey Slim |at 1434 27.1,77.5  -- Whiskey Slim's Lost Grog (50)
accept 626 |npc Musty Scroll |at 1445 31.1,66.1 |lvl 35 |preany 625  -- Cortello's Riddle (51)
complete 626  -- Cortello's Riddle (51)
turnin 626 |npc Cortello's Treasure |at 1425 80.8,46.8  -- Cortello's Riddle (51)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   3625  Enchanted Azsharite Fel Weaponry (58)
--   3626  Return to the Blasted Lands (58)
--   1036  Avast Ye, Scallywag (60)
--   4621  Avast Ye, Admiral! (60)
--   83934  Show Me the Money! (60)
--   96075  In Demand - Blackrock Legal Records (60)
--   96076  In Demand - Ancient Elven Curiosities (60)
