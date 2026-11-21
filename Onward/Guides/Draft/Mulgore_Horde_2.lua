-- DRAFT Mulgore (Horde) generated 2026-11-21 by tools/draft_guide.py
-- from Questie's Forever database (GPL-3.0). The order is computed, not played:
-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.
Onward:RegisterGuide{
  id = "mulgore-h-2", title = "Mulgore (58-60)", faction = "Horde", zone = "Mulgore",
  levels = { 58, 60 },
  steps = [[
accept 97198 |npc Muln Earthfury |at 1412 33.4,22.6 |lvl 52  -- Blackmaw Magic (59)
complete 97198  -- Blackmaw Magic (59)
turnin 97198 |npc Muln Earthfury |at 1412 33.4,22.6  -- Blackmaw Magic (59)
accept 98477 |npc Nuara Tremorhoof |at 1412 33.6,22.5 |value mid |lvl 48  -- Unstable Magic (60)
complete 98477 |item 281371 |value mid  -- Unstable Magic (60)
turnin 98477 |npc Nuara Tremorhoof |at 1412 33.6,22.5 |value mid  -- Unstable Magic (60)
accept 98476 |npc Nuara Tremorhoof |at 1412 33.6,22.5 |value mid |lvl 48 |preany 98477  -- More Unstable Magic (58)
complete 98476 |value mid  -- More Unstable Magic (58)
turnin 98476 |npc Nuara Tremorhoof |at 1412 33.6,22.5 |value mid  -- More Unstable Magic (58)
accept 99197 |npc Oura Stormspinner |at 1412 34.2,22.4 |lvl 26  -- A Donation of Silk (60)
accept 99196 |npc Oura Stormspinner |at 1412 34.2,22.4 |lvl 12  -- A Donation of Wool (60)
accept 99198 |npc Oura Stormspinner |at 1412 34.2,22.4 |lvl 40  -- A Donation of Mageweave (60)
complete 99197  -- A Donation of Silk (60)
turnin 99197 |npc Oura Stormspinner |at 1412 34.2,22.4  -- A Donation of Silk (60)
complete 99198  -- A Donation of Mageweave (60)
turnin 99198 |npc Oura Stormspinner |at 1412 34.2,22.4  -- A Donation of Mageweave (60)
complete 99196  -- A Donation of Wool (60)
turnin 99196 |npc Oura Stormspinner |at 1412 34.2,22.4  -- A Donation of Wool (60)
home |npc Innkeeper Kauth |at 1412 45.9,64.2  -- set your hearthstone at the inn
accept 99202 |npc Kar Stormsinger |at 1412 46.8,62.0 |lvl 60  -- Swift as the Wind (60)
complete 99202 |at 1412 46.9,62.0 |mobs Brown Riding Kodo;Gray Riding Kodo;White Riding Kodo;Grey Riding Kodo  -- Swift as the Wind (60)
accept 99217 |npc Harb Clawhoof |at 1412 46.6,62.1 |race Tauren |lvl 60  -- An Epic Ride (60)
complete 99217 |at 1412 46.7,62.1 |mobs Great Gray Kodo;Great Brown Kodo;Great White Kodo |race Tauren  -- An Epic Ride (60)
turnin 99217 |npc Harb Clawhoof |at 1412 46.6,62.1 |race Tauren  -- An Epic Ride (60)
turnin 99202 |npc Harb Clawhoof |at 1412 46.6,62.1  -- Swift as the Wind (60)
]]}

-- Not routed (far above the zone's level range, or no reachable path):
--   96241  Talkin' bout Toxins, Mon (29)
--   96259  Defending the Dead (29)
--   96260  Stronger than Steel (29)
--   96261  The Broodmother (30)
--   96294  A Darker Truth (30)
--   96774  Ancient Gurubashi Idol (40)
--   96982  Your First Riding Kodo (40)
--   97204  Learning to Ride (40)
