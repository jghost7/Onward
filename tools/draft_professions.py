"""Draft profession leveling guides (1-300) for every primary and secondary profession.

    python tools/draft_professions.py [--fetch]

Sources (nothing from Zygor, RestedXP or Wowhead):
  * Forever's own client tables (DB2), exported by wago.tools for the current `wowf` build:
    SkillLineAbility (recipes, skill-up thresholds), SpellReagents, SpellEffect (created items,
    learn spells), SpellName, ItemSparse (names, prices, recipe skill), ItemEffect/ItemXItemEffect
    (which item teaches which recipe). `--fetch` downloads them into tools/data/db2/<build>/.
  * Questie's Forever database (GPL-3.0): trainer and vendor NPCs and their spawns, which items
    vendors sell, herb and ore node spawns.

Writes Onward/Guides/Professions/*.lua (one guide per profession) and ProfData.lua (trainers,
vendors), plus Professions.xml. The routes are estimates: the addon checks them in game against the
recipes you actually know and their real colours (Professions.lua).

Skill-up chance: orange (below the recipe's TrivialSkillLineRankLow) always; between low and high
(grey) it falls linearly, (high - skill) / (high - low); grey never. Crafting cost per expected
skill point picks the recipe at each skill level, with a penalty for switching recipes so the route
stays a few long runs.
"""
import csv
import math
import pathlib
import re
import sys
import urllib.request

sys.path.insert(0, str(pathlib.Path(__file__).parent))
from questiedb import QuestieDB, area_to_uimap, lua_list  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "Onward" / "Guides" / "Professions"
BUILD = "1.60.1.70938"
DATA = ROOT / "tools" / "data" / "db2" / BUILD
TABLES = ["SkillLineAbility", "SpellReagents", "SpellName", "ItemSparse", "SpellEffect", "ItemEffect", "ItemXItemEffect",
          "SpellCooldowns", "SpellCategories"]
# The Forever client tables also carry Season of Discovery recipes (spell ids 400000-499999),
# which Forever doesn't offer. Forever's own additions (ids from 1,000,000) are real but we can't
# tell which trainer teaches them, so the route only uses them when a vendor sells the recipe;
# the in-game helper still suggests any of them the player knows.
SOD_IDS = range(400000, 500000)
FOREVER_IDS = 1000000
# Cooking, First Aid and Fishing: Expert comes from a book sold by a vendor, Artisan from a quest
EXPERT_BOOK = {185: 16072, 129: 16084, 356: 16083}
ALLIANCE_RACES, HORDE_RACES = 1 | 4 | 8 | 64, 2 | 16 | 32 | 128
# zones in the other faction's home territory: kept, but heavily down-weighted for gathering
HOME = {"A": {1429, 1426, 1438, 1436, 1432, 1439, 1453, 1455, 1457, 1433, 1431, 1437},
        "H": {1411, 1412, 1413, 1420, 1421, 1454, 1456, 1458, 1424, 1441}}

CRAFT = {171: "Alchemy", 164: "Blacksmithing", 333: "Enchanting", 202: "Engineering", 165: "Leatherworking",
         197: "Tailoring", 185: "Cooking", 129: "First Aid"}
GATHER = {182: "Herbalism", 186: "Mining", 393: "Skinning", 356: "Fishing"}
ALL = {**CRAFT, **GATHER}
# trainer subtitle keywords per profession
KEYWORD = {171: "Alchemis", 164: "Blacksmith", 333: "Enchant", 202: "Engineer", 165: "Leatherwork", 197: "Tailor",
           185: "Cook", 129: "First Aid", 182: "Herbalis", 186: "Min", 393: "Skinn", 356: "Fish"}
TRAINER_FLAG = 16
VENDOR_FLAG = 4
MAX_SKILL = 300
NEXT_CAP = {75: 150, 150: 225, 225: 300}
CAP_LEVEL = {150: 10, 225: 20, 300: 35}
SWITCH_PENALTY = 1.6     # a new recipe must be this much cheaper per point to switch to it

# Gathering node requirements (game rules: the skill needed to gather each herb / ore).
HERBS = [("Peacebloom", 1), ("Silverleaf", 1), ("Earthroot", 15), ("Mageroyal", 50), ("Briarthorn", 70),
         ("Stranglekelp", 85), ("Bruiseweed", 100), ("Wild Steelbloom", 115), ("Grave Moss", 120),
         ("Kingsblood", 125), ("Liferoot", 150), ("Fadeleaf", 160), ("Goldthorn", 170), ("Khadgar's Whisker", 185),
         ("Wintersbite", 195), ("Firebloom", 205), ("Purple Lotus", 210), ("Arthas' Tears", 220), ("Sungrass", 230),
         ("Blindweed", 235), ("Ghost Mushroom", 245), ("Gromsblood", 250), ("Golden Sansam", 260), ("Dreamfoil", 270),
         ("Mountain Silversage", 280), ("Plaguebloom", 285), ("Icecap", 290), ("Black Lotus", 300)]
ORES = [("Copper Vein", 1), ("Tin Vein", 65), ("Incendicite Mineral Vein", 65), ("Silver Vein", 75),
        ("Iron Deposit", 125), ("Indurium Mineral Vein", 150), ("Gold Vein", 155), ("Mithril Deposit", 175),
        ("Truesilver Deposit", 230), ("Small Thorium Vein", 245), ("Rich Thorium Vein", 275)]
# A node gives skill-ups until it turns grey: 100 points above its requirement (fewer near 300).
NODE_GREY = 100
GATHER_BANDS = [(1, 50), (50, 100), (100, 150), (150, 200), (200, 250), (250, 300)]
# zones a faction can't sensibly work in (enemy capitals' home zones)
ENEMY = {"A": {1411, 1412, 1420, 1454, 1456, 1458, 1941}, "H": {1426, 1429, 1438, 1453, 1455, 1457, 1943}}


def fetch():
    DATA.mkdir(parents=True, exist_ok=True)
    for t in TABLES:
        url = f"https://wago.tools/db2/{t}/csv?build={BUILD}"
        print("fetch", url)
        req = urllib.request.Request(url, headers={"User-Agent": "onward-tools"})
        with urllib.request.urlopen(req, timeout=300) as r:
            (DATA / f"{t}.csv").write_bytes(r.read())


def rows(t):
    with open(DATA / f"{t}.csv", encoding="utf-8", newline="") as fh:
        return list(csv.DictReader(fh))


def I(v):
    try:
        return int(float(v))
    except (TypeError, ValueError):
        return 0


def text(v):
    return v.decode("utf-8", "replace") if isinstance(v, bytes) else v


# ------------------------------------------------------------------ client data
class Client:
    def __init__(self):
        self.spell_name = {I(r["ID"]): r["Name_lang"] for r in rows("SpellName")}
        self.items = {}
        for r in rows("ItemSparse"):
            self.items[I(r["ID"])] = {"name": r["Display_lang"], "buy": I(r["BuyPrice"]), "sell": I(r["SellPrice"]),
                                      "stack": max(1, I(r["VendorStackCount"])), "ilvl": I(r["ItemLevel"]),
                                      "req_skill": I(r["RequiredSkill"]), "req_rank": I(r["RequiredSkillRank"])}
        self.reagents = {}
        for r in rows("SpellReagents"):
            out = []
            for i in range(8):
                it, n = I(r[f"Reagent_{i}"]), I(r[f"ReagentCount_{i}"])
                if it > 0 and n > 0:
                    out.append((it, n))
            self.reagents[I(r["SpellID"])] = out
        self.creates, learn = {}, {}
        for r in rows("SpellEffect"):
            sp, eff = I(r["SpellID"]), I(r["Effect"])
            if eff == 24 and I(r["EffectItemType"]):                      # CREATE_ITEM
                self.creates[sp] = (I(r["EffectItemType"]), max(1, I(r["EffectBasePointsF"])))
            elif eff == 36 and I(r["EffectTriggerSpell"]):                # LEARN_SPELL
                learn.setdefault(sp, set()).add(I(r["EffectTriggerSpell"]))
        effect_spell = {I(r["ID"]): I(r["SpellID"]) for r in rows("ItemEffect")}
        self.taught_by = {}                                               # recipe spell -> {item ids}
        for r in rows("ItemXItemEffect"):
            sp = effect_spell.get(I(r["ItemEffectID"]))
            for rec in learn.get(sp, {sp} if sp else set()):
                self.taught_by.setdefault(rec, set()).add(I(r["ItemID"]))
        self.sla = [r for r in rows("SkillLineAbility") if I(r["SkillLine"]) in ALL]
        # recipes with a cooldown (Mooncloth, transmutes, ...) can't be spammed for skill
        self.cooldown = {I(r["SpellID"]) for r in rows("SpellCooldowns")
                         if I(r["RecoveryTime"]) > 2000 or I(r["CategoryRecoveryTime"]) > 2000}
        self.cooldown |= {I(r["SpellID"]) for r in rows("SpellCategories") if I(r["ChargeCategory"])}
        self.item_rep = {I(r["ID"]): I(r["MinFactionID"]) for r in rows("ItemSparse")}


# ------------------------------------------------------------------ Questie
def npc_points(db, a2m, n):
    spawns = db.npc(n, "spawns")
    if isinstance(spawns, list):
        spawns = {i + 1: v for i, v in enumerate(spawns) if v}
    out = []
    for area, lst in (spawns or {}).items():
        m = a2m.get(area)
        for c in lua_list(lst):
            c = lua_list(c)
            if m and len(c) >= 2 and c[0] is not None and c[0] >= 0:
                out.append((m, round(float(c[0]), 1), round(float(c[1]), 1)))
    return out


def faction_of(db, n):
    f = text(db.npc(n, "friendlyToFaction")) or "AH"
    return "".join(ch for ch in "AH" if ch in f) or "AH"


def trainers(db, a2m):
    """{skillLine: [(cap, faction, map, x, y, name)]}"""
    out = {s: [] for s in ALL}
    for n in db.ids("Npc-"):
        flags = db.npc(n, "npcFlags") or 0
        if not flags & TRAINER_FLAG:
            continue
        sub = text(db.npc(n, "subName")) or ""
        if not sub or re.search(r"Suppl|Recipe|Trade", sub):
            continue
        for s, kw in KEYWORD.items():
            if kw in sub and not (s == 186 and "Mining" not in sub and "Miner" not in sub):
                # a trainer's title is their own rank and they teach the one below it: a
                # Journeyman teaches Apprentice (75), an Expert Journeyman (150), an Artisan
                # Expert (225), a Master Artisan (300). Specialisation masters (Goblin Engineer,
                # Dragonscale Leatherworker...) teach their speciality, not a rank.
                if re.search(r"Gnome|Goblin|Dragonscale|Elemental|Tribal|Shadoweave", sub):
                    continue
                cap = 300 if "Master" in sub else 225 if "Artisan" in sub else 150 if "Expert" in sub else \
                    75 if re.search(r"Junior|Journeyman|Apprentice", sub) else \
                    300 if s in (182, 186, 393) else 225
                # Herbalism, Mining and Skinning trainers carry no rank in their title ("Mining
                # Trainer", "Herbalist", "Skinner") and teach every rank up to Artisan; only the
                # Junior ones in the starting zones stop at Apprentice. (Checked on five trainers'
                # pages, city and zone, 2026-11-18.)
                name = text(db.npc(n, "name"))
                for m, x, y in npc_points(db, a2m, n)[:1]:
                    out[s].append((cap, faction_of(db, n), m, x, y, name))
    return out


def item_field(db, it, idx):
    return db.field("Item-", it, idx)


ITEM_VENDORS, ITEM_TEACHES = 14, 16


def vendors_of(db, a2m, it, cache={}):
    if it in cache:
        return cache[it]
    out = []
    for n in lua_list(item_field(db, it, ITEM_VENDORS)):
        if isinstance(n, int):
            for m, x, y in npc_points(db, a2m, n)[:1]:
                out.append((faction_of(db, n), m, x, y, text(db.npc(n, "name"))))
    cache[it] = out
    return out


# ------------------------------------------------------------------ crafting routes
def chance(r, s):
    lo, hi = r["low"], r["high"]
    if s >= hi:
        return 0.0
    if s < lo:
        return 1.0
    return (hi - s) / max(1, hi - lo)


def craft_route(skill, client, db, a2m, faction):
    """[(spell, from, to, crafts, mats per craft, recipe item or None)], plus the recipe list."""
    recipes = []
    made_by = {}
    for r in client.sla:
        if I(r["SkillLine"]) != skill:
            continue
        sp, lo, hi = I(r["Spell"]), I(r["TrivialSkillLineRankLow"]), I(r["TrivialSkillLineRankHigh"])
        if hi <= 0 or I(r["ClassMask"]) or sp not in client.reagents or sp not in client.spell_name:
            continue
        if sp in SOD_IDS or sp in client.cooldown:
            continue
        acq = I(r["AcquireMethod"])
        items = client.taught_by.get(sp, set())
        recipe_item, learn_at = None, (1 if acq in (1, 2) else lo)
        if items:
            # only recipes a vendor sells (no reputation ones); drops and quest rewards are left out
            sold = [it for it in items if not client.item_rep.get(it) and
                    any(faction in v[0] for v in vendors_of(db, a2m, it))]
            if not sold:
                continue
            recipe_item = sold[0]
            learn_at = client.items.get(recipe_item, {}).get("req_rank") or lo
        elif acq not in (0, 1, 2) or sp >= FOREVER_IDS:
            continue
        cr = client.creates.get(sp)
        rec = {"spell": sp, "name": client.spell_name[sp], "low": lo, "high": hi, "learn": max(1, learn_at),
               "mats": client.reagents[sp], "recipe": recipe_item, "creates": cr}
        recipes.append(rec)
        if cr:
            made_by.setdefault(cr[0], rec)

    def item_cost(it, depth=0):
        info = client.items.get(it, {})
        if it in made_by and depth < 3:
            rec = made_by[it]
            return sum(item_cost(m, depth + 1) * n for m, n in rec["mats"]) / max(1, rec["creates"][1])
        vend = vendors_of(db, a2m, it)
        if vend and info.get("buy"):
            return info["buy"] / info.get("stack", 1)
        return max(info.get("sell", 0) * 6, info.get("ilvl", 1) * 12) + 20

    for rec in recipes:
        rec["cost"] = sum(item_cost(m) * n for m, n in rec["mats"]) + (1 if not rec["mats"] else 0)

    route, s, cur = [], 1, None
    while s < MAX_SKILL:
        best, best_v = None, None
        for rec in recipes:
            if rec["learn"] > s:
                continue
            p = chance(rec, s)
            if p <= 0.05:
                continue
            v = rec["cost"] / p
            if rec is not cur and cur is not None:
                v *= SWITCH_PENALTY
            if best_v is None or v < best_v:
                best, best_v = rec, v
        if not best:
            s += 1                     # nothing to craft at this skill (gap in data): skip a point
            continue
        p = chance(best, s)
        if route and route[-1]["rec"] is best:
            route[-1]["to"] = s + 1
            route[-1]["crafts"] += 1 / p
        else:
            route.append({"rec": best, "from": s, "to": s + 1, "crafts": 1 / p})
        cur = best
        s += 1
    return route


# ------------------------------------------------------------------ gathering
def node_zones(db, a2m, names, faction):
    """{node name: {map: [(x, y)]}} for herb / ore objects Questie knows"""
    want = {n for n, _ in HERBS + ORES}
    out = {}
    for o in db.ids("Object-"):
        name = text(db.obj(o, "name"))
        if name not in want:
            continue
        spawns = db.obj(o, "spawns")
        if isinstance(spawns, list):
            spawns = {i + 1: v for i, v in enumerate(spawns) if v}
        for area, lst in (spawns or {}).items():
            m = a2m.get(area)
            if not m or m in ENEMY[faction]:
                continue
            for c in lua_list(lst):
                c = lua_list(c)
                if len(c) >= 2 and c[0] is not None and c[0] >= 0:
                    out.setdefault(name, {}).setdefault(m, []).append((float(c[0]), float(c[1])))
    return out


_artisan = {}


def artisan_quests(db):
    """{(skill, faction): questId} for the secondary professions' Artisan quests (skill 200+)"""
    if _artisan:
        return _artisan
    for q in db.ids("Quest-"):
        req = db.quest(q, "requiredSkill")
        if not (isinstance(req, list) and len(req) >= 2 and req[0] in EXPERT_BOOK and (req[1] or 0) >= 200):
            continue
        races = db.quest(q, "requiredRaces") or 0
        for f, mask in (("A", ALLIANCE_RACES), ("H", HORDE_RACES)):
            if not races or races & mask:
                _artisan.setdefault((req[0], f), q)
    return _artisan


def train_line(skill, cap, faction, db):
    if skill in EXPERT_BOOK and cap == 225:
        return f"train {skill} 225 |level {10 if skill == 356 else 20} |book {EXPERT_BOOK[skill]}"
    if skill in EXPERT_BOOK and cap == 300:
        q = artisan_quests(db).get((skill, faction))
        return f"train {skill} 300 |level 35" + (f" |quest {q}" if q else "")
    if skill == 333 and cap == 300:
        # the only Master Enchanter stands inside a dungeon, so there is no map spot to point at
        return f"train 333 300 |level {CAP_LEVEL[cap]} |note Annora, the Master Enchanter, is inside the Uldaman dungeon in the Badlands"
    return f"train {skill} {cap} |level {CAP_LEVEL[cap]}"


def gather_steps(nodes, table, skill, zone_names, faction="A"):
    lines = []
    for lo, hi in GATHER_BANDS:
        useful = [(n, req) for n, req in table if req <= lo and req + NODE_GREY > lo]
        if not useful:
            continue
        score = {}
        for n, req in useful:
            # yellow/green nodes give skill-ups less often: weight the ones closest to your skill
            w = 1.0 if lo - req < 50 else 0.5
            for m, pts in nodes.get(n, {}).items():
                home = 0.25 if m in HOME["H" if faction == "A" else "A"] else 1.0
                score[m] = score.get(m, 0) + w * home * len(pts)
        if not score:
            continue
        ranked = sorted(score.items(), key=lambda kv: -kv[1])[:2]
        for i, (m, _) in enumerate(ranked):
            pts = [p for n, _ in useful for p in nodes.get(n, {}).get(m, [])]
            cx = sum(p[0] for p in pts) / len(pts)
            cy = sum(p[1] for p in pts) / len(pts)
            here = [n for n, _ in useful if nodes.get(n, {}).get(m)]
            note = ", ".join(here)
            if i == 0:
                lines.append(f"gather {skill} {hi} |at {m} {cx:.1f},{cy:.1f} |note {note} ({zone_names.get(m, 'zone')})")
            else:
                lines.append(f"-- or: {zone_names.get(m, m)} ({note})")
    return lines


def render_craft(skill, route, faction, db):
    lines = [f"train {skill} 75"]
    trained = 75
    for seg in route:
        rec = seg["rec"]
        # learn the next rank before a run that would pass the current cap
        while seg["to"] > trained and trained < MAX_SKILL:
            trained = NEXT_CAP[trained]
            lines.append(train_line(skill, trained, faction, db))
        mats = ";".join(f"{it}:{n}" for it, n in rec["mats"])
        opts = [f"name {rec['name']}", f"n {math.ceil(seg['crafts'])}"]
        if mats:
            opts.append(f"mats {mats}")
        if rec["recipe"]:
            opts.append(f"recipe {rec['recipe']}")
        opts.append(f"from {seg['from']}")
        lines.append(f"craft {rec['spell']} {seg['to']} |" + " |".join(opts))
    return lines


def main():
    if "--fetch" in sys.argv or not (DATA / "SkillLineAbility.csv").exists():
        fetch()
    client = Client()
    db = QuestieDB()
    a2m = area_to_uimap()
    from questiedb import map_names
    zone_names = map_names()
    OUT.mkdir(parents=True, exist_ok=True)

    tr = trainers(db, a2m)
    files, used_items = [], set()
    report = []
    for skill, pname in sorted(ALL.items(), key=lambda kv: kv[1]):
        for faction in "AH":
            fname = f"{pname.replace(' ', '')}_{'Alliance' if faction == 'A' else 'Horde'}.lua"
            if skill in CRAFT:
                route = craft_route(skill, client, db, a2m, faction)
                body = render_craft(skill, route, faction, db)
                for line in body:
                    m = re.search(r"\|book (\d+)", line)
                    if m:
                        used_items.add(int(m.group(1)))
                for seg in route:
                    used_items.update(it for it, _ in seg["rec"]["mats"])
                    if seg["rec"]["recipe"]:
                        used_items.add(seg["rec"]["recipe"])
                crafts = sum(math.ceil(seg["crafts"]) for seg in route)
                top = route[-1]["to"] if route else 0
                report.append(f"{pname:15} {faction}  {len(route):3} runs  ~{crafts:5} crafts  reaches {top}")
            else:
                body = [f"train {skill} 75"]
                if skill in (182, 186):
                    nodes = node_zones(db, a2m, zone_names, faction)
                    table = HERBS if skill == 182 else ORES
                    steps = gather_steps(nodes, table, skill, zone_names, faction)
                    # train the next rank before the band that goes past the current cap
                    trained = 75
                    for line in steps:
                        m = re.match(rf"gather {skill} (\d+)", line)
                        while m and int(m.group(1)) > trained:
                            trained = NEXT_CAP[trained]
                            body.append(train_line(skill, trained, faction, db))
                        body.append(line)
                elif skill == 393:
                    trained = 75
                    for lo, hi in GATHER_BANDS:
                        while hi > trained:
                            trained = NEXT_CAP[trained]
                            body.append(train_line(skill, trained, faction, db))
                        # skinning needs (level - 10) * 10 up to level 20, then level * 5
                        mob = max(1, lo // 5) if lo >= 100 else max(1, lo // 10 + 10)
                        body.append(f"gather {skill} {hi} |beasts {mob} |note Skin beasts around level {mob}-{mob + 5}; "
                                    "higher-level beasts work too while they're not grey for you")
                    report.append(f"{pname:15} {faction}  level bands")
                else:   # fishing
                    # every catch can give a point; waters only matter for "fish got away"
                    body += [
                        "gather 356 75 |note Fish in any lake or river near town",
                        train_line(356, 150, faction, db),
                        "gather 356 150 |note Fish in the waters of the zones you're questing in",
                        train_line(356, 225, faction, db),
                        "gather 356 225 |note Fish in waters of level 30+ zones; if fish keep getting away, go back a zone",
                        train_line(356, 300, faction, db),
                        "gather 356 300 |note Fish in waters of level 40+ zones",
                    ]
                    used_items.add(EXPERT_BOOK[356])
            if skill in (182, 186):
                report.append(f"{pname:15} {faction}  {sum(1 for l in body if l.startswith('gather'))} zone bands")
            title = f"{pname} 1-300"
            steps = "\n".join(body)
            (OUT / fname).write_text(
                "-- GENERATED by tools/draft_professions.py from Forever's client tables (wago.tools export,\n"
                f"-- build {BUILD}) and Questie's Forever database (GPL-3.0). Do not edit by hand.\n"
                "Onward:RegisterGuide{\n"
                f"    id = \"prof-{pname.lower().replace(' ', '')}-{faction}\", title = \"{title}\", kind = \"profession\",\n"
                f"    skill = {skill}, faction = \"{'Alliance' if faction == 'A' else 'Horde'}\", levels = {{ 1, 60 }},\n"
                f"    steps = [[\n{steps}\n]],\n}}\n", encoding="utf-8")
            files.append(fname)

    # ProfData.lua: trainers per profession, vendors per item used in a route, item names
    def q(s):
        return '"' + (s or "").replace("\\", "\\\\").replace('"', '\\"') + '"'
    out = ["-- GENERATED by tools/draft_professions.py. Trainers and vendors from Questie's Forever database (GPL-3.0),",
           "-- item names and vendor prices from Forever's client tables.",
           "local _, W = ...", "local P = {}", "W.ProfData = P",
           "-- [skillLine] = { {cap, faction (A/H/AH), map, x, y, name}, ... }", "P.trainers = {"]
    for s in sorted(tr):
        out.append(f"  [{s}] = {{")
        for cap, f, m, x, y, n in sorted(set(tr[s])):
            out.append(f"    {{{cap}, \"{f}\", {m}, {x}, {y}, {q(n)}}},")
        out.append("  },")
    out += ["}", "-- [itemId] = { {faction, map, x, y, name}, ... } (vendors that sell it)", "P.vendors = {"]
    for it in sorted(used_items):
        vs = vendors_of(db, a2m, it)
        if vs:
            out.append(f"  [{it}] = {{" + " ".join(f"{{\"{f}\", {m}, {x}, {y}, {q(n)}}}," for f, m, x, y, n in vs[:12]) + "},")
    out += ["}", "-- [itemId] = name (so the panel can name mats before the item cache has them)", "P.items = {"]
    for it in sorted(used_items):
        name = client.items.get(it, {}).get("name")
        if name:
            out.append(f"  [{it}] = {q(name)},")
    out += ["}"]
    (OUT / "ProfData.lua").write_text("\n".join(out) + "\n", encoding="utf-8")

    xml = ['<Ui xmlns="http://www.blizzard.com/wow/ui/">',
           "    <!-- GENERATED by tools/draft_professions.py -->",
           '    <Script file="ProfData.lua"/>']
    xml += [f'    <Script file="{f}"/>' for f in files]
    xml.append("</Ui>")
    (OUT / "Professions.xml").write_text("\n".join(xml) + "\n", encoding="utf-8")
    for line in report:
        print(line)
    print("trainers:", {ALL[s]: len(v) for s, v in tr.items()})
    print(f"wrote {len(files)} guides + ProfData.lua to {OUT}")


if __name__ == "__main__":
    main()
