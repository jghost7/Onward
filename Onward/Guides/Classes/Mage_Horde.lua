-- GENERATED Mage (Horde) class guides 2026-11-27 by tools/draft_classes.py
-- from Questie's Forever database (GPL-3.0).

Onward:RegisterGuide{
  id = "class_mage_horde_mage10", title = "Level 10 Mage Trials", kind = "class",
  class = "MAGE", faction = "Horde", race = "Scourge,Troll", levels = { 10, 10 },
  steps = [[
accept 1882 |npc Anastasia Hartwell |at 1458 85.1,10.0 |exclusive 1884  -- The Balnir Farmstead (10)
complete 1882 |at 1420 77.6,62.0  -- The Balnir Farmstead (10)
turnin 1882 |npc Anastasia Hartwell |at 1458 85.1,10.0  -- The Balnir Farmstead (10)
]]}

Onward:RegisterGuide{
  id = "class_mage_horde_mage15", title = "Spellfire Robes", kind = "class",
  class = "MAGE", faction = "Horde", race = "Orc,Scourge,Troll", levels = { 15, 16 },
  steps = [[
accept 1960 |npc Anastasia Hartwell |at 1458 85.1,10.0  -- Investigate the Alchemist Shop (16)
complete 1960 |at 1458 85.7,10.2 |mobs Rift Spawn  -- Investigate the Alchemist Shop (16)
turnin 1960 |npc Anastasia Hartwell |at 1458 85.1,10.0  -- Investigate the Alchemist Shop (16)
accept 1961 |npc Anastasia Hartwell |at 1458 85.1,10.0 |preany 1960  -- Gathering Materials (15)
complete 1961 |at 1421 59.6,63.2 |mobs Dalaran Apprentice;Dalaran Watcher;Dalaran Wizard;Dalaran Protector  -- Gathering Materials (15)
turnin 1961 |npc Josef Gregorian |at 1458 70.8,30.7  -- Gathering Materials (15)
accept 1962 |npc Rhiannon Davis |at 1458 70.0,30.6 |race Scourge,Troll |preany 1961  -- Spellfire Robes (15)
turnin 1962 |npc Rhiannon Davis |at 1458 70.0,30.6 |race Scourge,Troll  -- Spellfire Robes (15)
]]}

Onward:RegisterGuide{
  id = "class_mage_horde_mage26", title = "Nether-lace Garment", kind = "class",
  class = "MAGE", faction = "Horde", race = "Orc,Scourge,Troll", levels = { 26, 26 },
  steps = [[
accept 1944 |npc Deino |at 1454 38.5,86.1  -- Waters of Xavian (26)
complete 1944 |at 1440 76.3,41.5 |item 7269  -- Waters of Xavian (26)
turnin 1944 |npc Deino |at 1454 38.5,86.1  -- Waters of Xavian (26)
accept 1945 |npc Deino |at 1454 38.5,86.1 |race Scourge,Troll |preany 1944  -- Laughing Sisters (26)
complete 1945 |at 1440 59.8,54.7 |mobs Laughing Sister |race Scourge,Troll  -- Laughing Sisters (26)
turnin 1945 |npc Kil'hala |at 1413 52.2,31.7 |race Scourge,Troll  -- Laughing Sisters (26)
accept 1946 |npc Kil'hala |at 1413 52.2,31.7 |race Scourge,Troll |preany 1945  -- Nether-lace Garment (26)
turnin 1946 |npc Kil'hala |at 1413 52.2,31.7 |race Scourge,Troll  -- Nether-lace Garment (26)
]]}

Onward:RegisterGuide{
  id = "class_mage_horde_tabetha30", title = "Tabetha's Wand & Rituals of Power", kind = "class",
  class = "MAGE", faction = "Horde", levels = { 30, 40 },
  steps = [[
accept 1947 |npc Deino |at 1454 38.5,86.1  -- Journey to the Marsh (38)
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
  id = "class_mage_horde_tabetha35", title = "Celestial Power (Infernal Orb)", kind = "class",
  class = "MAGE", faction = "Horde", levels = { 35, 40 },
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
  id = "class_mage_horde_literacy", title = "A Lesson in Literacy", kind = "class",
  class = "MAGE", faction = "Horde", levels = { 42, 45 },
  steps = [[
accept 82084 |npc Owen Thadd |at 1458 73.4,33.0  -- A Lesson in Literacy (45)
complete 82084 |at 1425 55.2,51.4 |mobs Savage Owlbeast;Primitive Owlbeast;Zukk'ash Tunneler;Vicious Owlbeast  -- A Lesson in Literacy (45)
turnin 82084 |npc Owen Thadd |at 1458 73.4,33.0  -- A Lesson in Literacy (45)
]]}

Onward:RegisterGuide{
  id = "class_mage_horde_st50", title = "Sunken Temple: Destroy Morphaz", kind = "class",
  class = "MAGE", faction = "Horde", levels = { 50, 52 },
  steps = [[
accept 8250 |npc Uthel'nay |at 1454 39.2,86.3  -- Magecraft (52)
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
  id = "class_mage_horde_krellian", title = "Warlord Krellian & Fragmented Magic", kind = "class",
  class = "MAGE", faction = "Horde", levels = { 60, 60 },
  steps = [[
accept 9362 |npc Archmage Xylem |at 1447 29.2,40.2  -- Warlord Krellian (60)
complete 9362 |at 1447 53.6,48.8 |mobs Scalebeard;Warlord Krellian  -- Warlord Krellian (60)
turnin 9362 |npc Archmage Xylem |at 1447 29.2,40.2  -- Warlord Krellian (60)
accept 9364 |npc Archmage Xylem |at 1447 29.2,40.2 |preany 9362  -- Fragmented Magic (60)
complete 9364 |at 1447 29.9,53.5 |item 23250 |mobs Polymorph Clone  -- Fragmented Magic (60)
turnin 9364 |npc Archmage Xylem |at 1447 29.2,40.2  -- Fragmented Magic (60)
]]}
