-- GENERATED Mage (Alliance) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_mage_alliance_mage10", title = "Level 10 Mage Trials", kind = "class",
  class = "MAGE", faction = "Alliance", levels = { 10, 10 },
  steps = [[
accept 1861 |npc Jennea Cannon |at 1453 49.6,85.8 |race Human,Gnome,SkyborneAlliance |exclusive 1880  -- Mirror Lake (10)
complete 1861 |at 1429 28.6,61.4 |item 7207 |race Human,Gnome,SkyborneAlliance  -- Mirror Lake (10)
turnin 1861 |npc Jennea Cannon |at 1453 49.6,85.8 |race Human,Gnome,SkyborneAlliance  -- Mirror Lake (10)
accept 93791 |npc Belann Windwood |at 2521 62.9,77.4  -- Speak with Belann (10)
turnin 93791 |npc Belann Windwood |at 2521 62.9,77.4  -- Speak with Belann (10)
accept 93797 |npc Belann Windwood |at 2521 62.9,77.4 |preany 93791  -- Boughs in the Wind (10)
complete 93797 |at 2521 48.6,67.6  -- Boughs in the Wind (10)
turnin 93797 |npc Belann Windwood |at 2521 62.9,77.4  -- Boughs in the Wind (10)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_mage15", title = "Manaweave Robe", kind = "class",
  class = "MAGE", faction = "Alliance", race = "Human,Gnome,SkyborneAlliance", levels = { 15, 16 },
  steps = [[
accept 1920 |npc Jennea Cannon |at 1453 49.6,85.8  -- Investigate the Blue Recluse (16)
complete 1920 |at 1453 49.6,85.6 |mobs Rift Spawn  -- Investigate the Blue Recluse (16)
turnin 1920 |npc Jennea Cannon |at 1453 49.6,85.8  -- Investigate the Blue Recluse (16)
accept 1921 |npc Jennea Cannon |at 1453 49.6,85.8 |preany 1920  -- Gathering Materials (15)
complete 1921 |at 1429 55.7,67.0  -- Gathering Materials (15)
turnin 1921 |npc Wynne Larson |at 1453 51.8,83.5  -- Gathering Materials (15)
accept 1941 |npc Wynne Larson |at 1453 51.8,83.5 |race Human,Gnome |preany 1921  -- Manaweave Robe (15)
turnin 1941 |npc Wynne Larson |at 1453 51.8,83.5 |race Human,Gnome  -- Manaweave Robe (15)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_mage26", title = "Astral Knot Garment", kind = "class",
  class = "MAGE", faction = "Alliance", race = "Human,Gnome,SkyborneAlliance", levels = { 26, 28 },
  steps = [[
accept 1938 |npc High Sorcerer Andromath |at 1453 48.7,87.6  -- Ur's Treatise on Shadow Magic (28)
complete 1938 |at 1433 73.8,47.6  -- Ur's Treatise on Shadow Magic (28)
turnin 1938 |npc High Sorcerer Andromath |at 1453 48.7,87.6  -- Ur's Treatise on Shadow Magic (28)
accept 1940 |npc High Sorcerer Andromath |at 1453 48.7,87.6 |preany 1938  -- Pristine Spider Silk (26)
complete 1940 |at 1431 32.6,48.2 |mobs Black Widow Hatchling;Carrion Recluse  -- Pristine Spider Silk (26)
turnin 1940 |npc Wynne Larson |at 1453 51.8,83.5  -- Pristine Spider Silk (26)
accept 1942 |npc Wynne Larson |at 1453 51.8,83.5 |race Human,Gnome |preany 1940  -- Astral Knot Garment (26)
turnin 1942 |npc Wynne Larson |at 1453 51.8,83.5 |race Human,Gnome  -- Astral Knot Garment (26)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_tabetha30", title = "Tabetha's Wand & Rituals of Power", kind = "class",
  class = "MAGE", faction = "Alliance", levels = { 30, 40 },
  steps = [[
accept 1947 |npc Jennea Cannon |at 1453 49.6,85.8  -- Journey to the Marsh (38)
turnin 1947 |npc Tabetha |at 1445 46.1,57.1  -- Journey to the Marsh (38)
accept 1949 |npc Tabetha |at 1445 46.1,57.1 |preany 1947  -- Hidden Secrets (38)
turnin 1949 |npc Magus Tirth |at 1441 78.3,75.7  -- Hidden Secrets (38)
accept 1950 |npc Magus Tirth |at 1441 78.3,75.7 |preany 1949  -- Get the Scoop (30)
complete 1950 |at 1441 79.6,75.6 |mobs "Plucky" Johnson  -- Get the Scoop (30)
turnin 1950 |npc Magus Tirth |at 1441 78.3,75.7  -- Get the Scoop (30)
accept 1948 |npc Tabetha |at 1445 46.1,57.1 |preany 1947  -- Items of Power (40)
complete 1948 |at 1445 49.4,45.0 |item 7516  -- Items of Power (40)
turnin 1948 |npc Tabetha |at 1445 46.1,57.1  -- Items of Power (40)
accept 1951 |npc Magus Tirth |at 1441 78.3,75.7 |group dungeon |preany 1950  -- Rituals of Power (40)
complete 1951 |group dungeon  -- Rituals of Power (40)
turnin 1951 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Rituals of Power (40)
accept 1952 |npc Tabetha |at 1445 46.1,57.1 |group dungeon |pre 1948,1951  -- Mage's Wand (40)
turnin 1952 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Mage's Wand (40)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_tabetha35", title = "Celestial Power (Infernal Orb)", kind = "class",
  class = "MAGE", faction = "Alliance", levels = { 35, 40 },
  steps = [[
accept 1954 |npc Tabetha |at 1445 46.1,57.1  -- The Infernal Orb (40)
complete 1954 |at 1443 80.3,77.0 |mobs Burning Blade Summoner  -- The Infernal Orb (40)
turnin 1954 |npc Tabetha |at 1445 46.1,57.1  -- The Infernal Orb (40)
accept 1955 |npc Tabetha |at 1445 46.1,57.1 |group elite |preany 1954  -- The Exorcism (40)
complete 1955 |at 1445 45.8,57.0 |mobs Demon of the Orb |group elite  -- The Exorcism (40)
turnin 1955 |npc Tabetha |at 1445 46.1,57.1 |group elite  -- The Exorcism (40)
accept 1956 |npc Tabetha |at 1445 46.1,57.1 |group dungeon |preany 1955  -- Power in Uldaman (40)
complete 1956 |group dungeon  -- Power in Uldaman (40)
turnin 1956 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Power in Uldaman (40)
accept 1957 |npc Tabetha |at 1445 46.1,57.1 |group dungeon |preany 1956  -- Mana Surges (40)
complete 1957 |at 1445 45.8,56.9 |mobs Mana Surge |group dungeon  -- Mana Surges (40)
turnin 1957 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Mana Surges (40)
accept 1958 |npc Tabetha |at 1445 46.1,57.1 |group dungeon |preany 1957  -- Celestial Power (40)
turnin 1958 |npc Tabetha |at 1445 46.1,57.1 |group dungeon  -- Celestial Power (40)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_literacy", title = "A Lesson in Literacy", kind = "class",
  class = "MAGE", faction = "Alliance", levels = { 42, 45 },
  steps = [[
accept 82084 |npc Garion Wendell |at 1453 48.9,86.5  -- A Lesson in Literacy (45)
complete 82084 |at 1425 55.2,51.4 |mobs Savage Owlbeast;Primitive Owlbeast;Zukk'ash Tunneler;Vicious Owlbeast  -- A Lesson in Literacy (45)
turnin 82084 |npc Garion Wendell |at 1453 48.9,86.5  -- A Lesson in Literacy (45)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_st50", title = "Sunken Temple: Destroy Morphaz", kind = "class",
  class = "MAGE", faction = "Alliance", levels = { 50, 52 },
  steps = [[
accept 8250 |npc Maginor Dumas |at 1453 49.2,87.8  -- Magecraft (52)
turnin 8250 |npc Sanath Lim-yo |at 1447 28.1,50.1  -- Magecraft (52)
accept 8251 |npc Archmage Xylem |at 1447 29.2,40.2  -- Magic Dust (52)
complete 8251 |at 1447 66.3,28.1 |mobs Blood Elf Arcanist;Blood Elf Reclaimer;Blood Elf Surveyor;Evin Schmidtt  -- Magic Dust (52)
turnin 8251 |npc Archmage Xylem |at 1447 29.2,40.2  -- Magic Dust (52)
accept 8252 |npc Archmage Xylem |at 1447 29.2,40.2 |preany 8251  -- The Siren's Coral (52)
complete 8252 |at 1447 44.4,53.9 |mobs Spitelash Siren  -- The Siren's Coral (52)
turnin 8252 |npc Archmage Xylem |at 1447 29.2,40.2  -- The Siren's Coral (52)
accept 8253 |npc Archmage Xylem |at 1447 29.2,40.2 |group dungeon |preany 8252  -- Destroy Morphaz (52)
complete 8253 |group dungeon  -- Destroy Morphaz (52)
turnin 8253 |npc Archmage Xylem |at 1447 29.2,40.2 |group dungeon  -- Destroy Morphaz (52)
]]}

Onward:RegisterGuide{
  id = "class_mage_alliance_krellian", title = "Warlord Krellian & Fragmented Magic", kind = "class",
  class = "MAGE", faction = "Alliance", levels = { 60, 60 },
  steps = [[
accept 9362 |npc Archmage Xylem |at 1447 29.2,40.2  -- Warlord Krellian (60)
complete 9362 |at 1447 53.6,48.8 |mobs Scalebeard;Warlord Krellian  -- Warlord Krellian (60)
turnin 9362 |npc Archmage Xylem |at 1447 29.2,40.2  -- Warlord Krellian (60)
accept 9364 |npc Archmage Xylem |at 1447 29.2,40.2 |preany 9362  -- Fragmented Magic (60)
complete 9364 |at 1447 29.9,53.5 |item 23250 |mobs Polymorph Clone  -- Fragmented Magic (60)
turnin 9364 |npc Archmage Xylem |at 1447 29.2,40.2  -- Fragmented Magic (60)
]]}
