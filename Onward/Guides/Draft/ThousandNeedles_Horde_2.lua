-- DRAFT Thousand Needles (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "thousand-needles-h-2", title = "Thousand Needles (37-44)", faction = "Horde", zone = "Thousand Needles",
  levels = { 37, 44 },
  steps = [[
accept 1118 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Back to Booty Bay (43)
accept 1178 |npc Pozzik |at 1441 80.2,75.9  -- Goblin Sponsorship (37)
accept 94930 |npc Lost Shipping Crate |at 1441 45.3,49.2  -- Lost Shipping Crate (38)
fly 1413 63.1,37.2 |from 1441 45.1,49.1 |npc The Barrens (Bragok)  -- flight master Nyse
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 1118 |npc Crank Fizzlebub |at 1434 27.1,77.2  -- Back to Booty Bay (43)
accept 1119 |npc Crank Fizzlebub |at 1434 27.1,77.2  -- Zanzil's Mixture and a Fool's Stout (44)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
turnin 1178 |npc Gazlowe |at 1413 62.7,36.2  -- Goblin Sponsorship (37)
accept 1180 |npc Gazlowe |at 1413 62.7,36.2  -- Goblin Sponsorship (37)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1418 4.0,44.8 |from 1434 26.9,77.1 |npc Badlands (Gorrik)  -- flight master Gringer
accept 1108 |npc Martek the Exiled |at 1418 42.2,52.7  -- Indurium (39)
complete 1108 |at 1418 50.9,67.2  -- Indurium (39)
turnin 1108 |npc Martek the Exiled |at 1418 42.2,52.7  -- Indurium (39)
accept 1137 |npc Martek the Exiled |at 1418 42.2,52.7  -- News for Fizzle (38)
fly 2548 59.6,45.1 |from 1418 4.0,44.8 |npc Riverglades (Grakna)  -- flight master Gorrik
turnin 94930 |npc Friz Frazzlespark |at 2548 77.1,52.9  -- Lost Shipping Crate (38)
fly 1434 26.9,77.1 |from 2548 59.6,45.1 |npc Stranglethorn Vale (Gringer)  -- flight master Grakna
turnin 1180 |npc Wharfmaster Lozgil |at 1434 26.4,73.6  -- Goblin Sponsorship (37)
accept 1181 |npc Wharfmaster Lozgil |at 1434 26.4,73.6  -- Goblin Sponsorship (37)
turnin 1181 |npc Baron Revilgaz |at 1434 27.2,76.9  -- Goblin Sponsorship (37)
accept 1182 |npc Baron Revilgaz |at 1434 27.2,76.9  -- Goblin Sponsorship (37)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1441 45.1,49.1 |from 1413 63.1,37.2 |npc Nyse  -- flight master Bragok
turnin 1119 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Zanzil's Mixture and a Fool's Stout (44)
accept 1120 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Get the Gnomes Drunk (44)
accept 1122 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Report Back to Fizzlebub (44)
complete 1182 |at 1441 79.7,77.0 |mobs Goblin Racer;Goblin Drag Car  -- Goblin Sponsorship (37)
turnin 1137 |npc Fizzle Brassbolts |at 1441 78.1,77.1  -- News for Fizzle (38)
turnin 1120 |npc Gnome Pit Boss |at 1441 77.6,76.9  -- Get the Gnomes Drunk (44)
fly 1413 63.1,37.2 |from 1441 45.1,49.1 |npc The Barrens (Bragok)  -- flight master Nyse
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 1182 |npc Baron Revilgaz |at 1434 27.2,76.9  -- Goblin Sponsorship (37)
accept 1183 |npc Baron Revilgaz |at 1434 27.2,76.9  -- Goblin Sponsorship (37)
turnin 1122 |npc Crank Fizzlebub |at 1434 27.1,77.2  -- Report Back to Fizzlebub (44)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1441 45.1,49.1 |from 1413 63.1,37.2 |npc Nyse  -- flight master Bragok
accept 1190 |npc Pozzik |at 1441 80.2,75.9  -- Keeping Pace (41)
turnin 1183 |npc Pozzik |at 1441 80.2,75.9  -- Goblin Sponsorship (37)
accept 1186 |npc Pozzik |at 1441 80.2,75.9  -- The Eighteenth Pilot (37)
turnin 1186 |npc Razzeric |at 1441 80.3,76.1  -- The Eighteenth Pilot (37)
accept 1187 |npc Razzeric |at 1441 80.3,76.1  -- Razzeric's Tweaking (41)
turnin 1190 |npc Rizzle's Unguarded Plans |at 1441 77.2,77.4  -- Keeping Pace (41)
accept 1194 |npc Rizzle's Unguarded Plans |at 1441 77.2,77.4  -- Rizzle's Schematics (41)
fly 1445 35.6,31.9 |from 1441 45.1,49.1 |npc Dustwallow Marsh (Shardi)  -- flight master Nyse
complete 1187 |at 1445 54.1,56.5  -- Razzeric's Tweaking (41)
fly 1441 45.1,49.1 |from 1445 35.6,31.9 |npc Nyse  -- flight master Shardi
turnin 1187 |npc Razzeric |at 1441 80.3,76.1  -- Razzeric's Tweaking (41)
accept 1188 |npc Razzeric |at 1441 80.3,76.1  -- Safety First (41)
turnin 1194 |npc Pozzik |at 1441 80.2,75.9  -- Rizzle's Schematics (41)
fly 1446 51.6,25.4 |from 1441 45.1,49.1 |npc Tanaris (Bulkrek Ragefist)  -- flight master Nyse
turnin 1188 |npc Shreev |at 1446 51.0,27.2  -- Safety First (41)
accept 1189 |npc Shreev |at 1446 51.0,27.2  -- Safety First (41)
fly 1441 45.1,49.1 |from 1446 51.6,25.4 |npc Nyse  -- flight master Bulkrek Ragefist
turnin 1189 |npc Razzeric |at 1441 80.3,76.1  -- Safety First (41)
]]}
