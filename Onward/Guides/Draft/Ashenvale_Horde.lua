-- DRAFT Ashenvale (Horde) generated 2026-11-18 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "ashenvale-h", title = "Ashenvale (20-30)", faction = "Horde", zone = "Ashenvale",
  levels = { 20, 30 },
  steps = [[
accept 216 |npc Karang Amakkar |at 1440 11.9,34.5 |lvl 21  -- Between a Rock and a Thistlefur (24)
accept 6462 |npc Mitsuwa |at 1440 11.7,34.9 |value mid |lvl 19  -- Troll Charm (24)
accept 6442 |npc Marukai |at 1440 11.7,34.9 |value low |lvl 14  -- Naga at the Zoram Strand (19)
complete 6442 |at 1440 11.3,28.0 |areas 7.8,14.4:38;11.3,28.0:37 |mobs Wrathtail Sorceress@Wrathtail Head;Wrathtail Priestess@Wrathtail Head;Wrathtail Myrmidon@Wrathtail Head;Wrathtail Razortail@Wrathtail Head |value low  -- Naga at the Zoram Strand (19)
complete 6462 |at 1440 40.9,33.6 |value mid  -- Troll Charm (24)
complete 216 |at 1440 35.7,36.9 |mobs Thistlefur Avenger;Thistlefur Shaman  -- Between a Rock and a Thistlefur (24)
turnin 6442 |npc Marukai |at 1440 11.7,34.9 |value low  -- Naga at the Zoram Strand (19)
turnin 6462 |npc Mitsuwa |at 1440 11.7,34.9 |value mid  -- Troll Charm (24)
turnin 216 |npc Karang Amakkar |at 1440 11.9,34.5  -- Between a Rock and a Thistlefur (24)
accept 6621 |npc Karang Amakkar |at 1440 11.9,34.5 |lvl 21 |preany 216  -- King of the Foulweald (26)
fly 1440 73.2,61.6 |from 1440 12.2,33.8 |npc Vhulgra  -- flight master Andruk
home |npc Innkeeper Kaylisk |at 1440 74.0,60.6  -- set your hearthstone at the inn
accept 6571 |npc Locke Okarr |at 1440 71.4,67.6 |lvl 22  -- Warsong Supplies (27)
accept 6383 |npc Senani Thunderheart |at 1440 73.8,61.5 |lvl 20  -- The Ashenvale Hunt (20)
turnin 6383 |npc Senani Thunderheart |at 1440 73.8,61.5  -- The Ashenvale Hunt (20)
accept 6441 |npc Pixel |at 1440 73.1,61.5 |value mid |lvl 21  -- Satyr Horns (26)
complete 6441 |at 1440 67.3,54.6 |areas 80.5,48.6:54;67.3,54.6:25 |mobs Bleakheart Shadowstalker@Satyr Horns;Xavian Felsworn@Satyr Horns;Felmusk Shadowstalker@Satyr Horns;Bleakheart Hellcaller@Satyr Horns |value mid  -- Satyr Horns (26)
accept 24 |at 1440 57.5,56.0 |note Starts from Shadumbra's Head |startitem 16304 |lvl 20 |preany 6383  -- Shadumbra's Head (27)
complete 6621 |at 1440 56.4,63.5 |item 16972 |mobs Chief Murgut@Murgut's Totem  -- King of the Foulweald (26)
complete 6571 |at 1440 53.8,62.0 |areas 37.9,34.5:72;53.8,62.0:42 |mobs Thistlefur Shaman@Logging Rope;Thistlefur Avenger@Logging Rope;Thistlefur Totemic@Logging Rope;Foulweald Warrior@Logging Rope  -- Warsong Supplies (27)
accept 23 |at 1440 39.8,65.2 |note Starts from Ursangous's Paw |startitem 16303 |lvl 20 |preany 6383  -- Ursangous's Paw (24)
accept 78132 |npc Alonso |at 1440 43.4,70.4 |lvl 15  -- Dragonslayer's Helm (25)
accept 78134 |npc Alonso |at 1440 43.4,70.4 |lvl 15  -- Dragonslayer's Lance (25)
complete 78132  -- Dragonslayer's Helm (25)
turnin 78132 |npc Alonso |at 1440 43.4,70.4  -- Dragonslayer's Helm (25)
complete 78134  -- Dragonslayer's Lance (25)
turnin 78134 |npc Alonso |at 1440 43.4,70.4  -- Dragonslayer's Lance (25)
accept 78133 |npc Alonso |at 1440 43.4,70.4 |lvl 15  -- Dragonslayer's Shield (25)
complete 78133  -- Dragonslayer's Shield (25)
turnin 78133 |npc Alonso |at 1440 43.4,70.4  -- Dragonslayer's Shield (25)
accept 1918 |at 1440 46.0,70.0 |note Starts from Befouled Water Globe |startitem 16408 |lvl 23  -- The Befouled Element (27)
accept 6504 |npc Gurda Ragescar |at 1440 70.0,71.2 |value mid |lvl 23  -- The Lost Pages (30)
accept 6503 |npc Kuray'bin |at 1440 71.1,68.1 |lvl 19  -- Ashenvale Outrunners (24)
turnin 6571 |npc Locke Okarr |at 1440 71.4,67.6  -- Warsong Supplies (27)
complete 6504 |at 1440 73.6,63.6 |mobs Splintertree Guard;Shredder 9000;Warsong Shredder;Splintertree Raider |value mid  -- The Lost Pages (30)
accept 2 |at 1440 75.0,70.1 |note Starts from Sharptalon's Claw |startitem 16305 |lvl 20 |preany 6383  -- Sharptalon's Claw (30)
complete 6503 |at 1440 73.6,70.8 |mobs Ashenvale Outrunner  -- Ashenvale Outrunners (24)
turnin 6504 |npc Gurda Ragescar |at 1440 70.0,71.2 |value mid  -- The Lost Pages (30)
turnin 6503 |npc Kuray'bin |at 1440 71.1,68.1  -- Ashenvale Outrunners (24)
turnin 6441 |npc Pixel |at 1440 73.1,61.5 |value mid  -- Satyr Horns (26)
turnin 24 |npc Senani Thunderheart |at 1440 73.8,61.5  -- Shadumbra's Head (27)
turnin 2 |npc Senani Thunderheart |at 1440 73.8,61.5  -- Sharptalon's Claw (30)
turnin 23 |npc Senani Thunderheart |at 1440 73.8,61.5  -- Ursangous's Paw (24)
accept 247 |npc Senani Thunderheart |at 1440 73.8,61.5 |lvl 20 |pre 2,23,24  -- The Hunt Completed (30)
turnin 247 |npc Senani Thunderheart |at 1440 73.8,61.5  -- The Hunt Completed (30)
turnin 1918 |npc Mastok Wrilehiss |at 1440 73.7,60.0  -- The Befouled Element (27)
accept 824 |npc Mastok Wrilehiss |at 1440 73.7,60.0 |lvl 23 |preany 1918  -- Je'neu of the Earthen Ring (27)
fly 1440 12.2,33.8 |from 1440 73.2,61.6 |npc Andruk  -- flight master Vhulgra
turnin 6621 |npc Karang Amakkar |at 1440 11.9,34.5  -- King of the Foulweald (26)
turnin 824 |npc Je'neu Sancrea |at 1440 11.6,34.3  -- Je'neu of the Earthen Ring (27)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   79098  Clear the Forest! (60)
