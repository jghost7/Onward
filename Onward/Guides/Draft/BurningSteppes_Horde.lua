-- DRAFT Burning Steppes (Horde) generated 2026-11-22 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "burning-steppes-h", title = "Burning Steppes (50-60)", faction = "Horde", zone = "Burning Steppes",
  levels = { 50, 60 },
  steps = [[
accept 4296 |npc Maxwort Uberglint |at 1428 65.2,23.9 |lvl 50  -- Tablet of the Seven (50)
accept 4726 |npc Tinkee Steamboil |at 1428 65.2,24.0 |lvl 50  -- Broodling Essence (52)
complete 4726 |at 1428 63.8,57.3 |item 12284  -- Broodling Essence (52)
complete 4296 |at 1428 54.1,40.8  -- Tablet of the Seven (50)
turnin 4726 |npc Tinkee Steamboil |at 1428 65.2,24.0  -- Broodling Essence (52)
turnin 4296 |npc Maxwort Uberglint |at 1428 65.2,23.9  -- Tablet of the Seven (50)
accept 4808 |npc Tinkee Steamboil |at 1428 65.2,24.0 |lvl 50 |preany 4726  -- Felnok Steelspring (54)
accept 4022 |npc Cyrus Therepentous |at 1428 95.1,31.6 |group elite |lvl 52 |preany 3481 |exclusive 4023  -- A Taste of Flame (54)
complete 4022 |at 1428 94.4,31.8 |mobs Cyrus Therepentous;Frenzied Black Drake@Black Dragonflight Molt |group elite  -- A Taste of Flame (54)
turnin 4022 |npc Cyrus Therepentous |at 1428 95.1,31.6 |group elite  -- A Taste of Flame (54)
accept 3822 |npc Sha'ni Proudtusk |at 1428 80.0,45.4 |lvl 48 |preany 3821  -- Krom'Grul (53)
complete 3822 |at 1428 79.7,47.4 |mobs Krom'Grul@Sha'ni's Nose-Ring  -- Krom'Grul (53)
accept 5522 |npc Tinkee Steamboil |at 1428 65.2,24.0 |group dungeon |lvl 57 |preany 4735  -- Leonid Barthalomew (60)
accept 84211 |npc Red Bag |at 1428 53.0,24.4 |class WARRIOR |lvl 58  -- Poacher's Den (60)
complete 84211 |at 1428 50.8,30.2 |item 226698 |mobs Sulfuron Smuggler@Vertically Composited Patch Hampler;Blackrock Bootlegger@Vertically Composited Patch Hampler;Abel@Vertically Composited Patch Hampler;Plio@Vertically Composited Patch Hampler |class WARRIOR  -- Poacher's Den (60)
turnin 3822 |npc Thal'trak Proudtusk |at 1418 3.4,48.1  -- Krom'Grul (53)
accept 4061 |npc Hierophant Theodora Mulvadania |at 1418 3.0,47.8 |value mid |lvl 52  -- The Rise of the Machines (54)
complete 4061 |at 1428 62.1,40.5 |mobs War Reaver@Fractured Elemental Shard;Greater Obsidian Elemental@Fractured Elemental Shard;Malfunctioning Reaver@Fractured Elemental Shard |value mid  -- The Rise of the Machines (54)
turnin 4061 |npc Hierophant Theodora Mulvadania |at 1418 3.0,47.8 |value mid  -- The Rise of the Machines (54)
turnin 5522 |npc Leonid Barthalomew the Revered |at 1423 71.9,48.3 |group dungeon  -- Leonid Barthalomew (60)
turnin 4808 |npc Felnok Steelspring |at 1452 61.6,38.6  -- Felnok Steelspring (54)
turnin 84211 |npc Nami |at 2482 60.1,61.2 |class WARRIOR  -- Poacher's Den (60)
]]}
