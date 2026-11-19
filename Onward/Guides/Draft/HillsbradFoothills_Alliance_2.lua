-- DRAFT Hillsbrad Foothills (Alliance) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "hillsbrad-foothills-a-2", title = "Hillsbrad Foothills (34-40)", faction = "Alliance", zone = "Hillsbrad Foothills",
  levels = { 34, 40 },
  steps = [[
home |npc Innkeeper Anderson |at 1424 51.2,58.9  -- set your hearthstone at the inn
accept 564 |npc Darren Malvew |at 1424 52.4,56.0 |value mid |lvl 30  -- Costly Menace (34)
accept 565 |npc Bartolo Ginsetti |at 1424 49.4,55.5 |value low |lvl 29  -- Bartolo's Yeti Fur Cloak (34)
fly 1417 45.7,46.1 |from 1424 49.3,52.3 |npc Arathi Highlands (Cedrik Prose)  -- flight master Darla Harris
accept 658 |npc Quae |at 1417 60.2,53.9 |lvl 30 |preany 659  -- Hints of a New Plague? (36)
fly 1424 49.3,52.3 |from 1417 45.7,46.1 |npc Darla Harris  -- flight master Cedrik Prose
complete 565 |at 1424 44.5,31.2 |mobs Cave Yeti@Yeti Fur;Ferocious Yeti@Yeti Fur |value low  -- Bartolo's Yeti Fur Cloak (34)
complete 658 |at 1424 43.5,30.2  -- Hints of a New Plague? (36)
complete 564 |at 1424 38.8,24.6 |mobs Mountain Lion;Hulking Mountain Lion |value mid  -- Costly Menace (34)
fly 1417 45.7,46.1 |from 1424 49.3,52.3 |npc Arathi Highlands (Cedrik Prose)  -- flight master Darla Harris
turnin 658 |npc Quae |at 1417 60.2,53.9  -- Hints of a New Plague? (36)
accept 661 |npc Quae |at 1417 60.2,53.9 |lvl 30 |preany 660  -- Hints of a New Plague? (37)
accept 657 |npc Quae |at 1417 60.2,53.9 |lvl 30 |preany 658  -- Hints of a New Plague? (36)
turnin 657 |npc Kinelory |at 1417 60.2,53.9  -- Hints of a New Plague? (36)
fly 1424 49.3,52.3 |from 1417 45.7,46.1 |npc Darla Harris  -- flight master Cedrik Prose
turnin 565 |npc Bartolo Ginsetti |at 1424 49.4,55.5 |value low  -- Bartolo's Yeti Fur Cloak (34)
turnin 564 |npc Darren Malvew |at 1424 52.4,56.0 |value mid  -- Costly Menace (34)
accept 95788 |npc Loremaster Dibbs |at 1424 50.6,57.1 |lvl 30 |preany 95786  -- Magics of the Drowned City (40)
complete 95788  -- Magics of the Drowned City (40)
turnin 95788 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- Magics of the Drowned City (40)
accept 95787 |npc Loremaster Dibbs |at 1424 50.6,57.1 |lvl 30 |preany 95786  -- Take Two With Water (40)
complete 95787  -- Take Two With Water (40)
turnin 95787 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- Take Two With Water (40)
accept 99326 |note No quest giver on record: it most likely starts from an item you loot or find in this zone |loose |race Human |lvl 40  -- Your First Horse (40)
turnin 99326 |race Human  -- Your First Horse (40)
turnin 661 |npc Phin Odelic |at 1424 50.4,59.0  -- Hints of a New Plague? (37)
]]}
