-- DRAFT Dustwallow Marsh (Horde) generated 2026-11-16 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /sq rec running and fix what feels wrong. Coordinates are spawn medoids.
SloppyQuesting:RegisterGuide{
  id = "dustwallow-marsh-h-1", title = "Dustwallow Marsh (35-45)", faction = "Horde", zone = "Dustwallow Marsh",
  levels = { 35, 45 },
  next = "dustwallow-marsh-h-2",
  steps = [[
accept 1201 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- Theramore Spies (35)
complete 1201 |at 1445 40.9,25.5 |mobs Theramore Infiltrator  -- Theramore Spies (35)
accept 1238 |npc Loose Dirt |at 1445 55.4,25.9  -- The Lost Report (35)
accept 1218 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3  -- Soothing Spices (35)
turnin 1238 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- The Lost Report (35)
turnin 1201 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- Theramore Spies (35)
fly 1456 47.0,49.8 |from 1445 35.6,31.9 |npc Thunder Bluff (Tal)  -- flight master Shardi
accept 1205 |npc Melor Stonehoof |at 1456 61.5,80.9  -- Deadmire (45)
fly 1445 35.6,31.9 |from 1456 47.0,49.8 |npc Shardi  -- flight master Tal
accept 1177 |npc Mudcrush Durtfeet |at 1445 35.1,38.3 |value mid  -- Hungry! (36)
accept 1268 |npc Hoofprints |at 1445 29.7,47.6  -- Suspicious Hoofprints (35)
accept 1269 |npc Theramore Guard Badge |at 1445 29.8,48.2  -- Lieutenant Paval Reethe (37)
accept 1251 |npc Black Shield |at 1445 29.6,48.6  -- The Black Shield (35)
complete 1205 |at 1445 50.2,52.7 |mobs Deadmire  -- Deadmire (45)
fly 1456 47.0,49.8 |from 1445 35.6,31.9 |npc Thunder Bluff (Tal)  -- flight master Shardi
turnin 1205 |npc Melor Stonehoof |at 1456 61.5,80.9  -- Deadmire (45)
complete 1218  -- Soothing Spices (35)
fly 1445 35.6,31.9 |from 1456 47.0,49.8 |npc Shardi  -- flight master Tal
turnin 1218 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3  -- Soothing Spices (35)
accept 1206 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid  -- Jarl Needs Eyes (35)
accept 1239 |npc Loose Dirt |at 1445 55.4,25.9  -- The Severed Head (35)
complete 1177 |at 1445 58.4,15.3 |mobs Mirefin Warrior;Mirefin Murloc;Mirefin Muckdweller;Mirefin Coastrunner |value mid  -- Hungry! (36)
complete 1206 |at 1445 32.2,22.2 |mobs Darkmist Silkspinner;Darkmist Spider;Darkmist Lurker;Darkmist Recluse |value mid  -- Jarl Needs Eyes (35)
accept 1202 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- The Theramore Docks (35)
turnin 1239 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- The Severed Head (35)
accept 1240 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- The Troll Witchdoctor (35)
fly 1434 32.5,29.4 |from 1445 35.6,31.9 |npc Stranglethorn Vale (Thysta)  -- flight master Shardi
turnin 1240 |npc Kin'weelay |at 1434 32.3,27.7  -- The Troll Witchdoctor (35)
accept 1261 |npc Bubbling Cauldron |at 1434 32.2,27.6  -- Marg Speaks (40)
fly 1445 35.6,31.9 |from 1434 32.5,29.4 |npc Shardi  -- flight master Thysta
turnin 1251 |npc Krog |at 1445 36.4,31.9  -- The Black Shield (35)
accept 1321 |npc Krog |at 1445 36.4,31.9  -- The Black Shield (35)
turnin 1321 |npc Do'gol |at 1445 36.5,30.8  -- The Black Shield (35)
accept 1322 |npc Do'gol |at 1445 36.5,30.8  -- The Black Shield (37)
accept 1168 |npc Tharg |at 1445 37.4,31.4  -- Army of the Black Dragon (43)
accept 1169 |npc Draz'Zilb |at 1445 37.1,33.1  -- Identifying the Brood (43)
complete 1169 |at 1445 45.6,72.4 |mobs Searing Hatchling;Searing Whelp  -- Identifying the Brood (43)
complete 1322 |at 1445 46.9,45.5 |mobs Darkfang Creeper;Giant Darkfang Spider;Darkfang Venomspitter;Darkfang Spider  -- The Black Shield (37)
turnin 1169 |npc Draz'Zilb |at 1445 37.1,33.1  -- Identifying the Brood (43)
accept 1170 |npc Draz'Zilb |at 1445 37.1,33.1  -- The Brood of Onyxia (43)
turnin 1170 |npc Overlord Mok'Morokk |at 1445 36.3,31.4  -- The Brood of Onyxia (43)
accept 1171 |npc Overlord Mok'Morokk |at 1445 36.3,31.4  -- The Brood of Onyxia (43)
accept 1166 |npc Overlord Mok'Morokk |at 1445 36.3,31.4  -- Overlord Mok'Morokk's Concern (43)
accept 98192 |npc Krak |at 1445 36.4,30.9  -- Skin Careful, Skin Sharp (43)
turnin 1322 |npc Do'gol |at 1445 36.5,30.8  -- The Black Shield (37)
accept 1323 |npc Do'gol |at 1445 36.5,30.8  -- The Black Shield (37)
turnin 1171 |npc Draz'Zilb |at 1445 37.1,33.1  -- The Brood of Onyxia (43)
accept 1172 |npc Draz'Zilb |at 1445 37.1,33.1  -- The Brood of Onyxia (45)
turnin 1177 |npc Mudcrush Durtfeet |at 1445 35.1,38.3 |value mid  -- Hungry! (36)
complete 98192 |at 1445 33.1,65.7 |mobs Bloodfen Lashtail;Bloodfen Razormaw  -- Skin Careful, Skin Sharp (43)
complete 1166 |at 1445 38.7,65.6  -- Overlord Mok'Morokk's Concern (43)
complete 1168 |at 1445 42.4,67.8 |mobs Firemane Scout;Firemane Ash Tail;Firemane Scalebane  -- Army of the Black Dragon (43)
complete 1172 |at 1445 48.4,76.0  -- The Brood of Onyxia (45)
complete 1261 |at 1445 56.7,61.4 |mobs Muckshell Scrabbler;Muckshell Pincer;Muckshell Snapclaw;Muckshell Clacker  -- Marg Speaks (40)
complete 1202 |at 1445 71.5,51.2  -- The Theramore Docks (35)
turnin 1206 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid  -- Jarl Needs Eyes (35)
accept 1203 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid  -- Jarl Needs a Blade (35)
complete 1203 |value mid  -- Jarl Needs a Blade (35)
turnin 1203 |npc "Swamp Eye" Jarl |at 1445 55.4,26.3 |value mid  -- Jarl Needs a Blade (35)
turnin 1168 |npc Tharg |at 1445 37.4,31.4  -- Army of the Black Dragon (43)
turnin 1172 |npc Draz'Zilb |at 1445 37.1,33.1  -- The Brood of Onyxia (45)
turnin 1268 |npc Krog |at 1445 36.4,31.9  -- Suspicious Hoofprints (35)
turnin 1323 |npc Krog |at 1445 36.4,31.9  -- The Black Shield (37)
accept 1276 |npc Krog |at 1445 36.4,31.9  -- The Black Shield (37)
turnin 1269 |npc Krog |at 1445 36.4,31.9  -- Lieutenant Paval Reethe (37)
turnin 1166 |npc Overlord Mok'Morokk |at 1445 36.3,31.4  -- Overlord Mok'Morokk's Concern (43)
turnin 98192 |npc Krak |at 1445 36.4,30.9  -- Skin Careful, Skin Sharp (43)
turnin 1261 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- Marg Speaks (40)
accept 1262 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- Report to Zor (40)
fly 1454 45.1,63.9 |from 1445 35.6,31.9 |npc Orgrimmar (Doras)  -- flight master Shardi
turnin 1262 |npc Zor Lonetree |at 1454 38.9,38.4  -- Report to Zor (40)
accept 7541 |npc Zor Lonetree |at 1454 38.9,38.4  -- Service to the Horde (40)
turnin 7541 |npc Zor Lonetree |at 1454 38.9,38.4  -- Service to the Horde (40)
fly 1445 35.6,31.9 |from 1454 45.1,63.9 |npc Shardi  -- flight master Doras
turnin 1202 |npc Nazeer Bloodpike |at 1445 35.2,30.7  -- The Theramore Docks (35)
fly 1456 47.0,49.8 |from 1445 35.6,31.9 |npc Thunder Bluff (Tal)  -- flight master Shardi
turnin 1276 |npc Mosarn |at 1456 54.0,80.8  -- The Black Shield (37)
]]}
