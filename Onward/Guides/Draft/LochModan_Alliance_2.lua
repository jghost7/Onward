-- DRAFT Loch Modan (Alliance) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "loch-modan-a-2", title = "Loch Modan (17-22)", faction = "Alliance", zone = "Loch Modan",
  levels = { 17, 22 },
  steps = [[
accept 217 |npc Captain Rugelfuss |at 1432 23.2,73.7 |value mid  -- In Defense of the King's Lands (17)
accept 86585 |npc Mountaineer Ylva |at 1432 31.8,86.3  -- Banner of the Fallen (17)
complete 217 |at 1432 34.6,90.5 |mobs Grawmug;Gnasher;Brawler |value mid  -- In Defense of the King's Lands (17)
complete 86585 |at 1432 31.4,85.4 |mobs Headsplitter  -- Banner of the Fallen (17)
turnin 217 |npc Captain Rugelfuss |at 1432 23.2,73.7 |value mid  -- In Defense of the King's Lands (17)
turnin 86585 |npc Captain Rugelfuss |at 1432 23.2,73.7  -- Banner of the Fallen (17)
home |npc Innkeeper Hearthstove |at 1432 35.5,48.4  -- set your hearthstone at the inn
accept 255 |npc Magistrate Bluntnose |at 1432 34.6,44.5 |group elite  -- Mercenaries (19)
accept 256 |npc WANTED |at 1432 37.3,46.5 |group elite  -- WANTED: Chok'sul (22)
accept 436 |npc Jern Hornhelm |at 1432 37.2,47.4  -- Ironband's Excavation (18)
accept 86614 |npc Discarded Fishing Toolbox |at 1432 45.7,43.3  -- Silver of the Waves (20)
turnin 86614 |npc Khara Deepwater |at 1432 40.3,39.3  -- Silver of the Waves (20)
accept 250 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6  -- A Dark Threat Looms (18)
turnin 250 |npc Suspicious Barrel |at 1432 56.0,13.2  -- A Dark Threat Looms (18)
accept 199 |npc Suspicious Barrel |at 1432 56.0,13.2  -- A Dark Threat Looms (18)
turnin 199 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6  -- A Dark Threat Looms (18)
accept 161 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6  -- A Dark Threat Looms (18)
fly 1437 9.5,59.7 |from 1432 33.9,51.0 |npc Wetlands (Shellei Brondir)  -- flight master Thorgrum Borrelson
turnin 161 |npc Ashlan Stonesmirk |at 1437 50.0,18.2  -- A Dark Threat Looms (18)
accept 274 |npc Ashlan Stonesmirk |at 1437 50.0,18.2  -- A Dark Threat Looms (18)
fly 1432 33.9,51.0 |from 1437 9.5,59.7 |npc Thorgrum Borrelson  -- flight master Shellei Brondir
accept 258 |npc Daryl the Youngling |at 1432 83.5,65.5 |value mid  -- A Hunter's Challenge (17)
complete 256 |at 1432 79.6,14.7 |mobs Chok'sul |group elite  -- WANTED: Chok'sul (22)
complete 255 |at 1432 70.7,22.8 |mobs Mo'grosh Ogre;Mo'grosh Brute;Mo'grosh Enforcer |group elite  -- Mercenaries (19)
turnin 274 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6  -- A Dark Threat Looms (18)
accept 278 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6 |group elite  -- A Dark Threat Looms (18)
complete 258 |at 1432 64.9,38.8 |mobs Elder Mountain Boar |value mid  -- A Hunter's Challenge (17)
complete 278 |at 1432 61.4,42.5 |mobs Daggerfang;Forest Lurker;Loch Crocolisk;Mo'grosh Enforcer |group elite  -- A Dark Threat Looms (18)
turnin 258 |npc Daryl the Youngling |at 1432 83.5,65.5 |value mid  -- A Hunter's Challenge (17)
accept 271 |npc Vyrin Swiftwind |at 1432 81.7,64.1 |value mid |group elite  -- Vyrin's Revenge (20)
accept 86613 |at 1432 69.4,67.5 |note Starts from Excavation Tools  -- Excavation Tools (18)
complete 86613 |at 1432 69.4,67.5  -- Excavation Tools (18)
accept 297 |npc Magmar Fellhew |at 1432 64.9,66.7 |value mid  -- Gathering Idols (18)
complete 297 |at 1432 70.6,64.8 |mobs Stonesplinter Digger;Stonesplinter Geomancer;Berserk Trogg |value mid  -- Gathering Idols (18)
turnin 86613 |npc Prospector Ironband |at 1432 65.9,65.6  -- Excavation Tools (18)
turnin 436 |npc Magmar Fellhew |at 1432 64.9,66.7  -- Ironband's Excavation (18)
turnin 297 |npc Magmar Fellhew |at 1432 64.9,66.7 |value mid  -- Gathering Idols (18)
complete 271 |at 1432 37.9,63.4 |mobs Ol' Sooty |value mid |group elite  -- Vyrin's Revenge (20)
turnin 256 |npc Magistrate Bluntnose |at 1432 34.6,44.5 |group elite  -- WANTED: Chok'sul (22)
turnin 255 |npc Magistrate Bluntnose |at 1432 34.6,44.5 |group elite  -- Mercenaries (19)
turnin 278 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6 |group elite  -- A Dark Threat Looms (18)
accept 280 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6 |group chain  -- A Dark Threat Looms (18)
turnin 280 |npc Explosive Charge |at 1432 50.6,14.3 |group chain  -- A Dark Threat Looms (18)
accept 283 |npc Explosive Charge |at 1432 50.6,14.3 |group chain  -- A Dark Threat Looms (20)
turnin 283 |npc Chief Engineer Hinderweir VII |at 1432 46.0,13.6 |group chain  -- A Dark Threat Looms (20)
turnin 271 |npc Daryl the Youngling |at 1432 83.5,65.5 |value mid |group elite  -- Vyrin's Revenge (20)
accept 531 |npc Daryl the Youngling |at 1432 83.5,65.5 |value mid |group chain  -- Vyrin's Revenge (20)
turnin 531 |npc Vyrin Swiftwind |at 1432 81.7,64.1 |value mid |group chain  -- Vyrin's Revenge (20)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   79975  Eagle's Fist (32)
--   2500  Badlands Reagent Run (39)
--   3182  Proof of Deed (48)
