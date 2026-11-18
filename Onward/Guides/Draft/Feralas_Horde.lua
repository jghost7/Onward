-- DRAFT Feralas (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "feralas-h", title = "Feralas (43-52)", faction = "Horde", zone = "Feralas",
  levels = { 43, 52 },
  steps = [[
home |npc Innkeeper Greul |at 1444 74.8,45.2  -- set your hearthstone at the inn
accept 2822 |npc Jangdor Swiftstrider |at 1444 74.4,42.9 |lvl 40  -- The Mark of Quality (46)
accept 2862 |npc Hadoken Swiftstrider |at 1444 74.9,42.5 |lvl 39  -- War on the Woodpaw (42)
complete 2862 |at 1444 72.4,37.7 |areas 71.0,54.9:126;72.4,37.7:32 |mobs Woodpaw Mystic@Woodpaw Gnoll Mane;Woodpaw Reaver@Woodpaw Gnoll Mane;Woodpaw Trapper@Woodpaw Gnoll Mane;Woodpaw Mongrel@Woodpaw Gnoll Mane  -- War on the Woodpaw (42)
turnin 2862 |npc Hadoken Swiftstrider |at 1444 74.9,42.5  -- War on the Woodpaw (42)
accept 2863 |npc Hadoken Swiftstrider |at 1444 74.9,42.5 |lvl 39 |preany 2862  -- Alpha Strike (43)
accept 2973 |npc Krueg Skullsplitter |at 1444 75.9,42.7 |lvl 38  -- A New Cloak's Sheen (45)
accept 2975 |npc Rok Orhan |at 1444 75.8,43.6 |lvl 38  -- The Ogres of Feralas (43)
complete 2863 |at 1444 71.4,55.9 |mobs Woodpaw Alpha  -- Alpha Strike (43)
complete 2975 |at 1444 60.8,56.8 |areas 75.4,29.7:40;60.8,56.8:13 |mobs Gordunni Ogre;Gordunni Ogre Mage;Gordunni Brute  -- The Ogres of Feralas (43)
accept 2766 |at 1444 59.0,51.4 |note Starts from OOX-22/FE Distress Beacon |startitem 8705 |lvl 40  -- Find OOX-22/FE! (45)
complete 2973 |at 1444 66.6,46.9 |mobs Sprite Darter@Iridescent Sprite Darter Wing;Captured Sprite Darter@Iridescent Sprite Darter Wing  -- A New Cloak's Sheen (45)
accept 2978 |at 1444 75.1,29.7 |note Starts from Gordunni Scroll |startitem 9370 |lvl 38  -- The Gordunni Scroll (43)
turnin 2863 |npc Hadoken Swiftstrider |at 1444 74.9,42.5  -- Alpha Strike (43)
accept 2902 |npc Hadoken Swiftstrider |at 1444 74.9,42.5 |lvl 39 |preany 2863  -- Woodpaw Investigation (43)
accept 92878 |npc Blaise Montgomery |at 1444 74.9,44.0 |group elite |lvl 36  -- Lost for Words (43)
turnin 2902 |npc Woodpaw Battle Map |at 1444 71.6,55.9  -- Woodpaw Investigation (43)
accept 2903 |npc Woodpaw Battle Map |at 1444 71.6,55.9 |lvl 39 |preany 2902  -- The Battle Plans (43)
accept 3121 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40  -- A Strange Request (45)
turnin 2903 |npc Hadoken Swiftstrider |at 1444 74.9,42.5  -- The Battle Plans (43)
accept 7731 |npc Hadoken Swiftstrider |at 1444 74.9,42.5 |lvl 39 |preany 2903  -- Stinglasher (47)
accept 7730 |npc Hadoken Swiftstrider |at 1444 74.9,42.5 |lvl 39 |preany 2903  -- Zukk'ash Infestation (45)
turnin 2973 |npc Krueg Skullsplitter |at 1444 75.9,42.7  -- A New Cloak's Sheen (45)
accept 2974 |npc Krueg Skullsplitter |at 1444 75.9,42.7 |lvl 38 |preany 2973  -- A Grim Discovery (45)
turnin 2978 |npc Rok Orhan |at 1444 75.8,43.6  -- The Gordunni Scroll (43)
turnin 2975 |npc Rok Orhan |at 1444 75.8,43.6  -- The Ogres of Feralas (43)
accept 2979 |npc Rok Orhan |at 1444 75.8,43.6 |lvl 38 |preany 2978  -- Dark Ceremony (46)
accept 2980 |npc Rok Orhan |at 1444 75.8,43.6 |lvl 38 |preany 2975  -- The Ogres of Feralas (44)
complete 7731 |at 1444 75.6,60.9 |mobs Stinglasher@Stinglasher's Glands  -- Stinglasher (47)
complete 7730 |at 1444 74.8,63.1 |mobs Zukk'ash Tunneler@Zukk'ash Carapace;Zukk'ash Stinger@Zukk'ash Carapace;Zukk'ash Wasp@Zukk'ash Carapace;Zukk'ash Worker@Zukk'ash Carapace  -- Zukk'ash Infestation (45)
complete 2979 |at 1444 60.8,69.5 |mobs Gordunni Mage-Lord@Gordunni Orb  -- Dark Ceremony (46)
accept 7721 |npc Zorbin Fandazzle |at 1444 44.8,43.4 |lvl 45  -- Fuel for the Zapping (48)
accept 7003 |npc Zorbin Fandazzle |at 1444 44.8,43.4 |lvl 45  -- Zapped Giants (48)
fly 1454 45.1,63.9 |from 1444 75.5,44.4 |npc Orgrimmar (Doras)  -- flight master Shyn
turnin 3121 |npc Neeru Fireblade |at 1454 49.5,50.6  -- A Strange Request (45)
accept 3122 |npc Neeru Fireblade |at 1454 49.5,50.6 |lvl 40 |preany 3121  -- Return to Witch Doctor Uzer'i (45)
fly 1444 75.5,44.4 |from 1454 45.1,63.9 |npc Shyn  -- flight master Doras
complete 7003 |at 1444 46.5,59.6 |areas 39.7,22.3:19;46.5,59.6:8 |item 18904 |mobs Land Walker@Miniaturization Residue;Cliff Giant@Miniaturization Residue;Zapped Cliff Giant@Miniaturization Residue;Shore Strider@Miniaturization Residue  -- Zapped Giants (48)
complete 2822 |at 1444 52.3,58.5 |mobs Feral Scar Yeti@Thick Yeti Hide;Hulking Feral Scar@Thick Yeti Hide;Enraged Feral Scar@Thick Yeti Hide;Bloodroar the Stalker@Thick Yeti Hide  -- The Mark of Quality (46)
turnin 2766 |npc Homing Robot OOX-22/FE |at 1444 53.4,55.7  -- Find OOX-22/FE! (45)
complete 2974 |at 1444 69.0,40.8 |mobs Grimtotem Raider@Grimtotem Horn;Grimtotem Naturalist@Grimtotem Horn;Grimtotem Shaman@Grimtotem Horn  -- A Grim Discovery (45)
turnin 3122 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Return to Witch Doctor Uzer'i (45)
accept 3123 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |preany 3122  -- Testing the Vessel (47)
turnin 7730 |npc Hadoken Swiftstrider |at 1444 74.9,42.5  -- Zukk'ash Infestation (45)
turnin 7731 |npc Hadoken Swiftstrider |at 1444 74.9,42.5  -- Stinglasher (47)
accept 7732 |npc Hadoken Swiftstrider |at 1444 74.9,42.5 |lvl 39 |pre 7730,7731  -- Zukk'ash Report (48)
turnin 2974 |npc Krueg Skullsplitter |at 1444 75.9,42.7  -- A Grim Discovery (45)
accept 2976 |npc Krueg Skullsplitter |at 1444 75.9,42.7 |lvl 37 |preany 2974  -- A Grim Discovery (45)
turnin 2979 |npc Rok Orhan |at 1444 75.8,43.6  -- Dark Ceremony (46)
accept 3002 |npc Rok Orhan |at 1444 75.8,43.6 |lvl 38 |preany 2979  -- The Gordunni Orb (47)
accept 3063 |npc Talo Thornhoof |at 1444 76.2,43.8 |lvl 45  -- Vengeance on the Northspring (50)
accept 3062 |npc Talo Thornhoof |at 1444 76.2,43.8 |group elite |lvl 45  -- Dark Heart (50)
accept 4120 |npc Talo Thornhoof |at 1444 76.2,43.8 |lvl 47  -- The Strength of Corruption (52)
accept 2987 |npc Orwin Gizzmick |at 1444 75.7,44.3 |value mid |lvl 38  -- Gordunni Cobalt (43)
complete 7721 |at 1444 38.0,36.2 |areas 46.8,55.3:23;38.0,36.2:20 |mobs Sea Spray@Water Elemental Core;Sea Elemental@Water Elemental Core  -- Fuel for the Zapping (48)
fly 1413 63.1,37.2 |from 1444 75.5,44.4 |npc The Barrens (Bragok)  -- flight master Shyn
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1425 81.7,81.8 |from 1434 26.9,77.1 |npc The Hinterlands (Gorkas)  -- flight master Gringer
complete 3123 |at 1425 55.2,51.4 |item 9618  -- Testing the Vessel (47)
fly 1434 26.9,77.1 |from 1425 81.7,81.8 |npc Stranglethorn Vale (Gringer)  -- flight master Gorkas
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1448 34.4,54.0 |from 1413 63.1,37.2 |npc Felwood (Brakkar)  -- flight master Bragok
complete 4120 |at 1448 56.6,19.4 |mobs Angerclaw Grizzly;Felpaw Ravager  -- The Strength of Corruption (52)
fly 1413 63.1,37.2 |from 1448 34.4,54.0 |npc The Barrens (Bragok)  -- flight master Brakkar
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1458 63.2,48.6 |from 1434 26.9,77.1 |npc Undercity (Michael Garrett)  -- flight master Gringer
accept 81951 |npc Owen Thadd |at 1458 73.4,33.0  -- The Liminal and the Arcane (45)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1454 45.1,63.9 |from 1413 63.1,37.2 |npc Orgrimmar (Doras)  -- flight master Bragok
turnin 2976 |npc Belgrom Rockmaul |at 1454 75.2,34.2  -- A Grim Discovery (45)
turnin 3002 |npc Uthel'nay |at 1454 39.2,86.3  -- The Gordunni Orb (47)
turnin 7732 |npc Zilzibin Drumlore |at 1454 56.3,46.7  -- Zukk'ash Report (48)
fly 1444 75.5,44.4 |from 1454 45.1,63.9 |npc Shyn  -- flight master Doras
complete 3063 |at 1444 39.1,13.1 |mobs Northspring Harpy;Northspring Roguefeather;Northspring Slayer;Northspring Windcaller  -- Vengeance on the Northspring (50)
complete 3062 |at 1444 40.5,8.6 |mobs Edana Hatetalon@Edana's Dark Heart |group elite  -- Dark Heart (50)
complete 81951 |at 1444 50.6,15.7  -- The Liminal and the Arcane (45)
turnin 81951  -- The Liminal and the Arcane (45)
complete 2987 |at 1444 76.5,33.1 |item 9466 |value mid  -- Gordunni Cobalt (43)
turnin 2822 |npc Jangdor Swiftstrider |at 1444 74.4,42.9  -- The Mark of Quality (46)
accept 7734 |npc Jangdor Swiftstrider |at 1444 74.4,42.9 |lvl 40 |preany 2822  -- Improved Quality (48)
turnin 3123 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Testing the Vessel (47)
accept 3124 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |preany 3123  -- Hippogryph Muisek (47)
complete 3124 |at 1444 55.0,69.3 |item 9619 |mobs Frayfeather Skystormer@Hippogryph Muisek;Frayfeather Stagwing@Hippogryph Muisek;Frayfeather Hippogryph@Hippogryph Muisek;Frayfeather Patriarch@Hippogryph Muisek  -- Hippogryph Muisek (47)
complete 2980 |at 1444 59.5,64.5 |mobs Gordunni Shaman;Gordunni Warlock;Gordunni Mauler  -- The Ogres of Feralas (44)
turnin 2987 |npc Orwin Gizzmick |at 1444 75.7,44.3 |value mid  -- Gordunni Cobalt (43)
turnin 3062 |npc Talo Thornhoof |at 1444 76.2,43.8 |group elite  -- Dark Heart (50)
turnin 3063 |npc Talo Thornhoof |at 1444 76.2,43.8  -- Vengeance on the Northspring (50)
turnin 4120 |npc Talo Thornhoof |at 1444 76.2,43.8  -- The Strength of Corruption (52)
turnin 2980 |npc Rok Orhan |at 1444 75.8,43.6  -- The Ogres of Feralas (44)
accept 3128 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |preany 3122  -- Natural Materials (50)
turnin 3124 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Hippogryph Muisek (47)
accept 3125 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |preany 3124  -- Faerie Dragon Muisek (45)
complete 3128 |at 1444 66.6,46.9 |areas 55.2,70.7:55;41.0,22.6:35;66.6,46.9:33 |mobs The Giant@Metallic Fragments;Frayfeather Skystormer@Resilient Sinew;Sprite Darter@Encrusted Minerals;Frayfeather Stagwing@Resilient Sinew  -- Natural Materials (50)
complete 3125 |at 1444 68.4,47.9 |areas 68.4,47.9:21;43.5,22.5:3 |item 9620 |mobs Sprite Darter@Faerie Dragon Muisek;Sprite Dragon@Faerie Dragon Muisek  -- Faerie Dragon Muisek (45)
turnin 3125 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Faerie Dragon Muisek (45)
accept 3126 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |preany 3125  -- Treant Muisek (50)
complete 3126 |at 1444 54.0,47.2 |item 9606 |mobs Wandering Forest Walker@Treant Muisek  -- Treant Muisek (50)
turnin 3126 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Treant Muisek (50)
accept 3127 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |preany 3126  -- Mountain Giant Muisek (50)
turnin 3128 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Natural Materials (50)
turnin 7721 |npc Zorbin Fandazzle |at 1444 44.8,43.4  -- Fuel for the Zapping (48)
turnin 7003 |npc Zorbin Fandazzle |at 1444 44.8,43.4  -- Zapped Giants (48)
complete 3127 |at 1444 39.7,22.3 |item 9621 |mobs Land Walker@Mountain Giant Muisek;Cliff Giant@Mountain Giant Muisek;Zapped Cliff Giant@Mountain Giant Muisek;Zapped Land Walker@Mountain Giant Muisek  -- Mountain Giant Muisek (50)
complete 7734 |at 1444 54.0,32.5 |mobs Rage Scar Yeti@Rage Scar Yeti Hide;Elder Rage Scar@Rage Scar Yeti Hide;Ferocious Rage Scar@Rage Scar Yeti Hide;Lurking Feral Scar@Rage Scar Yeti Hide  -- Improved Quality (48)
complete 92878 |at 1444 67.7,39.2 |mobs Namida Grimtotem@Namida's Hoof |group elite  -- Lost for Words (43)
turnin 7734 |npc Jangdor Swiftstrider |at 1444 74.4,42.9  -- Improved Quality (48)
turnin 3127 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Mountain Giant Muisek (50)
accept 3129 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4 |lvl 40 |pre 3127,3128  -- Weapons of Spirit (50)
turnin 3129 |npc Witch Doctor Uzer'i |at 1444 74.4,43.4  -- Weapons of Spirit (50)
turnin 92878 |npc Blaise Montgomery |at 1444 74.9,44.0 |group elite  -- Lost for Words (43)
]]}
