"""Draft WoW Forever profession leveling guides (1-300) for all primary, secondary, and rogue skills.

    python tools/draft_professions.py [--fetch]

Routes follow WoW Forever 1-300 progressions (including Forever-added recipes such as Elixir of
Minor Force, Mote of Magic enchants, First Aid potions, and Mount Hyjal Runecloth Cuffs).
All spell IDs, reagent lists, item names, trainer/vendor coordinates, and gathering node medoids
are resolved directly from:
  * Forever's client tables (DB2), exported by wago.tools for the current `wowf` build.
  * Questie's Forever database (GPL-3.0).

Writes Onward/Guides/Professions/*.lua, ProfData.lua, and Professions.xml.
"""
import csv
import math
import pathlib
import re
import sys
import urllib.request

sys.path.insert(0, str(pathlib.Path(__file__).parent))
from questiedb import QuestieDB, area_to_uimap, lua_list, map_names  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "Onward" / "Guides" / "Professions"
BUILD = "1.60.1.70938"
DATA = ROOT / "tools" / "data" / "db2" / BUILD
TABLES = ["SkillLineAbility", "SpellReagents", "SpellName", "ItemSparse", "SpellEffect", "ItemEffect", "ItemXItemEffect",
          "SpellCooldowns", "SpellCategories"]
SOD_IDS = range(400000, 500000)

# Cooking, First Aid and Fishing: Expert comes from a book sold by a vendor, Artisan from a quest
EXPERT_BOOK = {185: 16072, 129: 16084, 356: 16083}
ALLIANCE_RACES, HORDE_RACES = 1 | 4 | 8 | 64, 2 | 16 | 32 | 128

CRAFT = {171: "Alchemy", 164: "Blacksmithing", 333: "Enchanting", 202: "Engineering", 165: "Leatherworking",
         197: "Tailoring", 185: "Cooking", 129: "First Aid"}
GATHER = {182: "Herbalism", 186: "Mining", 393: "Skinning", 356: "Fishing"}
ALL = {**CRAFT, **GATHER}
KEYWORD = {171: "Alchemis", 164: "Blacksmith", 333: "Enchant", 202: "Engineer", 165: "Leatherwork", 197: "Tailor",
           185: "Cook", 129: "First Aid", 182: "Herbalis", 186: "Min", 393: "Skinn", 356: "Fish"}
TRAINER_FLAG = 16
MAX_SKILL = 300
CAP_LEVEL = {150: 10, 225: 20, 300: 35}

# Extra vendor NPC IDs missing from QuestieDB's item-vendor table (coords still come from QuestieDB)
EXTRA_ITEM_VENDORS = {
    16042: [3413],   # Schematic: Thorium Widget -> Sovik in Orgrimmar (Horde)
}


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
    if v is None:
        return ""
    return v.decode("utf-8", "replace") if isinstance(v, bytes) else str(v)


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
            if eff == 24 and I(r["EffectItemType"]):
                self.creates[sp] = (I(r["EffectItemType"]), max(1, I(r["EffectBasePointsF"])))
            elif eff == 36 and I(r["EffectTriggerSpell"]):
                learn.setdefault(sp, set()).add(I(r["EffectTriggerSpell"]))
        effect_spell = {I(r["ID"]): I(r["SpellID"]) for r in rows("ItemEffect")}
        self.taught_by = {}
        for r in rows("ItemXItemEffect"):
            sp = effect_spell.get(I(r["ItemEffectID"]))
            for rec in learn.get(sp, {sp} if sp else set()):
                self.taught_by.setdefault(rec, set()).add(I(r["ItemID"]))
        self.sla = [r for r in rows("SkillLineAbility") if I(r["SkillLine"]) in ALL]
        # index (skill, lower_name) -> {spell, name, mats, low, high}
        self.by_name = {}
        for r in self.sla:
            sk = I(r["SkillLine"])
            sp = I(r["Spell"])
            if sp in SOD_IDS or sp not in self.spell_name or sp not in self.reagents:
                continue
            nm = self.spell_name[sp]
            self.by_name.setdefault((sk, nm.lower()), []).append({
                "spell": sp, "name": nm, "mats": self.reagents[sp],
                "low": I(r["TrivialSkillLineRankLow"]), "high": I(r["TrivialSkillLineRankHigh"]),
            })

    def lookup(self, skill, name):
        hits = self.by_name.get((skill, name.lower()))
        if not hits:
            raise SystemExit(f"draft_professions: spell not found in DB2 for skill {skill}: {name!r}")
        return hits[0]


# ------------------------------------------------------------------ Questie helpers
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
                if re.search(r"Gnome|Goblin|Dragonscale|Elemental|Tribal|Shadoweave", sub):
                    continue
                cap = 300 if "Master" in sub else 225 if "Artisan" in sub else 150 if "Expert" in sub else \
                    75 if re.search(r"Junior|Journeyman|Apprentice", sub) else \
                    300 if s in (182, 186, 393) else 225
                name = text(db.npc(n, "name"))
                for m, x, y in npc_points(db, a2m, n)[:1]:
                    out[s].append((cap, faction_of(db, n), m, x, y, name))
    return out


ITEM_VENDORS = 14


def vendors_of(db, a2m, it, cache={}):
    if it in cache:
        return cache[it]
    out, seen = [], set()
    raw = list(lua_list(db.field("Item-", it, ITEM_VENDORS))) + EXTRA_ITEM_VENDORS.get(it, [])
    for n in raw:
        if isinstance(n, int) and n not in seen:
            seen.add(n)
            for m, x, y in npc_points(db, a2m, n)[:1]:
                out.append((faction_of(db, n), m, x, y, text(db.npc(n, "name"))))
    cache[it] = out
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


def medoid(pts):
    if len(pts) > 120:
        step = max(1, len(pts) // 120)
        pts = pts[::step]
    best = min(pts, key=lambda p: sum(math.dist(p, q) for q in pts))
    return round(best[0], 1), round(best[1], 1)


def obj_medoid(db, a2m, map_id, names=None, ids=None):
    pts = []
    target_names = {n.lower() for n in names} if names else None
    target_ids = set(ids) if ids else None
    for o in (target_ids or db.ids("Object-")):
        if target_names and text(db.obj(o, "name")).lower() not in target_names:
            continue
        sp = db.obj(o, "spawns")
        if isinstance(sp, list):
            sp = {i + 1: v for i, v in enumerate(sp) if v}
        for area, lst in (sp or {}).items():
            if a2m.get(area) != map_id:
                continue
            for c in lua_list(lst):
                c = lua_list(c)
                if len(c) >= 2 and c[0] is not None and c[0] >= 0:
                    pts.append((float(c[0]), float(c[1])))
    if not pts:
        raise SystemExit(f"draft_professions: no object spawns on map {map_id} for {names or ids}")
    return medoid(pts)


def npc_medoid(db, a2m, map_id, names):
    pts = []
    want = set(names)
    for n in db.ids("Npc-"):
        if text(db.npc(n, "name")) not in want:
            continue
        sp = db.npc(n, "spawns")
        if isinstance(sp, list):
            sp = {i + 1: v for i, v in enumerate(sp) if v}
        for area, lst in (sp or {}).items():
            if a2m.get(area) != map_id:
                continue
            for c in lua_list(lst):
                c = lua_list(c)
                if len(c) >= 2 and c[0] is not None and c[0] >= 0:
                    pts.append((float(c[0]), float(c[1])))
    if not pts:
        raise SystemExit(f"draft_professions: no NPC spawns on map {map_id} for {names}")
    return medoid(pts)


# ------------------------------------------------------------------ WoW Forever crafting routes
# Entry formats:
#   ("train", cap, opts_dict)
#   ("craft", from_skill, to_skill, spell_name, crafts, opts_dict)
# opts_dict keys: recipe (itemId), note (str), at ((map, x, y)), npc (str), level (int or None),
#                 book (itemId), quest (bool -> auto artisan quest)

CRAFT_ROUTES = {
    171: [  # Alchemy
        ("train", 75, {}),
        ("craft", 1, 10, "Elixir of Minor Force", 9, {"note": "Buy Empty Vials from an Alchemy Supply vendor"}),
        ("craft", 10, 55, "Elixir of Minor Defense", 45, {}),
        ("craft", 55, 65, "Minor Mana Potion", 10, {}),
        ("train", 150, {"level": 10}),
        ("craft", 65, 90, "Elixir of Minor Fortitude", 28, {}),
        ("craft", 90, 120, "Elixir of Wisdom", 30, {}),
        ("craft", 120, 130, "Lesser Mana Potion", 10, {}),
        ("craft", 130, 150, "Fire Oil", 20, {"note": "Keep 30 Fire Oil for Elixir of Fire Power at 150"}),
        ("train", 225, {"level": 20, "note": "Master Mycologist Shurome in Felwood (Emerald Sanctuary) teaches both Expert and Artisan"}),
        ("craft", 150, 165, "Elixir of Fire Power", 15, {}),
        ("craft", 165, 195, "Mana Potion", 36, {}),
        ("craft", 195, 225, "Nature Protection Potion", 36, {"recipe": 6057}),
        ("train", 300, {"level": 35, "note": "Rogvar (Stonard), Kylanna Windwhisper (Feathermoon), or Master Mycologist Shurome (Felwood)"}),
        ("craft", 225, 235, "Nature Protection Potion", 26, {"recipe": 6057}),
        ("craft", 235, 250, "Elixir of Greater Intellect", 15, {}),
        ("craft", 250, 260, "Stonescale Oil", 47, {"note": "Keep all Stonescale Oil for 265 (or skip if pricey and finish with Superior Mana Potion)"}),
        ("craft", 260, 265, "Elixir of Greater Intellect", 10, {}),
        ("craft", 265, 300, "Elixir of Greater Defense", 44, {
            "recipe": 13478,
            "note": "Sold as Recipe: Elixir of Superior Defense; alt: Superior Mana Potion (Algernon / Ulthir)",
        }),
    ],
    164: [  # Blacksmithing
        ("train", 75, {"note": "Buy a Blacksmith Hammer from a nearby vendor"}),
        ("craft", 1, 25, "Rough Sharpening Stone", 30, {}),
        ("craft", 25, 50, "Rough Grinding Stone", 30, {"note": "Keep 10 for Silver Rods at 75"}),
        ("craft", 50, 75, "Coarse Grinding Stone", 36, {"note": "Make all 36 for Patterned Bronze Bracers at 95 and 112"}),
        ("train", 150, {"level": 10}),
        ("craft", 75, 80, "Silver Rod", 5, {"note": "Alt if Silver Bars are pricey: 5x Runed Copper Belt"}),
        ("craft", 80, 95, "Rough Bronze Leggings", 15, {}),
        ("craft", 95, 100, "Patterned Bronze Bracers", 5, {}),
        ("craft", 100, 112, "Heavy Grinding Stone", 20, {"note": "Keep all 20 for Golden Scale Bracers at 180"}),
        ("craft", 112, 125, "Patterned Bronze Bracers", 13, {}),
        ("craft", 125, 140, "Silvered Bronze Gauntlets", 15, {"note": "Alt if Silver Bars are pricey: 15x Bronze Warhammer"}),
        ("train", 225, {"level": 20}),
        ("craft", 140, 175, "Green Iron Bracers", 40, {"note": "Taught by Expert trainers (Saru Steelfury / Bengus Deepforge)"}),
        ("craft", 175, 180, "Solid Grinding Stone", 8, {"note": "Keep for 210"}),
        ("craft", 180, 195, "Golden Scale Bracers", 20, {}),
        ("craft", 195, 210, "Mithril Plate Pants", 17, {}),
        ("train", 300, {"level": 35, "note": "Brikk Keencraft in Booty Bay teaches Artisan and recipes from 210+"}),
        ("craft", 210, 215, "Heavy Mithril Axe", 6, {"note": "If you find Plans: Mithril Spurs on the AH, craft Mithril Spurs 210-225 & 235-245 instead"}),
        ("craft", 215, 225, "Mithril Coif", 10, {}),
        ("craft", 225, 235, "Dense Sharpening Stone", 16, {}),
        ("craft", 235, 240, "Heavy Mithril Boots", 11, {}),
        ("craft", 240, 245, "Imperial Plate Belt", 5, {
            "at": (1446, 51.4, 28.7), "npc": "Derotain Mudsipper",
            "note": "Plan from Derotain Mudsipper's Imperial Plate quest in Tanaris (bring 40+ Thorium Bars for Belt and Bracers)",
        }),
        ("craft", 245, 270, "Imperial Plate Bracers", 27, {
            "at": (1446, 51.4, 28.7), "npc": "Derotain Mudsipper",
            "note": "Plan from Derotain Mudsipper in Tanaris (alt 245-255: Thorium Belt if you have AH plans)",
        }),
        ("craft", 270, 290, "Imperial Plate Boots", 20, {
            "at": (1446, 51.4, 28.7), "npc": "Derotain Mudsipper",
            "note": "Cheaper with AH plans: Radiant Boots (270-290) + Radiant Leggings (290-300), or Thorium Leggings (275-300)",
        }),
        ("craft", 290, 300, "Imperial Plate Leggings", 10, {
            "at": (1446, 51.4, 28.7), "npc": "Derotain Mudsipper",
            "note": "Plan from Derotain Mudsipper in Tanaris (alt: Radiant Leggings or Thorium Leggings)",
        }),
    ],
    185: [  # Cooking
        ("train", 75, {}),
        ("craft", 1, 50, "Brilliant Smallfish", 55, {"recipe": 6325, "note": "Alt if cheaper: 55x Slitherskin Mackerel"}),
        ("train", 150, {"level": 10}),
        ("craft", 50, 100, "Longjaw Mud Snapper", 55, {"recipe": 6328, "note": "Alt if cheaper: 55x Rainbow Fin Albacore"}),
        ("craft", 100, 150, "Bristle Whisker Catfish", 53, {"recipe": 6330}),
        ("train", 225, {"level": 20, "book": 16072}),
        ("craft", 150, 175, "Goblin Deviled Clams", 28, {"note": "Buy Hot Spices from a Cooking Supply vendor"}),
        ("craft", 175, 225, "Roast Raptor", 55, {"recipe": 12228, "note": "Alt if cheaper: 55x Mithril Headed Trout"}),
        ("train", 300, {
            "level": 35, "quest": True,
            "note": "Bring 12 Giant Egg, 10 Zesty Clam Meat, and 20 Alterac Swiss; buy Spotted Yellowtail & Nightfin Soup recipes from Gikkix in Steamwheedle Port",
        }),
        ("craft", 225, 285, "Spotted Yellowtail", 72, {"recipe": 13939, "note": "Alt if cheaper: 72x Filet of Redgill (Kelsey Yance, Booty Bay)"}),
        ("craft", 285, 300, "Nightfin Soup", 18, {"recipe": 13945}),
    ],
    333: [  # Enchanting
        ("train", 75, {}),
        ("craft", 1, 2, "Runed Copper Rod", 1, {"note": "Buy Copper Rod and Mote of Magic from an Enchanting Supply vendor"}),
        ("craft", 2, 20, "Enchant Bracer - Inferior Stamina", 18, {"note": "Disenchanting green items also gives skill-ups up to 60"}),
        ("craft", 20, 70, "Enchant Chest - Inferior Stamina", 50, {"note": "Alt if cheaper: 50x Enchant Bracer - Minor Deflect (Lesser Magic Essence)"}),
        ("train", 150, {"level": 10}),
        ("craft", 70, 85, "Enchant Chest - Inferior Stamina", 21, {}),
        ("craft", 85, 100, "Enchant Bracer - Minor Stamina", 15, {}),
        ("craft", 100, 109, "Enchant Cloak - Minor Protection", 9, {}),
        ("craft", 109, 110, "Runed Silver Rod", 1, {}),
        ("craft", 110, 130, "Enchant Cloak - Minor Protection", 29, {}),
        ("craft", 130, 150, "Enchant Boots - Minor Stamina", 20, {
            "note": "Buy Formula: Minor Mana Oil and Lesser Wizard Oil from a city vendor before heading to the Expert trainer",
        }),
        ("train", 225, {"level": 20}),
        ("craft", 150, 151, "Runed Golden Rod", 1, {}),
        ("craft", 151, 165, "Minor Mana Oil", 16, {"recipe": 20752}),
        ("craft", 165, 200, "Enchant Boots - Lesser Agility", 44, {"note": "Alt 185-200 if Vision Dust is cheaper: Enchant Bracer - Strength"}),
        ("craft", 200, 201, "Runed Truesilver Rod", 1, {}),
        ("craft", 201, 220, "Lesser Wizard Oil", 25, {"recipe": 20753}),
        ("craft", 220, 225, "Enchant Cloak - Greater Defense", 5, {}),
        ("train", 300, {
            "level": 35,
            "note": "Annora is inside Uldaman (Badlands back entrance); bring ~12g and ~50 Vision Dust to learn all 230-250 recipes in one trip",
        }),
        ("craft", 225, 250, "Enchant Gloves - Agility", 34, {}),
        ("craft", 250, 270, "Lesser Mana Oil", 26, {
            "recipe": 20754,
            "note": "Buy Formula: Wizard Oil from Kania in Silithus at the same time (alt: Enchant Bracer - Greater Strength)",
        }),
        ("craft", 270, 275, "Enchant Shield - Greater Stamina", 5, {"recipe": 16217}),
        ("craft", 275, 295, "Wizard Oil", 26, {"recipe": 20755, "note": "Alt if Illusion Dust is pricey: Enchant Shield - Greater Stamina"}),
        ("craft", 295, 299, "Enchant Shield - Greater Stamina", 8, {"recipe": 16217}),
        ("craft", 299, 300, "Runed Arcanite Rod", 1, {
            "recipe": 16243,
            "note": "Needed for 300 enchants (or craft 1 more Enchant Shield - Greater Stamina for the final point)",
        }),
    ],
    202: [  # Engineering
        ("train", 75, {"note": "Buy a Blacksmith Hammer from a nearby vendor"}),
        ("craft", 1, 35, "Rough Blasting Powder", 56, {"note": "Keep all for Rough Copper Bombs"}),
        ("craft", 35, 55, "Handful of Copper Bolts", 28, {"note": "Keep all for Rough Copper Bombs"}),
        ("craft", 55, 56, "Arclight Spanner", 1, {"note": "Keep as a crafting tool"}),
        ("craft", 56, 75, "Rough Copper Bomb", 28, {}),
        ("train", 150, {"level": 10}),
        ("craft", 75, 90, "Coarse Blasting Powder", 51, {"note": "Keep all for Coarse Dynamite"}),
        ("craft", 90, 100, "Coarse Dynamite", 17, {}),
        ("craft", 100, 105, "Silver Contact", 5, {"note": "Alt if Silver Bars are pricey: 5x Flying Tiger Goggles"}),
        ("craft", 105, 125, "Bronze Tube", 25, {"note": "Keep 10 for Standard Scopes"}),
        ("craft", 125, 135, "Standard Scope", 10, {"note": "Skip to Heavy Blasting Powder if Moss Agate is expensive"}),
        ("craft", 135, 145, "Heavy Blasting Powder", 40, {"note": "Keep 30 for Explosive Sheep and 3 for Iron Grenades"}),
        ("craft", 145, 150, "Whirring Bronze Gizmo", 15, {"note": "Keep all 15 for Explosive Sheep"}),
        ("train", 225, {"level": 20}),
        ("craft", 150, 160, "Bronze Framework", 15, {"note": "Keep all 15 for Explosive Sheep"}),
        ("craft", 160, 175, "Explosive Sheep", 15, {}),
        ("craft", 175, 193, "Solid Blasting Powder", 61, {"note": "Keep all for Unstable Triggers and Hi-Explosive Bombs"}),
        ("craft", 193, 194, "Gyromatic Micro-Adjustor", 1, {"note": "Keep as a crafting tool"}),
        ("craft", 194, 195, "Iron Grenade", 3, {"note": "Skip if already at 195"}),
        ("craft", 195, 200, "Mithril Tube", 6, {}),
        ("train", 300, {"level": 35, "note": "Buzzek Bracketswing (Gadgetzan) or Kaylaena Springwhisper (Mount Hyjal) teach Artisan and 200+ recipes"}),
        ("craft", 200, 215, "Unstable Trigger", 21, {"note": "Keep 20 for Hi-Explosive Bombs"}),
        ("craft", 215, 238, "Mithril Casing", 40, {"note": "Keep all 40 for Hi-Explosive Bombs"}),
        ("craft", 238, 250, "Hi-Explosive Bomb", 20, {}),
        ("craft", 250, 260, "Dense Blasting Powder", 44, {}),
        ("craft", 260, 280, "Thorium Widget", 20, {"recipe": 16042, "note": "PvP alt: 10x Thorium Widget + 10x Thorium Grenade"}),
        ("craft", 280, 300, "Thorium Tube", 21, {
            "recipe": 16047,
            "note": "Schematic from Xizzer Fizzbolt (Winterspring) or Kor'gar (Riverglades); alt from 285: Thorium Shells",
        }),
    ],
    129: [  # First Aid
        ("train", 75, {}),
        ("craft", 1, 40, "Linen Bandage", 50, {"note": "Forever herb alt 1-75: 86x Minor Healing Potion (Peacebloom, Mild Spices, Empty Vial)"}),
        ("craft", 40, 75, "Heavy Linen Bandage", 47, {}),
        ("train", 150, {"level": 10}),
        ("craft", 75, 80, "Heavy Linen Bandage", 13, {}),
        ("craft", 80, 115, "Wool Bandage", 52, {"note": "Forever herb alt 90-150: Simple Poultice (90-125) + Healing Potion (125-150)"}),
        ("craft", 115, 150, "Heavy Wool Bandage", 51, {"note": "Learn Silk Bandage from your trainer before heading to the Expert vendor"}),
        ("train", 225, {"book": 16084, "note": "No level requirement in Forever; buy Heavy Silk and Mageweave manuals at the same vendor"}),
        ("craft", 150, 180, "Silk Bandage", 44, {}),
        ("craft", 180, 210, "Heavy Silk Bandage", 44, {"recipe": 16112}),
        ("craft", 210, 225, "Mageweave Bandage", 19, {"recipe": 16113}),
        ("train", 300, {
            "level": 35, "quest": True,
            "note": "Bring ~90 Mageweave Cloth and ~70 Runecloth; the Triage doctor also teaches the final bandages up to 300",
        }),
        ("craft", 225, 240, "Mageweave Bandage", 26, {}),
        ("craft", 240, 260, "Heavy Mageweave Bandage", 30, {"note": "Taught by the Triage doctor at 240"}),
        ("craft", 260, 290, "Runecloth Bandage", 44, {
            "note": "Taught by the Triage doctor at 260; alt 275-300: Major Healing Potion (Manual from Pexmit in Mount Hyjal)",
        }),
        ("craft", 290, 300, "Heavy Runecloth Bandage", 12, {"note": "Taught by the Triage doctor at 290"}),
    ],
    165: [  # Leatherworking
        ("train", 75, {}),
        ("craft", 1, 30, "Light Leather", 35, {}),
        ("craft", 30, 40, "Cured Light Hide", 10, {"note": "Keep all 10 for Embossed Leather Pants at 70 (alt: 14x Light Armor Kit)"}),
        ("craft", 40, 70, "Embossed Leather Gloves", 30, {}),
        ("train", 150, {"level": 10}),
        ("craft", 70, 80, "Embossed Leather Pants", 10, {"note": "Alt without hides: 14x Embossed Leather Gloves"}),
        ("craft", 80, 95, "Cured Medium Hide", 20, {"note": "Keep all 20 for Dark Leather Belts at 105 (alt: 19x Fine Leather Belt)"}),
        ("craft", 95, 105, "Fine Leather Belt", 22, {"note": "Keep 20 for Dark Leather Belts"}),
        ("craft", 105, 125, "Dark Leather Belt", 20, {"note": "Alt without hides: Dark Leather Pants (105-120) + Hillman's Leather Gloves (120-125)"}),
        ("craft", 125, 130, "Heavy Leather", 8, {}),
        ("craft", 130, 143, "Cured Heavy Hide", 25, {"note": "Keep all 25 for Barbaric Shoulders (150) and Guardian Gloves (165)"}),
        ("craft", 143, 150, "Hillman's Leather Gloves", 8, {}),
        ("train", 225, {"level": 20}),
        ("craft", 150, 165, "Barbaric Shoulders", 15, {"note": "Alt without hides: Pattern: Barbaric Leggings (Jandia / Lardan)"}),
        ("craft", 165, 175, "Guardian Gloves", 10, {"note": "Stays orange to 185 if you have extra Cured Heavy Hides"}),
        ("craft", 175, 185, "Barbaric Harness", 10, {"note": "Alt without Iron Buckles: 10x Thick Armor Kit"}),
        ("craft", 185, 205, "Nightscape Headband", 22, {}),
        ("train", 300, {"level": 35, "note": "Hahrana Ironhide (Camp Mojache) or Drakk Stonehand (Aerie Peak) teach Artisan and 205+ recipes"}),
        ("craft", 205, 235, "Nightscape Pants", 36, {}),
        ("craft", 235, 265, "Wicked Leather Gauntlets", 36, {
            "recipe": 15725,
            "note": "Alt with AH patterns: Blue Suede Shoes or Wicked Leather Headband (255-265)",
        }),
        ("craft", 265, 300, "Runic Leather Headband", 49, {
            "recipe": 15756,
            "note": "Alt with AH patterns: Tooled Leather Bracers (270-300) or Blue Suede Bracers (275-300)",
        }),
    ],
    197: [  # Tailoring
        ("train", 75, {}),
        ("craft", 1, 30, "Bolt of Linen Cloth", 30, {"note": "Keep all bolts for Linen Belts"}),
        ("craft", 30, 55, "Linen Belt", 28, {}),
        ("train", 150, {"level": 10}),
        ("craft", 55, 80, "Bolt of Woolen Cloth", 37, {"note": "Keep all bolts for capes and shoulders"}),
        ("craft", 80, 95, "Woolen Cape", 22, {}),
        ("craft", 95, 100, "Double-stitched Woolen Shoulders", 5, {}),
        ("craft", 100, 120, "Bolt of Silk Cloth", 54, {"note": "Keep bolts (203 total needed through 185)"}),
        ("craft", 120, 125, "Azure Silk Hood", 5, {}),
        ("craft", 125, 140, "Small Silk Pack", 15, {}),
        ("train", 225, {"level": 20, "note": "Expert trainers (Josef Gregorian / Georgio Bolero) also teach Bolt of Mageweave at 140"}),
        ("craft", 140, 150, "Bolt of Mageweave", 23, {"note": "Keep bolts (144 total needed through 225)"}),
        ("craft", 150, 170, "Crimson Silk Vest", 20, {}),
        ("craft", 170, 185, "Crimson Silk Pantaloons", 17, {}),
        ("craft", 185, 200, "Black Mageweave Leggings", 22, {}),
        ("train", 300, {"level": 35, "note": "Daryl Stack (Tarren Mill) or Timothy Worthington (Theramore) teach Artisan and 200+ recipes (Alliance: bring Rune Thread)"}),
        ("craft", 200, 205, "Black Mageweave Shoulders", 5, {}),
        ("craft", 205, 215, "Bolt of Runecloth", 23, {"note": "Keep bolts (311 total needed through 280)"}),
        ("craft", 215, 225, "Red Mageweave Bag", 17, {"note": "Alt if you don't want bags: 10x Runecloth Belt"}),
        ("craft", 225, 240, "Runecloth Belt", 24, {}),
        ("craft", 240, 250, "Runecloth Gloves", 11, {"recipe": 14481, "note": "Pattern sold by Qia in Everlook (alt: Brightcloth Cloak)"}),
        ("craft", 250, 280, "Runecloth Cuffs", 39, {
            "recipe": 254124,
            "note": "Pattern from Pexmit in Mount Hyjal (Horde: also from Threading a Solution); alt: Runecloth Gloves to 260 then Runecloth Shoulders",
        }),
        ("craft", 280, 300, "Runecloth Shoulders", 58, {"note": "Buy Pattern: Runecloth Shoulders (or Wizardweave Turban) on the AH"}),
    ],
}


# ------------------------------------------------------------------ WoW Forever gathering routes
# (faction letters, untilSkill, map_id, node_names, note, train_cap_before_or_None)
HERB_BANDS = [
    ("H", 70, 1411, ("Peacebloom", "Silverleaf", "Earthroot"),
     "Peacebloom, Silverleaf, and Earthroot (15+) in Durotar, Mulgore, Tirisfal Glades, or Zephras Isle", None),
    ("A", 70, 1429, ("Peacebloom", "Silverleaf", "Earthroot"),
     "Peacebloom, Silverleaf, and Earthroot (15+) in Elwynn Forest, Dun Morogh, Teldrassil, or Zephras Isle", None),
    ("H", 115, 1421, ("Mageroyal", "Briarthorn", "Stranglekelp"),
     "Mageroyal, Briarthorn, and Stranglekelp (85+) in southern Silverpine Forest", 150),
    ("A", 115, 1439, ("Mageroyal", "Briarthorn", "Stranglekelp"),
     "Mageroyal, Briarthorn, and Stranglekelp (85+) in Darkshore (alt: Loch Modan)", 150),
    ("AH", 170, 1424, ("Bruiseweed", "Wild Steelbloom", "Kingsblood", "Liferoot"),
     "Bruiseweed, Wild Steelbloom, Kingsblood (125+), and Liferoot (150+) in Hillsbrad Foothills (alt: Stonetalon Mountains)", 225),
    ("AH", 205, 1434, ("Kingsblood", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker"),
     "Kingsblood, Liferoot, Fadeleaf, Goldthorn, and Khadgar's Whisker (185+) in Stranglethorn Vale (alt: Arathi Highlands)", None),
    ("AH", 230, 1446, ("Firebloom", "Purple Lotus"),
     "Firebloom and Purple Lotus in Tanaris (alt: Searing Gorge) — train Artisan at 200 before heading out", 300),
    ("AH", 270, 1425, ("Sungrass", "Purple Lotus", "Ghost Mushroom", "Golden Sansam"),
     "Sungrass, Purple Lotus, Ghost Mushroom (245+ in caves), and Golden Sansam in The Hinterlands", None),
    ("AH", 300, 1448, ("Sungrass", "Gromsblood", "Golden Sansam", "Dreamfoil", "Mountain Silversage", "Plaguebloom"),
     "Sungrass, Gromsblood, Golden Sansam, Dreamfoil, Mountain Silversage, and Plaguebloom in Felwood", None),
]

MINING_BANDS = [
    ("H", 65, 1411, ("Copper Vein",),
     "Copper Veins in Durotar (alt: Mulgore, Tirisfal Glades, or Zephras Isle); buy a Mining Pick and smelt Copper Bars along the way", None),
    ("A", 65, 1429, ("Copper Vein",),
     "Copper Veins in Elwynn Forest (alt: Dun Morogh, Teldrassil, or Zephras Isle); buy a Mining Pick and smelt Copper Bars along the way", None),
    ("H", 125, 1424, ("Tin Vein", "Copper Vein", "Silver Vein"),
     "Tin (65+), Copper, and Silver (75+) in Hillsbrad Foothills or Silverpine Forest; smelt Bronze Bars up to ~105", 150),
    ("A", 125, 1437, ("Tin Vein", "Incendicite Mineral Vein", "Silver Vein"),
     "Tin (65+), Incendicite, and Silver (75+) in Wetlands (alt: Westfall or Ashenvale); smelt Bronze Bars up to ~105", 150),
    ("AH", 175, 1417, ("Iron Deposit", "Tin Vein", "Gold Vein"),
     "Iron (125+), Tin, and Gold (155+) in Arathi Highlands (safer alt: Thousand Needles or Desolace); optional Smelt Iron to 135 and Gold 155-175", 225),
    ("AH", 245, 1425, ("Mithril Deposit", "Truesilver Deposit"),
     "Mithril (175+) and Truesilver (230+) in The Hinterlands (alt: Tanaris) — train Artisan at 200", 300),
    ("AH", 275, 1449, ("Small Thorium Vein", "Mithril Deposit", "Truesilver Deposit"),
     "Small Thorium (245+), Mithril, and Truesilver in Un'Goro Crater (alt: Blasted Lands or Felwood)", None),
    ("AH", 300, 1449, ("Rich Thorium Vein", "Small Thorium Vein"),
     "Rich Thorium (275+) and Small Thorium in Un'Goro Crater (alt: Eastern Plaguelands, Winterspring, or Burning Steppes)", None),
]

# (faction, untilSkill, map_id, beast_lvl, mob_names, note, train_cap_before_or_None)
SKINNING_BANDS = [
    ("H", 75, 1411, 1, ("Mottled Boar",),
     "Buy a Skinning Knife; skin beasts in your starting zone or Mottled Boars in Valley of Trials (Durotar) up to 75", None),
    ("A", 75, 1429, 1, ("Young Wolf", "Timber Wolf"),
     "Buy a Skinning Knife; skin beasts in your starting zone or wolves in Northshire Valley (Elwynn Forest) up to 75", None),
    ("H", 150, 1413, 16, ("Sunscale Scytheclaw", "Zhevra Charger", "Ornery Plainstrider"),
     "Raptors, zhevras, and plainstriders near Northwatch Hold in The Barrens (level 16-18)", 150),
    ("A", 130, 1432, 16, ("Elder Mountain Boar", "Black Bear Patriarch", "Loch Crocolisk"),
     "Boars, bears, and crocolisks around the Loch in Loch Modan (level 16-17)", 150),
    ("A", 150, 1437, 25, ("Mottled Scytheclaw", "Mottled Razormaw"),
     "Raptors at Whelgar's Excavation Site in Wetlands (level 25-27)", None),
    ("AH", 225, 1424, 30, ("Cave Yeti", "Ferocious Yeti"),
     "Bears/lions outside Foothill Caverns to 160, then Cave and Ferocious Yetis inside in Hillsbrad (alt: Duskwood worgen)", 225),
    ("AH", 280, 1444, 43, ("Feral Scar Yeti", "Enraged Feral Scar", "Hulking Feral Scar"),
     "Yetis in Feral Scar Vale in southern Feralas (level 43-46)", 300),
    ("AH", 300, 1449, 50, ("Diemetradon", "Pterrordax", "Elder Diemetradon", "Frenzied Pterrordax"),
     "Diemetradons and Pterrordax in western Un'Goro Crater (level 50-55)", None),
]

LOCKPICKING = 633
# (faction letters, skill to reach, object ids, uiMap, note)
LOCK_BANDS = [
    ("A", 100, (178244, 178246), 1433,
     "Practice Lockboxes around Alther's Mill in Redridge Mountains (need Pick Lock at level 16 and Thieves' Tools)"),
    ("H", 100, (123330, 123331, 123333), 1413,
     "Buccaneer's Strongboxes aboard the pirate ship off the Ratchet coast in The Barrens (avoid The Jewel of the Southsea chest below deck)"),
    ("AH", 150, (179487, 179489), 1440,
     "Waterlogged Footlockers along the Zoram Strand shore in Ashenvale (and in the water from 110; skill caps at 5x character level)"),
    ("AH", 225, (179490, 179492), 1418,
     "Battered Footlockers upstairs (150+) and Dented Footlockers downstairs (175+) in Angor Fortress, Badlands"),
    ("AH", 300, (179494, 179496), 1427,
     "Dented Footlockers in The Slag Pit, Searing Gorge (lower pit 200+, upper pit 225 to 300; alt: Lost Rigger Cove in Tanaris)"),
]


def format_train(skill, cap, opts, faction, db, used_items):
    parts = [f"train {skill} {cap}"]
    lvl = opts.get("level")
    if lvl:
        parts.append(f"level {lvl}")
    book = opts.get("book")
    if book:
        parts.append(f"book {book}")
        used_items.add(book)
    if opts.get("quest"):
        q = artisan_quests(db).get((skill, faction))
        if q:
            parts.append(f"quest {q}")
    note = opts.get("note")
    if note:
        parts.append(f"note {note}")
    return parts[0] + ((" |" + " |".join(parts[1:])) if len(parts) > 1 else "")


def render_craft(skill, client, faction, db, used_items):
    lines = []
    for entry in CRAFT_ROUTES[skill]:
        if entry[0] == "train":
            _, cap, opts = entry
            lines.append(format_train(skill, cap, opts, faction, db, used_items))
        else:
            _, frm, to, name, crafts, opts = entry
            rec = client.lookup(skill, name)
            mats = ";".join(f"{it}:{n}" for it, n in rec["mats"])
            used_items.update(it for it, _ in rec["mats"])
            p = [f"name {rec['name']}", f"n {crafts}"]
            if mats:
                p.append(f"mats {mats}")
            if opts.get("recipe"):
                p.append(f"recipe {opts['recipe']}")
                used_items.add(opts["recipe"])
            if opts.get("at"):
                m, x, y = opts["at"]
                p.append(f"at {m} {x:.1f},{y:.1f}")
            if opts.get("npc"):
                p.append(f"npc {opts['npc']}")
            p.append(f"from {frm}")
            if opts.get("note"):
                p.append(f"note {opts['note']}")
            lines.append(f"craft {rec['spell']} {to} |" + " |".join(p))
    return lines


def render_gather(skill, faction, db, a2m, used_items):
    lines = [f"train {skill} 75"]
    if skill in (182, 186):
        bands = HERB_BANDS if skill == 182 else MINING_BANDS
        for who, hi, m, names, note, cap in bands:
            if faction not in who:
                continue
            if cap:
                lines.append(format_train(skill, cap, {"level": CAP_LEVEL[cap]}, faction, db, used_items))
            x, y = obj_medoid(db, a2m, m, names=names)
            lines.append(f"gather {skill} {hi} |at {m} {x:.1f},{y:.1f} |note {note}")
    elif skill == 393:
        for who, hi, m, mob, names, note, cap in SKINNING_BANDS:
            if faction not in who:
                continue
            if cap:
                lines.append(format_train(skill, cap, {"level": CAP_LEVEL[cap]}, faction, db, used_items))
            x, y = npc_medoid(db, a2m, m, names)
            lines.append(f"gather {skill} {hi} |at {m} {x:.1f},{y:.1f} |beasts {mob} |note {note}")
    else:  # Fishing (356)
        lines += [
            "gather 356 75 |note Buy a Fishing Pole and Shiny Baubles; fish in any starting zone lake or river (not capital cities)",
            format_train(356, 150, {"level": 10}, faction, db, used_items),
            "gather 356 150 |note Fish in a capital city or level 10-20 zone (use Nightcrawlers if fish escape)",
            format_train(356, 225, {"level": 20, "book": EXPERT_BOOK[356], "note": "Buy Expert Fishing book and Bright Baubles from Old Man Heming in Booty Bay"}, faction, db, used_items),
            "gather 356 225 |at 1445 58.6,60.1 |note Fish in Dustwallow Marsh with Bright Baubles (Artisan quest starts right here at Nat Pagle)",
            format_train(356, 300, {"level": 35, "quest": True, "note": "Nat Pagle in Dustwallow Marsh: catch 4 quest fish in STV, Desolace, Swamp of Sorrows, and Feralas (use Bright Baubles in Feralas)"}, faction, db, used_items),
            "gather 356 300 |note Fish in Felwood, Azshara, Tanaris, Feralas, Un'Goro Crater, or Winterspring",
        ]
    return lines


def lockpicking_guides(db, a2m):
    out = []
    for faction in "AH":
        body = []
        for who, cap, objs, m, note in LOCK_BANDS:
            if faction in who:
                x, y = obj_medoid(db, a2m, m, ids=objs)
                body.append(f"gather {LOCKPICKING} {cap} |at {m} {x:.1f},{y:.1f} |note {note}")
        steps = "\n".join(body)
        fname = f"Lockpicking_{'Alliance' if faction == 'A' else 'Horde'}.lua"
        out.append((fname,
            "-- GENERATED by tools/draft_professions.py: Forever 1-300 route, spawns from Questie's Forever database (GPL-3.0).\n"
            "-- Do not edit by hand.\n"
            "Onward:RegisterGuide{\n"
            f"    id = \"prof-lockpicking-{faction}\", title = \"Lockpicking 1-300\", kind = \"profession\",\n"
            f"    skill = {LOCKPICKING}, class = \"ROGUE\", faction = \"{'Alliance' if faction == 'A' else 'Horde'}\", levels = {{ 16, 60 }},\n"
            f"    steps = [[\n{steps}\n]],\n}}\n"))
    return out


def main():
    if "--fetch" in sys.argv or not (DATA / "SkillLineAbility.csv").exists():
        fetch()
    client = Client()
    db = QuestieDB()
    a2m = area_to_uimap()
    OUT.mkdir(parents=True, exist_ok=True)

    tr = trainers(db, a2m)
    files, used_items = [], set()
    report = []
    for skill, pname in sorted(ALL.items(), key=lambda kv: kv[1]):
        for faction in "AH":
            fname = f"{pname.replace(' ', '')}_{'Alliance' if faction == 'A' else 'Horde'}.lua"
            if skill in CRAFT:
                body = render_craft(skill, client, faction, db, used_items)
                runs = sum(1 for l in body if l.startswith("craft "))
                report.append(f"{pname:15} {faction}  {runs:2d} craft steps (1-300)")
            else:
                body = render_gather(skill, faction, db, a2m, used_items)
                bands = sum(1 for l in body if l.startswith("gather "))
                report.append(f"{pname:15} {faction}  {bands:2d} zone bands (1-300)")
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

    for fname, text_ in lockpicking_guides(db, a2m):
        (OUT / fname).write_text(text_, encoding="utf-8")
        files.append(fname)
    report.append("Lockpicking     A/H   4 footlocker bands (1-300, rogues only)")

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
    print(f"wrote {len(files)} guides + ProfData.lua ({len(used_items)} tracked items) to {OUT}")


if __name__ == "__main__":
    main()
