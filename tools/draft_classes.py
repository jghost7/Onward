"""Generate Onward class questline guides for every class and faction from QuestieDB (WoW Forever).

    python tools/draft_classes.py -> Onward/Guides/Classes/<Class>_<Faction>.lua + Classes.xml

Each class + faction file registers one guide per class questline milestone (e.g. Rogue: Poisons,
Lockpicking, Ravenholdt & Syndicate, Sunken Temple; Shaman: Call of Earth / Fire / Water / Air;
Druid: Bear / Cure Poison / Aquatic / Cat Form; Warlock: Voidwalker / Succubus / Felhunter /
Dreadsteed; etc.), filtered by `kind = "class"`, `class`, and `faction`.

Data: Questie/QuestieDB (GPL-3.0), so generated guides are GPL-3.0 too.
"""
import datetime
import math
import pathlib
import re

from questiedb import QuestieDB, TOC, area_to_uimap, lua_list, map_names
import draft_guide

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT_DIR = ROOT / "Onward" / "Guides" / "Classes"

SORT_CLASS = {
    -81: "WARRIOR",
    -141: "PALADIN",
    -261: "HUNTER",
    -162: "ROGUE",
    -262: "PRIEST",
    -82: "SHAMAN",
    -161: "MAGE",
    -61: "WARLOCK",
    -263: "DRUID",
}
CLASS_LABEL = {
    "WARRIOR": "Warrior", "PALADIN": "Paladin", "HUNTER": "Hunter",
    "ROGUE": "Rogue", "PRIEST": "Priest", "SHAMAN": "Shaman",
    "MAGE": "Mage", "WARLOCK": "Warlock", "DRUID": "Druid",
}
CLASS_ORDER = ["WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "SHAMAN", "MAGE", "WARLOCK", "DRUID"]

CLASSIC_A, CLASSIC_H = 77, 178
SKY_A, SKY_H = 2 ** 32, 2 ** 33
ALLIANCE, HORDE = CLASSIC_A | SKY_A, CLASSIC_H | SKY_H
RACE_BITS = {
    1: "Human", 2: "Orc", 4: "Dwarf", 8: "NightElf", 16: "Scourge",
    32: "Tauren", 64: "Gnome", 128: "Troll",
    SKY_A: "SkyborneAlliance", SKY_H: "SkyborneHorde",
}

# Milestone grouping & curated titles: any chain containing one of these anchor quest IDs
# gets merged into the same milestone guide (merging racial variants / fragmented subchains
# into one clean row in the Class tab) and receives the human-friendly title.
MILESTONES = {
    "WARRIOR": [
        ("defensive", "Defensive Stance", {1638, 1639, 1640, 1678, 1679, 1683, 1684, 1686, 1498, 1502, 1503, 1505, 1818, 1819, 1820, 1821, 1822, 94003}),
        ("armor20", {"Alliance": "Fire Hardened Mail", "Horde": "Brutal Armor"}, {1698, 1699, 1700, 1701, 1702, 1782, 1823, 1824, 1838, 1848}),
        ("whirlwind", "Berserker Stance & Whirlwind Weapon", {1718, 1719, 1791, 1712, 1713, 1792}),
        ("st50", "Sunken Temple: Voodoo Feathers", {8417, 8423, 8424, 8425}),
    ],
    "PALADIN": [
        ("horde_start", "Path of the Forsaken Paladin", {91208, 91209, 91282, 91285, 91294, 91316, 91317, 95803}),
        ("redemption", {"Alliance": "Redemption: Tome of Divinity", "Horde": "Redemption: Lesson in Divinity"}, {1642, 1646, 1644, 1648, 1785, 1788, 94427, 94434, 94441}),
        ("verigan", {"Alliance": "Verigan's Fist", "Horde": "The Moonsilver Blade"}, {1649, 1650, 1653, 1806, 91858, 95036, 95140}),
        ("artifact", "A Strange Artifact", {78088, 78089, 78093}),
        ("aeonas35", "The Broken Hammer & Aeonas", {79939, 79940, 79945, 79946, 79963, 79970, 96438, 96439, 96449}),
        ("warhorse", "Summon Warhorse", {1661, 4485, 4486, 94971, 97022}),
        ("aeonas45", "In Search of Aeonas", {81762, 81764, 81765, 81790, 81885, 81944, 82135, 96476}),
        ("st50", {"Alliance": "Sunken Temple: Forging the Mightstone", "Horde": "The Reliquary of Tyr"}, {8414, 8415, 8416, 8418, 99187}),
        ("thane54", "A Thane's Gratitude", {84318, 84330, 84331, 84332, 84333, 84414}),
        ("charger", "Summon Charger", {7637, 7638, 7639, 7640, 7641, 7642, 7643, 7644, 7645, 7646, 7647, 7648, 7669, 7670, 97174, 97175, 97176, 97177, 97179, 97180, 97182, 97183, 97184, 97185, 97186}),
    ],
    "HUNTER": [
        ("taming", "Taming the Beast", {6061, 6062, 6063, 6064, 6081, 6086, 6089, 6103, 94007, 94013, 94050, 94792, 94793, 94978}),
        ("st50", "Sunken Temple: The Green Drake", {8151, 8153, 8231, 8232}),
        ("rhokdelar", "Rhok'delar: The Ancient Leaf", {7632, 7633, 7634, 7635, 7636}),
    ],
    "ROGUE": [
        ("rogue10", "Level 10 Rogue Trials", {1858, 1859, 1885, 1886, 1898, 1899, 1963, 1978, 2205, 2206, 2218, 2238, 2239, 2241, 2242}),
        ("lockpick16", {"Alliance": "Lockpicking: Alther's Mill", "Horde": "Lockpicking: Plundering the Plunderers"}, {1998, 1999, 2260, 2281, 2282, 2298, 2300, 2378, 2379, 2380, 2381, 2382}),
        ("poisons", {"Alliance": "Poisons: Klaven's Tower", "Horde": "Poisons: Mission Possible"}, {2359, 2360, 2607, 2608, 2609, 2458, 2460, 2478, 2479, 2480}),
        ("xelthos", "The Horn of Xelthos & Eye of Bhossca", {78261, 78270, 78307, 78676, 78699}),
        ("ravenholdt", "Ravenholdt & Syndicate", {6681, 6701, 96779, 96781, 96782, 96783, 96784, 96785, 96786}),
        ("kazdor", "The Talisman of Kazdor", {80411, 80453, 80454, 80455, 80526}),
        ("st50", "Sunken Temple: The Azure Key", {8233, 8234, 8235, 8236}),
    ],
    "PRIEST": [
        ("garments", {"Alliance": "Garments of the Light", "Horde": "Garments of Faith"}, {5621, 5624, 5625, 5648, 5650}),
        ("racial10", "Level 10 Racial Spell", {5627, 5628, 5634, 5652, 5658, 94773, 94817}),
        ("racial20", "Level 20 Racial Spell", {5641, 5642, 5644, 5672, 5676, 94818}),
        ("trollscroll", "The Troll Scroll", {79731}),
        ("st50", "Sunken Temple: Blood of Morphaz", {8254, 8255, 8256, 8257}),
        ("benediction", "Benediction / Anathema", {7621, 7622}),
    ],
    "SHAMAN": [
        ("earth", "Call of Earth (Earth Totem)", {1516, 1517, 1518, 1519, 1520, 1521, 94373, 94374, 94375, 96243}),
        ("fire", "Call of Fire (Fire Totem)", {1524, 1525, 1526, 1527, 94449, 94465, 94466, 94467, 94468, 97243, 97244, 97245, 97257}),
        ("water", "Call of Water (Water Totem)", {63, 96, 100, 220, 1530, 1534, 1535, 1536, 94494, 94495, 94497, 94499, 94500, 94501, 94502, 94503, 94505}),
        ("air", "Call of Air & Tempest's Weapons", {1531, 1532, 79358, 79360, 79361, 79364, 79365, 79366, 79442, 94789, 96016, 96135, 96136, 96264}),
        ("desertwolf", "Challenge of the Desert Wolf", {95753}),
        ("st50", "Sunken Temple: Da Voodoo", {8410, 8411, 8412, 8413}),
        ("darkreaver", "The Darkreaver Menace", {7667, 8258, 97168}),
    ],
    "MAGE": [
        ("mage10", "Level 10 Mage Trials", {1861, 1880, 1882, 1884, 93791, 93797}),
        ("mage15", {"Alliance": "Manaweave Robe", "Horde": "Spellfire Robes"}, {1920, 1921, 1941, 1960, 1961, 1962}),
        ("mage26", {"Alliance": "Astral Knot Garment", "Horde": "Nether-lace Garment"}, {1938, 1940, 1942, 1944, 1945, 1946}),
        ("tabetha30", "Tabetha's Wand & Rituals of Power", {1947, 1948, 1949, 1950, 1951, 1952}),
        ("tabetha35", "Celestial Power (Infernal Orb)", {1954, 1955, 1956, 1957, 1958}),
        ("literacy", "A Lesson in Literacy", {82084}),
        ("st50", "Sunken Temple: Destroy Morphaz", {8250, 8251, 8252, 8253}),
        ("water60", "Arcane Refreshment (Conjure Water)", {7463}),
        ("krellian", "Warlord Krellian & Fragmented Magic", {9362, 9364}),
    ],
    "WARLOCK": [
        ("imp", "Summon Imp / Starter Trials", {1598, 1599, 1470, 1485, 1715}),
        ("voidwalker", "Summon Voidwalker", {1471, 1473, 1501, 1504, 1688, 1689}),
        ("succubus", "Summon Succubus", {1472, 1474, 1476, 1507, 1508, 1509, 1510, 1511, 1512, 1513, 1515, 1716, 1738, 1739}),
        ("soranruk", "The Orb of Soran'ruk", {1740}),
        ("felhunter", "Summon Felhunter", {1758, 1795, 1801, 1802, 1803, 1804, 1805}),
        ("bloodrobe", "Enchanted Gold Bloodrobe", {1796, 4781, 4782, 4783, 4784, 4786}),
        ("orahil", "The Orb of Orahil", {1799, 4961, 4962, 4963, 4964, 4975, 4976}),
        ("felsteed", "Summon Felsteed", {3631, 4487, 4488, 4489, 4490}),
        ("st50", "Sunken Temple: Trolls of a Feather", {8419, 8420, 8421, 8422}),
        ("infernal", "Infernal: Kroshius' Infernal Core", {7601, 7602, 7603}),
        ("dreadsteed", "Dreadsteed of Xoroth", {7562, 7563, 7564, 7581, 7582, 7583, 7623, 7624, 7625, 7626, 7627, 7628, 7629, 7630, 7631}),
    ],
    "DRUID": [
        ("bear", "Bear Form (Great Bear Spirit)", {5921, 5922, 5929, 5930, 5931, 5932, 6001, 6002, 94006, 94638, 94911, 94912, 94913, 94914}),
        ("curepoison", "Cure Poison (Power over Poison)", {6121, 6122, 6123, 6124, 6125, 6126, 6127, 6128, 6129, 6130}),
        ("aquatic", "Aquatic Form (Trial of the Sea Lion)", {26, 27, 28, 29, 30, 31, 272, 5061}),
        ("cat", "Cat Form (Great Cat Spirit)", {98340, 98341, 98342, 98362, 98393, 98394, 98396, 98397, 98404, 98405, 98731, 98738, 98739}),
        ("guardians", "Wisdom of the Guardians", {81924}),
        ("st50", "Sunken Temple: A Better Ingredient", {9051, 9052, 9053, 9063}),
    ],
}


def s(v):
    return v.decode("utf-8", "replace") if isinstance(v, bytes) else (v or "")


def clean(t):
    return str(t).replace("|", "/").replace("]]", "] ]")


def slugify(text):
    out = re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")
    return out[:28] or "chain"


def as_area_map(spawns):
    if isinstance(spawns, list):
        return {i + 1: v for i, v in enumerate(spawns) if v}
    return spawns if isinstance(spawns, dict) else {}


def medoid(pts):
    if not pts:
        return None
    if len(pts) == 1:
        return pts[0]
    best, best_d = pts[0], 1e18
    for p in pts:
        d = sum(math.hypot(p[0] - q[0], p[1] - q[1]) for q in pts)
        if d < best_d:
            best, best_d = p, d
    return best


def all_points(spawns, a2m, dm):
    """Return {uimap: [(x, y), ...]} across all world maps (excluding dungeons if world exists)."""
    world, inst = {}, {}
    for area, lst in as_area_map(spawns).items():
        m = a2m.get(area)
        if not m:
            continue
        bucket = inst if m in dm else world
        for c in lua_list(lst):
            c = lua_list(c)
            if len(c) >= 2 and c[0] is not None and c[0] >= 0:
                bucket.setdefault(m, []).append((float(c[0]), float(c[1])))
    return world or inst


def pick_entity_spot(db, ent_lists, a2m, dm, fac_letter, prefer_map=None):
    """Find best (map, x, y, name) from startedBy / finishedBy table ([npcs, objs, items])."""
    npcs = lua_list(ent_lists[0]) if len(ent_lists) > 0 else []
    objs = lua_list(ent_lists[1]) if len(ent_lists) > 1 else []
    cands = []
    for n in npcs:
        friendly = s(db.npc(n, "friendlyToFaction")) or "AH"
        if fac_letter not in friendly:
            continue
        nm = s(db.npc(n, "name"))
        pts_by_map = all_points(db.npc(n, "spawns"), a2m, dm)
        for m, pts in pts_by_map.items():
            xy = medoid(pts)
            cands.append((0 if m == prefer_map else 1, 0 if m not in dm else 1, -len(pts), m, xy[0], xy[1], nm))
    if not cands:
        # fallback: allow neutral/unmarked NPCs if none matched friendlyToFaction strictly
        for n in npcs:
            nm = s(db.npc(n, "name"))
            pts_by_map = all_points(db.npc(n, "spawns"), a2m, dm)
            for m, pts in pts_by_map.items():
                xy = medoid(pts)
                cands.append((0 if m == prefer_map else 1, 0 if m not in dm else 1, -len(pts), m, xy[0], xy[1], nm))
    for o in objs:
        nm = s(db.obj(o, "name"))
        pts_by_map = all_points(db.obj(o, "spawns"), a2m, dm)
        for m, pts in pts_by_map.items():
            xy = medoid(pts)
            cands.append((0 if m == prefer_map else 1, 1 if m not in dm else 2, -len(pts), m, xy[0], xy[1], nm))
    if not cands:
        return None
    cands.sort()
    _, _, _, m, x, y, nm = cands[0]
    return (m, x, y, nm)


def objective_spot(db, q, a2m, dm, prefer_map=None):
    """Compute (has_objectives, spot=(map, x, y) or None, mobs=[...], use_item)."""
    raw_obj = db.quest(q, "objectives")
    trig = db.quest(q, "triggerEnd")
    extra = db.quest(q, "extraObjectives")
    groups = {}
    if isinstance(raw_obj, dict):
        groups = raw_obj
    elif isinstance(raw_obj, list):
        for i, v in enumerate(raw_obj):
            if v:
                groups[i + 1] = v
    has_obj = any(lua_list(v) for v in groups.values()) or bool(trig) or bool(extra)
    if not has_obj:
        return False, None, [], None

    pts_by_map = {}
    mob_counts = {}

    def add_spawns(sp, mob_name=None):
        for m, pts in all_points(sp, a2m, dm).items():
            pts_by_map.setdefault(m, []).extend(pts)
            if mob_name and not any(c in mob_name for c in ";|@"):
                mob_counts[mob_name] = mob_counts.get(mob_name, 0) + len(pts)

    # 1: creatures, 2: objects, 3: items, 5: killCredit
    for e in lua_list(groups.get(1)):
        e = lua_list(e)
        if e and e[0]:
            add_spawns(db.npc(e[0], "spawns"), s(db.npc(e[0], "name")))
    for e in lua_list(groups.get(2)):
        e = lua_list(e)
        if e and e[0]:
            add_spawns(db.obj(e[0], "spawns"))
    for e in lua_list(groups.get(3)):
        e = lua_list(e)
        if e and e[0]:
            iid = e[0]
            for n in lua_list(db.field("Item-", iid, 2)):
                add_spawns(db.npc(n, "spawns"), s(db.npc(n, "name")))
            for o in lua_list(db.field("Item-", iid, 3)):
                add_spawns(db.obj(o, "spawns"))
    for e in lua_list(groups.get(5)):
        e = lua_list(e)
        if e and e[0]:
            for n in lua_list(e[0]):
                add_spawns(db.npc(n, "spawns"), s(db.npc(n, "name")))
    if trig and isinstance(trig, list) and len(trig) >= 2 and isinstance(trig[1], dict):
        add_spawns(trig[1])

    spot = None
    if pts_by_map:
        # prefer world maps, then prefer_map, then most points
        ranked = sorted(
            pts_by_map.items(),
            key=lambda kv: (0 if kv[0] not in dm else 1, 0 if kv[0] == prefer_map else 1, -len(kv[1]), kv[0]),
        )
        m, pts = ranked[0]
        xy = medoid(pts)
        spot = (m, xy[0], xy[1])

    mobs = [nm for nm, _ in sorted(mob_counts.items(), key=lambda kv: (-kv[1], kv[0]))[:4]]
    use_item = db.quest(q, "sourceItemId")
    return True, spot, mobs, use_item


def quest_race_mask(db, q, fac_mask, classic_mask):
    rm = db.quest(q, "requiredRaces") or 0
    if not rm:
        return fac_mask
    m = rm & fac_mask
    if m & classic_mask == classic_mask:
        m = fac_mask
    return m


def race_tokens(mask, fac_mask):
    if not mask or mask == fac_mask:
        return []
    return [nm for bit, nm in RACE_BITS.items() if mask & bit]


def build_class_faction(db, a2m, dm, era_tags, blacklisted, draft_qids, zos, cls, faction):
    fac_mask = ALLIANCE if faction == "Alliance" else HORDE
    classic_mask = CLASSIC_A if faction == "Alliance" else CLASSIC_H
    fac_letter = "A" if faction == "Alliance" else "H"

    # 1. Collect all eligible quests for this (class, faction)
    raw = {}
    for qid in db.ids("Quest-"):
        if qid in blacklisted or qid in draft_qids:
            continue
        if (db.quest(qid, "zoneOrSort") or 0) != zos:
            continue
        if (db.quest(qid, "specialFlags") or 0) & 1:
            continue
        name = s(db.quest(qid, "name"))
        if not name or any(tok in name for tok in ("<NYI>", "<TXT>", "[DEPRECATED", "UNUSED")) or name.strip() == "REUSEME":
            continue
        rlvl = db.quest(qid, "requiredLevel") or 0
        qlvl = db.quest(qid, "questLevel") or 0
        if rlvl < 4 and qlvl < 4:
            continue
        if qid == 97286:  # Research Access: requires any of 40 hidden Mage Library books
            continue
        rm = quest_race_mask(db, qid, fac_mask, classic_mask)
        if not rm:
            continue
        sb = lua_list(db.quest(qid, "startedBy"))
        fb = lua_list(db.quest(qid, "finishedBy"))
        if not sb or not fb:
            continue
        start = pick_entity_spot(db, sb, a2m, dm, fac_letter)
        fin = pick_entity_spot(db, fb, a2m, dm, fac_letter, prefer_map=start[0] if start else None)
        if not start and not fin:
            continue
        has_obj, obj_spot, mobs, use_item = objective_spot(
            db, qid, a2m, dm, prefer_map=start[0] if start else (fin[0] if fin else None)
        )
        # Re-pick start/finish preferring objective map if available
        if obj_spot:
            start = pick_entity_spot(db, sb, a2m, dm, fac_letter, prefer_map=obj_spot[0]) or start
            fin = pick_entity_spot(db, fb, a2m, dm, fac_letter, prefer_map=obj_spot[0]) or fin
        pre_all = [abs(p) for p in lua_list(db.quest(qid, "preQuestGroup")) if p]
        pre_any = [abs(p) for p in lua_list(db.quest(qid, "preQuestSingle")) if p]
        excl = [abs(p) for p in lua_list(db.quest(qid, "exclusiveTo")) if p]
        nxt = db.quest(qid, "nextQuestInChain") or 0
        bc = db.quest(qid, "breadcrumbForQuestId") or 0
        grp = era_tags.get(qid)
        if not grp and obj_spot and obj_spot[0] in dm:
            grp = "dungeon"
        raw[qid] = {
            "id": qid, "name": name,
            "rlvl": max(1, rlvl or qlvl), "qlvl": max(1, qlvl if qlvl > 0 else (rlvl or 1)),
            "rm": rm, "start": start, "finish": fin,
            "hasObj": has_obj, "obj": obj_spot, "mobs": mobs, "useItem": use_item,
            "preAll": pre_all, "preAny": pre_any, "excl": excl, "nxt": nxt, "bc": bc,
            "group": grp,
        }

    # 2. Drop optional breadcrumbs (when their target is in raw and does not require them)
    required_by = set()
    for q in raw.values():
        for p in q["preAll"]:
            required_by.add(p)
        local_any = [p for p in q["preAny"] if p in raw]
        if len(local_any) == 1:
            required_by.add(local_any[0])
    for qid in list(raw):
        q = raw[qid]
        if q["bc"] and q["bc"] in raw and qid not in required_by:
            del raw[qid]
            continue
        # Pure talk-to-trainer breadcrumb whose nextQuestInChain is already in raw and has no prereq on us
        if (not q["hasObj"]) and q["nxt"] in raw and qid not in required_by:
            target = raw[q["nxt"]]
            if qid not in target["preAll"] and qid not in target["preAny"]:
                # keep only if target has a different race or no valid start of its own
                if target["start"] and (target["rm"] & q["rm"]) == q["rm"]:
                    del raw[qid]

    # 3. Resolve mutually exclusive conflicts when race masks overlap.
    # Evaluate root quests (no local prereq) BEFORE dependent quests so two rival chains
    # (e.g. Undercity vs Orgrimmar Succubus) don't cross-drop each other's roots!
    dropped = set()
    def rank_q(qid):
        q = raw[qid]
        has_local_pre = any(p in raw for p in q["preAll"] + q["preAny"])
        return (
            1 if has_local_pre else 0,
            1 if q["bc"] else 0,
            0 if q["nxt"] in raw else 1,
            0 if q["hasObj"] else 1,
            qid,
        )

    for qid in sorted(list(raw), key=rank_q):
        if qid in dropped or qid not in raw:
            continue
        q = raw[qid]
        conflicts = set(q["excl"]) | {o for o, ov in raw.items() if qid in ov["excl"]}
        for other in sorted(conflicts, key=lambda x: rank_q(x) if x in raw else (9, 9, 9, x)):
            if other == qid or other in dropped or other not in raw:
                continue
            # Only drop if race masks overlap (disjoint race variants both stay!)
            if raw[other]["rm"] & q["rm"]:
                dropped.add(other)
    # Cascade-drop quests whose required prereq was dropped (or all preAny were dropped)
    changed = True
    while changed:
        changed = False
        for qid in list(raw):
            if qid in dropped:
                continue
            q = raw[qid]
            if any(p in dropped for p in q["preAll"]):
                dropped.add(qid); changed = True
            elif q["preAny"] and all(p in dropped for p in q["preAny"]):
                dropped.add(qid); changed = True
    for qid in dropped:
        raw.pop(qid, None)

    # 4. Narrow race masks down prerequisite chains so dependents match their prereqs
    for _ in range(10):
        changed = False
        for q in raw.values():
            rm = q["rm"]
            for p in q["preAll"]:
                if p in raw:
                    rm &= raw[p]["rm"]
            local_any = [p for p in q["preAny"] if p in raw]
            if local_any:
                u = 0
                for p in local_any:
                    u |= raw[p]["rm"]
                rm &= u
            if rm and rm != q["rm"]:
                q["rm"] = rm
                changed = True
        if not changed:
            break

    # Propagate group tags down prerequisite chains (so lint_guides never sees solo quest depending on group quest)
    for _ in range(10):
        changed = False
        for q in raw.values():
            if q["group"]:
                continue
            for p in q["preAll"]:
                if p in raw and raw[p]["group"]:
                    q["group"] = raw[p]["group"]; changed = True; break
            if not q["group"]:
                local_any = [p for p in q["preAny"] if p in raw]
                if local_any and all(raw[p]["group"] for p in local_any):
                    q["group"] = raw[local_any[0]]["group"]; changed = True
        if not changed:
            break

    # 5. Build connected components, then merge into curated milestones
    adj = {q: set() for q in raw}
    for qid, q in raw.items():
        for p in q["preAll"] + q["preAny"]:
            if p in raw:
                adj[qid].add(p); adj[p].add(qid)
        if q["nxt"] in raw:
            adj[qid].add(q["nxt"]); adj[q["nxt"]].add(qid)

    seen = set()
    comps = []
    for qid in sorted(raw):
        if qid in seen:
            continue
        comp, stack = [], [qid]
        while stack:
            u = stack.pop()
            if u in seen:
                continue
            seen.add(u)
            comp.append(u)
            stack.extend(adj[u] - seen)
        comps.append(comp)

    milestones = MILESTONES.get(cls, [])
    grouped = {}  # key -> {"slug", "title", "qids": set}
    extra_idx = 0
    for comp in comps:
        cset = set(comp)
        matched = None
        for slug, title_spec, anchors in milestones:
            if cset & anchors:
                title = title_spec[faction] if isinstance(title_spec, dict) else title_spec
                matched = (slug, title)
                break
        if matched:
            slug, title = matched
            g = grouped.setdefault(slug, {"slug": slug, "title": title, "qids": set()})
            g["qids"].update(cset)
        else:
            extra_idx += 1
            rep = min(comp, key=lambda x: (raw[x]["rlvl"], raw[x]["qlvl"], x))
            title = raw[rep]["name"]
            slug = f"{slugify(title)}_{extra_idx}"
            grouped[slug] = {"slug": slug, "title": title, "qids": set(cset)}

    # 6. Order quests within each milestone guide respecting prerequisites & nextQuestInChain
    guides = []
    for g in grouped.values():
        qids = set(g["qids"])
        # Compute topological order
        deps = {q: set() for q in qids}
        for q in qids:
            for p in raw[q]["preAll"]:
                if p in qids and p != q:
                    deps[q].add(p)
            local_any = [p for p in raw[q]["preAny"] if p in qids and p != q]
            if local_any:
                # wait for all local_any that share a race with q, or at least the earliest
                for p in local_any:
                    deps[q].add(p)
            nxt = raw[q]["nxt"]
            if nxt in qids and nxt != q and q not in deps[nxt]:
                # soft chain edge (avoid cycles)
                deps[nxt].add(q)

        # Break any accidental cycle in soft edges by dropping nxt edges if needed
        order = []
        rem = set(qids)
        while rem:
            ready = [q for q in rem if not (deps[q] & rem)]
            if not ready:
                # Break cycle: pick lowest requiredLevel / id
                pick = min(rem, key=lambda x: (raw[x]["rlvl"], raw[x]["qlvl"], x))
                ready = [pick]
            ready.sort(key=lambda x: (raw[x]["rlvl"], raw[x]["qlvl"], raw[x]["rm"], x))
            pick = ready[0]
            order.append(pick)
            rem.remove(pick)

        # If a quest has requiredLevel=1 on a high-level Forever quest (e.g. L1/23 or L1/35), use qlvl for display
        eff_lo = lambda q: raw[q]["qlvl"] if (raw[q]["rlvl"] <= 1 and raw[q]["qlvl"] >= 10) else raw[q]["rlvl"]
        lo = min(eff_lo(q) for q in order)
        hi = max(max(raw[q]["qlvl"], eff_lo(q)) for q in order)
        # Guide-level race restriction if every quest shares a strict subset of faction races
        union_rm = 0
        for q in order:
            union_rm |= raw[q]["rm"]
        guide_races = race_tokens(union_rm, fac_mask)

        # Render steps (sequential accept -> complete -> turnin per quest keeps log <= 1!)
        lines = []
        for qid in order:
            q = raw[qid]
            # Step-level race tag only when narrower than the guide's own race union
            step_races = race_tokens(q["rm"], union_rm) if q["rm"] != union_rm else []
            who = ""
            if step_races:
                who += " |race " + ",".join(step_races)
            if q["group"]:
                who += " |group " + q["group"]

            # Pre tags (only include prereqs that exist in our guide or external required prereqs)
            gate = ""
            pre_all = [p for p in q["preAll"] if p in qids]
            pre_any = [p for p in q["preAny"] if p in qids and p not in pre_all]
            if pre_all:
                gate += " |pre " + ",".join(str(p) for p in pre_all)
            if pre_any:
                gate += " |preany " + ",".join(str(p) for p in pre_any)
            excl = [x for x in q["excl"] if x != qid]
            if excl:
                gate += " |exclusive " + ",".join(str(x) for x in excl)

            title_cmt = f"  -- {clean(q['name'])} ({q['qlvl']})"
            st = q["start"]
            st_npc = f" |npc {clean(st[3])}" if st and st[3] else ""
            st_at = f" |at {st[0]} {st[1]:.1f},{st[2]:.1f}" if st else ""
            lines.append(f"accept {qid}{st_npc}{st_at}{who}{gate}{title_cmt}")

            if q["hasObj"]:
                ob = q["obj"]
                ob_at = f" |at {ob[0]} {ob[1]:.1f},{ob[2]:.1f}" if ob else ""
                mobs = f" |mobs {';'.join(clean(m) for m in q['mobs'])}" if q["mobs"] else ""
                use = f" |item {q['useItem']}" if q["useItem"] else ""
                lines.append(f"complete {qid}{ob_at}{use}{mobs}{who}{title_cmt}")

            fn = q["finish"]
            fn_npc = f" |npc {clean(fn[3])}" if fn and fn[3] else ""
            fn_at = f" |at {fn[0]} {fn[1]:.1f},{fn[2]:.1f}" if fn else ""
            lines.append(f"turnin {qid}{fn_npc}{fn_at}{who}{title_cmt}")

        guides.append({
            "id": f"class_{cls.lower()}_{faction.lower()}_{g['slug']}",
            "title": g["title"],
            "class": cls,
            "faction": faction,
            "race": ",".join(guide_races) if guide_races else None,
            "levels": (lo, hi),
            "steps": lines,
            "count": len(order),
        })

    guides.sort(key=lambda g: (g["levels"][0], g["levels"][1], g["title"]))
    return guides


def render_file(cls, faction, guides):
    lbl = CLASS_LABEL[cls]
    out = [
        f"-- GENERATED {lbl} ({faction}) class guides {datetime.date.today()} by tools/draft_classes.py",
        "-- from Questie's Forever database (GPL-3.0).",
    ]
    for g in guides:
        lo, hi = g["levels"]
        lv_str = f"{lo}" if lo == hi else f"{lo}-{hi}"
        race_attr = f' race = "{g["race"]}",' if g["race"] else ""
        out.append("")
        out.append("Onward:RegisterGuide{")
        out.append(f'  id = "{g["id"]}", title = "{clean(g["title"])}", kind = "class",')
        out.append(f'  class = "{cls}", faction = "{faction}",{race_attr} levels = {{ {lo}, {hi} }},')
        out.append("  steps = [[")
        out.extend(g["steps"])
        out.append("]]}")
    return "\n".join(out) + "\n"


def main():
    db = QuestieDB(TOC)
    a2m = area_to_uimap()
    dm = draft_guide.dungeon_maps()
    era_tags = draft_guide.questie_era_tags()
    blacklisted = draft_guide.questie_blacklist()

    # Collect quests already accepted in Guides/Draft so we never duplicate a quest per faction
    draft_by_fac = {"Alliance": set(), "Horde": set()}
    for p in (ROOT / "Onward" / "Guides" / "Draft").glob("*.lua"):
        txt = p.read_text(encoding="utf-8")
        fac = "Alliance" if "Alliance" in p.name else "Horde"
        for q in re.findall(r"^\s*accept\s+(\d+)", txt, flags=re.M):
            draft_by_fac[fac].add(int(q))

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    # Clean old generated files
    for old in OUT_DIR.glob("*.lua"):
        old.unlink()

    xml_files = []
    total_guides = 0
    total_quests = 0
    sort_by_cls = {v: k for k, v in SORT_CLASS.items()}
    for cls in CLASS_ORDER:
        zos = sort_by_cls[cls]
        for faction in ("Alliance", "Horde"):
            guides = build_class_faction(db, a2m, dm, era_tags, blacklisted, draft_by_fac[faction], zos, cls, faction)
            if not guides:
                continue
            fname = f"{CLASS_LABEL[cls]}_{faction}.lua"
            (OUT_DIR / fname).write_text(render_file(cls, faction, guides), encoding="utf-8")
            xml_files.append(fname)
            qsum = sum(g["count"] for g in guides)
            total_guides += len(guides)
            total_quests += qsum
            print(f"  {fname:24s}: {len(guides):2d} guides, {qsum:2d} quests  "
                  + ", ".join(f"{g['title']} ({g['levels'][0]}-{g['levels'][1]})" for g in guides))

    xml = [
        '<Ui xmlns="http://www.blizzard.com/wow/ui/">',
        "    <!-- GENERATED by tools/draft_classes.py -->",
    ] + [f'    <Script file="{f}"/>' for f in xml_files] + ["</Ui>"]
    (OUT_DIR / "Classes.xml").write_text("\n".join(xml) + "\n", encoding="utf-8")
    print(f"\nGenerated {len(xml_files)} files, {total_guides} class guides, {total_quests} quests -> {OUT_DIR}")


if __name__ == "__main__":
    main()
