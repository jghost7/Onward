-- DRAFT Dun Morogh (Horde) generated 2026-11-21 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "dun-morogh-h", title = "Dun Morogh (30-35)", faction = "Horde", zone = "Dun Morogh",
  levels = { 30, 35 },
  steps = [[
accept 2904 |note Starts from Kernobee, whose place isn't on record. Hand it in to Scooty |loose |lvl 24  -- A Fine Mess (30)
accept 2951 |note Starts from The Sparklematic 5200, whose place isn't on record |loose |lvl 25 |exclusive 4601,4602  -- The Sparklematic 5200! (30)
complete 2951 |at 1426 20.9,36.0 |mobs Irradiated Invader@Grime-Encrusted Object;Caverndeep Looter@Grime-Encrusted Object;Caverndeep Invader@Grime-Encrusted Object;Caverndeep Pillager@Grime-Encrusted Object  -- The Sparklematic 5200! (30)
turnin 2951  -- The Sparklematic 5200! (30)
accept 2952 |note Starts from The Sparklematic 5200, whose place isn't on record |loose |lvl 25 |preany 2951,4601,4602 |exclusive 4605,4606  -- The Sparklematic 5200! (30)
turnin 2952  -- The Sparklematic 5200! (30)
accept 2945 |mobs Dark Iron Agent |note Starts from the item Grime-Encrusted Ring, found on Dark Iron Agent |startitem 9326 |loose |lvl 28  -- Grime-Encrusted Ring (34)
complete 2945 |item 9326  -- Grime-Encrusted Ring (34)
turnin 2945  -- Grime-Encrusted Ring (34)
complete 2904  -- A Fine Mess (30)
accept 2949 |note Starts from The Sparklematic 5200, whose place isn't on record. Hand it in to Nogg |loose |lvl 28 |preany 2945  -- Return of the Ring (34)
complete 2949 |item 9362  -- Return of the Ring (34)
turnin 2904 |npc Scooty |at 1434 27.6,77.5  -- A Fine Mess (30)
accept 2841 |npc Nogg |at 1454 76.0,25.4 |group dungeon |lvl 25  -- Rig Wars (35)
turnin 2949 |npc Nogg |at 1454 76.0,25.4  -- Return of the Ring (34)
accept 2842 |npc Sovik |at 1454 75.5,25.4 |lvl 20  -- Chief Engineer Scooty (35)
complete 2841 |at 1426 24.2,38.2 |group dungeon  -- Rig Wars (35)
turnin 2842 |npc Scooty |at 1434 27.6,77.5  -- Chief Engineer Scooty (35)
accept 2843 |npc Scooty |at 1434 27.6,77.5 |lvl 20 |preany 2842  -- Gnomer-gooooone! (35)
complete 2843 |at 1434 27.6,77.5 |mobs Scooty  -- Gnomer-gooooone! (35)
turnin 2843 |npc Scooty |at 1434 27.6,77.5  -- Gnomer-gooooone! (35)
turnin 2841 |npc Nogg |at 1454 76.0,25.4 |group dungeon  -- Rig Wars (35)
]]}
