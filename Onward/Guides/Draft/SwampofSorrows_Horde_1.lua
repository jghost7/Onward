-- DRAFT Swamp of Sorrows (Horde) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "swamp-of-sorrows-h-1", title = "Swamp of Sorrows (35-40)", faction = "Horde", zone = "Swamp of Sorrows",
  levels = { 35, 40 },
  next = "swamp-of-sorrows-h-2",
  steps = [[
accept 1389 |npc Magtoor |at 1435 26.0,31.4 |lvl 30  -- Draenethyst Crystals (35)
accept 93430 |npc Pelluk |at 1435 26.5,30.4 |lvl 30  -- Taking the Bait Back (35)
accept 93176 |npc Amaryllis Webb |at 1435 25.2,54.0 |lvl 25  -- My Little Friends (35)
accept 698 |npc Dar |at 1435 44.7,57.2 |value mid |lvl 35  -- Lack of Surplus (40)
accept 93663 |npc Dar |at 1435 44.7,57.2 |lvl 30  -- Lost in Transit (35)
accept 1418 |npc Helgrum the Swift |at 1435 47.7,55.2 |lvl 30  -- Neeka Bloodscar (35)
complete 698 |at 1435 53.6,55.6 |areas 75.5,19.4:9;52.2,41.5:8;53.6,55.6:7 |mobs Sawtooth Snapper@Unprepared Sawtooth Flank;Sawtooth Crocolisk@Unprepared Sawtooth Flank |value mid  -- Lack of Surplus (40)
complete 93176 |at 1435 62.9,67.6 |item 213565 |mobs Deathstrike Tarantula  -- My Little Friends (35)
turnin 698 |npc Tok'Kar |at 1435 81.3,81.0 |value mid  -- Lack of Surplus (40)
complete 1389 |at 1435 62.3,23.6  -- Draenethyst Crystals (35)
complete 93430 |at 1435 53.7,30.6 |mobs Lost One Fisherman@Lucky Lure  -- Taking the Bait Back (35)
accept 1392 |at 1435 54.9,34.1 |note Starts from Noboru's Cudgel |startitem 6196 |lvl 29  -- Noboru the Cudgel (39)
turnin 93430 |npc Pelluk |at 1435 26.5,30.4  -- Taking the Bait Back (35)
turnin 1389 |npc Magtoor |at 1435 26.0,31.4  -- Draenethyst Crystals (35)
complete 93663  -- Lost in Transit (35)
turnin 93663 |npc Magtoor |at 1435 26.0,31.4  -- Lost in Transit (35)
turnin 1392 |npc Magtoor |at 1435 26.0,31.4  -- Noboru the Cudgel (39)
accept 93464 |npc Magtoor |at 1435 26.0,31.4 |lvl 30 |preany 1389  -- The Visiting Mage (38)
accept 93429 |npc Karana |at 1435 24.7,32.6 |lvl 30  -- Blood of My Blood (35)
turnin 93429 |npc Karana |at 1435 24.7,32.6  -- Blood of My Blood (35)
turnin 93176 |npc Amaryllis Webb |at 1435 25.2,54.0  -- My Little Friends (35)
fly 1434 26.9,77.1 |from 1435 46.1,54.8 |npc Stranglethorn Vale (Gringer)  -- flight master Breyk
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1443 21.6,74.1 |from 1413 63.1,37.2 |npc Desolace (Thalon)  -- flight master Bragok
turnin 93464 |npc Azore Aldamort |at 1443 38.9,27.2  -- The Visiting Mage (38)
fly 1413 63.1,37.2 |from 1443 21.6,74.1 |npc The Barrens (Bragok)  -- flight master Thalon
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1418 4.0,44.8 |from 1434 26.9,77.1 |npc Badlands (Gorrik)  -- flight master Gringer
turnin 1418 |npc Neeka Bloodscar |at 1418 6.5,47.2  -- Neeka Bloodscar (35)
fly 1434 26.9,77.1 |from 1418 4.0,44.8 |npc Stranglethorn Vale (Gringer)  -- flight master Gorrik
accept 1116 |npc Krazek |at 1434 26.9,77.2 |lvl 30 |preany 1115  -- Dream Dust in the Swamp (36)
fly 1435 46.1,54.8 |from 1434 26.9,77.1 |npc Breyk  -- flight master Gringer
complete 1116 |at 1435 14.3,61.3 |areas 14.3,61.3:13;86.0,45.9:10;62.2,41.7:9;76.6,68.8:7 |mobs Scalebane Captain@Speck of Dream Dust;Green Scalebane@Speck of Dream Dust;Adolescent Whelp@Speck of Dream Dust;Wyrmkin Dreamwalker@Speck of Dream Dust  -- Dream Dust in the Swamp (36)
fly 1458 63.2,48.6 |from 1435 46.1,54.8 |npc Undercity (Michael Garrett)  -- flight master Breyk
accept 79953 |npc Owen Thadd |at 1458 73.4,33.0  -- A Ludite's Guide to Caring for Your Demonic Pet (35)
complete 79953  -- A Ludite's Guide to Caring for Your Demonic Pet (35)
turnin 79953 |npc Owen Thadd |at 1458 73.4,33.0  -- A Ludite's Guide to Caring for Your Demonic Pet (35)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
turnin 1116 |npc Krazek |at 1434 26.9,77.2  -- Dream Dust in the Swamp (36)
]]}
