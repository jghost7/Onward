-- DRAFT Dustwallow Marsh (Horde) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "dustwallow-marsh-h-2", title = "Dustwallow Marsh (53-60)", faction = "Horde", zone = "Dustwallow Marsh",
  levels = { 53, 60 },
  steps = [[
accept 95284 |npc Nazeer Bloodpike |at 1445 35.2,30.7 |value low  -- The Elite of the Elite (53)
turnin 95284 |npc Sergeant Ulka |at 1445 70.3,18.9 |value low  -- The Elite of the Elite (53)
accept 95285 |npc Sergeant Ulka |at 1445 70.3,18.9 |value low  -- Right Place, Wrong Time (53)
turnin 95285 |npc Sergeant Ulka |at 1445 70.3,18.9 |value low  -- Right Place, Wrong Time (53)
fly 1454 45.1,63.9 |from 1445 35.6,31.9 |npc Orgrimmar (Doras)  -- flight master Shardi
accept 95283 |npc Eitrigg |at 1454 34.3,39.4  -- The Missing Kor'kron (53)
fly 1445 35.6,31.9 |from 1454 45.1,63.9 |npc Shardi  -- flight master Doras
turnin 95283 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- The Missing Kor'kron (53)
accept 6570 |npc Myranda the Hag |at 1422 50.8,77.8 |group chain  -- Emberstrife (60)
turnin 6570 |npc Emberstrife |at 1445 56.7,87.7 |group chain  -- Emberstrife (60)
accept 6582 |npc Emberstrife |at 1445 56.7,87.7 |group elite  -- The Test of Skulls, Scryer (60)
accept 6583 |npc Emberstrife |at 1445 56.7,87.7 |group elite  -- The Test of Skulls, Somnus (60)
accept 6584 |npc Emberstrife |at 1445 56.7,87.7 |group chain  -- The Test of Skulls, Chronalis (60)
complete 6582 |group elite  -- The Test of Skulls, Scryer (60)
turnin 6582 |npc Emberstrife |at 1445 56.7,87.7 |group elite  -- The Test of Skulls, Scryer (60)
complete 6583 |group elite  -- The Test of Skulls, Somnus (60)
turnin 6583 |npc Emberstrife |at 1445 56.7,87.7 |group elite  -- The Test of Skulls, Somnus (60)
accept 8970 |npc Bodley |at 1415 48.9,63.9 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- I See Alcaz Island In Your Future... (60)
complete 6584 |group chain  -- The Test of Skulls, Chronalis (60)
turnin 6584 |npc Emberstrife |at 1445 56.7,87.7 |group chain  -- The Test of Skulls, Chronalis (60)
accept 6585 |npc Emberstrife |at 1445 56.7,87.7 |group elite  -- The Test of Skulls, Axtroz (60)
complete 6585 |group elite  -- The Test of Skulls, Axtroz (60)
turnin 6585 |npc Emberstrife |at 1445 56.7,87.7 |group elite  -- The Test of Skulls, Axtroz (60)
accept 6601 |npc Emberstrife |at 1445 56.7,87.7 |group chain  -- Ascension... (60)
fly 1443 21.6,74.1 |from 1445 35.6,31.9 |npc Desolace (Thalon)  -- flight master Shardi
turnin 6601 |npc Rexxar |at 1443 54.0,2.0 |group chain  -- Ascension... (60)
fly 1445 35.6,31.9 |from 1443 21.6,74.1 |npc Shardi  -- flight master Thalon
complete 8970 |at 1445 76.4,18.4 |mobs Strashaz Serpent Guard;Strashaz Myrmidon;Strashaz Siren;Strashaz Warrior |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- I See Alcaz Island In Your Future... (60)
turnin 8970 |npc Bodley |at 1415 48.9,63.9 |value mid |class WARRIOR,HUNTER,ROGUE,PRIEST,SHAMAN,MAGE,WARLOCK,DRUID |group chain  -- I See Alcaz Island In Your Future... (60)
]]}
