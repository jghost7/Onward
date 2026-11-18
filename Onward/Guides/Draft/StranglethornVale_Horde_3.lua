-- DRAFT Stranglethorn Vale (Horde) generated 2026-11-18 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "stranglethorn-vale-h-3", title = "Stranglethorn Vale (50-55)", faction = "Horde", zone = "Stranglethorn Vale",
  levels = { 50, 55 },
  steps = [[
home |npc Innkeeper Skindle |at 1434 27.0,77.3  -- set your hearthstone at the inn
accept 580 |npc Whiskey Slim |at 1434 27.1,77.5 |lvl 40  -- Whiskey Slim's Lost Grog (50)
accept 8552 |at 1434 23.2,72.1 |note Starts from Monogrammed Sash |startitem 3985 |lvl 40  -- The Monogrammed Sash (50)
turnin 8552 |npc Captain Hecklebury Smotts |at 1434 26.7,73.6  -- The Monogrammed Sash (50)
accept 7810 |at 1434 30.5,47.9 |note Starts from Arena Master |startitem 18706  -- Arena Master (55)
accept 615 |note No quest giver on record: it most likely starts from an item you loot or find in this zone |loose |lvl 35 |preany 8552  -- The Captain's Cutlass (51)
turnin 615  -- The Captain's Cutlass (51)
turnin 7810 |npc Short John Mithril |at 1434 29.6,47.4  -- Arena Master (55)
accept 618 |note No quest giver on record: it most likely starts from an item you loot or find in this zone |loose |value mid |group elite |lvl 40 |preany 615,8553  -- Facing Negolash (50)
goto 1434 31.3,29.2 15 |note Take the zeppelin to Orgrimmar  -- zeppelin Grom'gol to Orgrimmar
accept 626 |npc Musty Scroll |at 1445 31.1,66.1 |lvl 35 |preany 625  -- Cortello's Riddle (51)
fly 1413 63.1,37.2 |from 1445 35.6,31.9 |npc The Barrens (Bragok)  -- flight master Shardi
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1425 81.7,81.8 |from 1434 26.9,77.1 |npc The Hinterlands (Gorkas)  -- flight master Gringer
turnin 626 |npc Cortello's Treasure |at 1425 80.8,46.8  -- Cortello's Riddle (51)
complete 580 |at 1425 77.4,70.3  -- Whiskey Slim's Lost Grog (50)
fly 1434 26.9,77.1 |from 1425 81.7,81.8 |npc Gringer  -- flight master Gorkas
turnin 580 |npc Whiskey Slim |at 1434 27.1,77.5  -- Whiskey Slim's Lost Grog (50)
accept 3721 |npc Oglethorpe Obnoticus |at 1434 28.4,76.3 |lvl 45 |pre 648,836,2767  -- An OOX of Your Own (50)
turnin 3721 |npc Oglethorpe Obnoticus |at 1434 28.4,76.3  -- An OOX of Your Own (50)
complete 618 |at 1434 32.5,81.6 |mobs Negolash@Smotts' Cutlass |value mid |group elite  -- Facing Negolash (50)
turnin 618 |value mid |group elite  -- Facing Negolash (50)
accept 630 |npc Princess Poobah |at 1434 38.5,80.6 |group elite |lvl 45 |preany 594  -- Message in a Bottle (51)
complete 630 |at 1434 41.0,83.9 |mobs King Mukla@Shackle Key |group elite  -- Message in a Bottle (51)
turnin 630 |npc Princess Poobah |at 1434 38.5,80.6 |group elite  -- Message in a Bottle (51)
accept 9272 |npc Fleet Master Firallon |at 1434 30.6,90.6 |lvl 49  -- Dressing the Part (55)
turnin 9272 |npc Fleet Master Firallon |at 1434 30.6,90.6  -- Dressing the Part (55)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   3626  Return to the Blasted Lands (58)
--   1036  Avast Ye, Scallywag (60)
--   4621  Avast Ye, Admiral! (60)
--   83934  Show Me the Money! (60)
--   96076  In Demand - Ancient Elven Curiosities (60)
