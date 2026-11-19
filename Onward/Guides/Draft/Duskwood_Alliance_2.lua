-- DRAFT Duskwood (Alliance) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "duskwood-a-2", title = "Duskwood (30-35)", faction = "Alliance", zone = "Duskwood",
  levels = { 30, 35 },
  steps = [[
home |npc Innkeeper Trelayne |at 1431 73.9,44.4  -- set your hearthstone at the inn
accept 58 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8 |lvl 18 |preany 57  -- The Night Watch (30)
accept 98 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8 |lvl 22 |preany 97  -- The Legend of Stalvan (35)
accept 222 |npc Calor |at 1431 75.8,47.6 |lvl 23 |preany 221  -- Worgen in the Woods (31)
accept 181 |npc Viktori Prism'Antras |at 1431 79.8,48.0 |lvl 20 |preany 177  -- Look To The Stars (30)
complete 98 |at 1431 77.3,36.2 |mobs Stalvan Mistmantle@Mistmantle Family Ring  -- The Legend of Stalvan (35)
accept 134 |npc Abercrombie |at 1431 28.1,31.5 |lvl 20 |preany 133  -- Ogre Thieves (30)
accept 55 |npc Sven Yorgen |at 1431 7.8,34.1 |group elite |lvl 20 |preany 325  -- Morbent Fel (32)
complete 55 |at 1431 16.9,33.4 |item 7297 |mobs Morbent Fel |group elite  -- Morbent Fel (32)
accept 225 |npc A Weathered Grave |at 1431 17.7,29.1 |lvl 28  -- The Weathered Grave (35)
turnin 55 |npc Sven Yorgen |at 1431 7.8,34.1 |group elite  -- Morbent Fel (32)
accept 96138 |at 1431 39.7,66.4 |note Starts from Merrick's Bow |startitem 281142 |lvl 18  -- Merrick's Bow (30)
complete 96138 |at 1431 34.7,75.7 |item 281142 |mobs Splinter Fist Warrior;Splinter Fist Taskmaster  -- Merrick's Bow (30)
complete 134 |at 1431 33.4,76.3  -- Ogre Thieves (30)
complete 181 |at 1431 38.0,80.0 |mobs Zzarc' Vul@Ogre's Monocle  -- Look To The Stars (30)
complete 222 |at 1431 73.0,72.7 |areas 73.0,72.7:20;61.9,81.9:13 |mobs Nightbane Vile Fang;Nightbane Tainted One  -- Worgen in the Woods (31)
turnin 181 |npc Viktori Prism'Antras |at 1431 79.8,48.0  -- Look To The Stars (30)
turnin 98 |npc Madame Eva |at 1431 75.8,45.3  -- The Legend of Stalvan (35)
turnin 222 |npc Calor |at 1431 75.8,47.6  -- Worgen in the Woods (31)
accept 223 |npc Calor |at 1431 75.8,47.6 |lvl 23 |preany 222  -- Worgen in the Woods (31)
turnin 223 |npc Jonathan Carevin |at 1431 75.3,49.0  -- Worgen in the Woods (31)
turnin 225 |npc Sirra Von'Indi |at 1431 72.6,47.6  -- The Weathered Grave (35)
accept 227 |npc Sirra Von'Indi |at 1431 72.6,47.6 |lvl 28 |preany 225  -- Morgan Ladimore (35)
turnin 227 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8  -- Morgan Ladimore (35)
accept 228 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8 |group elite |lvl 28 |preany 227  -- Mor'Ladim (35)
turnin 134 |npc Abercrombie |at 1431 28.1,31.5  -- Ogre Thieves (30)
accept 160 |npc Abercrombie |at 1431 28.1,31.5 |lvl 20 |preany 134  -- Note to the Mayor (30)
complete 58 |at 1431 23.7,34.1 |mobs Plague Spreader  -- The Night Watch (30)
complete 228 |at 1431 16.7,37.4 |mobs Mor'Ladim@Mor'Ladim's Skull |group elite  -- Mor'Ladim (35)
turnin 160 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4  -- Note to the Mayor (30)
accept 251 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4 |lvl 20 |preany 160  -- Translate Abercrombie's Note (30)
turnin 228 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8 |group elite  -- Mor'Ladim (35)
turnin 58 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8  -- The Night Watch (30)
accept 229 |npc Commander Althea Ebonlocke |at 1431 73.5,46.8 |group chain |lvl 28 |preany 228  -- The Daughter Who Lived (35)
turnin 229 |npc Watcher Ladimore |at 1431 74.0,47.8 |group chain  -- The Daughter Who Lived (35)
accept 231 |npc Watcher Ladimore |at 1431 74.0,47.8 |value mid |group chain |lvl 28 |preany 229  -- A Daughter's Love (35)
turnin 251 |npc Sirra Von'Indi |at 1431 72.6,47.6  -- Translate Abercrombie's Note (30)
accept 401 |npc Sirra Von'Indi |at 1431 72.6,47.6 |lvl 20 |preany 251  -- Wait for Sirra to Finish (30)
turnin 96138 |npc Sirra Von'Indi |at 1431 72.6,47.6  -- Merrick's Bow (30)
turnin 401 |npc Sirra Von'Indi |at 1431 72.6,47.6  -- Wait for Sirra to Finish (30)
accept 252 |npc Sirra Von'Indi |at 1431 72.6,47.6 |lvl 20 |preany 401  -- Translation to Ello (30)
turnin 252 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4  -- Translation to Ello (30)
accept 253 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4 |group elite |lvl 20 |preany 252  -- Bride of the Embalmer (30)
complete 253 |at 1431 28.8,30.9 |mobs Eliza@The Embalmer's Heart |group elite  -- Bride of the Embalmer (30)
turnin 231 |npc A Weathered Grave |at 1431 17.7,29.1 |value mid |group chain  -- A Daughter's Love (35)
turnin 253 |npc Lord Ello Ebonlocke |at 1431 71.9,46.4 |group elite  -- Bride of the Embalmer (30)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   1395  Supplies for Nethergarde (45)
--   98372  An Unfortunate End (60)
--   99267  An Unfortunate End (60)
