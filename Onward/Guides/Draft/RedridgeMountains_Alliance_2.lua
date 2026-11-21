-- DRAFT Redridge Mountains (Alliance) generated 2026-11-21 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "redridge-mountains-a-2", title = "Redridge Mountains (23-27)", faction = "Alliance", zone = "Redridge Mountains",
  levels = { 23, 27 },
  steps = [[
accept 248 |npc Old Lion Statue |at 1433 79.4,46.8 |lvl 20 |preany 94  -- Looking Further (22)
accept 178 |at 1433 73.8,47.4 |mobs Shadowhide Warrior;Shadowhide Darkweaver;Shadowhide Gnoll;Shadowhide Slayer |note Starts from the item Glowing Shadowhide Pendant, found on Shadowhide Darkweaver, Shadowhide Slayer, Shadowhide Brute. Hand it in to Theocritus |startitem 1962 |loose |lvl 15  -- Theocritus' Retrieval (23)
complete 248 |item 1083  -- Looking Further (22)
turnin 248 |npc An Empty Jar |at 1433 58.2,49.8  -- Looking Further (22)
accept 128 |npc Guard Howe |at 1433 26.4,57.9 |value mid |lvl 20  -- Blackrock Bounty (25)
home |npc Innkeeper Brianna |at 1433 21.9,44.8  -- set your hearthstone at the inn
accept 19 |npc Marshal Marris |at 1433 28.4,49.0 |group elite |lvl 18 |pre 20,98387  -- Tharil'zun (25)
accept 115 |npc Marshal Marris |at 1433 28.4,49.0 |group elite |lvl 18 |pre 20,98387  -- Shadow Magic (23)
accept 126 |npc Verner Osgood |at 1433 25.9,47.3 |lvl 15 |preany 124  -- Howling in the Hills (25)
accept 169 |npc Wanted: Gath'Ilzogg |at 1433 24.5,46.2 |group elite |lvl 15  -- WANTED: Gath'Ilzogg (26)
accept 95999 |npc Wanted: Incinerator Gar'im |at 1433 24.3,46.2 |value mid |group elite |lvl 16  -- WANTED: Incinerator Gar'im (25)
accept 34 |npc Martie Jainrose |at 1433 16.8,46.3 |value mid |lvl 18  -- An Unwelcome Guest (24)
complete 34 |at 1433 10.6,49.3 |mobs Bellygrub@Bellygrub's Tusk |value mid  -- An Unwelcome Guest (24)
turnin 34 |npc Martie Jainrose |at 1433 16.8,46.3 |value mid  -- An Unwelcome Guest (24)
accept 180 |npc Wanted: Lieutenant Fangore |at 1433 21.7,46.4 |lvl 15  -- WANTED: Lieutenant Fangore (26)
accept 91 |npc Bailiff Conacher |at 1433 24.6,44.3 |lvl 17  -- Solomon's Law (23)
complete 126 |at 1433 22.6,21.4 |mobs Yowler@Yowler's Paw  -- Howling in the Hills (25)
accept 219 |npc Corporal Keeshan |at 1433 23.3,12.6 |lvl 19  -- Missing In Action (25)
complete 128 |at 1433 24.5,11.2 |mobs Blackrock Champion |value mid  -- Blackrock Bounty (25)
complete 180 |at 1433 75.1,37.1 |mobs Lieutenant Fangore@Fangore's Paw  -- WANTED: Lieutenant Fangore (26)
complete 91 |at 1433 73.8,47.4 |mobs Shadowhide Warrior@Shadowhide Pendant;Shadowhide Darkweaver@Shadowhide Pendant;Shadowhide Slayer@Shadowhide Pendant;Shadowhide Gnoll@Shadowhide Pendant  -- Solomon's Law (23)
complete 169 |at 1433 64.5,55.8 |mobs Gath'Ilzogg@Head of Gath'Ilzogg |group elite  -- WANTED: Gath'Ilzogg (26)
complete 115 |at 1433 63.5,55.6 |areas 63.5,55.6:30;30.5,8.0:4 |mobs Blackrock Shadowcaster@Midnight Orb |group elite  -- Shadow Magic (23)
complete 19 |at 1433 64.4,59.4 |mobs Tharil'zun@Tharil'zun's Head |group elite  -- Tharil'zun (25)
complete 95999 |at 1433 72.8,86.3 |mobs Incinerator Gar'im@Broken Staff of Incinerator Gar'im |value mid |group elite  -- WANTED: Incinerator Gar'im (25)
turnin 128 |npc Guard Howe |at 1433 26.4,57.9 |value mid  -- Blackrock Bounty (25)
turnin 126 |npc Verner Osgood |at 1433 25.9,47.3  -- Howling in the Hills (25)
turnin 91 |npc Bailiff Conacher |at 1433 24.6,44.3  -- Solomon's Law (23)
turnin 169 |npc Magistrate Solomon |at 1433 24.9,44.5 |group elite  -- WANTED: Gath'Ilzogg (26)
turnin 180 |npc Magistrate Solomon |at 1433 24.9,44.5  -- WANTED: Lieutenant Fangore (26)
turnin 95999 |npc Magistrate Solomon |at 1433 24.9,44.5 |value mid |group elite  -- WANTED: Incinerator Gar'im (25)
complete 219 |at 1433 28.3,48.7  -- Missing In Action (25)
turnin 219 |npc Marshal Marris |at 1433 28.4,49.0  -- Missing In Action (25)
turnin 19 |npc Marshal Marris |at 1433 28.4,49.0 |group elite  -- Tharil'zun (25)
turnin 115 |npc Marshal Marris |at 1433 28.4,49.0 |group elite  -- Shadow Magic (23)
turnin 178 |npc Theocritus |at 1429 65.2,69.7  -- Theocritus' Retrieval (23)
accept 249 |npc Theocritus |at 1429 65.2,69.7 |value low |group elite |lvl 20 |preany 248  -- Morganth (27)
complete 249 |at 1433 75.0,49.5 |mobs Morganth@Pendant of Shadow |value low |group elite  -- Morganth (27)
turnin 249 |npc Theocritus |at 1429 65.2,69.7 |value low |group elite  -- Morganth (27)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   95816  Sign Me Up! (60)
--   98247  Shipping Label (60)
