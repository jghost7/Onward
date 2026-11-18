-- DRAFT Dun Morogh (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "dun-morogh-a-2", title = "Dun Morogh (30-35)", faction = "Alliance", zone = "Dun Morogh",
  levels = { 30, 35 },
  steps = [[
accept 2962 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |group dungeon |lvl 20 |preany 2926  -- The Only Cure is More Green Glow (30)
accept 2929 |npc High Tinker Mekkatorque |at 1455 68.8,49.0 |group dungeon |lvl 25  -- The Grand Betrayal (35)
accept 2924 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |value low |group dungeon |lvl 24  -- Essential Artificials (30)
accept 2930 |npc Master Mechanic Castpipe |at 1455 69.8,48.1 |group dungeon |lvl 25  -- Data Rescue (30)
fly 1453 71.3,72.2 |from 1455 55.5,47.7 |npc Stormwind City (Dungar Longdrink)  -- flight master Gryth Thurden
accept 2928 |npc Shoni the Shilent |at 1453 62.6,34.1 |lvl 20  -- Gyrodrillmatic Excavationators (30)
accept 2951 |loose |lvl 25  -- The Sparklematic 5200! (30)
fly 1434 27.5,77.8 |from 1453 71.3,72.2 |npc Stranglethorn Vale (Gyll)  -- flight master Dungar Longdrink
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
accept 2925 |npc Mathiel |at 1457 59.5,45.4 |lvl 24  -- Klockmort's Essentials (30)
accept 2945 |note Starts from Grime-Encrusted Ring |startitem 9326 |loose |lvl 28  -- Grime-Encrusted Ring (34)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
complete 2924 |at 1426 48.0,53.6 |mobs Ironforge Protector |value low |group dungeon  -- Essential Artificials (30)
complete 2930 |at 1426 48.0,53.6 |mobs Ironforge Protector |group dungeon  -- Data Rescue (30)
complete 2962 |at 1426 49.1,48.2 |item 9364 |mobs Green Mechanostrider;Swift Green Mechanostrider |group dungeon  -- The Only Cure is More Green Glow (30)
turnin 2962 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |group dungeon  -- The Only Cure is More Green Glow (30)
complete 2929 |at 1426 24.2,38.2 |mobs Mekgineer Thermaplugg |group dungeon  -- The Grand Betrayal (35)
complete 2928 |at 1426 21.7,34.0 |mobs Irradiated Invader@Robo-mechanical Guts;Caverndeep Invader@Robo-mechanical Guts;Techbot@Robo-mechanical Guts  -- Gyrodrillmatic Excavationators (30)
complete 2951 |at 1426 20.9,36.0 |mobs Irradiated Invader@Grime-Encrusted Object;Caverndeep Looter@Grime-Encrusted Object;Caverndeep Invader@Grime-Encrusted Object;Caverndeep Pillager@Grime-Encrusted Object  -- The Sparklematic 5200! (30)
accept 2952 |loose |lvl 25 |preany 2951,4601,4602  -- The Sparklematic 5200! (30)
turnin 2951  -- The Sparklematic 5200! (30)
turnin 2952  -- The Sparklematic 5200! (30)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1442 36.4,7.2 |from 1413 63.1,37.2 |npc Stonetalon Mountains (Teloren)  -- flight master Bragok
accept 2931 |npc Gaxim Rustfizzle |at 1442 59.5,67.2 |lvl 25  -- Castpipe's Task (28)
fly 1413 63.1,37.2 |from 1442 36.4,7.2 |npc The Barrens (Bragok)  -- flight master Teloren
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1455 55.5,47.7 |from 1434 27.5,77.8 |npc Ironforge (Gryth Thurden)  -- flight master Gyll
turnin 2930 |npc Master Mechanic Castpipe |at 1455 69.8,48.1 |group dungeon  -- Data Rescue (30)
turnin 2929 |npc High Tinker Mekkatorque |at 1455 68.8,49.0 |group dungeon  -- The Grand Betrayal (35)
turnin 2925 |npc Klockmort Spannerspan |at 1455 67.9,46.1  -- Klockmort's Essentials (30)
turnin 2931 |npc Master Mechanic Castpipe |at 1455 69.8,48.1  -- Castpipe's Task (28)
turnin 2945  -- Grime-Encrusted Ring (34)
accept 2947 |loose |lvl 28 |preany 2945  -- Return of the Ring (34)
fly 1453 71.3,72.2 |from 1455 55.5,47.7 |npc Stormwind City (Dungar Longdrink)  -- flight master Gryth Thurden
turnin 2928 |npc Shoni the Shilent |at 1453 62.6,34.1  -- Gyrodrillmatic Excavationators (30)
fly 1455 55.5,47.7 |from 1453 71.3,72.2 |npc Ironforge (Gryth Thurden)  -- flight master Dungar Longdrink
turnin 2947 |npc Talvash del Kissel |at 1455 36.4,3.6  -- Return of the Ring (34)
turnin 2924 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |value low |group dungeon  -- Essential Artificials (30)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   97017  Your First Riding Ram (40)
--   97018  Learning to Ride (40)
--   99207  Swift as the Wind (60)
--   99209  Swift as the Wind (60)
