-- DRAFT Swamp of Sorrows (Horde) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "swamp-of-sorrows-h-2", title = "Swamp of Sorrows (43-55)", faction = "Horde", zone = "Swamp of Sorrows",
  levels = { 43, 55 },
  steps = [[
accept 699 |npc Tok'Kar |at 1435 81.3,81.0 |lvl 35 |preany 698  -- Lack of Surplus (42)
complete 699 |at 1435 78.1,100.0 |areas 82.7,30.9:9;78.1,100.0:5;78.0,14.6:4 |mobs Sawtooth Snapper@Sawtooth Snapper Claw  -- Lack of Surplus (42)
turnin 699 |npc Tok'Kar |at 1435 81.3,81.0  -- Lack of Surplus (42)
accept 1422 |npc Tok'Kar |at 1435 81.3,81.0 |lvl 35 |preany 699  -- Threat From the Sea (45)
turnin 1422 |npc Katar |at 1435 83.8,80.4  -- Threat From the Sea (45)
accept 1426 |npc Katar |at 1435 83.8,80.4 |lvl 35 |preany 1422  -- Threat From the Sea (43)
complete 1426 |obj Marsh Murloc |at 1435 85.9,85.0 |mobs Marsh Murloc  -- Threat From the Sea (43)
complete 1426 |obj Marsh Inkspewer |at 1435 64.3,80.6 |areas 83.9,90.0:12;93.2,66.8:10;64.3,80.6:7 |mobs Marsh Inkspewer  -- Threat From the Sea (43)
complete 1426 |obj Marsh Flesheater |at 1435 63.2,84.9 |mobs Marsh Flesheater  -- Threat From the Sea (43)
home |npc Innkeeper Karakul |at 1435 45.2,56.7  -- set your hearthstone at the inn
accept 1430 |npc Dar |at 1435 44.7,57.2 |value mid |lvl 35  -- Fresh Meat (44)
accept 1424 |npc Fel'zerul |at 1435 47.9,54.8 |group elite |lvl 38  -- Pool of Tears (43)
complete 1424 |at 1435 72.5,53.1 |group elite  -- Pool of Tears (43)
complete 1430 |at 1435 96.2,69.4 |areas 91.4,91.4:76;96.2,69.4:71;96.2,37.2:67;90.6,9.4:62 |mobs Monstrous Crawler@Monstrous Crawler Leg |value mid  -- Fresh Meat (44)
turnin 1426 |npc Katar |at 1435 83.8,80.4  -- Threat From the Sea (43)
accept 1427 |npc Katar |at 1435 83.8,80.4 |lvl 35 |preany 1426  -- Threat From the Sea (43)
turnin 1427 |npc Tok'Kar |at 1435 81.3,81.0  -- Threat From the Sea (43)
accept 1428 |npc Katar |at 1435 83.8,80.4 |value mid |lvl 35 |preany 1427  -- Continued Threat (45)
complete 1428 |obj Marsh Flesheater |at 1435 63.2,84.9 |mobs Marsh Flesheater |value mid  -- Continued Threat (45)
complete 1428 |obj Marsh Oracle |at 1435 63.6,86.8 |mobs Marsh Oracle |value mid  -- Continued Threat (45)
complete 1428 |obj Marsh Inkspewer |at 1435 64.3,80.6 |areas 83.9,90.0:12;93.2,66.8:10;64.3,80.6:7 |mobs Marsh Inkspewer |value mid  -- Continued Threat (45)
turnin 1428 |npc Katar |at 1435 83.8,80.4 |value mid  -- Continued Threat (45)
turnin 1424 |npc Fel'zerul |at 1435 47.9,54.8 |group elite  -- Pool of Tears (43)
accept 1429 |npc Fel'zerul |at 1435 47.9,54.8 |group chain |lvl 38 |preany 1424  -- The Atal'ai Exile (44)
accept 2622 |npc Dispatch Commander Ruag |at 1435 47.8,54.9 |lvl 45 |preany 2621  -- The Missing Orders (50)
turnin 2622 |npc Bengor |at 1435 45.0,57.4  -- The Missing Orders (50)
accept 2623 |npc Bengor |at 1435 45.0,57.4 |lvl 45 |preany 2622  -- The Swamp Talker (55)
turnin 1430 |npc Dar |at 1435 44.7,57.2 |value mid  -- Fresh Meat (44)
accept 93679 |npc Magtoor |at 1435 26.0,31.4 |preany 93678  -- Visions of Another (55)
complete 93679  -- Visions of Another (55)
turnin 93679 |npc Magtoor |at 1435 26.0,31.4  -- Visions of Another (55)
accept 93684 |npc Magtoor |at 1435 26.0,31.4 |preany 93679  -- The Found One (55)
accept 3374 |at 1435 13.7,71.7 |mobs Itharius |note Starts from the item Oathstone of Ysera's Dragonflight, found on Itharius. Hand it in to Itharius |startitem 10589 |loose |group chain |lvl 48 |preany 3373  -- The Essence of Eranikus (55)
complete 2623 |at 1435 63.6,86.4 |mobs Swamp Talker@Warchief's Orders  -- The Swamp Talker (55)
complete 3374 |at 1435 39.1,47.3 |item 10589 |mobs Swamp Jaguar;Swamp Talker |group chain  -- The Essence of Eranikus (55)
turnin 2623 |npc Fallen Hero of the Horde |at 1435 34.3,66.1  -- The Swamp Talker (55)
turnin 3374 |npc Itharius |at 1435 13.7,71.7 |group chain  -- The Essence of Eranikus (55)
accept 3512 |npc Itharius |at 1435 13.7,71.7 |group chain |lvl 48 |preany 3374  -- In Eranikus' Own Words (55)
turnin 93684 |npc Kum'isha the Collector |at 1419 52.0,35.6  -- The Found One (55)
turnin 1429 |npc Atal'ai Exile |at 1425 33.8,75.2 |group chain  -- The Atal'ai Exile (44)
turnin 3512 |npc Umbranse the Spiritspeaker |at 1452 67.8,27.4 |group chain  -- In Eranikus' Own Words (55)
]]}
