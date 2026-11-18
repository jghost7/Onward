-- DRAFT Blasted Lands (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "blasted-lands-h", title = "Blasted Lands (50-60)", faction = "Horde", zone = "Blasted Lands",
  levels = { 50, 60 },
  steps = [[
accept 2581 |npc Bloodmage Drazial |at 1419 50.5,14.2 |value mid |lvl 45  -- Snickerfang Jowls (50)
accept 2585 |npc Bloodmage Drazial |at 1419 50.5,14.2 |value mid |lvl 45  -- The Decisive Striker (50)
accept 2583 |npc Bloodmage Drazial |at 1419 50.5,14.2 |value mid |lvl 45  -- A Boar's Vitality (50)
accept 2603 |npc Bloodmage Lynnore |at 1419 50.6,14.3 |lvl 45  -- Vulture's Vigor (50)
accept 2601 |npc Bloodmage Lynnore |at 1419 50.6,14.3 |lvl 45  -- The Basilisk's Bite (50)
accept 81919 |npc Bloodmage Lynnore |at 1419 50.6,14.3 |group elite |lvl 45  -- Brought to Heel (54)
accept 81917 |npc Bloodmage Lynnore |at 1419 50.6,14.3 |value low |lvl 45 |preany 81900  -- Chains That Bind (54)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
accept 91548 |npc Zevrost |at 1454 48.5,45.4 |group elite |lvl 44 |preany 91547  -- Vek'zol (55)
fly 1413 63.1,37.2 |from 1454 45.1,63.9 |npc The Barrens (Bragok)  -- flight master Doras
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1435 46.1,54.8 |from 1434 26.9,77.1 |npc Swamp of Sorrows (Breyk)  -- flight master Gringer
accept 2681 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |lvl 45 |preany 2801  -- The Stones That Bind Us (57)
accept 2621 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |lvl 45 |preany 2784  -- The Disgraced One (50)
accept 3627 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |group elite |lvl 45 |preany 3626  -- Uniting the Shattered Amulet (60)
accept 87451 |lvl 45  -- Memories of Rockard (55)
complete 2681 |at 1419 55.0,48.5 |mobs Servant of Razelikh;Servant of Grol;Servant of Allistarj;Servant of Sevine  -- The Stones That Bind Us (57)
complete 81919 |at 1419 49.2,38.8 |item 220216 |mobs Calefactus the Unleashed@Fel Lifeblood |group elite  -- Brought to Heel (54)
accept 2521 |npc Kum'isha the Collector |at 1419 52.0,35.6 |lvl 45  -- To Serve Kum'isha (55)
accept 93685 |npc Kum'isha the Collector |at 1419 52.0,35.6 |preany 93684  -- To Serve Kum'isha (55)
accept 3501 |npc Kum'isha the Collector |at 1419 52.0,35.6 |lvl 45  -- Everything Counts In Large Amounts (55)
complete 3501 |at 1419 55.0,29.1 |mobs Helboar@Imperfect Draenethyst Fragment;Nethergarde Miner@Imperfect Draenethyst Fragment;Scorpok Stinger@Imperfect Draenethyst Fragment;Nethergarde Soldier@Imperfect Draenethyst Fragment  -- Everything Counts In Large Amounts (55)
complete 2521 |at 1419 55.0,29.1 |mobs Helboar@Flawless Draenethyst Sphere;Nethergarde Miner@Flawless Draenethyst Sphere;Scorpok Stinger@Flawless Draenethyst Sphere;Nethergarde Soldier@Flawless Draenethyst Sphere  -- To Serve Kum'isha (55)
complete 93685 |at 1419 55.0,29.1 |mobs Helboar@Flawless Draenethyst Sphere;Nethergarde Miner@Flawless Draenethyst Sphere;Scorpok Stinger@Flawless Draenethyst Sphere;Nethergarde Soldier@Flawless Draenethyst Sphere  -- To Serve Kum'isha (55)
complete 3627 |at 1419 40.8,30.0 |mobs Grol the Destroyer@Amulet of Grol;Archmage Allistarj@Amulet of Allistarj;Lady Sevine@Amulet of Sevine |group elite  -- Uniting the Shattered Amulet (60)
complete 91548 |at 1419 39.2,33.0 |item 246778 |mobs Vek'zol@Heart of Vek'zol |group elite  -- Vek'zol (55)
turnin 3627 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |group elite  -- Uniting the Shattered Amulet (60)
accept 3628 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |group elite |lvl 45 |preany 3627  -- You Are Rakh'likh, Demon (60)
turnin 2681 |npc Fallen Hero of the Horde |at 1435 34.3,66.1  -- The Stones That Bind Us (57)
accept 2702 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |lvl 45 |preany 2681  -- Heroes of Old (57)
turnin 2702 |npc Corporal Thund Splithoof |at 1435 33.5,66.0  -- Heroes of Old (57)
accept 2701 |npc Corporal Thund Splithoof |at 1435 33.5,66.0 |lvl 45 |preany 2702  -- Heroes of Old (57)
turnin 2701 |npc Spectral Lockbox |at 1435 33.3,66.2  -- Heroes of Old (57)
turnin 2621 |npc Dispatch Commander Ruag |at 1435 47.8,54.9  -- The Disgraced One (50)
accept 2721 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |lvl 45 |preany 2701  -- Kirith (58)
fly 1434 26.9,77.1 |from 1435 46.1,54.8 |npc Stranglethorn Vale (Gringer)  -- flight master Breyk
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 91548 |npc Zevrost |at 1454 48.5,45.4 |group elite  -- Vek'zol (55)
turnin 87451  -- Memories of Rockard (55)
fly 1413 63.1,37.2 |from 1454 45.1,63.9 |npc The Barrens (Bragok)  -- flight master Doras
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
complete 3628 |at 1419 47.6,29.8 |item 10757 |mobs Razelikh the Defiler@Severed Horn of the Defiler |group elite  -- You Are Rakh'likh, Demon (60)
complete 2581 |at 1419 50.8,35.2 |mobs Helboar@Blasted Boar Lung;Scorpok Stinger@Scorpok Pincer;Grunter@Blasted Boar Lung;Clack the Reaver@Scorpok Pincer |value mid  -- Snickerfang Jowls (50)
complete 2583 |at 1419 50.8,35.2 |mobs Helboar@Blasted Boar Lung;Scorpok Stinger@Scorpok Pincer;Grunter@Blasted Boar Lung;Clack the Reaver@Scorpok Pincer |value mid  -- A Boar's Vitality (50)
complete 2585 |at 1419 50.8,35.2 |mobs Helboar@Blasted Boar Lung;Scorpok Stinger@Scorpok Pincer;Black Slayer@Vulture Gizzard;Grunter@Blasted Boar Lung |value mid  -- The Decisive Striker (50)
turnin 3501 |npc Kum'isha the Collector |at 1419 52.0,35.6  -- Everything Counts In Large Amounts (55)
turnin 93685 |npc Kum'isha the Collector |at 1419 52.0,35.6  -- To Serve Kum'isha (55)
turnin 2521 |npc Kum'isha the Collector |at 1419 52.0,35.6  -- To Serve Kum'isha (55)
complete 2601 |at 1419 54.8,35.2 |mobs Black Slayer@Vulture Gizzard;Deatheye@Basilisk Brain;Redstone Crystalhide@Basilisk Brain;Bonepicker@Vulture Gizzard  -- The Basilisk's Bite (50)
complete 2603 |at 1419 54.8,35.2 |mobs Black Slayer@Vulture Gizzard;Ravage@Snickerfang Jowl;Starving Snickerfang@Snickerfang Jowl;Snickerfang Hyena@Snickerfang Jowl  -- Vulture's Vigor (50)
complete 81917 |at 1419 64.1,35.2 |mobs Shadowsworn Cultist@Infernal Chain Link;Shadowsworn Thug@Infernal Chain Link;Shadowsworn Adept@Infernal Chain Link;Shadowsworn Enforcer@Infernal Chain Link |value low  -- Chains That Bind (54)
turnin 2721 |npc Spirit of Kirith |at 1419 68.8,31.1  -- Kirith (58)
accept 2743 |npc Spirit of Kirith |at 1419 68.8,31.1 |lvl 45 |preany 2721  -- The Cover of Darkness (60)
accept 91882 |npc Ambassador Ardalan |at 1419 67.6,19.3  -- The Grand Alliance (55)
turnin 81917 |npc Bloodmage Lynnore |at 1419 50.6,14.3 |value low  -- Chains That Bind (54)
turnin 2601 |npc Bloodmage Lynnore |at 1419 50.6,14.3  -- The Basilisk's Bite (50)
turnin 81919 |npc Bloodmage Lynnore |at 1419 50.6,14.3 |group elite  -- Brought to Heel (54)
turnin 2603 |npc Bloodmage Lynnore |at 1419 50.6,14.3  -- Vulture's Vigor (50)
turnin 2585 |npc Bloodmage Drazial |at 1419 50.5,14.2 |value mid  -- The Decisive Striker (50)
turnin 2581 |npc Bloodmage Drazial |at 1419 50.5,14.2 |value mid  -- Snickerfang Jowls (50)
turnin 2583 |npc Bloodmage Drazial |at 1419 50.5,14.2 |value mid  -- A Boar's Vitality (50)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 2482 68.7,46.8 |from 1413 63.1,37.2 |npc Mount Hyjal (Fayran Elthas)  -- flight master Bragok
turnin 91882 |npc Sefira Everbright |at 2482 15.7,54.7  -- The Grand Alliance (55)
fly 1413 63.1,37.2 |from 2482 68.7,46.8 |npc The Barrens (Bragok)  -- flight master Fayran Elthas
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1435 46.1,54.8 |from 1434 26.9,77.1 |npc Swamp of Sorrows (Breyk)  -- flight master Gringer
turnin 3628 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |group elite  -- You Are Rakh'likh, Demon (60)
turnin 2743 |npc Fallen Hero of the Horde |at 1435 34.3,66.1  -- The Cover of Darkness (60)
]]}
