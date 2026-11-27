-- GENERATED Warrior (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_warrior_horde_defensive", title = "Defensive Stance", kind = "class",
  class = "WARRIOR", faction = "Horde", levels = { 10, 11 },
  steps = [[
accept 94003 |npc Seena Skybreaker |at 2521 59.9,72.9 |race SkyborneHorde  -- The Skybreaker Bulwark (10)
complete 94003 |at 2521 56.6,50.4 |mobs Zaal Stormshield |race SkyborneHorde  -- The Skybreaker Bulwark (10)
turnin 94003 |npc Seena Skybreaker |at 2521 59.9,72.9 |race SkyborneHorde  -- The Skybreaker Bulwark (10)
accept 1498 |npc Uzzek |at 1413 61.4,21.1 |exclusive 1819  -- Path of Defense (10)
complete 1498 |at 1411 40.2,28.1 |mobs Lightning Hide;Thunder Lizard  -- Path of Defense (10)
turnin 1498 |npc Uzzek |at 1413 61.4,21.1  -- Path of Defense (10)
accept 1502 |npc Uzzek |at 1413 61.4,21.1 |preany 1498  -- Thun'grim Firegaze (10)
turnin 1502 |npc Thun'grim Firegaze |at 1413 57.2,30.3  -- Thun'grim Firegaze (10)
accept 1503 |npc Thun'grim Firegaze |at 1413 57.2,30.3 |preany 1502  -- Forged Steel (10)
complete 1503 |at 1413 55.0,26.6  -- Forged Steel (10)
turnin 1503 |npc Thun'grim Firegaze |at 1413 57.2,30.3  -- Forged Steel (10)
accept 1821 |npc Coleman Farthing |at 1420 61.7,52.3 |preany 1498  -- Agamand Heirlooms (11)
complete 1821 |at 1420 52.7,27.0  -- Agamand Heirlooms (11)
turnin 1821 |npc Coleman Farthing |at 1420 61.7,52.3  -- Agamand Heirlooms (11)
accept 1822 |npc Coleman Farthing |at 1420 61.7,52.3 |preany 1821  -- Heirloom Weapon (11)
turnin 1822 |npc Coleman Farthing |at 1420 61.7,52.3  -- Heirloom Weapon (11)
]]}

Onward:RegisterGuide{
  id = "class_warrior_horde_armor20", title = "Brutal Armor", kind = "class",
  class = "WARRIOR", faction = "Horde", levels = { 20, 30 },
  steps = [[
accept 1824 |npc Ruga Ragetotem |at 1413 44.7,59.4  -- Trial at the Field of Giants (20)
complete 1824 |at 1413 44.2,71.3 |mobs Silithid Swarmer;Silithid Creeper;Silithid Grub;Silithid Harvester  -- Trial at the Field of Giants (20)
turnin 1824 |npc Ruga Ragetotem |at 1413 44.7,59.4  -- Trial at the Field of Giants (20)
accept 1838 |npc Thun'grim Firegaze |at 1413 57.2,30.3 |preany 1824  -- Brutal Armor (30)
complete 1838 |at 1442 72.9,60.6 |item 7587 |mobs Windshear Digger;Hillsbrad Miner;Windshear Overlord;Windshear Geomancer  -- Brutal Armor (30)
turnin 1838 |npc Thun'grim Firegaze |at 1413 57.2,30.3  -- Brutal Armor (30)
accept 1848 |npc Thun'grim Firegaze |at 1413 57.2,30.3 |preany 1838  -- Brutal Hauberk (30)
turnin 1848 |npc Thun'grim Firegaze |at 1413 57.2,30.3  -- Brutal Hauberk (30)
accept 1842 |npc Ula'elek |at 1411 56.3,74.3 |preany 1848  -- Satyr Hooves (30)
complete 1842 |at 1440 79.6,49.3 |mobs Bleakheart Shadowstalker;Xavian Felsworn;Bleakheart Hellcaller;Felmusk Shadowstalker  -- Satyr Hooves (30)
turnin 1842 |npc Ula'elek |at 1411 56.3,74.3  -- Satyr Hooves (30)
accept 1843 |npc Ula'elek |at 1411 56.3,74.3 |preany 1842  -- Brutal Gauntlets (30)
turnin 1843 |npc Ula'elek |at 1411 56.3,74.3  -- Brutal Gauntlets (30)
accept 1844 |npc Orm Stonehoof |at 1456 39.0,56.0 |preany 1848  -- Chimaeric Horn (30)
complete 1844 |at 1442 33.6,74.7 |mobs Chimaera Matriarch  -- Chimaeric Horn (30)
turnin 1844 |npc Orm Stonehoof |at 1456 39.0,56.0  -- Chimaeric Horn (30)
accept 1845 |npc Orm Stonehoof |at 1456 39.0,56.0 |preany 1844  -- Brutal Helm (30)
turnin 1845 |npc Orm Stonehoof |at 1456 39.0,56.0  -- Brutal Helm (30)
accept 1846 |npc Velora Nitely |at 1458 62.1,39.1 |preany 1848  -- Dragonmaw Shinbones (30)
complete 1846 |at 1437 47.1,46.1 |mobs Dragonmaw Raider;Dragonmaw Bonewarder;Dragonmaw Swamprunner;Dragonmaw Centurion  -- Dragonmaw Shinbones (30)
turnin 1846 |npc Velora Nitely |at 1458 62.1,39.1  -- Dragonmaw Shinbones (30)
accept 1847 |npc Velora Nitely |at 1458 62.1,39.1 |preany 1846  -- Brutal Legguards (30)
turnin 1847 |npc Velora Nitely |at 1458 62.1,39.1  -- Brutal Legguards (30)
]]}

Onward:RegisterGuide{
  id = "class_warrior_horde_whirlwind", title = "Berserker Stance & Whirlwind Weapon", kind = "class",
  class = "WARRIOR", faction = "Horde", levels = { 30, 40 },
  steps = [[
accept 1718 |npc Sorek |at 1454 80.4,32.4  -- The Islander (30)
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
  id = "class_warrior_horde_st50", title = "Sunken Temple: Voodoo Feathers", kind = "class",
  class = "WARRIOR", faction = "Horde", levels = { 50, 52 },
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
