-- DRAFT Alterac Mountains (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "alterac-mountains-a-1", title = "Alterac Mountains (33-38)", faction = "Alliance", zone = "Alterac Mountains",
  levels = { 33, 38 },
  next = "alterac-mountains-a-2",
  steps = [[
accept 92459 |npc Image of Archmage Modera |at 1416 14.3,59.6 |value low |lvl 24 |preany 92458,96984  -- Friend of the Kirin Tor (33)
accept 510 |npc Syndicate Documents |at 1416 58.3,67.9 |lvl 26  -- Foreboding Plans (34)
accept 511 |npc Syndicate Documents |at 1416 58.3,67.9 |lvl 30  -- Encrypted Letter (34)
turnin 511 |npc Loremaster Dibbs |at 1424 50.6,57.1  -- Encrypted Letter (34)
turnin 510 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Foreboding Plans (34)
accept 514 |npc Loremaster Dibbs |at 1424 50.6,57.1 |lvl 30 |preany 511  -- Letter to Stormpike (34)
accept 505 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |value mid |lvl 26  -- Syndicate Assassins (33)
accept 512 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |lvl 26 |preany 510  -- Noble Deaths (36)
accept 92432 |npc Emissary Jacques |at 1424 48.3,60.0 |lvl 30  -- An Alarming Request (33)
accept 500 |npc Marshal Redpath |at 1424 49.5,58.7 |lvl 30  -- Crushridge Bounty (36)
accept 522 |note Starts from Assassin's Contract |lvl 30  -- Assassin's Contract (38)
turnin 92459 |npc Archmage Celindra |at 1416 14.2,60.0 |value low  -- Friend of the Kirin Tor (33)
accept 96602 |npc Archmage Celindra |at 1416 14.2,60.0 |preany 96603  -- More Unstable Magic (0)
turnin 96602 |npc Archmage Celindra |at 1416 14.2,60.0  -- More Unstable Magic (0)
turnin 92432 |npc Image of Archmage Modera |at 1416 14.3,59.6  -- An Alarming Request (33)
complete 505 |at 1416 57.6,68.5 |mobs Syndicate Footpad;Syndicate Thief |value mid  -- Syndicate Assassins (33)
accept 95534 |at 1416 61.3,44.0 |note Starts from Singed Note |lvl 25  -- Strahnbrad Mystery (36)
complete 512 |at 1416 55.4,30.5 |mobs Syndicate Sentry@Alterac Signet Ring;Syndicate Spy@Alterac Signet Ring;Syndicate Assassin@Alterac Signet Ring;Syndicate Enforcer@Alterac Signet Ring  -- Noble Deaths (36)
complete 500 |at 1416 43.3,48.0 |mobs Crushridge Ogre@Dirty Knucklebones;Crushridge Brute@Dirty Knucklebones;Crushridge Warmonger@Dirty Knucklebones;Crushridge Mauler@Dirty Knucklebones  -- Crushridge Bounty (36)
turnin 514 |npc Prospector Stormpike |at 1455 74.6,11.7  -- Letter to Stormpike (34)
accept 525 |npc Prospector Stormpike |at 1455 74.6,11.7 |lvl 30 |preany 514  -- Further Mysteries (34)
fly 1424 49.3,52.3 |from 1455 55.5,47.7 |npc Hillsbrad Foothills (Darla Harris)  -- flight master Gryth Thurden
turnin 525 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Further Mysteries (34)
turnin 500 |npc Marshal Redpath |at 1424 49.5,58.7  -- Crushridge Bounty (36)
turnin 512 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Noble Deaths (36)
turnin 505 |npc Magistrate Henry Maleb |at 1424 48.1,59.1 |value mid  -- Syndicate Assassins (33)
turnin 95534 |npc Kundric Zanden |at 1424 48.6,59.0  -- Strahnbrad Mystery (36)
turnin 522 |npc Magistrate Henry Maleb |at 1424 48.1,59.1  -- Assassin's Contract (38)
]]}
