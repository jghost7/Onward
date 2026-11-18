-- DRAFT Moonglade (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "moonglade-a", title = "Moonglade (57-60)", faction = "Alliance", zone = "Moonglade",
  levels = { 57, 60 },
  steps = [[
accept 1124 |npc Rabine Saturna |at 1450 51.7,45.1 |lvl 54 |preany 1123,6762  -- Wasteland (55)
accept 5527 |npc Rabine Saturna |at 1450 51.7,45.1 |lvl 56  -- A Reliquary of Purity (60)
complete 5527 |at 1450 51.0,40.5 |mobs Moonglade Warden  -- A Reliquary of Purity (60)
accept 96209 |npc Dendrite Starblaze |at 1450 56.2,30.6 |preany 92612  -- The Ancient, Orokai (58)
accept 6845 |npc Umber |at 1450 44.9,35.6 |lvl 54 |preany 6844  -- Uncovering Past Secrets (57)
turnin 96209 |npc Orokai |at 1450 41.5,43.6  -- The Ancient, Orokai (58)
accept 95006 |npc Orokai |at 1450 41.5,43.6 |preany 96209  -- Stolen Power (58)
turnin 5527 |npc Rabine Saturna |at 1450 51.7,45.1  -- A Reliquary of Purity (60)
accept 5526 |npc Rabine Saturna |at 1450 51.7,45.1 |lvl 56 |preany 5527  -- Shards of the Felvine (60)
complete 5526 |at 1450 51.0,40.5 |item 18539 |mobs Moonglade Warden  -- Shards of the Felvine (60)
turnin 5526 |npc Rabine Saturna |at 1450 51.7,45.1  -- Shards of the Felvine (60)
turnin 6845 |npc Rabine Saturna |at 1450 51.7,45.1  -- Uncovering Past Secrets (57)
turnin 95006 |npc Dendrite Starblaze |at 1450 56.2,30.6  -- Stolen Power (58)
accept 93773 |npc Dendrite Starblaze |at 1450 56.2,30.6 |value mid |preany 95006  -- The Pact (58)
accept 1185 |npc Umber |at 1450 44.9,35.6 |lvl 54 |preany 6845  -- Under the Chitin Was... (57)
turnin 1185 |npc Umber |at 1450 44.9,35.6  -- Under the Chitin Was... (57)
accept 8735 |npc Keeper Remulos |at 1450 36.2,41.8 |value mid |group elite |lvl 60 |preany 8734  -- The Nightmare's Corruption (60)
accept 8741 |npc Keeper Remulos |at 1450 36.2,41.8 |group chain |lvl 60 |preany 8736  -- The Champion Returns (60)
complete 8735 |at 1450 51.0,40.5 |mobs Moonglade Warden;Air Elemental Fragment;Earth Elemental Fragment |value mid |group elite  -- The Nightmare's Corruption (60)
turnin 8735 |npc Keeper Remulos |at 1450 36.2,41.8 |value mid |group elite  -- The Nightmare's Corruption (60)
fly 2482 68.7,46.8 |from 1450 44.1,45.2 |npc Mount Hyjal (Fayran Elthas) |value mid  -- flight master Silva Fil'naveth
turnin 93773 |npc Ketharas |at 2482 73.3,81.9 |value mid  -- The Pact (58)
fly 1451 50.6,34.5 |from 2482 68.7,46.8 |npc Silithus (Cloud Skydancer)  -- flight master Fayran Elthas
turnin 1124 |npc Layo Starstrike |at 1451 81.9,18.9  -- Wasteland (55)
fly 1446 51.0,29.3 |from 1451 50.6,34.5 |npc Tanaris (Bera Stonehammer)  -- flight master Cloud Skydancer
turnin 8741 |npc Anachronos |at 1446 65.3,50.0 |group chain  -- The Champion Returns (60)
]]}
