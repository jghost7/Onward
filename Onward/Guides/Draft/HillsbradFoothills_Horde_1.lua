-- DRAFT Hillsbrad Foothills (Horde) generated 2026-11-17 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "hillsbrad-foothills-h-1", title = "Hillsbrad Foothills (22-28)", faction = "Horde", zone = "Hillsbrad Foothills",
  levels = { 22, 28 },
  next = "hillsbrad-foothills-h-2",
  steps = [[
accept 494 |npc Deathstalker Lesh |at 1424 20.8,47.4 |value low |lvl 19  -- Time To Strike (20)
home |npc Innkeeper Shay |at 1424 62.8,19.0  -- set your hearthstone at the inn
accept 567 |npc Dangerous! |at 1424 62.6,19.7 |lvl 19  -- Dangerous! (28)
accept 527 |npc High Executor Darthalia |at 1424 62.3,20.4 |lvl 19  -- Battle of Hillsbrad (24)
complete 527 |at 1424 34.8,38.5 |mobs Hillsbrad Farmer;Hillsbrad Farmhand;Farmer Ray;Farmer Getz  -- Battle of Hillsbrad (24)
turnin 527 |npc High Executor Darthalia |at 1424 62.3,20.4  -- Battle of Hillsbrad (24)
accept 528 |npc High Executor Darthalia |at 1424 62.3,20.4 |lvl 19 |preany 527  -- Battle of Hillsbrad (25)
complete 528 |at 1424 34.1,45.7 |mobs Hillsbrad Peasant  -- Battle of Hillsbrad (25)
turnin 528 |npc High Executor Darthalia |at 1424 62.3,20.4  -- Battle of Hillsbrad (25)
accept 529 |npc High Executor Darthalia |at 1424 62.3,20.4 |lvl 19 |preany 528  -- Battle of Hillsbrad (26)
accept 98094 |npc High Executor Darthalia |at 1424 62.3,20.4 |lvl 19 |preany 528  -- Scout Support (25)
turnin 494 |npc High Executor Darthalia |at 1424 62.3,20.4 |value low  -- Time To Strike (20)
complete 529 |at 1424 32.0,45.5 |mobs Blacksmith Verringtan;Hillsbrad Apprentice Blacksmith  -- Battle of Hillsbrad (26)
turnin 529 |npc High Executor Darthalia |at 1424 62.3,20.4  -- Battle of Hillsbrad (26)
accept 532 |npc High Executor Darthalia |at 1424 62.3,20.4 |lvl 19 |preany 529  -- Battle of Hillsbrad (26)
complete 532 |at 1424 29.7,41.8 |mobs Magistrate Burnside;Hillsbrad Councilman  -- Battle of Hillsbrad (26)
complete 567 |at 1424 29.5,42.4 |mobs Clerk Horrace Whitesteed;Citizen Wilkes;Miner Hackett;Farmer Kalaba  -- Dangerous! (28)
turnin 532 |npc High Executor Darthalia |at 1424 62.3,20.4  -- Battle of Hillsbrad (26)
accept 539 |npc High Executor Darthalia |at 1424 62.3,20.4 |lvl 19 |preany 532  -- Battle of Hillsbrad (28)
accept 509 |npc Apothecary Lydon |at 1424 61.4,19.1 |lvl 24  -- Elixir of Agony (28)
accept 501 |npc Apothecary Lydon |at 1424 61.4,19.1 |lvl 21  -- Elixir of Pain (24)
accept 496 |npc Apothecary Lydon |at 1424 61.4,19.1 |lvl 19  -- Elixir of Suffering (22)
accept 546 |npc Deathguard Samsa |at 1424 62.1,19.7 |lvl 20 |preany 527  -- Souvenirs of Death (25)
accept 549 |npc WANTED |at 1424 62.6,20.8 |lvl 17  -- WANTED: Syndicate Personnel (22)
accept 498 |npc Krusk |at 1424 63.2,20.7 |lvl 17  -- The Rescue (22)
complete 498 |at 1424 75.3,41.5  -- The Rescue (22)
complete 546 |at 1424 79.8,43.4 |areas 79.8,43.4:100;33.8,41.6:93;29.7,56.5:56 |mobs Syndicate Watchman@Hillsbrad Human Skull;Hillsbrad Miner@Hillsbrad Human Skull;Syndicate Shadow Mage@Hillsbrad Human Skull;Hillsbrad Farmer@Hillsbrad Human Skull  -- Souvenirs of Death (25)
complete 549 |at 1424 79.7,43.2 |areas 79.7,43.2:57;66.0,48.1:10 |mobs Syndicate Rogue;Syndicate Watchman  -- WANTED: Syndicate Personnel (22)
turnin 98094 |npc Deathstalker Masoj |at 1424 63.6,53.1  -- Scout Support (25)
accept 98095 |npc Deathstalker Masoj |at 1424 63.6,53.1 |lvl 19 |preany 98094  -- Valuable Vantages (25)
turnin 98095 |npc Deathstalker Masoj |at 1424 63.6,53.1  -- Valuable Vantages (25)
complete 509 |at 1424 64.6,61.2  -- Elixir of Agony (28)
complete 539 |at 1424 30.4,55.6 |mobs Foreman Bonds;Hillsbrad Miner  -- Battle of Hillsbrad (28)
complete 496 |at 1424 52.3,46.0 |mobs Giant Moss Creeper@Creeper Ichor;Elder Gray Bear@Gray Bear Tongue;Gray Bear@Gray Bear Tongue;Vicious Gray Bear@Gray Bear Tongue  -- Elixir of Suffering (22)
complete 501 |at 1424 52.5,35.9 |areas 52.5,35.9:17;64.9,69.3:9;59.0,56.5:7 |mobs Starving Mountain Lion@Mountain Lion Blood;Feral Mountain Lion@Mountain Lion Blood;Mountain Lion@Mountain Lion Blood  -- Elixir of Pain (24)
turnin 498 |npc Krusk |at 1424 63.2,20.7  -- The Rescue (22)
turnin 539 |npc High Executor Darthalia |at 1424 62.3,20.4  -- Battle of Hillsbrad (28)
turnin 567 |npc High Executor Darthalia |at 1424 62.3,20.4  -- Dangerous! (28)
turnin 549 |npc High Executor Darthalia |at 1424 62.3,20.4  -- WANTED: Syndicate Personnel (22)
turnin 546 |npc Deathguard Samsa |at 1424 62.1,19.7  -- Souvenirs of Death (25)
turnin 501 |npc Apothecary Lydon |at 1424 61.4,19.1  -- Elixir of Pain (24)
accept 502 |npc Apothecary Lydon |at 1424 61.4,19.1 |lvl 21 |preany 501  -- Elixir of Pain (24)
turnin 496 |npc Apothecary Lydon |at 1424 61.4,19.1  -- Elixir of Suffering (22)
accept 499 |npc Apothecary Lydon |at 1424 61.4,19.1 |lvl 19 |preany 496  -- Elixir of Suffering (22)
turnin 509 |npc Apothecary Lydon |at 1424 61.4,19.1  -- Elixir of Agony (28)
accept 513 |npc Apothecary Lydon |at 1424 61.4,19.1 |lvl 24 |preany 509  -- Elixir of Agony (28)
turnin 499 |npc Umpi |at 1424 61.5,19.1  -- Elixir of Suffering (22)
turnin 502 |npc Stanley |at 1424 32.7,35.3  -- Elixir of Pain (24)
fly 1458 63.2,48.6 |from 1424 60.1,18.6 |npc Undercity (Michael Garrett)  -- flight master Zarise
turnin 513 |npc Master Apothecary Faranell |at 1458 48.8,69.3  -- Elixir of Agony (28)
]]}
