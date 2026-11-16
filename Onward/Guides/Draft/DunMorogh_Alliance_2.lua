-- DRAFT Dun Morogh (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "dun-morogh-a-2", title = "Dun Morogh (30-35)", faction = "Alliance", zone = "Dun Morogh",
  levels = { 30, 35 },
  steps = [[
accept 2962 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |value low |group dungeon  -- The Only Cure is More Green Glow (30)
accept 2924 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |value mid |group dungeon  -- Essential Artificials (30)
accept 2925 |npc Mathiel |at 1457 59.5,45.4  -- Klockmort's Essentials (30)
turnin 2925 |npc Klockmort Spannerspan |at 1455 67.9,46.1  -- Klockmort's Essentials (30)
accept 2929 |npc High Tinker Mekkatorque |at 1455 68.8,49.0 |group dungeon  -- The Grand Betrayal (35)
accept 2930 |npc Master Mechanic Castpipe |at 1455 69.8,48.1 |group dungeon  -- Data Rescue (30)
fly 1453 71.3,72.2 |from 1455 55.5,47.7 |npc Stormwind City (Dungar Longdrink)  -- flight master Gryth Thurden
accept 2928 |npc Shoni the Shilent |at 1453 62.6,34.1  -- Gyrodrillmatic Excavationators (30)
complete 2928 |at 1426 21.7,34.0 |mobs Irradiated Invader;Caverndeep Invader;Techbot  -- Gyrodrillmatic Excavationators (30)
turnin 2928 |npc Shoni the Shilent |at 1453 62.6,34.1  -- Gyrodrillmatic Excavationators (30)
fly 1442 36.4,7.2 |from 1453 71.3,72.2 |npc Stonetalon Mountains (Teloren)  -- flight master Dungar Longdrink
accept 2931 |npc Gaxim Rustfizzle |at 1442 59.5,67.2  -- Castpipe's Task (28)
fly 1455 55.5,47.7 |from 1442 36.4,7.2 |npc Ironforge (Gryth Thurden)  -- flight master Teloren
turnin 2931 |npc Master Mechanic Castpipe |at 1455 69.8,48.1  -- Castpipe's Task (28)
accept 2945 |note Starts from Grime-Encrusted Ring  -- Grime-Encrusted Ring (34)
turnin 2945  -- Grime-Encrusted Ring (34)
accept 2947  -- Return of the Ring (34)
turnin 2947 |npc Talvash del Kissel |at 1455 36.4,3.6  -- Return of the Ring (34)
accept 2951  -- The Sparklematic 5200! (30)
complete 2951 |at 1426 20.9,36.0 |mobs Irradiated Invader;Caverndeep Looter;Caverndeep Invader;Caverndeep Pillager  -- The Sparklematic 5200! (30)
turnin 2951  -- The Sparklematic 5200! (30)
accept 2952  -- The Sparklematic 5200! (30)
turnin 2952  -- The Sparklematic 5200! (30)
complete 2924 |value mid |group dungeon  -- Essential Artificials (30)
turnin 2924 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |value mid |group dungeon  -- Essential Artificials (30)
complete 2929 |mobs Mekgineer Thermaplugg |group dungeon  -- The Grand Betrayal (35)
turnin 2929 |npc High Tinker Mekkatorque |at 1455 68.8,49.0 |group dungeon  -- The Grand Betrayal (35)
complete 2930 |group dungeon  -- Data Rescue (30)
turnin 2930 |npc Master Mechanic Castpipe |at 1455 69.8,48.1 |group dungeon  -- Data Rescue (30)
complete 2962 |value low |group dungeon  -- The Only Cure is More Green Glow (30)
turnin 2962 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |value low |group dungeon  -- The Only Cure is More Green Glow (30)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   97017  Your First Riding Ram (40)
--   97018  Learning to Ride (40)
--   99207  Swift as the Wind (60)
--   99209  Swift as the Wind (60)
