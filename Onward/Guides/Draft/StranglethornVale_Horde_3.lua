-- DRAFT Stranglethorn Vale (Horde) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stranglethorn-vale-h-3", title = "Stranglethorn Vale (50-55)", faction = "Horde", zone = "Stranglethorn Vale",
  levels = { 50, 55 },
  steps = [[
accept 580 |npc Whiskey Slim |at 1434 27.1,77.5  -- Whiskey Slim's Lost Grog (50)
accept 8552 |at 1434 23.2,72.1 |note Starts from Monogrammed Sash  -- The Monogrammed Sash (50)
turnin 8552 |npc Captain Hecklebury Smotts |at 1434 26.7,73.6  -- The Monogrammed Sash (50)
accept 7810 |at 1434 30.5,47.9 |note Starts from Arena Master  -- Arena Master (55)
accept 615  -- The Captain's Cutlass (51)
turnin 7810 |npc Short John Mithril |at 1434 29.6,47.4  -- Arena Master (55)
turnin 615  -- The Captain's Cutlass (51)
accept 618 |value mid |group elite  -- Facing Negolash (50)
accept 630 |npc Princess Poobah |at 1434 38.5,80.6 |group elite  -- Message in a Bottle (51)
complete 630 |at 1434 41.0,83.9 |mobs King Mukla |group elite  -- Message in a Bottle (51)
turnin 630 |npc Princess Poobah |at 1434 38.5,80.6 |group elite  -- Message in a Bottle (51)
complete 618 |at 1434 32.5,81.6 |mobs Negolash |value mid |group elite  -- Facing Negolash (50)
turnin 618 |value mid |group elite  -- Facing Negolash (50)
fly 1445 35.6,31.9 |from 1434 26.9,77.1 |npc Dustwallow Marsh (Shardi)  -- flight master Gringer
accept 626 |npc Musty Scroll |at 1445 31.1,66.1  -- Cortello's Riddle (51)
fly 1425 81.7,81.8 |from 1445 35.6,31.9 |npc The Hinterlands (Gorkas)  -- flight master Shardi
turnin 626 |npc Cortello's Treasure |at 1425 80.8,46.8  -- Cortello's Riddle (51)
complete 580 |at 1425 77.4,70.3  -- Whiskey Slim's Lost Grog (50)
fly 1434 26.9,77.1 |from 1425 81.7,81.8 |npc Gringer  -- flight master Gorkas
accept 3721 |npc Oglethorpe Obnoticus |at 1434 28.4,76.3  -- An OOX of Your Own (50)
turnin 3721 |npc Oglethorpe Obnoticus |at 1434 28.4,76.3  -- An OOX of Your Own (50)
turnin 580 |npc Whiskey Slim |at 1434 27.1,77.5  -- Whiskey Slim's Lost Grog (50)
accept 9272 |npc Fleet Master Firallon |at 1434 30.6,90.6  -- Dressing the Part (55)
turnin 9272 |npc Fleet Master Firallon |at 1434 30.6,90.6  -- Dressing the Part (55)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   3626  Return to the Blasted Lands (58)
--   1036  Avast Ye, Scallywag (60)
--   4621  Avast Ye, Admiral! (60)
--   83934  Show Me the Money! (60)
