-- DRAFT Shen'dralas (Horde) generated 2026-11-19 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "shen-dralas-h-2", title = "Shen'dralas (45-49)", faction = "Horde", zone = "Shen'dralas",
  levels = { 45, 49 },
  steps = [[
accept 93404 |npc Woodwyrd |at 2652 69.7,71.8 |preany 93594  -- Rot and Regret (49)
complete 93404 |at 2652 69.7,71.8 |mobs Woodwyrd  -- Rot and Regret (49)
turnin 93404 |npc Woodwyrd |at 2652 69.7,71.8  -- Rot and Regret (49)
accept 93601 |npc Woodwyrd |at 2652 69.7,71.8 |preany 93404  -- Passing the Blame (45)
accept 93644 |note No quest giver on record: it most likely starts from an item you loot or find in this zone. Hand it in to Mordent Evenshade |loose  -- Tattered Journal (45)
accept 93574 |note No quest giver on record: it most likely starts from an item you loot or find in this zone. Hand it in to Kog'thug the Brave |loose |group elite  -- Corpsefeeder's Carapace (45)
complete 93644 |at 2652 57.6,54.1 |areas 34.0,27.3:154;57.6,54.1:116;57.3,23.8:111 |mobs Magram Necromancer@Tattered Journal  -- Tattered Journal (45)
complete 93574 |at 2652 62.9,40.1 |areas 59.2,23.8:112;47.2,32.0:84;62.9,40.1:59 |mobs Corpsefeeder@Corpsefeeder's Carapace |group elite  -- Corpsefeeder's Carapace (45)
accept 93568 |note No quest giver on record: it most likely starts from an item you loot or find in this zone. Hand it in to Liranne |loose  -- Partially Digested Collar (45)
accept 93609 |note No quest giver on record: it most likely starts from an item you loot or find in this zone. Hand it in to Mithera |loose  -- Forlorn Necklace (45)
turnin 93601 |npc Kog'thug the Brave |at 2652 72.7,31.2  -- Passing the Blame (45)
turnin 93574 |npc Kog'thug the Brave |at 2652 72.7,31.2 |group elite  -- Corpsefeeder's Carapace (45)
accept 93604 |npc Kog'thug the Brave |at 2652 72.7,31.2 |preany 93601  -- Agamaggan's Blood (45)
complete 93604  -- Agamaggan's Blood (45)
turnin 93604 |npc Kog'thug the Brave |at 2652 72.7,31.2  -- Agamaggan's Blood (45)
accept 93606 |npc Kog'thug the Brave |at 2652 72.7,31.2 |value low |preany 93604  -- Not on Squealing Terms (45)
complete 93606 |at 2652 58.8,41.9 |mobs Desolace Bone Worm;Shen'dralas Protector |value low  -- Not on Squealing Terms (45)
complete 93609 |at 2652 58.8,41.9 |mobs Desolace Bone Worm;Shen'dralas Protector  -- Forlorn Necklace (45)
turnin 93606 |npc Quolga the Wise |at 2652 58.1,14.8 |value low  -- Not on Squealing Terms (45)
turnin 93644 |npc Mordent Evenshade |at 2652 35.2,46.6  -- Tattered Journal (45)
complete 93568 |at 2652 48.6,55.4 |mobs Prowler@Partially Digested Collar  -- Partially Digested Collar (45)
turnin 93568 |npc Liranne |at 2652 47.5,65.6  -- Partially Digested Collar (45)
turnin 93609 |npc Mithera |at 2652 53.3,76.0  -- Forlorn Necklace (45)
]]}
