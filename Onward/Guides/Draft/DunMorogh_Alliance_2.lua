-- DRAFT Dun Morogh (Alliance) generated 2026-11-21 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "dun-morogh-a-2", title = "Dun Morogh (30-40)", faction = "Alliance", zone = "Dun Morogh",
  levels = { 30, 40 },
  steps = [[
home |npc Innkeeper Belm |at 1426 47.4,52.5  -- set your hearthstone at the inn
accept 2926 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |group elite |lvl 20  -- Gnogaine (27)
accept 2951 |note Starts from The Sparklematic 5200, whose place isn't on record |loose |lvl 25 |exclusive 4601,4602  -- The Sparklematic 5200! (30)
complete 2951 |at 1426 20.9,36.0 |mobs Irradiated Invader@Grime-Encrusted Object;Caverndeep Looter@Grime-Encrusted Object;Caverndeep Invader@Grime-Encrusted Object;Caverndeep Pillager@Grime-Encrusted Object  -- The Sparklematic 5200! (30)
turnin 2951  -- The Sparklematic 5200! (30)
accept 2952 |note Starts from The Sparklematic 5200, whose place isn't on record |loose |lvl 25 |preany 2951,4601,4602 |exclusive 4605,4606  -- The Sparklematic 5200! (30)
turnin 2952  -- The Sparklematic 5200! (30)
complete 2926 |at 1426 20.9,36.0 |item 9283 |mobs Irradiated Invader@Full Leaden Collection Phial |group elite  -- Gnogaine (27)
accept 2945 |mobs Dark Iron Agent |note Starts from the item Grime-Encrusted Ring, found on Dark Iron Agent |startitem 9326 |loose |lvl 28  -- Grime-Encrusted Ring (34)
accept 2904 |note Starts from Kernobee, whose place isn't on record. Hand it in to Scooty |loose |lvl 24  -- A Fine Mess (30)
turnin 2926 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |group elite  -- Gnogaine (27)
accept 2962 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |group dungeon |lvl 20 |preany 2926  -- The Only Cure is More Green Glow (30)
complete 2962 |at 1426 49.1,48.2 |item 9364 |mobs Green Mechanostrider;Swift Green Mechanostrider |group dungeon  -- The Only Cure is More Green Glow (30)
turnin 2962 |npc Ozzie Togglevolt |at 1426 45.9,49.4 |group dungeon  -- The Only Cure is More Green Glow (30)
complete 2904  -- A Fine Mess (30)
complete 2945 |item 9326  -- Grime-Encrusted Ring (34)
turnin 2945  -- Grime-Encrusted Ring (34)
accept 2947 |note Starts from The Sparklematic 5200, whose place isn't on record. Hand it in to Talvash del Kissel |loose |lvl 28 |preany 2945  -- Return of the Ring (34)
complete 2947 |item 9362  -- Return of the Ring (34)
accept 97018 |npc Ultham Ironhorn |at 1426 63.9,50.1 |race Dwarf |lvl 40 |exclusive 97074,97170,97188,97205  -- Learning to Ride (40)
complete 97018 |at 1426 63.4,49.4 |mobs White Riding Ram;Apprentice Soren |race Dwarf  -- Learning to Ride (40)
turnin 97018 |npc Veron Amberstill |at 1426 63.5,50.6 |race Dwarf  -- Learning to Ride (40)
accept 97017 |npc Veron Amberstill |at 1426 63.5,50.6 |lvl 40 |exclusive 95511,96996,97045,97046,97171,98166,99326  -- Your First Riding Ram (40)
complete 97017 |at 1426 64.1,50.2 |mobs White Ram;Brown Ram;Gray Ram  -- Your First Riding Ram (40)
turnin 97017 |npc Veron Amberstill |at 1426 63.5,50.6  -- Your First Riding Ram (40)
accept 2929 |npc High Tinker Mekkatorque |at 1455 68.8,49.0 |group dungeon |lvl 25  -- The Grand Betrayal (35)
accept 2930 |npc Master Mechanic Castpipe |at 1455 69.8,48.1 |group dungeon |lvl 25  -- Data Rescue (30)
accept 2924 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |value low |group dungeon |lvl 24  -- Essential Artificials (30)
turnin 2947 |npc Talvash del Kissel |at 1455 36.4,3.6  -- Return of the Ring (34)
complete 2930 |at 1426 21.9,38.6 |mobs Caverndeep Invader@White Punch Card;Caverndeep Looter@White Punch Card;Caverndeep Pillager@White Punch Card |pick 9279 |note First get White Punch Card from Caverndeep Invader or Caverndeep Looter or Caverndeep Pillager |group dungeon  -- Data Rescue (30)
complete 2930 |at 1426 47.9,53.8 |mobs Ironforge Protector |group dungeon  -- Data Rescue (30)
complete 2924 |at 1426 47.9,53.8 |mobs Ironforge Protector |value low |group dungeon  -- Essential Artificials (30)
complete 2929 |at 1426 24.2,38.2 |mobs Mekgineer Thermaplugg |group dungeon  -- The Grand Betrayal (35)
turnin 2924 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |value low |group dungeon  -- Essential Artificials (30)
turnin 2930 |npc Master Mechanic Castpipe |at 1455 69.8,48.1 |group dungeon  -- Data Rescue (30)
turnin 2929 |npc High Tinker Mekkatorque |at 1455 68.8,49.0 |group dungeon  -- The Grand Betrayal (35)
accept 2928 |npc Shoni the Shilent |at 1453 62.6,34.1 |lvl 20  -- Gyrodrillmatic Excavationators (30)
complete 2928 |at 1426 21.7,34.0 |mobs Irradiated Invader@Robo-mechanical Guts;Caverndeep Invader@Robo-mechanical Guts;Techbot@Robo-mechanical Guts  -- Gyrodrillmatic Excavationators (30)
turnin 2928 |npc Shoni the Shilent |at 1453 62.6,34.1  -- Gyrodrillmatic Excavationators (30)
turnin 2904 |npc Scooty |at 1434 27.6,77.5  -- A Fine Mess (30)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   99207  Swift as the Wind (60)
--   99209  Swift as the Wind (60)
--   99210  An Epic Ride (60)
--   99212  An Epic Ride (60)
