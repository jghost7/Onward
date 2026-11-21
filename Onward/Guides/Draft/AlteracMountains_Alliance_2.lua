-- DRAFT Alterac Mountains (Alliance) generated 2026-11-21 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "alterac-mountains-a-2", title = "Alterac Mountains (40-45)", faction = "Alliance", zone = "Alterac Mountains",
  levels = { 40, 45 },
  steps = [[
accept 551 |at 1416 39.2,14.7 |note Starts from Ensorcelled Parchment |startitem 3706 |value mid |lvl 30  -- The Ensorcelled Parchment (40)
accept 97130 |npc Archmage Timear |at 1416 15.4,74.1 |value low |lvl 34  -- Ancient Gurubashi Secrets (40)
complete 97130 |at 1416 60.1,46.1 |mobs Ancient Fire Elemental;Ancient Sapling;Fel Ancient |value low  -- Ancient Gurubashi Secrets (40)
accept 96771 |npc Ranath Nightstride |at 1416 17.8,66.0 |group elite |lvl 37  -- Vengeance of the Highborne (45)
complete 96771 |mobs Zalfan Moonshadow |group elite  -- Vengeance of the Highborne (45)
turnin 96771 |npc Ranath Nightstride |at 1416 17.8,66.0 |group elite  -- Vengeance of the Highborne (45)
turnin 97130 |npc Archmage Timear |at 1416 15.4,74.1 |value low  -- Ancient Gurubashi Secrets (40)
turnin 551 |npc Loremaster Dibbs |at 1424 50.6,57.1 |value mid  -- The Ensorcelled Parchment (40)
accept 554 |npc Loremaster Dibbs |at 1424 50.6,57.1 |value mid |lvl 28 |preany 551  -- Stormpike's Deciphering (40)
accept 95798 |npc Loremaster Dibbs |at 1424 50.6,57.1 |lvl 30 |preany 95788  -- The Web of Magic (40)
accept 504 |npc Marshal Redpath |at 1424 49.5,58.7 |group elite |lvl 30 |preany 500  -- Crushridge Warmongers (40)
accept 537 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |lvl 30 |preany 525  -- Dark Council (40)
accept 523 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |lvl 30 |preany 522  -- Baron's Demise (40)
turnin 95798 |npc Abra Cadabra |at 1416 12.0,70.5  -- The Web of Magic (40)
complete 504 |at 1416 36.3,53.8 |mobs Crushridge Warmonger |group elite  -- Crushridge Warmongers (40)
complete 537 |at 1416 58.7,30.5 |mobs Argus Shadow Mage;Nagaz@Head of Nagaz  -- Dark Council (40)
complete 523 |at 1416 56.3,26.7 |mobs Baron Vardus@Head of Baron Vardus  -- Baron's Demise (40)
turnin 504 |npc Marshal Redpath |at 1424 49.5,58.7 |group elite  -- Crushridge Warmongers (40)
turnin 537 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Dark Council (40)
turnin 523 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Baron's Demise (40)
turnin 554 |npc Prospector Stormpike |at 1455 74.6,11.7 |value mid  -- Stormpike's Deciphering (40)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   96772  The Dragon's Journal (53)
--   97173  Blackmaw Magic (59)
--   98529  Junkboxes Needed (60)
--   99191  A Donation of Wool (60)
--   99192  A Donation of Silk (60)
--   99193  A Donation of Mageweave (60)
--   99194  A Donation of Runecloth (60)
