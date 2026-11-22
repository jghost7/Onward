"""Build Onward/QuestItems.lua: quest items safe to offer for voluntary bag cleanup once every
quest that ever uses them is completed.

    python tools/make_quest_items.py    -> Onward/QuestItems.lua

Safety rules (an item is included ONLY when EVERY check passes):
  1. Item class is 12 (Quest item) in QuestieDB.
  2. Bonding is 1 (Bind on Pickup) or 4 (Quest item) in Forever's ItemSparse.csv — never BoE or
     tradable/auctionable items (e.g. Green Hills pages, Wastewander Water Pouches).
  3. SellPrice == 0, InventoryType == 0 (never vendorable or equippable), OverallQualityID < 3
     (never Rare/Epic/Legendary), and not openable (Flags_0 & 0x4 == 0).
  4. Never rewarded by any quest (protects permanent rewards like Dartol's Rod, Scepter of Celebras,
     Brazier of Invocation), never teaches a spell, never sold by a vendor.
  5. Referenced by at least one quest (objectives, sourceItemId, requiredSourceItems, startedBy,
     startQuest, or relatedQuests) — protects unreferenced permanent tools like Mallet of Zul'Farrak,
     Aqual/Eternal Quintessence, Cenarion Beacon, Yeh'kinya's Scroll.
  6. ZERO referencing quests may be repeatable (specialFlags & 1), war-effort/hidden-reward
     (questFlags & 256), or level 0.
  7. Usable items (having an ItemEffect) tied to dungeon/raid quests are excluded (protects boss
     summoners like Banner of Provocation and Ectoplasmic Distiller).
  8. Downstream chain propagation: if any follow-up quest down the chain mentions the item's name
     in its title or objective text, that follow-up is added to the item's required-completed list.
  9. Quest lists are split by faction (A / H) so an Alliance character isn't blocked by a Horde
     quest they cannot do, while still requiring every quest their faction can do to be completed.

Data: Questie/QuestieDB (GPL-3.0) + Forever client DB2 tables.
"""
import csv
import datetime
import pathlib
import re

from questiedb import QuestieDB, area_to_uimap, lua_list, map_names

ROOT = pathlib.Path(__file__).resolve().parent.parent
DB2 = ROOT / "tools" / "data" / "db2" / "1.60.1.70938"
OUT = ROOT / "Onward" / "QuestItems.lua"

CLASSIC_ALLIANCE, CLASSIC_HORDE = 77, 178
SKYBORNE_ALLIANCE, SKYBORNE_HORDE = 2 ** 32, 2 ** 33
ALLIANCE, HORDE = CLASSIC_ALLIANCE | SKYBORNE_ALLIANCE, CLASSIC_HORDE | SKYBORNE_HORDE

# Explicit extra safeguard: reusable boss-summoners, attunements, toys, or special tools
NEVER_DELETE = {
    5462,   # Dartol's Rod of Transformation
    9240,   # Mallet of Zul'Farrak
    10515,  # Torch of Retribution
    10699,  # Yeh'kinya's Bramble
    10818,  # Yeh'kinya's Scroll
    11511,  # Cenarion Beacon
    12344,  # Seal of Ascension
    12846,  # Argent Dawn Commission
    13289,  # Egan's Blaster
    13544,  # Spectral Essence
    16309,  # Drakefire Amulet
    17191,  # Scepter of Celebras
    17333,  # Aqual Quintessence
    21175,  # The Scepter of the Shifting Sands
    21946,  # Ectoplasmic Distiller
    21986,  # Banner of Provocation
    22057,  # Brazier of Invocation
    22754,  # Eternal Quintessence
}


def s(v):
    return v.decode("utf-8", "replace") if isinstance(v, bytes) else (v or "")


def load_sparse():
    out = {}
    with open(DB2 / "ItemSparse.csv", encoding="utf-8") as f:
        for r in csv.DictReader(f):
            out[int(r["ID"])] = (
                r.get("Display_lang", ""),
                int(r.get("Bonding") or 0),
                int(r.get("SellPrice") or 0),
                int(r.get("InventoryType") or 0),
                int(r.get("Flags_0") or 0),
                int(r.get("OverallQualityID") or 0),
            )
    return out


def load_usable_items():
    out = set()
    with open(DB2 / "ItemXItemEffect.csv", encoding="utf-8") as f:
        for r in csv.DictReader(f):
            iid = int(r.get("ItemID") or 0)
            if iid:
                out.add(iid)
    return out


def main():
    db = QuestieDB()
    sparse = load_sparse()
    usable = load_usable_items()
    a2m = area_to_uimap()
    dungeons = {m for m, n in map_names().items() if "dungeon" in n.lower() or "raid" in n.lower()}

    item_qs = {}
    q_text = {}
    q_children = {}
    q_dungeon = set()
    q_bad = set()
    q_fac = {}  # q -> (alliance_ok, horde_ok)

    def add(iid, q):
        if iid and isinstance(iid, int):
            item_qs.setdefault(iid, set()).add(q)

    for q in db.ids("Quest-"):
        sf = db.quest(q, "specialFlags") or 0
        qf = db.quest(q, "questFlags") or 0
        ql = db.quest(q, "questLevel") or 0
        if (sf & 1) or (qf & 256) or ql <= 0:
            q_bad.add(q)
        z = db.quest(q, "zoneOrSort")
        if z and a2m.get(z) in dungeons:
            q_dungeon.add(q)
        races = db.quest(q, "requiredRaces") or 0
        q_fac[q] = (not races or bool(races & ALLIANCE), not races or bool(races & HORDE))

        nm = s(db.quest(q, "name"))
        txts = " ".join(s(t) for t in lua_list(db.quest(q, "objectivesText")))
        q_text[q] = (nm + " " + txts).lower()
        for p in lua_list(db.quest(q, "preQuestSingle")) + lua_list(db.quest(q, "preQuestGroup")):
            if p:
                q_children.setdefault(p, set()).add(q)
        nxt = db.quest(q, "nextQuestInChain")
        if nxt:
            q_children.setdefault(q, set()).add(nxt)

        add(db.quest(q, "sourceItemId"), q)
        for i in lua_list(db.field("Quest-", q, 21)):  # requiredSourceItems
            add(i, q)
        sb = db.quest(q, "startedBy") or {}
        sb = sb if isinstance(sb, dict) else dict(enumerate(lua_list(sb), 1))
        for i in lua_list(sb.get(3)):
            add(i, q)
        obj = db.quest(q, "objectives") or {}
        obj = obj if isinstance(obj, dict) else dict(enumerate(lua_list(obj), 1))
        for e in lua_list(obj.get(3)):
            add(e if isinstance(e, int) else lua_list(e)[0], q)

    for iid in db.ids("Item-"):
        st = db.field("Item-", iid, 5)
        if st:
            add(iid, st)
        for q in lua_list(db.field("Item-", iid, 15)):  # relatedQuests
            add(iid, q)

    rows = []
    chain_extended = 0
    for iid in sorted(item_qs):
        if iid in NEVER_DELETE:
            continue
        if db.field("Item-", iid, 12) != 12:            # must be Quest item class
            continue
        if lua_list(db.field("Item-", iid, 6)):         # never quest rewards
            continue
        if db.field("Item-", iid, 16):                  # never teaches a spell
            continue
        if lua_list(db.field("Item-", iid, 14)):        # never vendor-sold
            continue
        sp = sparse.get(iid)
        if not sp:
            continue
        name, bonding, sell, inv, flags0, qual = sp
        if not name or bonding not in (1, 4):           # must be BoP or Quest-bound
            continue
        if sell > 0 or inv != 0 or (flags0 & 0x4) or qual >= 3:
            continue

        qs = set(item_qs[iid])
        # Propagate downstream: if any descendant quest mentions this item's name, require it too
        needle = name.lower()
        if len(needle) >= 5:
            seen, stack = set(qs), list(qs)
            while stack:
                cur = stack.pop()
                for child in q_children.get(cur, ()):
                    if child not in seen:
                        seen.add(child)
                        stack.append(child)
                        if needle in q_text.get(child, ""):
                            qs.add(child)
                            chain_extended += 1

        # Exclude if any referencing quest is repeatable / war-effort / level-0 / unknown
        if any(q in q_bad or q not in q_fac for q in qs):
            continue
        # Exclude usable items tied to dungeon/raid quests (boss summoners, instance tools)
        if iid in usable and any(q in q_dungeon for q in qs):
            continue

        a_qs = sorted(q for q in qs if q_fac[q][0])
        h_qs = sorted(q for q in qs if q_fac[q][1])
        if not a_qs and not h_qs:
            continue
        rows.append((iid, a_qs, h_qs))

    lines = [
        f"-- GENERATED {datetime.date.today()} by tools/make_quest_items.py from QuestieDB (GPL-3.0) + Forever DB2.",
        "-- Soulbound/quest-bound, non-vendorable, non-reward quest items and every non-repeatable quest",
        "-- that uses them (split by faction when they differ). An item is offered for voluntary cleanup",
        "-- ONLY when every quest listed for the player's faction is completed and none is in the quest log.",
        "local _, W = ...",
        "W.QuestItemQuests = {",
    ]
    for iid, a_qs, h_qs in rows:
        if a_qs == h_qs:
            lines.append(f"  [{iid}] = {{ {', '.join(map(str, a_qs))} }},")
        else:
            parts = []
            if a_qs:
                parts.append(f"A = {{ {', '.join(map(str, a_qs))} }}")
            if h_qs:
                parts.append(f"H = {{ {', '.join(map(str, h_qs))} }}")
            lines.append(f"  [{iid}] = {{ {', '.join(parts)} }},")
    lines.append("}")
    OUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"wrote {OUT}: {len(rows)} safe quest items ({chain_extended} downstream chain links added)")


if __name__ == "__main__":
    main()
