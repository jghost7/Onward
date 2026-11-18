-- DRAFT Desolace (Horde) generated 2026-11-18 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "desolace-h-2", title = "Desolace (40-45)", faction = "Horde", zone = "Desolace",
  levels = { 40, 45 },
  steps = [[
accept 1381 |npc Warug |at 1443 75.0,68.2 |group elite |lvl 30 |preany 1375  -- Khan Hratha (42)
accept 93225 |npc Gurda Wildmane |at 1443 56.3,59.7 |value low |lvl 30  -- Carved Centaur Totems (40)
accept 94872 |npc Gurda Wildmane |at 1443 56.3,59.7 |value low |lvl 30 |preany 93224,93225  -- Buying Friendship: Magram (45)
accept 1488 |npc Takata Steelblade |at 1443 52.6,54.4 |group elite |lvl 25 |preany 1484  -- The Corrupter (40)
accept 79229 |npc Extinguished Campfire |at 1443 47.5,54.6 |lvl 30  -- Highway Robbery (40)
accept 96222 |npc Umarak |at 1443 43.5,79.0 |group elite |lvl 35  -- Khan Hratha (42)
accept 1380 |npc Uthek the Wise |at 1443 36.2,79.2 |group elite |lvl 30 |preany 1374  -- Khan Hratha (42)
complete 96222 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
complete 1381 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
complete 1380 |at 1443 29.6,52.0 |mobs Khan Hratha@Maraudine Key Fragment |group elite  -- Khan Hratha (42)
accept 93465 |npc Azore Aldamort |at 1443 38.9,27.2 |value mid |lvl 30 |preany 93464  -- Notes on Draenethyst (40)
turnin 79229 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0  -- Highway Robbery (40)
accept 79235 |npc Bibbly F'utzbuckle |at 1443 62.3,39.0 |lvl 30 |preany 79229  -- On the Lam (40)
complete 93225 |at 1443 71.5,45.5 |areas 68.6,77.3:119;36.4,85.0:73;71.5,45.5:56;30.8,55.7:48 |mobs Magram Guardian@Carved Centaur Totem;Gelkis Windchaser@Carved Centaur Totem;Gelkis Stamper@Carved Centaur Totem;Magram Wrangler@Carved Centaur Totem |value low  -- Carved Centaur Totems (40)
accept 92743 |npc Warug |at 1443 75.0,68.2 |lvl 30 |preany 1369  -- A Conqueror's Crown (40)
turnin 92743 |npc Warug |at 1443 75.0,68.2  -- A Conqueror's Crown (40)
turnin 1381 |npc Warug |at 1443 75.0,68.2 |group elite  -- Khan Hratha (42)
complete 93465 |at 1443 80.9,76.5 |mobs Gimashi@Gimashi's Findings |value mid  -- Notes on Draenethyst (40)
turnin 94872 |npc Gorhak |at 1443 66.2,79.4 |value low  -- Buying Friendship: Magram (45)
complete 1488 |at 1443 57.0,75.7 |mobs Lord Azrethoc;Jugkar Grim'rod |group elite  -- The Corrupter (40)
turnin 93225 |npc Gurda Wildmane |at 1443 56.3,59.7 |value low  -- Carved Centaur Totems (40)
turnin 1488 |npc Takata Steelblade |at 1443 52.6,54.4 |group elite  -- The Corrupter (40)
turnin 93465 |npc Azore Aldamort |at 1443 38.9,27.2 |value mid  -- Notes on Draenethyst (40)
accept 93678 |npc Azore Aldamort |at 1443 38.9,27.2 |value mid |lvl 30 |preany 93465  -- Abridged Notes on Draenethyst (40)
fly 1413 63.1,37.2 |from 1443 21.6,74.1 |npc The Barrens (Bragok)  -- flight master Thalon
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1435 46.1,54.8 |from 1434 26.9,77.1 |npc Swamp of Sorrows (Breyk) |value mid  -- flight master Gringer
turnin 93678 |npc Magtoor |at 1435 26.0,31.4 |value mid  -- Abridged Notes on Draenethyst (40)
fly 1434 26.9,77.1 |from 1435 46.1,54.8 |npc Stranglethorn Vale (Gringer)  -- flight master Breyk
turnin 79235 |npc Tokal |at 1434 27.0,77.3  -- On the Lam (40)
accept 79236 |npc Tokal |at 1434 27.0,77.3 |lvl 30 |preany 79235  -- Cherry for Your Thoughts? (40)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
accept 93128 |npc Nerlokh |at 2652 20.9,22.7 |lvl 35 |preany 93122  -- Khan Jehn (42)
complete 79236  -- Cherry for Your Thoughts? (40)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 79236 |npc Tokal |at 1434 27.0,77.3  -- Cherry for Your Thoughts? (40)
accept 79242 |npc Tokal |at 1434 27.0,77.3 |lvl 30 |preany 79236  -- No Honor Among Thieves (40)
fly 1417 73.0,32.7 |from 1434 26.9,77.1 |npc Arathi Highlands (Urda)  -- flight master Gringer
turnin 79242 |npc Illari's Loot Cache |at 1417 94.2,69.3  -- No Honor Among Thieves (40)
fly 1434 26.9,77.1 |from 1417 73.0,32.7 |npc Stranglethorn Vale (Gringer)  -- flight master Urda
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1443 21.6,74.1 |from 1413 63.1,37.2 |npc Thalon  -- flight master Bragok
turnin 93128 |npc Uthek the Wise |at 1443 36.2,79.2  -- Khan Jehn (42)
turnin 1380 |npc Uthek the Wise |at 1443 36.2,79.2 |group elite  -- Khan Hratha (42)
turnin 96222 |npc Umarak |at 1443 43.5,79.0 |group elite  -- Khan Hratha (42)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   6568  The Testament of Rexxar (60)
--   92811  Economic Warfare (60)
--   92812  Economic Warfare (60)
