-- DRAFT Tirisfal Glades (Horde) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "tirisfal-glades-h-2", title = "Tirisfal Glades (12-13)", faction = "Horde", zone = "Tirisfal Glades",
  levels = { 12, 13 },
  steps = [[
home |npc Innkeeper Renee |at 1420 61.7,52.0  -- set your hearthstone at the inn
accept 372 |npc Executor Zygand |at 1420 60.6,51.8 |lvl 5 |preany 371  -- At War With The Scarlet Crusade (12)
accept 408 |npc Magistrate Sevren |at 1420 61.3,50.8 |lvl 7 |preany 355  -- The Family Crypt (13)
accept 96895 |npc Deathguard Terrence |at 1420 61.5,53.5 |lvl 10  -- The Argent Emissary (12)
accept 99156 |npc Deathguard Linnea |at 1420 65.5,60.2 |race Orc,Scourge |group elite |lvl 6 |preany 356  -- Rear Guard Patrol (13)
turnin 96895 |npc Hadric Harlson |at 1420 65.9,61.1  -- The Argent Emissary (12)
accept 96897 |npc Hadric Harlson |at 1420 65.9,61.1 |lvl 10 |preany 96895  -- The Cult of the Damned (12)
accept 96898 |npc Hadric Harlson |at 1420 65.9,61.1 |lvl 10 |preany 96895  -- Remnants of War (12)
complete 96898 |at 1420 68.5,64.2 |mobs Dark Enforcer@Necrotic Crystal Fragment;Dark Neophyte@Necrotic Crystal Fragment  -- Remnants of War (12)
complete 96897 |at 1420 68.5,64.2 |mobs Dark Neophyte;Dark Enforcer  -- The Cult of the Damned (12)
turnin 96898 |npc Hadric Harlson |at 1420 65.9,61.1  -- Remnants of War (12)
turnin 96897 |npc Hadric Harlson |at 1420 65.9,61.1  -- The Cult of the Damned (12)
accept 96899 |npc Hadric Harlson |at 1420 65.9,61.1 |lvl 10 |pre 96897,96898  -- Bandarion Keep (12)
accept 409 |npc Gunther Arcanus |at 1420 68.2,41.9 |lvl 5 |preany 366  -- Proving Allegiance (12)
complete 409 |at 1420 68.2,42.0 |pick 3080 |note First get Candle of Beckoning at Crate of Candles  -- Proving Allegiance (12)
complete 409 |at 1420 66.7,45.0 |mobs Lillith Nefara  -- Proving Allegiance (12)
turnin 409 |npc Gunther Arcanus |at 1420 68.2,41.9  -- Proving Allegiance (12)
accept 411 |npc Gunther Arcanus |at 1420 68.2,41.9 |lvl 5 |preany 409  -- The Prodigal Lich Returns (12)
complete 99156 |at 1420 83.3,45.2 |mobs Riptear@Riptear's Heart |race Orc,Scourge |group elite  -- Rear Guard Patrol (13)
complete 372 |at 1420 79.5,25.1 |mobs Captain Melrache;Scarlet Bodyguard  -- At War With The Scarlet Crusade (12)
complete 408 |at 1420 52.2,27.4 |mobs Wailing Ancestor;Rotting Ancestor;Captain Dargol@Dargol's Skull  -- The Family Crypt (13)
turnin 96899 |npc Leonid Barthalomew the Revered |at 1420 22.0,44.7  -- Bandarion Keep (12)
accept 96896 |npc Leonid Barthalomew the Revered |at 1420 22.0,44.7 |race Scourge |lvl 10 |preany 96899  -- A Righteous Cause (12)
complete 96896 |race Scourge  -- A Righteous Cause (12)
turnin 96896 |npc Leonid Barthalomew the Revered |at 1420 22.0,44.7 |race Scourge  -- A Righteous Cause (12)
accept 98545 |npc Leonid Barthalomew the Revered |at 1420 22.0,44.7 |race Scourge |lvl 10 |preany 96896  -- Leonid's Letter (12)
accept 99152 |npc Hilda the Breaker |at 1420 22.0,47.2 |race Scourge |lvl 10 |preany 96896  -- As Above, So Below (12)
accept 99153 |npc Ephram Barbaro |at 1420 20.2,46.5 |race Scourge |lvl 10 |preany 96896  -- The One That Got Away (12)
accept 95328 |at 1420 8.7,60.1 |mobs Whispering Horror |note Starts from the item Whispering Horror Residue, found on Whispering Horror. Hand it in to Father Lankester |startitem 268812 |loose |group elite |lvl 7  -- Whispering Horror Residue (13)
complete 95328 |at 1420 8.7,60.1 |mobs Whispering Horror@Whispering Horror Residue |group elite  -- Whispering Horror Residue (13)
complete 99153 |at 1420 9.7,69.4 |race Scourge  -- The One That Got Away (12)
complete 99152 |at 1420 10.3,65.4 |mobs Shadowvale Lurcher@Faintly Glowing Bone;Shadowvale Mystic@Faintly Glowing Bone |race Scourge  -- As Above, So Below (12)
turnin 99153 |npc Ephram Barbaro |at 1420 20.2,46.5 |race Scourge  -- The One That Got Away (12)
turnin 99152 |npc Hilda the Breaker |at 1420 22.0,47.2 |race Scourge  -- As Above, So Below (12)
turnin 372 |npc Executor Zygand |at 1420 60.6,51.8  -- At War With The Scarlet Crusade (12)
turnin 408 |npc Magistrate Sevren |at 1420 61.3,50.8  -- The Family Crypt (13)
turnin 99156 |npc Deathguard Linnea |at 1420 65.5,60.2 |race Orc,Scourge |group elite  -- Rear Guard Patrol (13)
turnin 411 |npc Bethor Iceshard |at 1458 84.1,17.4  -- The Prodigal Lich Returns (12)
turnin 98545 |npc Glix Xizzix |at 1458 70.0,47.3 |race Scourge  -- Leonid's Letter (12)
turnin 95328 |npc Father Lankester |at 1458 49.1,14.6 |group elite  -- Whispering Horror Residue (13)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   96997  A Steed in Death as They Were in Life (40)
--   97203  Learning to Ride (40)
--   5901  A Plague Upon Thee (55)
--   5902  A Plague Upon Thee (55)
--   93030  The Knight of Mourning (58)
--   97178  Ott of Tarren Mill (60)
--   99208  Swift as the Wind (60)
--   99211  An Epic Ride (60)
