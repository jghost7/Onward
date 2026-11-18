-- DRAFT Tanaris (Horde) generated 2026-11-18 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "tanaris-h-1", title = "Tanaris (40-51)", faction = "Horde", zone = "Tanaris",
  levels = { 40, 51 },
  next = "tanaris-h-2",
  steps = [[
home |npc Innkeeper Fizzgrimble |at 1446 52.5,27.9  -- set your hearthstone at the inn
accept 992 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5 |lvl 38  -- Gadgetzan Water Survey (46)
accept 2865 |npc Tran'rek |at 1446 51.6,26.8 |group dungeon |lvl 40  -- Scarab Shells (45)
accept 8365 |npc Haughty Modiste |at 1446 66.6,22.3 |value mid |lvl 40  -- Pirate Hats Ahoy! (45)
accept 2875 |npc Wanted Poster |at 1446 66.8,22.3 |lvl 40  -- WANTED: Andre Firebeard (45)
accept 2781 |npc Wanted Poster |at 1446 66.8,22.3 |lvl 39  -- WANTED: Caliph Scorpidsting (46)
accept 3520 |npc Yeh'kinya |at 1446 67.0,22.4 |lvl 40  -- Screecher Spirits (44)
accept 95383 |npc Wharfmaster Steamfizzle |at 1446 67.6,23.1 |preany 95296  -- Shipping and Handling (40)
turnin 95383 |npc Tazzik |at 1446 67.3,24.0  -- Shipping and Handling (40)
accept 95312 |npc Tazzik |at 1446 67.3,24.0 |preany 95383  -- Coming to Collect (40)
accept 8366 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9 |value mid |lvl 40  -- Southsea Shakedown (45)
accept 97530 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9 |lvl 40  -- Dunemaul Dues (47)
accept 2876 |note Starts from the item Ship Schedule; where it comes from isn't on record. Hand it in to Security Chief Bilgewhizzle |startitem 9250 |loose |lvl 40  -- Ship Schedules (45)
accept 2873 |npc Stoley |at 1446 67.1,24.0 |lvl 40  -- Stoley's Shipment (45)
fly 1413 63.1,37.2 |from 1446 51.6,25.4 |npc The Barrens (Bragok)  -- flight master Bulkrek Ragefist
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 1458 63.2,48.6 |from 1434 26.9,77.1 |npc Undercity (Michael Garrett)  -- flight master Gringer
accept 2861 |npc Anastasia Hartwell |at 1458 85.1,10.0 |lvl 40  -- Tabetha's Task (46)
accept 243 |npc Apothecary Zinge |at 1458 50.1,68.0 |lvl 38 |preany 238  -- Into the Field (46)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
accept 2872 |npc "Sea Wolf" MacKinley |at 1434 27.8,77.1 |lvl 40  -- Stoley's Debt (45)
accept 2864 |npc Krazek |at 1434 26.9,77.2 |lvl 40  -- Tran'rek (45)
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1445 35.6,31.9 |from 1413 63.1,37.2 |npc Dustwallow Marsh (Shardi)  -- flight master Bragok
turnin 2861 |npc Tabetha |at 1445 46.1,57.1  -- Tabetha's Task (46)
accept 2846 |npc Tabetha |at 1445 46.1,57.1 |group dungeon |lvl 40  -- Tiara of the Deep (46)
fly 1444 75.5,44.4 |from 1445 35.6,31.9 |npc Feralas (Shyn)  -- flight master Shardi
complete 3520 |at 1444 52.3,49.2 |item 10699 |mobs Screecher Spirit  -- Screecher Spirits (44)
fly 1446 51.6,25.4 |from 1444 75.5,44.4 |npc Bulkrek Ragefist  -- flight master Shyn
complete 992 |at 1446 39.0,29.0 |item 8584  -- Gadgetzan Water Survey (46)
turnin 992 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Gadgetzan Water Survey (46)
accept 82 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5 |lvl 39 |preany 992  -- Noxious Lair Investigation (47)
turnin 95312 |npc Fizbuz Mithril |at 1446 51.7,27.8  -- Coming to Collect (40)
accept 95321 |npc Fizbuz Mithril |at 1446 51.7,27.8 |preany 95312  -- Tazzik's Dues (40)
accept 1707 |npc Spigot Operator Luglunket |at 1446 52.5,28.4 |lvl 40  -- Water Pouch Bounty (44)
turnin 243 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5  -- Into the Field (46)
accept 1690 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |lvl 40  -- Wastewander Justice (43)
accept 379 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |lvl 38 |preany 243  -- Slake That Thirst (46)
accept 3042 |npc Trenton Lighthammer |at 1446 51.4,28.8 |value mid |group dungeon |lvl 40  -- Troll Temper (45)
complete 3042 |value mid |group dungeon  -- Troll Temper (45)
turnin 3042 |npc Trenton Lighthammer |at 1446 51.4,28.8 |value mid |group dungeon  -- Troll Temper (45)
complete 82 |at 1446 33.3,44.4 |mobs Centipaar Stinger@Centipaar Insect Parts;Centipaar Wasp@Centipaar Insect Parts;Centipaar Swarmer@Centipaar Insect Parts;Centipaar Worker@Centipaar Insect Parts  -- Noxious Lair Investigation (47)
complete 97530 |at 1446 40.1,54.3 |areas 40.1,54.3:53;41.0,72.7:22 |mobs Dunemaul Brute@Brilliantly Polished Bangle;Dunemaul Enforcer@Brilliantly Polished Bangle;Dunemaul Warlock@Brilliantly Polished Bangle;Dunemaul Ogre@Brilliantly Polished Bangle  -- Dunemaul Dues (47)
complete 2873 |at 1446 72.2,46.8  -- Stoley's Shipment (45)
complete 2875 |at 1446 73.4,47.1 |mobs Andre Firebeard@Firebeard's Head  -- WANTED: Andre Firebeard (45)
complete 8366 |at 1446 74.0,46.6 |mobs Southsea Pirate;Southsea Freebooter;Southsea Dock Worker;Southsea Swashbuckler |value mid  -- Southsea Shakedown (45)
complete 8365 |at 1446 74.0,46.6 |mobs Southsea Swashbuckler@Southsea Pirate Hat;Southsea Dock Worker@Southsea Pirate Hat;Southsea Freebooter@Southsea Pirate Hat;Southsea Pirate@Southsea Pirate Hat |value mid  -- Pirate Hats Ahoy! (45)
complete 1707 |at 1446 62.2,35.0 |mobs Wastewander Thief@Wastewander Water Pouch;Wastewander Shadow Mage@Wastewander Water Pouch;Wastewander Rogue@Wastewander Water Pouch;Wastewander Bandit@Wastewander Water Pouch  -- Water Pouch Bounty (44)
complete 379 |at 1446 62.2,35.0 |mobs Wastewander Thief@Wastewander Water Pouch;Wastewander Shadow Mage@Wastewander Water Pouch;Wastewander Rogue@Wastewander Water Pouch;Wastewander Bandit@Wastewander Water Pouch  -- Slake That Thirst (46)
complete 1690 |at 1446 63.6,31.0 |mobs Wastewander Bandit;Wastewander Thief  -- Wastewander Justice (43)
turnin 2872 |npc Stoley |at 1446 67.1,24.0  -- Stoley's Debt (45)
turnin 2873 |npc Stoley |at 1446 67.1,24.0  -- Stoley's Shipment (45)
accept 2874 |npc Stoley |at 1446 67.1,24.0 |lvl 40 |preany 2873  -- Deliver to MacKinley (45)
complete 95321 |at 1446 67.3,24.0 |mobs Tazzik  -- Tazzik's Dues (40)
turnin 95321 |npc Tazzik |at 1446 67.3,24.0  -- Tazzik's Dues (40)
accept 95472 |npc Tazzik |at 1446 67.3,24.0 |preany 95321  -- Consolation Prize (40)
turnin 2876 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- Ship Schedules (45)
turnin 2875 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- WANTED: Andre Firebeard (45)
turnin 97530 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9  -- Dunemaul Dues (47)
turnin 8366 |npc Security Chief Bilgewhizzle |at 1446 67.1,23.9 |value mid  -- Southsea Shakedown (45)
turnin 3520 |npc Yeh'kinya |at 1446 67.0,22.4  -- Screecher Spirits (44)
accept 3527 |npc Yeh'kinya |at 1446 67.0,22.4 |group dungeon |lvl 40 |preany 3520  -- The Prophecy of Mosh'aru (47)
complete 3527 |group dungeon  -- The Prophecy of Mosh'aru (47)
turnin 3527 |npc Yeh'kinya |at 1446 67.0,22.4 |group dungeon  -- The Prophecy of Mosh'aru (47)
turnin 8365 |npc Haughty Modiste |at 1446 66.6,22.3 |value mid  -- Pirate Hats Ahoy! (45)
accept 5863 |npc Andi Lynn |at 1446 52.8,27.4 |lvl 44  -- The Dunemaul Compound (49)
turnin 1690 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5  -- Wastewander Justice (43)
accept 1691 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid |lvl 40 |preany 1690  -- More Wastewander Justice (44)
turnin 379 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5  -- Slake That Thirst (46)
accept 654 |note Starts from the item Model 4711-FTZ Power Source; where it comes from isn't on record. Hand it in to Chief Engineer Bilgewhizzle |startitem 8524 |loose |value mid |lvl 38 |preany 379  -- Tanaris Field Sampling (46)
accept 2768 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |group dungeon |lvl 40  -- Divino-matic Rod (47)
complete 2768 |group dungeon  -- Divino-matic Rod (47)
turnin 2768 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |group dungeon  -- Divino-matic Rod (47)
turnin 1707 |npc Spigot Operator Luglunket |at 1446 52.5,28.4  -- Water Pouch Bounty (44)
accept 95144 |npc Innkeeper Fizzgrimble |at 1446 52.5,27.9 |lvl 36  -- Overseas Delivery (38)
accept 3362 |npc Tran'rek |at 1446 51.6,26.8 |lvl 45  -- Thistleshrub Valley (50)
complete 2865 |group dungeon  -- Scarab Shells (45)
turnin 2865 |npc Tran'rek |at 1446 51.6,26.8 |group dungeon  -- Scarab Shells (45)
turnin 82 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Noxious Lair Investigation (47)
accept 10 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5 |lvl 39 |preany 82  -- The Scrimshank Redemption (48)
accept 97534 |npc Quinn |at 1446 51.1,27.9 |lvl 40  -- Gritty Business (45)
complete 97534  -- Gritty Business (45)
turnin 97534 |npc Quinn |at 1446 51.1,27.9  -- Gritty Business (45)
accept 2605 |npc Marin Noggenfogger |at 1446 51.8,28.7 |lvl 44  -- The Thirsty Goblin (49)
accept 3444 |npc Marvon Rivetseeker |at 1446 52.7,45.9 |lvl 46 |preany 3380,3445  -- The Stone Circle (51)
accept 3161 |npc Marvon Rivetseeker |at 1446 52.7,45.9 |value low |lvl 43  -- Gahz'ridian (48)
complete 3161 |at 1446 53.5,47.6 |areas 47.1,64.5:24;53.5,47.6:17 |item 9978 |value low  -- Gahz'ridian (48)
accept 351 |at 1446 48.3,50.4 |note Starts from OOX-17/TN Distress Beacon |startitem 8623 |lvl 43  -- Find OOX-17/TN! (48)
complete 5863 |at 1446 40.1,54.3 |areas 40.1,54.3:43;40.1,72.7:8 |mobs Dunemaul Brute;Dunemaul Enforcer;Gor'marok the Ravager  -- The Dunemaul Compound (49)
accept 97540 |npc Tooga |at 1446 30.0,65.0  -- Oasis (50)
turnin 97540 |npc Tooga |at 1446 30.0,65.0  -- Oasis (50)
complete 2605 |at 1446 29.4,66.3 |mobs Thistleshrub Dew Collector@Laden Dew Gland  -- The Thirsty Goblin (49)
complete 3362 |at 1446 29.7,66.3 |mobs Gnarled Thistleshrub;Thistleshrub Rootshaper  -- Thistleshrub Valley (50)
complete 10 |at 1446 56.0,71.2  -- The Scrimshank Redemption (48)
turnin 351 |npc Homing Robot OOX-17/TN |at 1446 60.2,64.7  -- Find OOX-17/TN! (48)
complete 2781 |at 1446 61.8,38.2 |mobs Caliph Scorpidsting@Caliph Scorpidsting's Head  -- WANTED: Caliph Scorpidsting (46)
complete 1691 |at 1446 61.7,38.2 |mobs Wastewander Rogue;Wastewander Assassin;Wastewander Shadow Mage |value mid  -- More Wastewander Justice (44)
turnin 2605 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- The Thirsty Goblin (49)
accept 2606 |npc Marin Noggenfogger |at 1446 51.8,28.7 |lvl 44 |preany 2605  -- In Good Taste (49)
turnin 10 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- The Scrimshank Redemption (48)
accept 110 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5 |lvl 39 |preany 10  -- Insect Part Analysis (48)
turnin 110 |npc Alchemist Pestlezugg |at 1446 50.9,27.0  -- Insect Part Analysis (48)
accept 113 |npc Alchemist Pestlezugg |at 1446 50.9,27.0 |lvl 39 |preany 110  -- Insect Part Analysis (48)
turnin 2606 |npc Sprinkle |at 1446 51.1,26.9  -- In Good Taste (49)
accept 2641 |npc Sprinkle |at 1446 51.1,26.9 |lvl 44 |preany 2606  -- Sprinkle's Secret Ingredient (49)
turnin 113 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5  -- Insect Part Analysis (48)
accept 32 |npc Senior Surveyor Fizzledowser |at 1446 50.2,27.5 |lvl 39 |preany 113  -- Rise of the Silithid (48)
fly 1454 45.1,63.9 |from 1446 51.6,25.4 |npc Orgrimmar (Doras)  -- flight master Bulkrek Ragefist
turnin 32 |npc Zilzibin Drumlore |at 1454 56.3,46.7  -- Rise of the Silithid (48)
fly 1413 63.1,37.2 |from 1454 45.1,63.9 |npc The Barrens (Bragok)  -- flight master Doras
complete 3444 |at 1413 62.5,38.5  -- The Stone Circle (51)
complete 2846 |group dungeon  -- Tiara of the Deep (46)
fly 1445 35.6,31.9 |from 1413 63.1,37.2 |npc Dustwallow Marsh (Shardi)  -- flight master Bragok
turnin 2846 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Tiara of the Deep (46)
fly 1413 63.1,37.2 |from 1445 35.6,31.9 |npc The Barrens (Bragok)  -- flight master Shardi
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
fly 2548 59.6,45.1 |from 1434 26.9,77.1 |npc Riverglades (Grakna)  -- flight master Gringer
turnin 95144 |npc Friz Frazzlespark |at 2548 77.1,52.9  -- Overseas Delivery (38)
turnin 95472 |npc Friz Frazzlespark |at 2548 77.1,52.9  -- Consolation Prize (40)
fly 1434 26.9,77.1 |from 2548 59.6,45.1 |npc Stranglethorn Vale (Gringer)  -- flight master Grakna
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1441 45.1,49.1 |from 1413 63.1,37.2 |npc Thousand Needles (Nyse)  -- flight master Bragok
accept 2770 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group dungeon |lvl 40  -- Gahz'rilla (50)
complete 2770 |group dungeon  -- Gahz'rilla (50)
turnin 2770 |npc Wizzle Brassbolts |at 1441 78.1,77.1 |group dungeon  -- Gahz'rilla (50)
fly 1413 63.1,37.2 |from 1441 45.1,49.1 |npc The Barrens (Bragok)  -- flight master Nyse
goto 1413 63.7,38.6 15 |note Take the boat to Booty Bay  -- boat Ratchet to Booty Bay
turnin 2874 |npc "Sea Wolf" MacKinley |at 1434 27.8,77.1  -- Deliver to MacKinley (45)
fly 1425 81.7,81.8 |from 1434 26.9,77.1 |npc The Hinterlands (Gorkas)  -- flight master Gringer
complete 2641 |at 1425 41.0,59.8  -- Sprinkle's Secret Ingredient (49)
fly 1458 63.2,48.6 |from 1425 81.7,81.8 |npc Undercity (Michael Garrett) |value mid  -- flight master Gorkas
complete 654 |at 1458 58.6,54.7 |value mid  -- Tanaris Field Sampling (46)
fly 1434 26.9,77.1 |from 1458 63.2,48.6 |npc Stranglethorn Vale (Gringer)  -- flight master Michael Garrett
goto 1434 25.8,73.1 15 |note Take the boat to Ratchet  -- boat Booty Bay to Ratchet
fly 1446 51.6,25.4 |from 1413 63.1,37.2 |npc Bulkrek Ragefist  -- flight master Bragok
accept 95753 |npc Odd Totem |at 1446 43.0,41.3 |value low  -- Challenge of the Desert Wolf (45)
complete 95753 |at 1446 45.7,37.8 |value low  -- Challenge of the Desert Wolf (45)
turnin 95753 |npc Odd Totem |at 1446 45.7,37.7 |value low  -- Challenge of the Desert Wolf (45)
turnin 2641 |npc Sprinkle |at 1446 51.1,26.9  -- Sprinkle's Secret Ingredient (49)
accept 2661 |npc Sprinkle |at 1446 51.1,26.9 |lvl 44 |preany 2641  -- Delivery for Marin (49)
turnin 2864 |npc Tran'rek |at 1446 51.6,26.8  -- Tran'rek (45)
turnin 3362 |npc Tran'rek |at 1446 51.6,26.8  -- Thistleshrub Valley (50)
turnin 5863 |npc Andi Lynn |at 1446 52.8,27.4  -- The Dunemaul Compound (49)
turnin 1691 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid  -- More Wastewander Justice (44)
turnin 2781 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5  -- WANTED: Caliph Scorpidsting (46)
turnin 654 |npc Chief Engineer Bilgewhizzle |at 1446 52.5,28.5 |value mid  -- Tanaris Field Sampling (46)
turnin 2661 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- Delivery for Marin (49)
accept 2662 |npc Marin Noggenfogger |at 1446 51.8,28.7 |lvl 44 |preany 2661  -- Noggenfogger Elixir (49)
turnin 2662 |npc Marin Noggenfogger |at 1446 51.8,28.7  -- Noggenfogger Elixir (49)
turnin 3444 |npc Marvon Rivetseeker |at 1446 52.7,45.9  -- The Stone Circle (51)
turnin 3161 |npc Marvon Rivetseeker |at 1446 52.7,45.9 |value low  -- Gahz'ridian (48)
]]}
