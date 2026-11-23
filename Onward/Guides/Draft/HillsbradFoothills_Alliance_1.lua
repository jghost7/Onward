-- DRAFT Hillsbrad Foothills (Alliance) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "hillsbrad-foothills-a-1", title = "Hillsbrad Foothills (27-33)", faction = "Alliance", zone = "Hillsbrad Foothills",
  levels = { 27, 33 },
  next = "hillsbrad-foothills-a-2",
  steps = [[
home |npc Innkeeper Anderson |at 1424 51.2,58.9  -- set your hearthstone at the inn
accept 98071 |npc Brewmeister Bilger |at 1424 52.1,58.7 |lvl 23  -- Brewer's Trade (27)
accept 536 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4 |lvl 25  -- Down the Coast (30)
complete 536 |at 1424 43.4,68.2 |mobs Torn Fin Tidehunter;Torn Fin Oracle  -- Down the Coast (30)
turnin 536 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4  -- Down the Coast (30)
accept 559 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4 |lvl 25 |preany 536  -- Farren's Proof (32)
accept 98059 |npc Captain McManus |at 1424 46.4,50.2 |lvl 23  -- Hillsbrad's Hoard (27)
complete 98059 |item 279386  -- Hillsbrad's Hoard (27)
turnin 98059 |npc Captain McManus |at 1424 46.4,50.2  -- Hillsbrad's Hoard (27)
complete 559 |at 1424 32.9,71.4 |mobs Torn Fin Coastrunner@Murloc Head;Torn Fin Muckdweller@Murloc Head;Torn Fin Oracle@Murloc Head;Torn Fin Tidehunter@Murloc Head  -- Farren's Proof (32)
turnin 559 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4  -- Farren's Proof (32)
accept 560 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4 |lvl 25 |preany 559  -- Farren's Proof (32)
turnin 560 |npc Marshal Redpath |at 1424 49.5,58.7  -- Farren's Proof (32)
accept 561 |npc Marshal Redpath |at 1424 49.5,58.7 |lvl 25 |preany 560  -- Farren's Proof (32)
accept 659 |npc Phin Odelic |at 1424 50.4,59.0 |lvl 30  -- Hints of a New Plague? (33)
turnin 561 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4  -- Farren's Proof (32)
accept 562 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4 |lvl 25 |preany 561  -- Stormwind Ho! (32)
accept 555 |npc Chef Jessen |at 1424 51.9,58.7 |lvl 28  -- Soothing Turtle Bisque (31)
complete 562 |at 1424 57.2,68.3 |mobs Daggerspine Shorehunter;Daggerspine Siren  -- Stormwind Ho! (32)
complete 98071 |at 1424 72.1,71.5 |item 279390  -- Brewer's Trade (27)
complete 555 |at 1424 55.9,54.0 |areas 63.9,39.7:4;68.0,22.9:4;55.9,54.0:3 |mobs Snapjaw@Turtle Meat |need 3713:1:Soothing Spices:sold by Micha Yance in Hillsbrad Foothills and other vendors  -- Soothing Turtle Bisque (31)
turnin 562 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4  -- Stormwind Ho! (32)
accept 563 |npc Lieutenant Farren Orinelle |at 1424 51.5,58.4 |lvl 25 |preany 562  -- Reassignment (32)
turnin 555 |npc Chef Jessen |at 1424 51.9,58.7  -- Soothing Turtle Bisque (31)
turnin 98071 |npc Brewmeister Bilger |at 1424 52.1,58.7  -- Brewer's Trade (27)
turnin 659 |npc Quae |at 1417 60.2,53.9  -- Hints of a New Plague? (33)
turnin 563 |npc Major Samuelson |at 1453 75.8,36.7  -- Reassignment (32)
]]}
