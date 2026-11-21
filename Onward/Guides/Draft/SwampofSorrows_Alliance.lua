-- DRAFT Swamp of Sorrows (Alliance) generated 2026-11-20 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "swamp-of-sorrows-a", title = "Swamp of Sorrows (35-42)", faction = "Alliance", zone = "Swamp of Sorrows",
  levels = { 35, 42 },
  steps = [[
accept 93585 |npc Father Tuttle |at 1435 22.3,50.4 |lvl 30  -- This Light of Mine (34)
accept 1396 |npc Watcher Biggs |at 1435 26.7,59.8 |lvl 30  -- Encroaching Wildlife (37)
complete 1396 |at 1435 30.0,52.5 |areas 38.6,35.3:19;24.6,39.2:15;30.0,52.5:14 |mobs Young Sawtooth Crocolisk;Sorrow Spinner;Swamp Jaguar  -- Encroaching Wildlife (37)
turnin 1396 |npc Watcher Biggs |at 1435 26.7,59.8  -- Encroaching Wildlife (37)
accept 1421 |npc Watcher Biggs |at 1435 26.7,59.8 |lvl 30 |preany 1396  -- The Lost Caravan (35)
accept 93176 |npc Amaryllis Webb |at 1435 25.2,54.0 |lvl 25  -- My Little Friends (35)
accept 93429 |npc Karana |at 1435 24.7,32.6 |lvl 30  -- Blood of My Blood (35)
turnin 93429 |npc Karana |at 1435 24.7,32.6  -- Blood of My Blood (35)
turnin 93585 |npc Magtoor |at 1435 26.0,31.4  -- This Light of Mine (34)
accept 1389 |npc Magtoor |at 1435 26.0,31.4 |lvl 30  -- Draenethyst Crystals (35)
accept 93430 |npc Pelluk |at 1435 26.5,30.4 |lvl 30  -- Taking the Bait Back (35)
accept 1392 |at 1435 54.9,34.1 |note Starts from Noboru's Cudgel |startitem 6196 |lvl 29  -- Noboru the Cudgel (39)
complete 93430 |at 1435 53.7,30.6 |mobs Lost One Fisherman@Lucky Lure  -- Taking the Bait Back (35)
complete 1389 |at 1435 62.3,23.6  -- Draenethyst Crystals (35)
complete 1421 |at 1435 64.5,18.3  -- The Lost Caravan (35)
turnin 93430 |npc Pelluk |at 1435 26.5,30.4  -- Taking the Bait Back (35)
turnin 1389 |npc Magtoor |at 1435 26.0,31.4  -- Draenethyst Crystals (35)
turnin 1392 |npc Magtoor |at 1435 26.0,31.4  -- Noboru the Cudgel (39)
accept 93464 |npc Magtoor |at 1435 26.0,31.4 |lvl 30 |preany 1389  -- The Visiting Mage (38)
turnin 1421 |npc Watcher Biggs |at 1435 26.7,59.8  -- The Lost Caravan (35)
accept 1398 |npc Watcher Biggs |at 1435 26.7,59.8 |lvl 30 |preany 1421  -- Driftwood (42)
complete 93176 |at 1435 62.9,67.6 |item 213565 |mobs Deathstrike Tarantula  -- My Little Friends (35)
complete 1398 |at 1435 84.8,87.7 |areas 84.8,87.7:5;91.9,68.6:5;90.0,25.9:4;80.5,9.4:3  -- Driftwood (42)
accept 1116 |npc Krazek |at 1434 26.9,77.2 |value mid |lvl 30 |preany 1115  -- Dream Dust in the Swamp (36)
turnin 1398 |npc Watcher Biggs |at 1435 26.7,59.8  -- Driftwood (42)
accept 94929 |npc Watcher Biggs |at 1435 26.7,59.8 |lvl 36 |preany 1398  -- Deliver the Second Shipment (38)
accept 1425 |npc Watcher Biggs |at 1435 26.7,59.8 |lvl 30 |preany 1398  -- Deliver the Shipment (42)
turnin 93176 |npc Amaryllis Webb |at 1435 25.2,54.0  -- My Little Friends (35)
complete 1116 |at 1435 14.3,61.3 |areas 14.3,61.3:13;86.0,45.9:10;62.2,41.7:9;76.6,68.8:7 |mobs Scalebane Captain@Speck of Dream Dust;Green Scalebane@Speck of Dream Dust;Adolescent Whelp@Speck of Dream Dust;Wyrmkin Dreamwalker@Speck of Dream Dust |value mid  -- Dream Dust in the Swamp (36)
turnin 1425 |npc Quartermaster Lungertz |at 1419 66.5,21.4  -- Deliver the Shipment (42)
turnin 94929 |npc Demar Brant |at 2548 66.7,81.0  -- Deliver the Second Shipment (38)
turnin 1116 |npc Krazek |at 1434 26.9,77.2 |value mid  -- Dream Dust in the Swamp (36)
accept 79953 |npc Owen Thadd |at 1458 73.4,33.0  -- A Ludite's Guide to Caring for Your Demonic Pet (35)
complete 79953  -- A Ludite's Guide to Caring for Your Demonic Pet (35)
turnin 79953 |npc Owen Thadd |at 1458 73.4,33.0  -- A Ludite's Guide to Caring for Your Demonic Pet (35)
turnin 93464 |npc Azore Aldamort |at 1443 38.9,27.2  -- The Visiting Mage (38)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   3374  The Essence of Eranikus (55)
--   3512  In Eranikus' Own Words (55)
