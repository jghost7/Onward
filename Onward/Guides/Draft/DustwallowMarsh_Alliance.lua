-- DRAFT Dustwallow Marsh (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "dustwallow-marsh-a", title = "Dustwallow Marsh (35-44)", faction = "Alliance", zone = "Dustwallow Marsh",
  levels = { 35, 44 },
  steps = [[
home |npc Innkeeper Janene |at 1445 66.6,45.2  -- set your hearthstone at the inn
accept 1133 |npc Fiora Longears |at 1445 66.5,45.1 |lvl 18  -- Journey to Astranaar (20)
accept 1135 |npc Fiora Longears |at 1445 66.5,45.1 |lvl 25  -- Highperch Venom (30)
accept 1204 |npc Morgan Stern |at 1445 66.3,45.5 |lvl 33  -- Mudrock Soup and Bugs (38)
accept 98233 |npc Guard Jameson |at 1445 65.5,45.4 |lvl 36  -- Sword in the Slime (42)
complete 1204 |at 1445 56.2,44.2 |mobs Mudrock Burrower@Forked Mudrock Tongue;Mudrock Tortoise@Forked Mudrock Tongue;Mudrock Borer@Forked Mudrock Tongue;Mudrock Snapjaw@Forked Mudrock Tongue  -- Mudrock Soup and Bugs (38)
accept 1253 |npc Black Shield |at 1445 29.6,48.6 |lvl 30 |preany 1302,1282  -- The Black Shield (35)
accept 1252 |npc Theramore Guard Badge |at 1445 29.8,48.2 |lvl 30 |preany 1302,1282  -- Lieutenant Paval Reethe (40)
accept 1284 |npc Hoofprints |at 1445 29.7,47.6 |lvl 30 |preany 1282,1302  -- Suspicious Hoofprints (35)
accept 1177 |npc Mudcrush Durtfeet |at 1445 35.1,38.3 |value mid |lvl 32  -- Hungry! (36)
complete 1177 |at 1445 58.4,15.3 |mobs Mirefin Warrior@Mirefin Head;Mirefin Murloc@Mirefin Head;Mirefin Muckdweller@Mirefin Head;Mirefin Coastrunner@Mirefin Head |value mid  -- Hungry! (36)
accept 1219 |npc Loose Dirt |at 1445 55.4,25.9 |lvl 30  -- The Orc Report (35)
accept 1218 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |lvl 30  -- Soothing Spices (35)
turnin 1204 |npc Morgan Stern |at 1445 66.3,45.5  -- Mudrock Soup and Bugs (38)
accept 1258 |npc Morgan Stern |at 1445 66.3,45.5 |lvl 33 |preany 1204  -- ... and Bugs (40)
accept 1282 |npc Guard Byron |at 1445 66.2,46.1 |lvl 30  -- They Call Him Smiling Jim (35)
turnin 1252 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- Lieutenant Paval Reethe (40)
accept 1259 |npc Captain Garran Vimes |at 1445 68.2,48.6 |lvl 30 |preany 1252  -- Lieutenant Paval Reethe (40)
turnin 1259 |npc Adjutant Tesoran |at 1445 68.0,48.1  -- Lieutenant Paval Reethe (40)
accept 1285 |npc Adjutant Tesoran |at 1445 68.0,48.1 |lvl 30 |preany 1259  -- Daelin's Men (38)
turnin 1284 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- Suspicious Hoofprints (35)
turnin 1285 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- Daelin's Men (38)
turnin 1282 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- They Call Him Smiling Jim (35)
turnin 1253 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- The Black Shield (35)
accept 1286 |npc Captain Garran Vimes |at 1445 68.2,48.6 |lvl 30 |preany 1285  -- The Deserters (38)
accept 1319 |npc Captain Garran Vimes |at 1445 68.2,48.6 |lvl 30 |preany 1253  -- The Black Shield (35)
turnin 1319 |npc Caz Twosprocket |at 1445 64.8,50.4  -- The Black Shield (35)
accept 1320 |npc Caz Twosprocket |at 1445 64.8,50.4 |lvl 30 |preany 1319  -- The Black Shield (35)
complete 1218 |at 1445 52.0,54.6 |mobs Acidic Swamp Ooze;Bubbling Swamp Ooze;Corrosive Swamp Ooze;Swamp Ooze  -- Soothing Spices (35)
complete 98233 |at 1445 49.3,55.7 |mobs Corrosive Swamp Ooze@Jameson's Training Sword  -- Sword in the Slime (42)
turnin 1286 |npc Balos Jacken |at 1445 36.1,54.3  -- The Deserters (38)
accept 1287 |npc Balos Jacken |at 1445 36.1,54.3 |lvl 30 |preany 1286  -- The Deserters (38)
accept 98215 |npc Drazzit Dripvalve |at 1445 41.0,75.7  -- Dragon Scales, Post Burnt Tails (44)
accept 98205 |npc Drazzit Dripvalve |at 1445 41.0,75.7  -- Whelps are the Worst! (44)
complete 98215 |at 1445 45.6,72.4 |mobs Searing Hatchling@Shed Dark Dragonscale;Searing Whelp@Shed Dark Dragonscale;Firemane Scout@Shed Dark Dragonscale;Firemane Ash Tail@Shed Dark Dragonscale  -- Dragon Scales, Post Burnt Tails (44)
complete 98205 |at 1445 45.4,73.2 |mobs Searing Hatchling;Searing Whelp  -- Whelps are the Worst! (44)
accept 98231 |npc Gizzix Grimegurgle |at 1445 41.0,75.7  -- Active Ingredient (44)
turnin 98215 |npc Drazzit Dripvalve |at 1445 41.0,75.7  -- Dragon Scales, Post Burnt Tails (44)
turnin 98205 |npc Drazzit Dripvalve |at 1445 41.0,75.7  -- Whelps are the Worst! (44)
complete 98231  -- Active Ingredient (44)
turnin 98231 |npc Gizzix Grimegurgle |at 1445 41.0,75.7  -- Active Ingredient (44)
complete 1135 |at 1441 12.3,37.1  -- Highperch Venom (30)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1453 71.3,72.2 |from 1434 27.5,77.8 |npc Stormwind City (Dungar Longdrink)  -- flight master Gyll
accept 1271 |npc Angus Stern |at 1453 51.8,93.6 |lvl 30 |preany 1222  -- Feast at the Blue Recluse (37)
turnin 1271 |npc Angus Stern |at 1453 51.8,93.6  -- Feast at the Blue Recluse (37)
accept 1260 |npc Angus Stern |at 1453 51.8,93.6 |lvl 33  -- Morgan Stern (38)
fly 1434 27.5,77.8 |from 1453 71.3,72.2 |npc Stranglethorn Vale (Gyll)  -- flight master Dungar Longdrink
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1440 34.4,48.0 |from 1413 63.1,37.2 |npc Ashenvale (Daelyshia)  -- flight master Bragok
turnin 1133 |npc Shindrell Swiftfire |at 1440 34.7,48.8  -- Journey to Astranaar (20)
fly 1413 63.1,37.2 |from 1440 34.4,48.0 |npc The Barrens (Bragok)  -- flight master Daelyshia
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
complete 1258 |at 1435 96.0,57.6  -- ... and Bugs (40)
goto 1437 4.6,57.1 15 |note Take the boat to Theramore  -- boat Menethil Harbor to Theramore
turnin 1177 |npc Mudcrush Durtfeet |at 1445 35.1,38.3 |value mid  -- Hungry! (36)
turnin 1218 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3  -- Soothing Spices (35)
accept 1206 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid |lvl 30 |preany 1218  -- Jarl Needs Eyes (35)
complete 1206 |at 1445 32.2,22.2 |mobs Darkmist Silkspinner@Unpopped Darkmist Eye;Darkmist Spider@Unpopped Darkmist Eye;Darkmist Lurker@Unpopped Darkmist Eye;Darkmist Recluse@Unpopped Darkmist Eye |value mid  -- Jarl Needs Eyes (35)
turnin 1206 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid  -- Jarl Needs Eyes (35)
accept 1203 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid |lvl 30 |preany 1206  -- Jarl Needs a Blade (35)
complete 1203 |value mid  -- Jarl Needs a Blade (35)
turnin 1203 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid  -- Jarl Needs a Blade (35)
turnin 98233 |npc Guard Jameson |at 1445 65.5,45.4  -- Sword in the Slime (42)
turnin 1135 |npc Fiora Longears |at 1445 66.5,45.1  -- Highperch Venom (30)
turnin 1258 |npc Morgan Stern |at 1445 66.3,45.5  -- ... and Bugs (40)
turnin 1260 |npc Morgan Stern |at 1445 66.3,45.5  -- Morgan Stern (38)
turnin 1219 |npc Theramore Lieutenant |at 1445 68.0,48.0  -- The Orc Report (35)
accept 1220 |npc Theramore Lieutenant |at 1445 68.0,48.0 |lvl 30 |preany 1219  -- Captain Vimes (35)
turnin 1320 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- The Black Shield (35)
turnin 1220 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- Captain Vimes (35)
turnin 1287 |npc Captain Garran Vimes |at 1445 68.2,48.6  -- The Deserters (38)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   95194  Our Man in Theramore (53)
--   95196  Watch Yer Back (53)
--   95198  The Return of the King? (53)
--   95262  The Secret Prison (53)
--   95263  Somber News (53)
--   96381  A Bit of Wet Work (53)
--   8970  I See Alcaz Island In Your Future... (60)
