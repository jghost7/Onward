-- DRAFT Mount Hyjal (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "mount-hyjal-h", title = "Mount Hyjal (57-60)", faction = "Horde", zone = "Mount Hyjal",
  levels = { 57, 60 },
  steps = [[
home |npc Ortak Lomgok |at 2482 12.9,52.9  -- set your hearthstone at the inn
accept 91794 |npc Kal'tinzan |at 2482 13.8,53.1  -- Flags of Our Forebears (59)
accept 92592 |npc Zet'gan |at 2482 13.8,54.8  -- Final Death (59)
accept 95026 |npc Zet'gan |at 2482 13.8,54.8 |value mid  -- Blight No More (58)
accept 92609 |npc Zet'gan |at 2482 13.8,54.8 |value mid  -- Feathers in Flight (57)
complete 95026 |at 2482 24.2,54.1 |mobs Forgotten Soldier;Fleshflay Ravener |value mid  -- Blight No More (58)
complete 92592 |at 2482 27.4,57.8 |item 274411 |mobs Scourge Reanimator@Reanimator's Amulet  -- Final Death (59)
accept 94782 |npc Curious Crow |at 2482 48.3,85.7 |value low  -- The Western Post (57)
complete 92609 |at 2482 36.6,73.9 |mobs Hyjal Owl@Hyjal Owl Feather;Tainted Hyjal Owl@Hyjal Owl Feather |value mid  -- Feathers in Flight (57)
turnin 92609 |npc Zet'gan |at 2482 13.8,54.8 |value mid  -- Feathers in Flight (57)
turnin 92592 |npc Zet'gan |at 2482 13.8,54.8  -- Final Death (59)
turnin 95026 |npc Zet'gan |at 2482 13.8,54.8 |value mid  -- Blight No More (58)
turnin 94782 |npc Zet'gan |at 2482 13.8,54.8 |value low  -- The Western Post (57)
accept 95248 |npc Zet'gan |at 2482 13.8,54.8 |value low  -- To the Summit of Eternity (59)
accept 92446 |npc Zet'gan |at 2482 13.8,54.8 |value mid |group elite  -- Head Scratcher (60)
complete 92446 |at 2482 35.3,71.3 |item 251780 |mobs Head Scratcher@Head Scratcher's Scratchers |value mid |group elite  -- Head Scratcher (60)
turnin 95248 |npc Thisalee Crow |at 2482 69.0,50.0 |value low  -- To the Summit of Eternity (59)
accept 96998 |npc Troll Remains |at 2482 61.6,41.5  -- Tribal Colors (58)
complete 91794 |at 2482 54.4,36.1 |mobs Felguard Sentinel@Scrap of Horde Heraldry;Doomguard@Scrap of Horde Heraldry;Doomguard Xarkul@Scrap of Horde Heraldry;Bethra'zel the Feeble@Scrap of Horde Heraldry  -- Flags of Our Forebears (59)
turnin 92446 |npc Zet'gan |at 2482 13.8,54.8 |value mid |group elite  -- Head Scratcher (60)
turnin 96998 |npc Zet'gan |at 2482 13.8,54.8  -- Tribal Colors (58)
accept 96999 |npc Zet'gan |at 2482 13.8,54.8  -- Wrap Return (58)
turnin 91794 |npc Kal'tinzan |at 2482 13.8,53.1  -- Flags of Our Forebears (59)
accept 92101 |npc Veteran of the Third War |at 2482 8.8,46.5  -- Lifted by Legacy (58)
accept 93510 |npc Veteran of the Third War |at 2482 8.8,46.5  -- Wake Memories (58)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
complete 93510 |at 1433 29.9,57.2 |item 274795  -- Wake Memories (58)
turnin 93510 |npc Weathered Anchor |at 1433 30.4,57.0  -- Wake Memories (58)
accept 97000 |npc Abigail Sawyer |at 1458 54.7,38.8  -- Grain of Memory (57)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1441 45.1,49.1 |from 1413 63.1,37.2 |npc Thousand Needles (Nyse)  -- flight master Bragok
complete 92101 |at 1441 31.9,24.1 |item 274795  -- Lifted by Legacy (58)
turnin 92101 |npc Carving |at 1441 31.9,24.1  -- Lifted by Legacy (58)
turnin 97000  -- Grain of Memory (57)
accept 97006  -- Notarized Claim (60)
accept 97007  -- Wood Remains (57)
accept 97119  -- Now We're Cooking (57)
turnin 97006  -- Notarized Claim (60)
turnin 96999 |npc Tai'tasi |at 1411 56.4,73.8  -- Wrap Return (58)
turnin 97007  -- Wood Remains (57)
accept 97001  -- Sawyer's Legacy (57)
turnin 97001  -- Sawyer's Legacy (57)
complete 97119  -- Now We're Cooking (57)
turnin 97119 |npc Ortak Lomgok |at 2482 12.9,52.9  -- Now We're Cooking (57)
accept 96616 |npc Ortak Lomgok |at 2482 12.9,52.9 |value low  -- Herbs for the Bruised and Weary (57)
complete 96616 |value low  -- Herbs for the Bruised and Weary (57)
turnin 96616 |npc Ortak Lomgok |at 2482 12.9,52.9 |value low  -- Herbs for the Bruised and Weary (57)
accept 96622 |npc Ortak Lomgok |at 2482 12.9,52.9 |value low  -- A Rest Without Pain (57)
turnin 96622 |npc Ortak Lomgok |at 2482 12.9,52.9 |value low  -- A Rest Without Pain (57)
]]}
