-- DRAFT Thousand Needles (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "thousand-needles-a-2", title = "Thousand Needles (41-46)", faction = "Alliance", zone = "Thousand Needles",
  levels = { 41, 46 },
  steps = [[
accept 1118 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Back to Booty Bay (43)
accept 1187 |npc Razzeric |at 1441 80.3,76.1  -- Razzeric's Tweaking (41)
accept 1190 |npc Pozzik |at 1441 80.2,75.9  -- Keeping Pace (41)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
accept 1108 |npc Martek the Exiled |at 1418 42.2,52.7 |value mid  -- Indurium (39)
complete 1108 |at 1418 50.9,67.2 |value mid  -- Indurium (39)
turnin 1108 |npc Martek the Exiled |at 1418 42.2,52.7 |value mid  -- Indurium (39)
turnin 1118 |npc Crank Fizzlebub |at 1434 27.1,77.2  -- Back to Booty Bay (43)
accept 1119 |npc Crank Fizzlebub |at 1434 27.1,77.2  -- Zanzil's Mixture and a Fool's Stout (44)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1445 67.5,51.3 |from 1413 63.1,37.2 |npc Dustwallow Marsh (Baldruc)  -- flight master Bragok
complete 1187 |at 1445 54.1,56.5  -- Razzeric's Tweaking (41)
goto 1445 71.6,56.4 15 |note Take the boat to Menethil Harbor  -- boat Theramore to Menethil Harbor
fly 1455 55.5,47.7 |from 1437 9.5,59.7 |npc Ironforge (Gryth Thurden)  -- flight master Shellei Brondir
accept 2769 |npc Klockmort Spannerspan |at 1455 67.9,46.1  -- The Brassbolts Brothers (46)
fly 1434 27.5,77.8 |from 1455 55.5,47.7 |npc Stranglethorn Vale (Gyll)  -- flight master Gryth Thurden
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
turnin 1190 |npc Rizzle's Unguarded Plans |at 1441 77.2,77.4  -- Keeping Pace (41)
accept 1194 |npc Rizzle's Unguarded Plans |at 1441 77.2,77.4  -- Rizzle's Schematics (41)
accept 1122 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Report Back to Fizzlebub (44)
turnin 1119 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Zanzil's Mixture and a Fool's Stout (44)
accept 1120 |npc Kravel Koalbeard |at 1441 77.8,77.3  -- Get the Gnomes Drunk (44)
turnin 2769 |npc Wizzle Brassbolts |at 1441 78.1,77.1  -- The Brassbolts Brothers (46)
turnin 1187 |npc Razzeric |at 1441 80.3,76.1  -- Razzeric's Tweaking (41)
accept 1188 |npc Razzeric |at 1441 80.3,76.1  -- Safety First (41)
turnin 1120 |npc Gnome Pit Boss |at 1441 77.6,76.9  -- Get the Gnomes Drunk (44)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 1122 |npc Crank Fizzlebub |at 1434 27.1,77.2  -- Report Back to Fizzlebub (44)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1446 51.0,29.3 |from 1413 63.1,37.2 |npc Tanaris (Bera Stonehammer)  -- flight master Bragok
turnin 1188 |npc Shreev |at 1446 51.0,27.2  -- Safety First (41)
accept 1189 |npc Shreev |at 1446 51.0,27.2  -- Safety First (41)
turnin 1194 |npc Pozzik |at 1441 80.2,75.9  -- Rizzle's Schematics (41)
turnin 1189 |npc Razzeric |at 1441 80.3,76.1  -- Safety First (41)
]]}
