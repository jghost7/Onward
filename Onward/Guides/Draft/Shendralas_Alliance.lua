-- DRAFT Shen'dralas (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "shen-dralas-a", title = "Shen'dralas (38-43)", faction = "Alliance", zone = "Shen'dralas",
  levels = { 38, 43 },
  steps = [[
accept 93125 |npc Rokren |at 2652 34.1,77.9 |lvl 30  -- Going Home (43)
accept 93034 |npc Uthek the Wise |at 1443 36.2,79.2 |lvl 30 |preany 1373  -- Valley of Bones (38)
accept 92841 |npc Warug |at 1443 75.0,68.2 |lvl 30 |preany 92743  -- Valley of Bones (40)
turnin 93034 |npc Nerlokh |at 2652 20.9,22.7  -- Valley of Bones (38)
accept 93037 |npc Nerlokh |at 2652 20.9,22.7 |lvl 30 |preany 93034  -- Outing Outcasts (40)
turnin 93125 |npc Nerlokh |at 2652 20.9,22.7  -- Going Home (43)
accept 93035 |npc Nerlokh |at 2652 20.9,22.7 |lvl 30 |preany 93034  -- Ravaging Ravagers (38)
turnin 93035 |npc Nerlokh |at 2652 20.9,22.7  -- Ravaging Ravagers (38)
turnin 93037 |npc Nerlokh |at 2652 20.9,22.7  -- Outing Outcasts (40)
accept 93041 |npc Nerlokh |at 2652 20.9,22.7 |lvl 30 |pre 93035,93037  -- Facing the Truth (38)
turnin 92841 |npc Orgrul |at 2652 35.7,12.7  -- Valley of Bones (40)
accept 92844 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |preany 92841  -- Mountain of Bones (42)
turnin 92844 |npc Orgrul |at 2652 35.7,12.7  -- Mountain of Bones (42)
accept 92846 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |preany 92841  -- Outcast Necromancers (40)
turnin 92846 |npc Orgrul |at 2652 35.7,12.7  -- Outcast Necromancers (40)
accept 92847 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |pre 92844,92846  -- Corrupting Tears (42)
turnin 92847 |npc Orgrul |at 2652 35.7,12.7  -- Corrupting Tears (42)
accept 92873 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |preany 92847  -- Proof of Concept (41)
turnin 92873 |npc Orgrul |at 2652 35.7,12.7  -- Proof of Concept (41)
accept 92893 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |preany 92873  -- No Mercy for the Weak (42)
accept 92894 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |preany 92873  -- Bone Raising (40)
turnin 92894 |npc Orgrul |at 2652 35.7,12.7  -- Bone Raising (40)
turnin 92893 |npc Orgrul |at 2652 35.7,12.7  -- No Mercy for the Weak (42)
accept 93066 |npc Orgrul |at 2652 35.7,12.7 |lvl 30 |pre 92893,92894  -- Bristleback Retreat (43)
turnin 93066 |npc Hagiak |at 2652 59.3,53.9  -- Bristleback Retreat (43)
accept 93072 |npc Hagiak |at 2652 59.3,53.9 |value mid |lvl 30 |preany 93066  -- Long-Term Solutions (43)
complete 93072 |at 2652 38.3,62.9 |mobs Outcast Scout;Outcast Marauder;Outcast Necromancer |value mid  -- Long-Term Solutions (43)
turnin 93072 |npc Hagiak |at 2652 59.3,53.9 |value mid  -- Long-Term Solutions (43)
accept 93129 |npc Hagiak |at 2652 59.3,53.9 |lvl 30 |preany 93066  -- Threat of Starvation (43)
turnin 93129 |npc Hagiak |at 2652 59.3,53.9  -- Threat of Starvation (43)
accept 93188 |npc Hagiak |at 2652 59.3,53.9 |value mid |lvl 30 |pre 93072,93129  -- Return to Orgrul (43)
turnin 93188 |npc Orgrul |at 2652 35.7,12.7 |value mid  -- Return to Orgrul (43)
turnin 93041 |npc Uthek the Wise |at 1443 36.2,79.2  -- Facing the Truth (38)
]]}
