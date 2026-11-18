-- DRAFT The Hinterlands (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "the-hinterlands-a", title = "The Hinterlands (43-51)", faction = "Alliance", zone = "The Hinterlands",
  levels = { 43, 51 },
  steps = [[
home |npc Innkeeper Thulfram |at 1425 14.2,41.6  -- set your hearthstone at the inn
accept 1450 |npc Falstad Wildhammer |at 1425 11.8,46.8 |lvl 38 |preany 1449  -- Gryphon Master Talonaxe (43)
turnin 1450 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5  -- Gryphon Master Talonaxe (43)
accept 1451 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5 |lvl 38 |preany 1450  -- Rhapsody Shindigger (43)
accept 2990 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5 |lvl 40 |preany 2989  -- Thadius Grimshade (47)
turnin 1451 |npc Rhapsody Shindigger |at 1425 26.9,48.6  -- Rhapsody Shindigger (43)
accept 1452 |npc Rhapsody Shindigger |at 1425 26.9,48.6 |lvl 38 |preany 1451  -- Rhapsody's Kalimdor Kocktail (43)
fly 1419 65.5,24.3 |from 1425 11.1,46.1 |npc Blasted Lands (Alexandra Constantine)  -- flight master Guthrum Thunderfist
accept 2993 |npc Thadius Grimshade |at 1419 66.9,19.5 |group chain |lvl 40 |preany 2992  -- Return to the Hinterlands (47)
turnin 2990 |npc Thadius Grimshade |at 1419 66.9,19.5  -- Thadius Grimshade (47)
fly 1434 27.5,77.8 |from 1419 65.5,24.3 |npc Stranglethorn Vale (Gyll)  -- flight master Alexandra Constantine
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1444 89.5,45.9 |from 1413 63.1,37.2 |npc Feralas (Thyssiana)  -- flight master Bragok
complete 1452 |at 1444 68.1,44.8  -- Rhapsody's Kalimdor Kocktail (43)
fly 1446 51.0,29.3 |from 1444 89.5,45.9 |npc Tanaris (Bera Stonehammer)  -- flight master Thyssiana
accept 4787 |npc Yeh'kinya |at 1446 67.0,22.4 |group chain |lvl 40 |preany 3527  -- The Ancient Egg (50)
fly 1413 63.1,37.2 |from 1446 51.0,29.3 |npc The Barrens (Bragok)  -- flight master Bera Stonehammer
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1425 11.1,46.1 |from 1434 27.5,77.8 |npc Guthrum Thunderfist  -- flight master Gyll
accept 2988 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5 |lvl 40  -- Witherbark Cages (45)
turnin 2993 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5 |group chain  -- Return to the Hinterlands (47)
accept 2994 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5 |group chain |lvl 40 |preany 2993  -- Saving Sharpbeak (51)
accept 86616 |npc Farseer Maret Firetend |at 1425 14.4,42.6 |value mid |lvl 45  -- Repurposed Totems (48)
accept 2877 |npc Fraggar Thundermantle |at 1425 14.8,44.6 |value mid |lvl 40  -- Skulk Rock Clean-up (48)
accept 2880 |npc Fraggar Thundermantle |at 1425 14.8,44.6 |lvl 40  -- Troll Necklace Bounty (45)
complete 2988 |at 1425 23.3,58.8  -- Witherbark Cages (45)
complete 4787 |at 1425 57.6,86.8 |group chain  -- The Ancient Egg (50)
complete 2880 |at 1425 57.1,68.8 |mobs Vilebranch Blood Drinker@Troll Tribal Necklace;Vilebranch Aman'zasi Guard@Troll Tribal Necklace;Vilebranch Scalper@Troll Tribal Necklace;Vilebranch Soothsayer@Troll Tribal Necklace  -- Troll Necklace Bounty (45)
complete 2994 |at 1425 53.4,67.1 |group chain  -- Saving Sharpbeak (51)
complete 86616 |at 1425 48.0,65.6 |mobs Vilebranch Soothsayer@Vilebranch Totem |value mid  -- Repurposed Totems (48)
accept 485 |at 1425 53.0,53.6 |note Starts from OOX-09/HL Distress Beacon |lvl 43  -- Find OOX-09/HL! (48)
complete 2877 |at 1425 56.0,42.7 |mobs Green Sludge;Jade Ooze |value mid  -- Skulk Rock Clean-up (48)
turnin 485 |npc Homing Robot OOX-09/HL |at 1425 49.4,37.7  -- Find OOX-09/HL! (48)
turnin 1452 |npc Rhapsody Shindigger |at 1425 26.9,48.6  -- Rhapsody's Kalimdor Kocktail (43)
accept 1469 |npc Rhapsody Shindigger |at 1425 26.9,48.6 |lvl 38 |preany 1452  -- Rhapsody's Tale (43)
turnin 2880 |npc Fraggar Thundermantle |at 1425 14.8,44.6  -- Troll Necklace Bounty (45)
turnin 2877 |npc Fraggar Thundermantle |at 1425 14.8,44.6 |value mid  -- Skulk Rock Clean-up (48)
turnin 86616 |npc Farseer Maret Firetend |at 1425 14.4,42.6 |value mid  -- Repurposed Totems (48)
turnin 2988 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5  -- Witherbark Cages (45)
turnin 2994 |npc Gryphon Master Talonaxe |at 1425 9.8,44.5 |group chain  -- Saving Sharpbeak (51)
fly 1453 71.3,72.2 |from 1425 11.1,46.1 |npc Stormwind City (Dungar Longdrink)  -- flight master Guthrum Thunderfist
turnin 1469 |npc Brohann Caskbelly |at 1453 69.5,40.4  -- Rhapsody's Tale (43)
fly 1434 27.5,77.8 |from 1453 71.3,72.2 |npc Stranglethorn Vale (Gyll)  -- flight master Dungar Longdrink
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1446 51.0,29.3 |from 1413 63.1,37.2 |npc Tanaris (Bera Stonehammer)  -- flight master Bragok
turnin 4787 |npc Yeh'kinya |at 1446 67.0,22.4 |group chain  -- The Ancient Egg (50)
]]}
