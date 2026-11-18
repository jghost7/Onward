-- DRAFT Loch Modan (Alliance) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "loch-modan-a-1", title = "Loch Modan (10-16)", faction = "Alliance", zone = "Loch Modan",
  levels = { 10, 16 },
  next = "loch-modan-a-2",
  steps = [[
home |npc Innkeeper Hearthstove |at 1432 35.5,48.4  -- set your hearthstone at the inn
accept 418 |npc Vidra Hearthstove |at 1432 34.8,49.3 |lvl 7  -- Thelsamar Blood Sausages (11)
accept 86667 |npc Grenhild Darktalon |at 1432 36.5,48.3 |lvl 10  -- Snowbound (10)
accept 6387 |npc Brock Stoneseeker |at 1432 37.0,47.8 |race Dwarf,Gnome |lvl 10  -- Honor Students (10)
accept 416 |npc Mountaineer Kadrell |at 1432 32.6,49.7 |value mid |lvl 10  -- Rat Catching (11)
accept 1339 |npc Mountaineer Kadrell |at 1432 32.6,49.7 |lvl 9  -- Mountaineer Stormpike's Task (15)
turnin 6387 |npc Thorgrum Borrelson |at 1432 33.9,51.0 |race Dwarf,Gnome  -- Honor Students (10)
accept 6391 |npc Thorgrum Borrelson |at 1432 33.9,51.0 |race Dwarf,Gnome |lvl 10 |preany 6387  -- Ride to Ironforge (10)
accept 224 |npc Mountaineer Cobbleflint |at 1432 22.1,73.1 |lvl 10  -- In Defense of the King's Lands (12)
complete 224 |at 1432 32.0,74.9 |areas 32.0,74.9:50;26.1,51.8:20 |mobs Stonesplinter Trogg;Stonesplinter Scout  -- In Defense of the King's Lands (12)
accept 267 |npc Captain Rugelfuss |at 1432 23.2,73.7 |lvl 10  -- The Trogg Threat (12)
turnin 224 |npc Mountaineer Cobbleflint |at 1432 22.1,73.1  -- In Defense of the King's Lands (12)
accept 237 |npc Mountaineer Gravelgaw |at 1432 23.5,76.4 |lvl 10 |preany 224  -- In Defense of the King's Lands (15)
complete 237 |at 1432 34.0,85.0 |areas 34.0,85.0:49;50.0,23.6:22 |mobs Stonesplinter Skullthumper;Stonesplinter Seer  -- In Defense of the King's Lands (15)
complete 267 |at 1432 34.0,85.0 |areas 34.0,85.0:57;51.8,24.6:38;70.6,64.8:31 |mobs Stonesplinter Seer@Trogg Stone Tooth;Stonesplinter Trogg@Trogg Stone Tooth;Stonesplinter Scout@Trogg Stone Tooth;Stonesplinter Skullthumper@Trogg Stone Tooth  -- The Trogg Threat (12)
turnin 237 |npc Mountaineer Gravelgaw |at 1432 23.5,76.4  -- In Defense of the King's Lands (15)
accept 263 |npc Mountaineer Wallbang |at 1432 23.5,74.5 |value mid |lvl 10 |preany 237  -- In Defense of the King's Lands (15)
complete 263 |at 1432 35.9,92.1 |areas 35.9,92.1:24;52.7,24.9:16 |mobs Stonesplinter Shaman;Stonesplinter Bonesnapper |value mid  -- In Defense of the King's Lands (15)
turnin 263 |npc Mountaineer Wallbang |at 1432 23.5,74.5 |value mid  -- In Defense of the King's Lands (15)
turnin 267 |npc Captain Rugelfuss |at 1432 23.2,73.7  -- The Trogg Threat (12)
accept 454 |npc Huldar |at 1432 52.2,69.3 |lvl 10 |preany 273  -- After the Ambush (15)
turnin 454 |npc Miran |at 1432 52.2,69.4  -- After the Ambush (15)
accept 298 |npc Prospector Ironband |at 1432 65.9,65.6 |lvl 10  -- Excavation Progress Report (15)
accept 385 |npc Marek Ironheart |at 1432 81.8,61.7 |lvl 10  -- Crocolisk Hunting (15)
accept 86758 |npc Marek Ironheart |at 1432 81.8,61.7 |lvl 12  -- Twisting the Knife (16)
accept 257 |npc Daryl the Youngling |at 1432 83.5,65.5 |lvl 11  -- A Hunter's Boast (16)
complete 257 |at 1432 75.8,70.5 |mobs Mountain Buzzard  -- A Hunter's Boast (16)
accept 2038 |npc Bingles Blastenheimer |at 1432 63.6,47.9 |lvl 12  -- Bingles' Missing Supplies (15)
complete 385 |at 1432 62.0,44.7 |mobs Daggerfang@Crocolisk Meat;Loch Crocolisk@Crocolisk Meat;Large Loch Crocolisk@Crocolisk Meat  -- Crocolisk Hunting (15)
complete 86758 |at 1432 61.5,43.8 |mobs Daggerfang@Marek's Croc-Hunting Knife  -- Twisting the Knife (16)
turnin 298 |npc Jern Hornhelm |at 1432 37.2,47.4  -- Excavation Progress Report (15)
accept 301 |npc Jern Hornhelm |at 1432 37.2,47.4 |lvl 10 |preany 298  -- Report to Ironforge (15)
complete 418 |at 1432 35.5,34.0 |areas 35.5,34.0:28;66.3,40.1:22 |mobs Forest Lurker@Spider Ichor;Mangy Mountain Boar@Boar Intestines;Mountain Boar@Boar Intestines;Elder Black Bear@Bear Meat  -- Thelsamar Blood Sausages (11)
complete 2038 |at 1432 51.8,24.1  -- Bingles' Missing Supplies (15)
complete 86667 |item 279380  -- Snowbound (10)
turnin 86667 |npc Norric Lochthane |at 1432 41.8,19.1  -- Snowbound (10)
accept 307 |npc Mountaineer Stormpike |at 1432 24.8,18.4 |lvl 9  -- Filthy Paws (15)
complete 307 |at 1432 35.3,24.4  -- Filthy Paws (15)
turnin 1339 |npc Mountaineer Stormpike |at 1432 24.8,18.4  -- Mountaineer Stormpike's Task (15)
turnin 307 |npc Mountaineer Stormpike |at 1432 24.8,18.4  -- Filthy Paws (15)
accept 1338 |npc Mountaineer Stormpike |at 1432 24.8,18.4 |lvl 9  -- Stormpike's Order (14)
fly 1455 55.5,47.7 |from 1432 33.9,51.0 |npc Ironforge (Gryth Thurden)  -- flight master Thorgrum Borrelson
turnin 6391 |npc Golnir Bouldertoe |at 1455 51.5,26.3 |race Dwarf,Gnome  -- Ride to Ironforge (10)
turnin 301 |npc Prospector Stormpike |at 1455 74.6,11.7  -- Report to Ironforge (15)
accept 6388 |npc Golnir Bouldertoe |at 1455 51.5,26.3 |race Dwarf,Gnome |lvl 10 |preany 6391  -- Gryth Thurden (10)
accept 302 |npc Prospector Stormpike |at 1455 74.6,11.7 |lvl 10 |preany 301  -- Powder to Ironband (15)
turnin 6388 |npc Gryth Thurden |at 1455 55.5,47.7 |race Dwarf,Gnome  -- Gryth Thurden (10)
accept 6392 |npc Gryth Thurden |at 1455 55.5,47.7 |race Dwarf,Gnome |lvl 10 |preany 6388  -- Return to Brock (10)
fly 1453 71.3,72.2 |from 1455 55.5,47.7 |npc Stormwind City (Dungar Longdrink)  -- flight master Gryth Thurden
turnin 1338 |npc Furen Longbeard |at 1453 64.6,37.2  -- Stormpike's Order (14)
fly 1432 33.9,51.0 |from 1453 71.3,72.2 |npc Thorgrum Borrelson  -- flight master Dungar Longdrink
complete 416 |at 1432 26.5,43.8 |areas 36.3,23.4:55;26.5,43.8:14 |mobs Tunnel Rat Vermin@Tunnel Rat Ear;Tunnel Rat Kobold@Tunnel Rat Ear;Tunnel Rat Digger@Tunnel Rat Ear;Tunnel Rat Forager@Tunnel Rat Ear |value mid  -- Rat Catching (11)
turnin 416 |npc Mountaineer Kadrell |at 1432 32.6,49.7 |value mid  -- Rat Catching (11)
turnin 418 |npc Vidra Hearthstove |at 1432 34.8,49.3  -- Thelsamar Blood Sausages (11)
turnin 6392 |npc Brock Stoneseeker |at 1432 37.0,47.8 |race Dwarf,Gnome  -- Return to Brock (10)
turnin 302 |npc Jern Hornhelm |at 1432 37.2,47.4  -- Powder to Ironband (15)
turnin 2038 |npc Bingles Blastenheimer |at 1432 63.6,47.9  -- Bingles' Missing Supplies (15)
turnin 385 |npc Marek Ironheart |at 1432 81.8,61.7  -- Crocolisk Hunting (15)
turnin 86758 |npc Marek Ironheart |at 1432 81.8,61.7  -- Twisting the Knife (16)
turnin 257 |npc Daryl the Youngling |at 1432 83.5,65.5  -- A Hunter's Boast (16)
]]}
