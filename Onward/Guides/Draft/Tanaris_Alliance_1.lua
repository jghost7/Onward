-- DRAFT Tanaris (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "tanaris-a-1", title = "Tanaris (44-51)", faction = "Alliance", zone = "Tanaris",
  levels = { 44, 51 },
  next = "tanaris-a-2",
  steps = [[
home |npc Innkeeper Fizzgrimble |at 1446 52.5,27.9  -- set your hearthstone at the inn
accept 992 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Gadgetzan Water Survey (46)
turnin 10 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- The Scrimshank Redemption (48)
accept 110 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Insect Part Analysis (48)
accept 2605 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- The Thirsty Goblin (49)
accept 1690 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid  -- Wastewander Justice (43)
accept 8365 |npc Haughty Modiste |at 1446 66.6,22.3 |value mid  -- Pirate Hats Ahoy! (45)
accept 2875 |npc Wanted Poster |at 1446 66.8,22.3  -- WANTED: Andre Firebeard (45)
accept 2781 |npc Wanted Poster |at 1446 66.8,22.3  -- WANTED: Caliph Scorpidsting (46)
accept 3520 |npc Yeh'kinya |at 1446 67.0,22.4  -- Screecher Spirits (44)
accept 8366 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9 |value mid  -- Southsea Shakedown (45)
accept 2876 |note Starts from Ship Schedule  -- Ship Schedules (45)
accept 2873 |npc Stoley |at 1446 67.1,24.0  -- Stoley's Shipment (45)
complete 1690 |at 1446 63.6,31.0 |mobs Wastewander Bandit;Wastewander Thief |value mid  -- Wastewander Justice (43)
complete 2873 |at 1446 72.2,46.8  -- Stoley's Shipment (45)
complete 2875 |at 1446 73.4,47.1 |mobs Andre Firebeard@Firebeard's Head  -- WANTED: Andre Firebeard (45)
complete 8365 |at 1446 74.0,46.6 |mobs Southsea Swashbuckler@Southsea Pirate Hat;Southsea Dock Worker@Southsea Pirate Hat;Southsea Freebooter@Southsea Pirate Hat;Southsea Pirate@Southsea Pirate Hat |value mid  -- Pirate Hats Ahoy! (45)
complete 8366 |at 1446 74.0,46.6 |mobs Southsea Pirate;Southsea Freebooter;Southsea Dock Worker;Southsea Swashbuckler |value mid  -- Southsea Shakedown (45)
turnin 2873 |npc Stoley |at 1446 67.1,24.0  -- Stoley's Shipment (45)
accept 2874 |npc Stoley |at 1446 67.1,24.0  -- Deliver to MacKinley (45)
turnin 8366 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9 |value mid  -- Southsea Shakedown (45)
accept 97530 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- Dunemaul Dues (47)
turnin 2875 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- WANTED: Andre Firebeard (45)
accept 5863 |npc Andi Lynn |at 1446 52.8,27.4 |value mid  -- The Dunemaul Compound (49)
accept 3022 |npc Curgle Cranklehop |at 1446 52.4,26.9  -- Handle With Care (47)
accept 97536 |npc Jhordy Lapforge |at 1446 52.3,26.9  -- Gnomish Garbage (45)
turnin 97536 |npc Jhordy Lapforge |at 1446 52.3,26.9  -- Gnomish Garbage (45)
accept 3362 |npc Tran'rek |at 1446 51.6,26.8 |value mid  -- Thistleshrub Valley (50)
turnin 110 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Insect Part Analysis (48)
accept 113 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Insect Part Analysis (48)
complete 992 |at 1446 39.0,29.0 |item 8584  -- Gadgetzan Water Survey (46)
complete 2605 |at 1446 29.4,66.3 |mobs Thistleshrub Dew Collector@Laden Dew Gland  -- The Thirsty Goblin (49)
complete 3362 |at 1446 29.7,66.3 |mobs Gnarled Thistleshrub;Thistleshrub Rootshaper |value mid  -- Thistleshrub Valley (50)
turnin 2605 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- The Thirsty Goblin (49)
accept 2606 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- In Good Taste (49)
turnin 113 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Insect Part Analysis (48)
turnin 992 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Gadgetzan Water Survey (46)
accept 162 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Rise of the Silithid (49)
accept 82 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Noxious Lair Investigation (47)
turnin 2606 |npc Sprinkle |at 1446 51.1,26.9  -- In Good Taste (49)
accept 2641 |npc Sprinkle |at 1446 51.1,26.9  -- Sprinkle's Secret Ingredient (49)
accept 95144 |npc Innkeeper Fizzgrimble |at 1446 52.5,27.9  -- Overseas Delivery (38)
accept 1707 |npc Spigot Operator Luglunket |at 1446 52.5,28.4 |value mid  -- Water Pouch Bounty (44)
turnin 1690 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid  -- Wastewander Justice (43)
accept 1691 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid  -- More Wastewander Justice (44)
accept 3161 |npc Marvon Rivetseeker |at 1446 52.7,45.9 |value low  -- Gahz'ridian (48)
accept 3444 |npc Marvon Rivetseeker |at 1446 52.7,45.9  -- The Stone Circle (51)
complete 82 |at 1446 33.3,44.4 |mobs Centipaar Stinger@Centipaar Insect Parts;Centipaar Wasp@Centipaar Insect Parts;Centipaar Swarmer@Centipaar Insect Parts;Centipaar Worker@Centipaar Insect Parts  -- Noxious Lair Investigation (47)
fly 1445 67.5,51.3 |from 1446 51.0,29.3 |npc Dustwallow Marsh (Baldruc)  -- flight master Bera Stonehammer
accept 2846 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Tiara of the Deep (46)
goto 1445 71.6,56.4 15 |note Take the boat to Menethil Harbor  -- boat Theramore to Menethil Harbor
accept 2861 |npc Anastasia Hartwell |at 1458 85.1,10.0  -- Tabetha's Task (46)
goto 1437 4.6,57.1 15 |note Take the boat to Theramore  -- boat Menethil Harbor to Theramore
turnin 2861 |npc Tabetha |at 1445 46.1,57.1  -- Tabetha's Task (46)
fly 1413 63.1,37.2 |from 1445 67.5,51.3 |npc The Barrens (Bragok)  -- flight master Baldruc
complete 3444 |at 1413 62.5,38.5  -- The Stone Circle (51)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 2548 60.6,81.5 |from 1434 27.5,77.8 |npc Riverglades (Gretchen Mayberry)  -- flight master Gyll
turnin 95144 |npc Friz Frazzlespark |at 2548 77.1,52.9  -- Overseas Delivery (38)
fly 1434 27.5,77.8 |from 2548 60.6,81.5 |npc Stranglethorn Vale (Gyll)  -- flight master Gretchen Mayberry
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1444 30.2,43.2 |from 1413 63.1,37.2 |npc Feralas (Fyldren Moonfeather)  -- flight master Bragok
complete 3520 |at 1444 52.3,49.2 |item 10699 |mobs Screecher Spirit  -- Screecher Spirits (44)
complete 2846 |group dungeon  -- Tiara of the Deep (46)
fly 1445 67.5,51.3 |from 1444 30.2,43.2 |npc Dustwallow Marsh (Baldruc)  -- flight master Fyldren Moonfeather
turnin 2846 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Tiara of the Deep (46)
goto 1445 71.6,56.4 15 |note Take the boat to Menethil Harbor  -- boat Theramore to Menethil Harbor
fly 1419 65.5,24.3 |from 1437 9.5,59.7 |npc Blasted Lands (Alexandra Constantine)  -- flight master Shellei Brondir
accept 2991 |npc Thadius Grimshade |at 1419 66.9,19.5 |group dungeon  -- Nekrum's Medallion (47)
fly 1434 27.5,77.8 |from 1419 65.5,24.3 |npc Stranglethorn Vale (Gyll)  -- flight master Alexandra Constantine
accept 2864 |npc Krazek |at 1434 26.9,77.2  -- Tran'rek (45)
turnin 2874 |npc "Sea Wolf" MacKinley |at 1434 27.8,77.1  -- Deliver to MacKinley (45)
accept 2872 |npc "Sea Wolf" MacKinley |at 1434 27.8,77.1  -- Stoley's Debt (45)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
accept 2770 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group dungeon  -- Gahz'rilla (50)
complete 2991 |group dungeon  -- Nekrum's Medallion (47)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1419 65.5,24.3 |from 1434 27.5,77.8 |npc Blasted Lands (Alexandra Constantine)  -- flight master Gyll
turnin 2991 |npc Thadius Grimshade |at 1419 66.9,19.5 |group dungeon  -- Nekrum's Medallion (47)
fly 1434 27.5,77.8 |from 1419 65.5,24.3 |npc Stranglethorn Vale (Gyll)  -- flight master Alexandra Constantine
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1438 58.4,94.0 |from 1413 63.1,37.2 |npc Teldrassil (Vesprystus)  -- flight master Bragok
turnin 3022 |npc Erelas Ambersky |at 1438 55.5,92.0  -- Handle With Care (47)
turnin 162 |npc Gracina Spiritmight |at 1457 41.8,85.6  -- Rise of the Silithid (49)
complete 2770 |group dungeon  -- Gahz'rilla (50)
turnin 2770 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group dungeon  -- Gahz'rilla (50)
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1425 11.1,46.1 |from 1434 27.5,77.8 |npc The Hinterlands (Guthrum Thunderfist)  -- flight master Gyll
complete 2641 |at 1425 41.0,59.8  -- Sprinkle's Secret Ingredient (49)
fly 1434 27.5,77.8 |from 1425 11.1,46.1 |npc Stranglethorn Vale (Gyll)  -- flight master Guthrum Thunderfist
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1446 51.0,29.3 |from 1413 63.1,37.2 |npc Bera Stonehammer  -- flight master Bragok
complete 5863 |at 1446 40.7,56.9 |mobs Dunemaul Brute;Dunemaul Enforcer;Gor'marok the Ravager |value mid  -- The Dunemaul Compound (49)
complete 97530 |at 1446 40.7,56.9 |mobs Dunemaul Brute@Brilliantly Polished Bangle;Dunemaul Enforcer@Brilliantly Polished Bangle;Dunemaul Warlock@Brilliantly Polished Bangle;Dunemaul Ogre@Brilliantly Polished Bangle  -- Dunemaul Dues (47)
complete 3161 |at 1446 47.6,57.2 |item 9978 |value low  -- Gahz'ridian (48)
accept 351 |at 1446 48.3,50.4 |note Starts from OOX-17/TN Distress Beacon  -- Find OOX-17/TN! (48)
turnin 3444 |npc Marvon Rivetseeker |at 1446 52.7,45.9  -- The Stone Circle (51)
turnin 3161 |npc Marvon Rivetseeker |at 1446 52.7,45.9 |value low  -- Gahz'ridian (48)
complete 1691 |at 1446 61.7,38.2 |mobs Wastewander Rogue;Wastewander Assassin;Wastewander Shadow Mage |value mid  -- More Wastewander Justice (44)
complete 2781 |at 1446 61.8,38.2 |mobs Caliph Scorpidsting@Caliph Scorpidsting's Head  -- WANTED: Caliph Scorpidsting (46)
complete 1707 |at 1446 62.2,35.0 |mobs Wastewander Thief@Wastewander Water Pouch;Wastewander Shadow Mage@Wastewander Water Pouch;Wastewander Rogue@Wastewander Water Pouch;Wastewander Bandit@Wastewander Water Pouch |value mid  -- Water Pouch Bounty (44)
turnin 2872 |npc Stoley |at 1446 67.1,24.0  -- Stoley's Debt (45)
turnin 97530 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- Dunemaul Dues (47)
turnin 2876 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- Ship Schedules (45)
turnin 3520 |npc Yeh'kinya |at 1446 67.0,22.4  -- Screecher Spirits (44)
accept 3527 |npc Yeh'kinya |at 1446 67.0,22.4 |group dungeon  -- The Prophecy of Mosh'aru (47)
complete 3527 |group dungeon  -- The Prophecy of Mosh'aru (47)
turnin 3527 |npc Yeh'kinya |at 1446 67.0,22.4 |group dungeon  -- The Prophecy of Mosh'aru (47)
turnin 8365 |npc Haughty Modiste |at 1446 66.6,22.3 |value mid  -- Pirate Hats Ahoy! (45)
turnin 5863 |npc Andi Lynn |at 1446 52.8,27.4 |value mid  -- The Dunemaul Compound (49)
accept 2865 |npc Tran'rek |at 1446 51.6,26.8 |group dungeon  -- Scarab Shells (45)
turnin 3362 |npc Tran'rek |at 1446 51.6,26.8 |value mid  -- Thistleshrub Valley (50)
complete 2865 |group dungeon  -- Scarab Shells (45)
turnin 2865 |npc Tran'rek |at 1446 51.6,26.8 |group dungeon  -- Scarab Shells (45)
turnin 2864 |npc Tran'rek |at 1446 51.6,26.8  -- Tran'rek (45)
turnin 2641 |npc Sprinkle |at 1446 51.1,26.9  -- Sprinkle's Secret Ingredient (49)
accept 2661 |npc Sprinkle |at 1446 51.1,26.9  -- Delivery for Marin (49)
turnin 82 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Noxious Lair Investigation (47)
accept 10 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- The Scrimshank Redemption (48)
accept 3042 |npc Trenton Lighthammer |at 1446 51.4,28.8 |value mid |group dungeon  -- Troll Temper (45)
complete 3042 |value mid |group dungeon  -- Troll Temper (45)
turnin 3042 |npc Trenton Lighthammer |at 1446 51.4,28.8 |value mid |group dungeon  -- Troll Temper (45)
turnin 2661 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- Delivery for Marin (49)
accept 2662 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- Noggenfogger Elixir (49)
turnin 2662 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- Noggenfogger Elixir (49)
turnin 1707 |npc Spigot Operator Luglunket |at 1446 52.5,28.4 |value mid  -- Water Pouch Bounty (44)
turnin 2781 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5  -- WANTED: Caliph Scorpidsting (46)
accept 2768 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |group dungeon  -- Divino-matic Rod (47)
turnin 1691 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid  -- More Wastewander Justice (44)
complete 2768 |group dungeon  -- Divino-matic Rod (47)
turnin 2768 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |group dungeon  -- Divino-matic Rod (47)
turnin 351 |npc Homing Robot OOX-17/TN |at 1446 60.2,64.7  -- Find OOX-17/TN! (48)
complete 10 |at 1446 56.0,71.2  -- The Scrimshank Redemption (48)
]]}
