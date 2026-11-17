-- DRAFT Alterac Mountains (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "alterac-mountains-a", title = "Alterac Mountains (33-40)", faction = "Alliance", zone = "Alterac Mountains",
  levels = { 33, 40 },
  steps = [[
accept 92459 |npc Image of Archmage Modera |at 1416 14.3,59.6  -- Friend of the Kirin Tor (33)
turnin 92459 |npc Archmage Celindra |at 1416 14.2,60.0  -- Friend of the Kirin Tor (33)
accept 500 |npc Marshal Redpath |at 1424 49.5,58.7  -- Crushridge Bounty (36)
accept 95798 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- The Web of Magic (40)
accept 505 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |value low  -- Syndicate Assassins (33)
accept 92432 |npc Emissary Jacques |at 1424 48.3,60.0  -- An Alarming Request (33)
complete 500 |at 1416 43.3,48.0 |mobs Crushridge Ogre@Dirty Knucklebones;Crushridge Brute@Dirty Knucklebones;Crushridge Warmonger@Dirty Knucklebones;Crushridge Mauler@Dirty Knucklebones  -- Crushridge Bounty (36)
accept 510 |npc Syndicate Documents |at 1416 58.3,67.9  -- Foreboding Plans (34)
accept 511 |npc Syndicate Documents |at 1416 58.3,67.9  -- Encrypted Letter (34)
complete 505 |at 1416 57.6,68.5 |mobs Syndicate Footpad;Syndicate Thief |value low  -- Syndicate Assassins (33)
turnin 95798 |npc Abra Cadabra |at 1416 12.0,70.5  -- The Web of Magic (40)
accept 522 |note Starts from Assassin's Contract  -- Assassin's Contract (38)
turnin 500 |npc Marshal Redpath |at 1424 49.5,58.7  -- Crushridge Bounty (36)
turnin 511 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- Encrypted Letter (34)
accept 514 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- Letter to Stormpike (34)
turnin 522 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Assassin's Contract (38)
turnin 510 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Foreboding Plans (34)
accept 523 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Baron's Demise (40)
accept 504 |npc Marshal Redpath |at 1424 49.5,58.7 |group elite  -- Crushridge Warmongers (40)
fly 1455 55.5,47.7 |from 1424 49.3,52.3 |npc Ironforge (Gryth Thurden)  -- flight master Darla Harris
turnin 514 |npc Prospector Stormpike |at 1455 74.6,11.7  -- Letter to Stormpike (34)
accept 525 |npc Prospector Stormpike |at 1455 74.6,11.7  -- Further Mysteries (34)
fly 1424 49.3,52.3 |from 1455 55.5,47.7 |npc Hillsbrad Foothills (Darla Harris)  -- flight master Gryth Thurden
turnin 525 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Further Mysteries (34)
accept 512 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |value mid  -- Noble Deaths (36)
accept 537 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Dark Council (40)
turnin 92432 |npc Image of Archmage Modera |at 1416 14.3,59.6  -- An Alarming Request (33)
complete 504 |at 1416 36.3,53.8 |mobs Crushridge Warmonger |group elite  -- Crushridge Warmongers (40)
accept 95534 |at 1416 61.3,44.0 |note Starts from Singed Note  -- Strahnbrad Mystery (36)
complete 537 |at 1416 58.7,30.5 |mobs Argus Shadow Mage;Nagaz@Head of Nagaz  -- Dark Council (40)
complete 512 |at 1416 55.4,30.5 |mobs Syndicate Sentry@Alterac Signet Ring;Syndicate Spy@Alterac Signet Ring;Syndicate Assassin@Alterac Signet Ring;Syndicate Enforcer@Alterac Signet Ring |value mid  -- Noble Deaths (36)
complete 523 |at 1416 56.3,26.7 |mobs Baron Vardus@Head of Baron Vardus  -- Baron's Demise (40)
accept 551 |at 1416 39.2,14.7 |note Starts from Ensorcelled Parchment  -- The Ensorcelled Parchment (40)
turnin 512 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |value mid  -- Noble Deaths (36)
turnin 523 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Baron's Demise (40)
turnin 551 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- The Ensorcelled Parchment (40)
accept 554 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- Stormpike's Deciphering (40)
turnin 537 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Dark Council (40)
turnin 95534 |npc Kundric Zanden |at 1424 48.6,59.0  -- Strahnbrad Mystery (36)
turnin 505 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |value low  -- Syndicate Assassins (33)
turnin 504 |npc Marshal Redpath |at 1424 49.5,58.7 |group elite  -- Crushridge Warmongers (40)
fly 1455 55.5,47.7 |from 1424 49.3,52.3 |npc Ironforge (Gryth Thurden)  -- flight master Darla Harris
turnin 554 |npc Prospector Stormpike |at 1455 74.6,11.7  -- Stormpike's Deciphering (40)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   99191  A Donation of Wool (60)
--   99192  A Donation of Silk (60)
--   99193  A Donation of Mageweave (60)
