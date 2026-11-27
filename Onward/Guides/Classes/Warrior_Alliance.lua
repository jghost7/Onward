-- GENERATED Warrior (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_warrior_alliance_defensive", title = "Defensive Stance", kind = "class",
  class = "WARRIOR", faction = "Alliance", levels = { 10, 11 },
  steps = [[
accept 94003 |npc Seena Skybreaker |at 2521 59.9,72.9 |race SkyborneAlliance  -- The Skybreaker Bulwark (10)
complete 94003 |at 2521 56.6,50.4 |mobs Zaal Stormshield |race SkyborneAlliance  -- The Skybreaker Bulwark (10)
turnin 94003 |npc Seena Skybreaker |at 2521 59.9,72.9 |race SkyborneAlliance  -- The Skybreaker Bulwark (10)
accept 1683 |npc Elanaria |at 1457 57.3,34.6 |exclusive 1639,1678  -- Vorlus Vilehoof (10)
complete 1683 |at 1438 47.2,63.6 |mobs Vorlus Vilehoof  -- Vorlus Vilehoof (10)
turnin 1683 |npc Elanaria |at 1457 57.3,34.6  -- Vorlus Vilehoof (10)
accept 1640 |npc Bartleby |at 1453 76.8,52.5 |preany 1683  -- Beat Bartleby (10)
complete 1640 |at 1453 76.8,52.5 |mobs Bartleby  -- Beat Bartleby (10)
turnin 1640 |npc Bartleby |at 1453 76.8,52.5  -- Beat Bartleby (10)
accept 1665 |npc Bartleby |at 1453 76.8,52.5 |preany 1640  -- Bartleby's Mug (10)
turnin 1665 |npc Harry Burlguard |at 1453 77.1,53.3  -- Bartleby's Mug (10)
accept 1666 |npc Harry Burlguard |at 1453 77.1,53.3 |preany 1665  -- Marshal Haggard (10)
turnin 1666 |npc Marshal Haggard |at 1429 84.6,69.4  -- Marshal Haggard (10)
accept 1667 |npc Marshal Haggard |at 1429 84.6,69.4 |preany 1666  -- Dead-tooth Jack (10)
complete 1667 |at 1429 89.3,78.9  -- Dead-tooth Jack (10)
turnin 1667 |npc Marshal Haggard |at 1429 84.6,69.4  -- Dead-tooth Jack (10)
accept 1686 |npc Elanaria |at 1457 57.3,34.6 |preany 1683  -- The Shade of Elura (10)
complete 1686 |at 1439 32.2,44.4 |mobs Shade of Elura  -- The Shade of Elura (10)
turnin 1686 |npc Elanaria |at 1457 57.3,34.6  -- The Shade of Elura (10)
accept 1692 |npc Elanaria |at 1457 57.3,34.6 |preany 1686  -- Smith Mathiel (10)
turnin 1692 |npc Mathiel |at 1457 59.5,45.4  -- Smith Mathiel (10)
accept 1693 |npc Mathiel |at 1457 59.5,45.4 |preany 1692  -- Weapons of Elunite (10)
turnin 1693 |npc Mathiel |at 1457 59.5,45.4  -- Weapons of Elunite (10)
accept 1681 |npc Tormus Deepforge |at 1455 48.6,42.5 |preany 1683  -- Ironband's Compound (11)
complete 1681 |at 1426 78.0,62.2  -- Ironband's Compound (11)
turnin 1681 |npc Tormus Deepforge |at 1455 48.6,42.5  -- Ironband's Compound (11)
accept 1682 |npc Tormus Deepforge |at 1455 48.6,42.5 |preany 1681  -- Grey Iron Weapons (10)
turnin 1682 |npc Tormus Deepforge |at 1455 48.6,42.5  -- Grey Iron Weapons (10)
]]}

Onward:RegisterGuide{
  id = "class_warrior_alliance_armor20", title = "Fire Hardened Mail", kind = "class",
  class = "WARRIOR", faction = "Alliance", levels = { 20, 30 },
  steps = [[
accept 1699 |npc Yorus Barleybrew |at 1433 21.5,44.7  -- The Rethban Gauntlet (22)
complete 1699 |at 1433 14.1,24.7  -- The Rethban Gauntlet (22)
turnin 1699 |npc Yorus Barleybrew |at 1433 21.5,44.7  -- The Rethban Gauntlet (22)
accept 1702 |npc Yorus Barleybrew |at 1433 21.5,44.7 |preany 1699  -- The Shieldsmith (22)
turnin 1702 |npc Furen Longbeard |at 1453 64.6,37.2  -- The Shieldsmith (22)
accept 1701 |npc Furen Longbeard |at 1453 64.6,37.2 |group elite |preany 1702  -- Fire Hardened Mail (28)
complete 1701 |at 1437 50.8,62.1 |item 6842 |mobs Leech Stalker;Cave Stalker;Fledgling Chimaera;Young Chimaera |group elite  -- Fire Hardened Mail (28)
turnin 1701 |npc Furen Longbeard |at 1453 64.6,37.2 |group elite  -- Fire Hardened Mail (28)
accept 1782 |npc Furen Longbeard |at 1453 64.6,37.2 |group elite |preany 1701  -- Furen's Armor (28)
turnin 1782 |npc Furen Longbeard |at 1453 64.6,37.2 |group elite  -- Furen's Armor (28)
accept 1705 |npc Grimand Elmore |at 1453 59.7,33.8 |group elite |preany 1782  -- Burning Blood (28)
complete 1705 |at 1431 65.6,67.0 |mobs Nightbane Dark Runner;Old Fire-Eye;Nightbane Worgen;Nightbane Shadow Weaver |group elite  -- Burning Blood (28)
turnin 1705 |npc Grimand Elmore |at 1453 59.7,33.8 |group elite  -- Burning Blood (28)
accept 1708 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |group elite |preany 1782  -- Iron Coral (29)
complete 1708 |at 1437 8.9,70.2 |group elite  -- Iron Coral (29)
turnin 1708 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |group elite  -- Iron Coral (29)
accept 1706 |npc Grimand Elmore |at 1453 59.7,33.8 |group elite |preany 1705  -- Grimand's Armor (30)
turnin 1706 |npc Grimand Elmore |at 1453 59.7,33.8 |group elite  -- Grimand's Armor (30)
accept 1709 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |group elite |preany 1708  -- Klockmort's Creation (30)
turnin 1709 |npc Klockmort Spannerspan |at 1455 67.9,46.1 |group elite  -- Klockmort's Creation (30)
accept 1710 |npc Mathiel |at 1457 59.5,45.4 |group elite |preany 1782  -- Sunscorched Shells (30)
complete 1710 |at 1441 11.8,37.1 |group elite  -- Sunscorched Shells (30)
turnin 1710 |npc Mathiel |at 1457 59.5,45.4 |group elite  -- Sunscorched Shells (30)
accept 1711 |npc Mathiel |at 1457 59.5,45.4 |group elite |preany 1710  -- Mathiel's Armor (30)
turnin 1711 |npc Mathiel |at 1457 59.5,45.4 |group elite  -- Mathiel's Armor (30)
]]}

Onward:RegisterGuide{
  id = "class_warrior_alliance_whirlwind", title = "Berserker Stance & Whirlwind Weapon", kind = "class",
  class = "WARRIOR", faction = "Alliance", levels = { 30, 40 },
  steps = [[
accept 1718 |npc Wu Shen |at 1453 80.5,59.9  -- The Islander (30)
turnin 1718 |npc Klannoc Macleod |at 1413 68.6,49.2  -- The Islander (30)
accept 1719 |npc Klannoc Macleod |at 1413 68.6,49.2 |preany 1718  -- The Affray (30)
complete 1719 |at 1413 68.6,48.7 |mobs Big Will  -- The Affray (30)
turnin 1719 |npc Klannoc Macleod |at 1413 68.6,49.2  -- The Affray (30)
accept 1791 |npc Klannoc Macleod |at 1413 68.6,49.2 |preany 1719  -- The Windwatcher (30)
turnin 1791 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9  -- The Windwatcher (30)
accept 1712 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |preany 1791  -- Cyclonian (40)
complete 1712 |at 1416 31.1,34.7 |item 6929 |mobs Bloodscalp Mystic;Bloodscalp Scout;Bloodscalp Headhunter;Bloodscalp Berserker  -- Cyclonian (40)
turnin 1712 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9  -- Cyclonian (40)
accept 1713 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group elite |preany 1712  -- The Summoning (40)
complete 1713 |at 1416 80.3,62.1 |mobs Cyclonian |group elite  -- The Summoning (40)
turnin 1713 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group elite  -- The Summoning (40)
accept 1792 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group elite |preany 1713  -- Whirlwind Weapon (40)
turnin 1792 |npc Bath'rah the Windwatcher |at 1416 80.5,66.9 |group elite  -- Whirlwind Weapon (40)
]]}

Onward:RegisterGuide{
  id = "class_warrior_alliance_st50", title = "Sunken Temple: Voodoo Feathers", kind = "class",
  class = "WARRIOR", faction = "Alliance", levels = { 50, 52 },
  steps = [[
accept 8423 |npc Fallen Hero of the Horde |at 1435 34.3,66.1  -- Warrior Kinship (52)
complete 8423 |at 1419 50.2,38.6 |mobs Helboar  -- Warrior Kinship (52)
turnin 8423 |npc Fallen Hero of the Horde |at 1435 34.3,66.1  -- Warrior Kinship (52)
accept 8424 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |preany 8423  -- War on the Shadowsworn (52)
complete 8424 |at 1419 65.2,34.0 |mobs Shadowsworn Cultist;Shadowsworn Adept;Shadowsworn Thug  -- War on the Shadowsworn (52)
turnin 8424 |npc Fallen Hero of the Horde |at 1435 34.3,66.1  -- War on the Shadowsworn (52)
accept 8425 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |group dungeon |preany 8424  -- Voodoo Feathers (52)
complete 8425 |group dungeon  -- Voodoo Feathers (52)
turnin 8425 |npc Fallen Hero of the Horde |at 1435 34.3,66.1 |group dungeon  -- Voodoo Feathers (52)
]]}
