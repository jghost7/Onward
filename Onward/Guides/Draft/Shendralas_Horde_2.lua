-- DRAFT Shen'dralas (Horde) generated 2026-11-17 by tools/draft_guide.py
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
accept 93644 |value mid  -- Tattered Journal (45)
accept 93574 |group elite  -- Corpsefeeder's Carapace (45)
complete 93574 |at 2652 58.6,28.4 |mobs Corpsefeeder@Corpsefeeder's Carapace |group elite  -- Corpsefeeder's Carapace (45)
turnin 93601 |npc Kog'thug the Brave |at 2652 72.7,31.2  -- Passing the Blame (45)
accept 93604 |npc Kog'thug the Brave |at 2652 72.7,31.2 |preany 93601  -- Agamaggan's Blood (45)
complete 93604  -- Agamaggan's Blood (45)
turnin 93604 |npc Kog'thug the Brave |at 2652 72.7,31.2  -- Agamaggan's Blood (45)
accept 93606 |npc Kog'thug the Brave |at 2652 72.7,31.2 |value low |preany 93604  -- Not on Squealing Terms (45)
accept 93609  -- Forlorn Necklace (45)
accept 93568  -- Partially Digested Collar (45)
turnin 93574 |npc Kog'thug the Brave |at 2652 72.7,31.2 |group elite  -- Corpsefeeder's Carapace (45)
complete 93609 |at 2652 48.8,31.5 |mobs Desolace Bone Worm;Shen'dralas Protector  -- Forlorn Necklace (45)
complete 93606 |at 2652 48.8,31.5 |mobs Desolace Bone Worm;Shen'dralas Protector |value low  -- Not on Squealing Terms (45)
complete 93644 |at 2652 43.0,29.5 |mobs Magram Necromancer@Tattered Journal |value mid  -- Tattered Journal (45)
turnin 93606 |npc Quolga the Wise |at 2652 58.1,14.8 |value low  -- Not on Squealing Terms (45)
turnin 93644 |npc Mordent Evenshade |at 2652 35.2,46.6 |value mid  -- Tattered Journal (45)
complete 93568 |at 2652 48.3,54.6 |mobs Prowler@Partially Digested Collar  -- Partially Digested Collar (45)
turnin 93568 |npc Liranne |at 2652 47.5,65.6  -- Partially Digested Collar (45)
turnin 93609 |npc Mithera |at 2652 53.3,76.0  -- Forlorn Necklace (45)
]]}
