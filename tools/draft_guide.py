"""Draft a Onward guide for one zone from Questie's Forever database.

    python draft_guide.py --zone Riverglades --map 2548 --faction Alliance

What it does:
  1. Collects the zone's quests (zoneOrSort in any area that maps to --map) for the faction.
  2. Locates every quest's giver, turn-in and objective area (creature / object / item-drop /
     trigger spawns -> medoid of the points on the zone map).
  3. Simulates a player: from the first hub, repeatedly takes the cheapest next action
     (accept / do objectives / turn in) respecting prerequisites, exclusive quests, a level gate
     and a 20-quest log, and bundles everything at the same spot into one stop.
The result is a computed route, not a played one: play it with /ow rec running and fix the order.
Data: Questie/QuestieDB (GPL-3.0), so generated guides are GPL-3.0 too.
"""
import argparse
import datetime
import math
import pathlib
import re

from questiedb import NPC, QuestieDB, area_to_uimap, lua_list

NPC_FLAGS = NPC["npcFlags"]

CLASSIC_ALLIANCE, CLASSIC_HORDE = 77, 178    # race bits Human|Dwarf|NightElf|Gnome, Orc|Undead|Tauren|Troll
SKYBORNE_ALLIANCE, SKYBORNE_HORDE = 2 ** 32, 2 ** 33   # Forever's High Order / Windshaper Skyborne
ALLIANCE, HORDE = CLASSIC_ALLIANCE | SKYBORNE_ALLIANCE, CLASSIC_HORDE | SKYBORNE_HORDE
LOG_SIZE = 20
NEAR = 4.0                         # map units (0-100) that count as "same spot"


def s(v):
    return v.decode("utf-8", "replace") if isinstance(v, bytes) else v


CLASS_BITS = {1: "WARRIOR", 2: "PALADIN", 4: "HUNTER", 8: "ROGUE", 16: "PRIEST",
              64: "SHAMAN", 128: "MAGE", 256: "WARLOCK", 1024: "DRUID"}
RACE_BITS = {1: "Human", 2: "Orc", 4: "Dwarf", 8: "NightElf", 16: "Scourge", 32: "Tauren",
             64: "Gnome", 128: "Troll", SKYBORNE_ALLIANCE: "SkyborneAlliance", SKYBORNE_HORDE: "SkyborneHorde"}
ALL_CLASSES = sum(CLASS_BITS)


def as_area_map(spawns):
    """Spawns are {areaId: [[x,y],...]}. When the only keys are 1..n, CBOR (like Lua) stores the
    table as an array, so area 1 (Dun Morogh) arrives as a list. Restore the area keys."""
    if isinstance(spawns, list):
        return {i + 1: v for i, v in enumerate(spawns) if v}
    return spawns if isinstance(spawns, dict) else None


def bits_to_tokens(mask, table):
    return [tok for bit, tok in table.items() if mask & bit]


_QZONE = {}


def quest_zone(db, q):
    """The quest's zone (Questie's zoneOrSort). About 300 quests in the Forever data have none,
    most of them in the new zones (Mount Hyjal, Riverglades, Shen'dralas): those take the area
    their giver stands in (most spawns), else their finisher's. Without this they were in no
    guide, and every quest that follows one of them had a prerequisite nobody was sent to."""
    if q not in _QZONE:
        z = db.quest(q, "zoneOrSort")
        if not z:
            for field in ("startedBy", "finishedBy"):
                who = db.quest(q, field) or {}
                who = who if isinstance(who, dict) else dict(enumerate(lua_list(who), 1))
                count = {}
                for kind, slot in (("npc", 1), ("obj", 2)):
                    for i in lua_list(who.get(slot)):
                        if not i:
                            continue
                        spawns = db.npc(i, "spawns") if kind == "npc" else db.obj(i, "spawns")
                        for area, pts in (as_area_map(spawns) or {}).items():
                            if pts:
                                count[area] = count.get(area, 0) + len(lua_list(pts))
                if count:
                    z = max(sorted(count), key=lambda a: count[a])
                    break
        _QZONE[q] = z
    return _QZONE[q]


class Zone:
    def __init__(self, db, uimap, faction, a2m=None, qids=None):
        self.db, self.map, self.faction = db, uimap, faction
        a2m = a2m or area_to_uimap()
        self.areas = {a for a, m in a2m.items() if m == uimap}
        self.a2m = a2m
        self.bit = ALLIANCE if faction == "Alliance" else HORDE
        self.classic = CLASSIC_ALLIANCE if faction == "Alliance" else CLASSIC_HORDE
        self.skyborne = SKYBORNE_ALLIANCE if faction == "Alliance" else SKYBORNE_HORDE
        self._who = {}
        self._group = {}
        self.dungeon_maps = dungeon_maps()
        self.quests = {}
        for q in (qids if qids is not None else db.ids("Quest-")):
            if quest_zone(db, q) not in self.areas:
                continue
            races = db.quest(q, "requiredRaces")
            if races and not (races & self.bit):
                continue
            flags = db.quest(q, "specialFlags") or 0
            if flags & 3:                                   # repeatable or event-gated
                continue
            if db.quest(q, "requiredSkill"):                # profession quests
                continue
            if not all(self.who(q)):                        # no race/class of this faction can get it
                continue
            self.quests[q] = self.describe(q)
        self.drop_exclusive()

    # ------------------------------------------------------------ who can do it
    def own_who(self, q):
        """(race mask, class mask) the quest itself allows, within this faction. A Skyborne
        character passes any mask that holds every classic race of its faction: faction-wide
        masks in the data often leave the Skyborne bit out."""
        races = (self.db.quest(q, "requiredRaces") or 0) or self.bit
        races &= self.bit
        if races & self.classic == self.classic:
            races |= self.skyborne
        classes = ((self.db.quest(q, "requiredClasses") or 0) or ALL_CLASSES) & ALL_CLASSES
        return races, classes

    def who(self, q, _stack=()):
        """(race mask, class mask) that can actually get the quest: its own limits, narrowed by
        its prerequisites (all of preQuestGroup, any of preQuestSingle). A follow-up to a
        dwarf-and-gnome quest is dwarf-and-gnome too, even when the data doesn't say so."""
        if q in self._who:
            return self._who[q]
        if q in _stack or self.db.row("Quest-", q) is None:
            return self.bit, ALL_CLASSES                        # loop, or a prerequisite we can't see
        races, classes = self.own_who(q)
        stack = _stack + (q,)
        for p in lua_list(self.db.quest(q, "preQuestGroup")):
            if p:
                r, c = self.who(p, stack)
                races, classes = races & r, classes & c
        any_r = any_c = 0
        # a breadcrumb is a shortcut to the quest, not a requirement: it never narrows
        singles = [p for p in lua_list(self.db.quest(q, "preQuestSingle"))
                   if p and self.db.quest(p, "breadcrumbForQuestId") != q]
        for p in singles:
            r, c = self.who(p, stack)
            if r and c:
                any_r, any_c = any_r | r, any_c | c
        if singles:
            races, classes = races & any_r, classes & any_c
        if not _stack:
            self._who[q] = (races, classes)
        return races, classes

    # ------------------------------------------------------------ elite / group quests
    def spawn_maps(self, spawns):
        return {self.a2m.get(a) for a, lst in (as_area_map(spawns) or {}).items() if lst}

    def own_group(self, q):
        """"elite" when the quest's targets are elite (every mob that drops a quest item, or any
        kill target), "dungeon" when they only live inside an instance, else None."""
        obj = self.db.quest(q, "objectives")
        groups = obj if isinstance(obj, dict) else dict(enumerate(lua_list(obj), 1))
        kills = [lua_list(e)[0] for e in lua_list(groups.get(1))]
        for e in lua_list(groups.get(5)):
            kills += lua_list(lua_list(e)[0])
        me = self.faction[0].encode()
        # elite, rare elite or boss, and an enemy: talk-to and escort credit often names friendly elites
        elite = lambda n: (self.db.npc(n, "rank") or 0) in (1, 2, 3) and me not in (self.db.npc(n, "friendlyToFaction") or b"")             and (self.db.npc(n, "minLevel") or 0) < 100        # 9999 = scripted story NPC
        inside = lambda maps: bool(maps) and maps <= self.dungeon_maps
        kinds = set()
        for n in kills:
            if inside(self.spawn_maps(self.db.npc(n, "spawns"))):
                kinds.add("dungeon")
            elif elite(n):
                kinds.add("elite")
        for e in lua_list(groups.get(3)):
            item = lua_list(e)[0]
            drops = [n for n in lua_list(self.db.field("Item-", item, 2)) if self.db.npc(n, "spawns")]
            objs = [o for o in lua_list(self.db.field("Item-", item, 3)) if self.db.obj(o, "spawns")]
            if drops and not objs:
                if all(inside(self.spawn_maps(self.db.npc(n, "spawns"))) for n in drops):
                    kinds.add("dungeon")
                elif all(elite(n) for n in drops):
                    kinds.add("elite")
            elif objs and not drops and all(inside(self.spawn_maps(self.db.obj(o, "spawns"))) for o in objs):
                kinds.add("dungeon")
        for e in lua_list(groups.get(2)):
            if inside(self.spawn_maps(self.db.obj(lua_list(e)[0], "spawns"))):
                kinds.add("dungeon")
        return "dungeon" if "dungeon" in kinds else "elite" if "elite" in kinds else None

    def group(self, q, _stack=()):
        """Group kind of the quest, or "chain" when a solo player can't reach it: one of its
        preQuestGroup prerequisites, or every preQuestSingle one, needs a group."""
        if q in self._group:
            return self._group[q]
        if q in _stack or self.db.row("Quest-", q) is None:
            return None
        kind = self.own_group(q)
        if not kind:
            stack = _stack + (q,)
            pre = [self.group(p, stack) for p in lua_list(self.db.quest(q, "preQuestGroup")) if p]
            singles = [p for p in lua_list(self.db.quest(q, "preQuestSingle"))
                       if p and self.db.quest(p, "breadcrumbForQuestId") != q]
            one = [self.group(p, stack) for p in singles]
            if any(pre) or (one and all(one)):
                kind = "chain"
        if not _stack:
            self._group[q] = kind
        return kind

    # ------------------------------------------------------------ locations
    def zone_points(self, spawns):
        """spawns {area: [[x,y],...]} -> [(x,y)] on this zone's map (skips -1 'instanced' coords)."""
        pts = []
        spawns = as_area_map(spawns)
        if spawns:
            for area, lst in spawns.items():
                if self.a2m.get(area) == self.map or area in self.areas:
                    for c in lua_list(lst):
                        c = lua_list(c)
                        if len(c) >= 2 and c[0] is not None and c[0] >= 0:
                            pts.append((float(c[0]), float(c[1])))
        return pts

    def other_map_point(self, spawns):
        spawns = as_area_map(spawns)
        if spawns:
            for area, lst in spawns.items():
                m = self.a2m.get(area)
                for c in lua_list(lst):
                    c = lua_list(c)
                    if m and len(c) >= 2 and c[0] is not None and c[0] >= 0:
                        return m, (float(c[0]), float(c[1]))
        return None, None

    def place(self, kind, ids):
        """first NPC/object in ids with a spawn -> (map, (x,y), name)."""
        for i in lua_list(ids):
            spawns = self.db.npc(i, "spawns") if kind == "npc" else self.db.obj(i, "spawns")
            name = s(self.db.npc(i, "name") if kind == "npc" else self.db.obj(i, "name"))
            pts = self.zone_points(spawns)
            if pts:
                return self.map, medoid(pts), name
            m, p = self.other_map_point(spawns)
            if p:
                return m, p, name
        return None

    def starter(self, q):
        sb = self.db.quest(q, "startedBy") or {}
        sb = sb if isinstance(sb, dict) else dict(enumerate(lua_list(sb), 1))
        loc = self.place("npc", sb.get(1)) or self.place("obj", sb.get(2))
        if loc:
            return loc, None
        items = lua_list(sb.get(3))
        if items:
            item = items[0]
            iname = s(self.db.field("Item-", item, 1))
            pts = self.item_points(item)
            return ((self.map, medoid(pts), None) if pts else None), iname
        return None, None

    def start_item(self, q):
        sb = self.db.quest(q, "startedBy") or {}
        sb = sb if isinstance(sb, dict) else dict(enumerate(lua_list(sb), 1))
        items = [i for i in lua_list(sb.get(3)) if i]
        return items[0] if items else None

    def finisher(self, q):
        fb = self.db.quest(q, "finishedBy") or {}
        fb = fb if isinstance(fb, dict) else dict(enumerate(lua_list(fb), 1))
        return self.place("npc", fb.get(1)) or self.place("obj", fb.get(2))

    def any_points(self, spawns):
        """spawns -> [(uiMap, (x, y))] on every open-world map (dungeon interiors left out)."""
        pts = []
        spawns = as_area_map(spawns)
        if spawns:
            for area, lst in spawns.items():
                m = self.a2m.get(area)
                if not m or m in self.dungeon_maps:
                    continue
                for c in lua_list(lst):
                    c = lua_list(c)
                    if len(c) >= 2 and c[0] is not None and c[0] >= 0:
                        pts.append((m, (float(c[0]), float(c[1]))))
        return pts

    def far_objective(self, q):
        """(uiMap, (x, y)) for objectives that lie outside this zone: the medoid on the map that
        holds most of their spawns (the mobs over the border in Alterac, say), or None."""
        by_map = {}
        for m, xy in self.objective_points(q, self.any_points):
            by_map.setdefault(m, []).append(xy)
        by_map.pop(self.map, None)
        if not by_map:
            return None
        m = max(by_map, key=lambda k: len(by_map[k]))
        # a drop shared by mobs all over the world (boar meat) says nothing about where to go
        if len(by_map[m]) < 0.6 * sum(len(v) for v in by_map.values()):
            return None
        return m, medoid(by_map[m])

    # ------------------------------------------------------------ objectives Questie can't place
    # Forever's own quests often have objectives with no spawn data (a woodpile, a herb only this
    # zone has). Their text still says where: "...from Peasant Woodpiles in Turner's Logging Camp",
    # "Gather Chunks of Boar Meat ... (Paletusk Harvesting)". Read it.
    def zone_mobs(self):
        """{name: [(x, y)]} for NPCs on this zone's map that aren't townsfolk (cached per map)."""
        if self.map not in _ZONE_MOBS:
            out = {}
            for n in self.db.ids("Npc-"):
                # townsfolk and quest NPCs aren't targets (friendlyToFaction is no help: neutral
                # beasts are "AH" too)
                if (self.db.field("Npc-", n, NPC_FLAGS) or self.db.npc(n, "questStarts")
                        or self.db.npc(n, "questEnds")):
                    continue
                spawns = self.db.npc(n, "spawns")
                if not spawns:
                    continue
                pts = self.zone_points(spawns)
                if pts:
                    name = s(self.db.npc(n, "name"))
                    if name:
                        out.setdefault(name, []).extend(pts)
            _ZONE_MOBS[self.map] = out
        return _ZONE_MOBS[self.map]

    def text_mobs(self, q, text):
        """Hostile mobs of this zone named in the quest's title or objective text: the full name,
        or a distinctive word of it ("Paletusk" -> Young Paletusk)."""
        hay = (s(self.db.quest(q, "name")) or "") + " " + text
        # place words name an area, not a mob ("Bolder'ok Brute" for "near Bolder'ok"): text_place
        # handles those
        placey = {w.lower() for *_, name in places().get(self.map, []) for w in re.findall(r"[\w'-]+", name)}
        words = {w for w in re.findall(r"[A-Z][\w'-]{4,}", hay)
                 if w.lower() not in TEXT_STOP and w.lower() not in placey}
        found = {}
        for name, pts in self.zone_mobs().items():
            parts = set(re.findall(r"[\w'-]+", name))
            if name in hay or (parts & words):
                found[name] = pts
        if not found or len(found) > 6:          # nothing, or a word too common to mean anything
            return None, []
        pts = [p for v in found.values() for p in v]
        return medoid(pts), sorted(found, key=lambda k: -len(found[k]))

    def text_place(self, q, text):
        """Centre of a named area of this zone that the objective text mentions, unless it's
        where you hand the quest in ("Bring 10 stew to Jasper in Powderfuse Port")."""
        low = text.lower()
        fin = self.finisher(q)
        fin = fin[1] if fin and fin[0] == self.map else None
        best = None
        for l, t, r, b, name in places().get(self.map, []):
            n = name.lower()
            short = n[4:] if n.startswith("the ") else n
            if not re.search(r"\b" + re.escape(short) + r"\b", low):
                continue
            if fin and l - 2 <= fin[0] <= r + 2 and t - 2 <= fin[1] <= b + 2:
                continue
            if best is None or len(short) > best[0]:
                best = (len(short), ((l + r) / 2, (t + b) / 2))
        return best and best[1]

    def item_points(self, item, collect=None):
        collect = collect or self.zone_points
        pts = []
        for n in lua_list(self.db.field("Item-", item, 2)):          # npcDrops
            pts += collect(self.db.npc(n, "spawns"))
        for o in lua_list(self.db.field("Item-", item, 3)):          # objectDrops
            pts += collect(self.db.obj(o, "spawns"))
        return pts

    def objective_points(self, q, collect=None):
        """objective spawn points on this zone's map (or, with collect=self.any_points, on every
        open-world map as (map, (x, y)))"""
        collect = collect or self.zone_points
        pts = []
        obj = self.db.quest(q, "objectives")
        groups = obj if isinstance(obj, dict) else dict(enumerate(lua_list(obj), 1))
        for e in lua_list(groups.get(1)):                            # creatures
            pts += collect(self.db.npc(lua_list(e)[0], "spawns"))
        for e in lua_list(groups.get(2)):                            # objects
            pts += collect(self.db.obj(lua_list(e)[0], "spawns"))
        for e in lua_list(groups.get(3)):                            # items
            pts += self.item_points(lua_list(e)[0], collect)
        for e in lua_list(groups.get(5)):                            # kill credit: [[npcIds], creditId, text]
            for n in lua_list(lua_list(e)[0]):
                pts += collect(self.db.npc(n, "spawns"))
        trig = self.db.quest(q, "triggerEnd")
        if trig:
            t = lua_list(trig)
            if len(t) > 1:
                pts += collect(t[1])
        for e in lua_list(self.db.quest(q, "extraObjectives")):
            e = lua_list(e)
            if e and isinstance(e[0], dict):
                pts += collect(e[0])
        return pts

    def mob_names(self, q, limit=4):
        """Names to /target for a quest: kill targets and kill credit first, then the mobs that
        drop its items, most common in this zone first (a drop list can run to dozens). A dropper
        is written "Mob@Item", so the addon drops it from the target button once that item's
        objective is done."""
        obj = self.db.quest(q, "objectives")
        groups = obj if isinstance(obj, dict) else dict(enumerate(lua_list(obj), 1))
        kill, drop = [], []
        for e in lua_list(groups.get(1)):
            kill.append(lua_list(e)[0])
        for e in lua_list(groups.get(5)):
            kill += lua_list(lua_list(e)[0])
        item_of = {}
        for e in lua_list(groups.get(3)):
            item = lua_list(e)[0]
            for n in lua_list(self.db.field("Item-", item, 2)):
                k = len(self.zone_points(self.db.npc(n, "spawns")))
                if k:
                    drop.append((-k, n))
                    item_of.setdefault(n, s(self.db.field("Item-", item, 1)))
        ids = kill + [n for _, n in sorted(drop)]
        names, out = [], []
        for n in ids:
            name = s(self.db.npc(n, "name"))
            if name and name not in names and not any(c in name for c in ";|@"):
                names.append(name)
                item = item_of.get(n) if n not in kill else None
                out.append(f"{name}@{item}" if item and not any(c in item for c in ";|@") else name)
        return out[:limit]

    def describe(self, q):
        db = self.db
        start, item = self.starter(q)
        pts = self.objective_points(q)
        texts = [s(t) for t in lua_list(db.quest(q, "objectivesText"))]
        races, classes = self.who(q)
        obj, guess, mobs = (medoid(pts) if pts else None), None, self.mob_names(q)
        has_obj = bool(db.quest(q, "objectives") or db.quest(q, "triggerEnd"))
        far_spot = None
        if obj is None and has_obj and q in quest_spots():
            # looked up by hand (tools/quest_spots.json): spots on this map, else the map with most
            by_map = {}
            for e in quest_spots()[q]:
                for xy in e["points"].split():
                    x, y = xy.split(",")
                    by_map.setdefault(e["map"], []).append((float(x), float(y)))
            if self.map in by_map:
                obj, guess = medoid(by_map[self.map]), "spots"
            elif by_map:
                m = max(by_map, key=lambda k: len(by_map[k]))
                far_spot = (m, medoid(by_map[m]))
        if obj is None and has_obj and not far_spot:
            text = " ".join(t for t in texts if t)
            spot, named = self.text_mobs(q, text)
            if spot:
                obj, guess, mobs = spot, "mobs", (mobs or named[:4])
            else:
                spot = self.text_place(q, text)
                if spot:
                    obj, guess = spot, "place"
        return {
            "classes": bits_to_tokens(classes, CLASS_BITS) if classes != ALL_CLASSES else [],
            # only worth a filter when narrower than the whole faction (e.g. dwarf+gnome start zone)
            "races": bits_to_tokens(races, RACE_BITS) if races != self.bit else [],
            "id": q, "name": s(db.quest(q, "name")) or f"quest {q}",
            "level": db.quest(q, "questLevel") or 0, "minLevel": db.quest(q, "requiredLevel") or 0,
            "start": start, "startItem": item, "startItemId": self.start_item(q), "finish": self.finisher(q),
            "obj": obj, "objGuess": guess, "objFar": None if obj else (far_spot or self.far_objective(q)), "hasObjectives": has_obj,
            "areas": areas_of(pts) if pts else [],
            "preAny": [p for p in lua_list(db.quest(q, "preQuestSingle")) if p] + quest_fixes().get(q, {}).get("preAny", []),
            "preAll": [p for p in lua_list(db.quest(q, "preQuestGroup")) if p] + quest_fixes().get(q, {}).get("preAll", []),
            "exclusive": [p for p in lua_list(db.quest(q, "exclusiveTo")) if p],
            "breadcrumbFor": db.quest(q, "breadcrumbForQuestId"),
            "text": texts[0] if texts else "",
            "mobs": mobs,
            "useItem": db.quest(q, "sourceItemId") or None,   # the item the quest hands you, often the one you use
            "group": self.group(q),
        }

    def drop_exclusive(self):
        # keep the lower id of each mutually exclusive set (deterministic; review by hand)
        for q in sorted(self.quests):
            if q in self.quests:
                for x in self.quests[q]["exclusive"]:
                    if x in self.quests and x > q:
                        del self.quests[x]


_ZONE_MOBS = {}
_PLACES = {}
TEXT_STOP = {"bring", "gather", "collect", "return", "deliver", "speak", "travel", "slay", "recover",
             "kill", "steal", "retrieve", "obtain", "find", "locate", "report", "there", "their", "these",
             "alliance", "horde", "young", "elder", "greater", "lesser"}


_SPOTS = {}


_FIXES = None


def quest_fixes():
    """{questId: {"preAny": [...], "preAll": [...]}} from tools/quest_fixes.json: prerequisites the
    game enforces that Questie's data doesn't list, looked up by hand."""
    global _FIXES
    import json
    if _FIXES is None:
        path = pathlib.Path(__file__).parent / "quest_fixes.json"
        raw = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}
        _FIXES = {int(k): v for k, v in raw.items() if k.isdigit()}
    return _FIXES


def quest_spots():
    """{questId: [{what, map, points, ...}]} from tools/quest_spots.json (looked up by hand)."""
    if not _SPOTS:
        import json
        path = pathlib.Path(__file__).resolve().parent / "quest_spots.json"
        _SPOTS.update({int(k): v for k, v in json.loads(path.read_text(encoding="utf-8")).items() if not k.startswith("_")})
    return _SPOTS


def places():
    """{uiMap: [(left, top, right, bottom, name)]} from Onward/Places.lua (tools/make_places.py)."""
    if not _PLACES:
        cur = None
        path = pathlib.Path(__file__).resolve().parent.parent / "Onward" / "Places.lua"
        for line in path.read_text(encoding="utf-8").splitlines():
            m = re.match(r"\s*\[(\d+)\] = \{", line)
            if m:
                cur = int(m.group(1))
                continue
            m = re.match(r'\s*\{ ([\d.]+), ([\d.]+), ([\d.]+), ([\d.]+), "(.*)" \}', line)
            if m and cur:
                _PLACES.setdefault(cur, []).append((*map(float, m.groups()[:4]), m.group(5)))
    return _PLACES


def dungeon_maps():
    from questiedb import map_names
    return {m for m, n in map_names().items() if "dungeon" in n.lower() or "raid" in n.lower()}


AREA_R = 6.0          # map units: spawns this close to a camp's densest point belong to it
AREA_APART = 14.0     # camps closer than this are one stretch of the same place, not two areas


def areas_of(pts):
    """The separate places an objective can be done: [((x, y), spawns), ...], biggest first, or
    [] when it is all one place. Densest point first, everything within AREA_R joins it; camps
    with under a tenth of the spawns (a stray mob or two) and camps next to a bigger one are
    left out."""
    left = list(dict.fromkeys(pts))
    if len(left) < 6:
        return []
    total, found = len(left), []
    while left:
        c = max(left, key=lambda p: (sum(1 for o in left if dist(p, o) < AREA_R), -p[0], -p[1]))
        members = [o for o in left if dist(c, o) < AREA_R]
        left = [o for o in left if dist(c, o) >= AREA_R]
        found.append((medoid(members), len(members)))
    found.sort(key=lambda a: (-a[1], a[0]))
    floor = max(3, round(total * 0.1))
    out = []
    for xy, n in found:
        if n >= floor and all(dist(xy, o) >= AREA_APART for o, _ in out):
            out.append((xy, n))
    return out[:5] if len(out) > 1 else []


def medoid(pts):
    if len(pts) > 300:
        pts = pts[:: len(pts) // 300 + 1]
    best = min(pts, key=lambda p: sum(math.dist(p, o) for o in pts))
    return round(best[0], 1), round(best[1], 1)


def dist(a, b):
    if a is None or b is None:
        return 60.0
    return math.dist(a, b)


def split_outliers(quests):
    """Far-above-range quests (a level 58 follow-up in a 38-45 zone) stay out of the route and are
    listed at the end of the file. Range = 10th..90th percentile of quest levels."""
    levels = sorted(q["level"] for q in quests.values())
    if not levels:
        return quests, []
    p90 = levels[min(len(levels) - 1, len(levels) * 9 // 10)]
    keep = {i: q for i, q in quests.items() if q["level"] <= p90 + 6}
    out = [q for q in quests.values() if q["level"] > p90 + 6]
    return keep, out


def route(zone, quests=None, presplit=False):
    Q = dict(quests if quests is not None else zone.quests)
    outliers = []
    if not presplit:
        Q, outliers = split_outliers(Q)
    done, ready, log = set(), set(), set()
    steps = []
    levels = sorted(q["level"] for q in Q.values())
    lo = levels[len(levels) // 10] if levels else 1
    hi = levels[-1] if levels else 60

    def available(q):
        if q["id"] in done or q["id"] in log:
            return False
        if q["preAll"] and not all(p in done or p not in Q for p in q["preAll"]):
            return False
        if q["preAny"] and not any(p in done or p not in Q for p in q["preAny"]):
            return False
        return True

    def xy(loc):
        return loc[1] if loc and loc[0] == zone.map else None

    # start at the giver hub of the lowest-level open quests
    opens = [q for q in Q.values() if available(q) and xy(q["start"])]
    if opens:
        first = min(opens, key=lambda q: (q["level"], -sum(1 for o in opens if dist(xy(o["start"]), xy(q["start"])) < NEAR)))
        pos = xy(first["start"])
    else:
        pos = (50.0, 50.0)
    gate = lo + 1

    def sim_level():
        return lo - 1 + (hi - lo + 2) * len(done) / max(1, len(Q))

    while len(done) < len(Q):
        # a quest with several camps is worked at the one nearest to where the route is now
        for q in Q.values():
            if q.get("areas") and q["id"] in log and q["id"] not in ready:
                q["obj"] = min((a for a, _ in q["areas"]), key=lambda a: dist(pos, a))
        cands = []
        for q in Q.values():
            i = q["id"]
            if i in ready:
                cands.append((dist(pos, xy(q["finish"])) * 0.7, "turnin", q))
            elif i in log:
                cands.append((dist(pos, q["obj"]), "complete", q))
            elif available(q) and len(log) < LOG_SIZE and (q["minLevel"] or 0) <= max(gate, sim_level() + 1):
                cands.append((dist(pos, xy(q["start"])) * 0.8, "accept", q))
        if not cands:
            if gate < hi + 5:
                gate += 1
                continue
            break
        cost, verb, q = min(cands, key=lambda c: c[0])
        here = {"turnin": xy(q["finish"]), "complete": q["obj"], "accept": xy(q["start"])}[verb] or pos
        # bundle: everything doable at this spot, turn-ins first, then accepts, then objectives
        bundle = [c for c in cands if c[2] is q or (dist(here, {"turnin": xy(c[2]["finish"]), "complete": c[2]["obj"], "accept": xy(c[2]["start"])}[c[1]]) < NEAR)]
        order = {"turnin": 0, "accept": 1, "complete": 2}
        for _, v, b in sorted(bundle, key=lambda c: (order[c[1]], c[2]["id"])):
            i = b["id"]
            if v == "turnin" and i in ready:
                ready.discard(i); log.discard(i); done.add(i)
                steps.append(("turnin", b))
            elif v == "accept" and available(b) and len(log) < LOG_SIZE:
                log.add(i)
                steps.append(("accept", b))
                if not b["hasObjectives"]:      # talk-to / delivery quests are ready on accept
                    ready.add(i)
            elif v == "complete" and i in log and i not in ready:
                ready.add(i)
                steps.append(("complete", b))
        pos = here
    leftovers = [q for q in Q.values() if q["id"] not in done] + outliers
    if optimize_route:
        steps = optimize(zone, Q, steps, lo, hi)
        steps = group_away(zone, Q, steps, lo, hi)
    refine_areas(zone, steps)
    return steps, leftovers, (lo, hi)


optimize_route = True


def refine_areas(zone, steps):
    """Once the order is settled, each several-camp objective takes the camp that adds the least
    travel between the step before it and the step after it."""
    for k, (v, q) in enumerate(steps):
        if v != "complete" or not q.get("areas"):
            continue
        prev = next((p for p in (step_xy(zone, *s) for s in reversed(steps[:k])) if p), None)
        nxt = next((p for p in (step_xy(zone, *s) for s in steps[k + 1:]) if p), None)
        q["obj"] = min((a for a, _ in q["areas"]),
                       key=lambda a: (dist(prev, a) if prev else 0) + (dist(a, nxt) if nxt else 0))


# ---------------------------------------------------------------- route quality + optimizer
def step_xy(zone, verb, q):
    loc = {"accept": q["start"], "turnin": q["finish"]}.get(verb)
    if verb == "complete":
        return q["obj"]
    return loc[1] if loc and loc[0] == zone.map else None


def stats(zone, steps):
    """Total travel (map units, 0-100 per zone width) and revisits: arriving at a spot you
    already left earlier with somewhere else in between."""
    pts = [p for p in (step_xy(zone, v, q) for v, q in steps) if p]
    stops = []
    for p in pts:
        if not stops or dist(stops[-1], p) >= NEAR:
            stops.append(p)
    travel = sum(dist(a, b) for a, b in zip(stops, stops[1:]))
    # a trip back = a long leg (>= 15 map units, ~15% of the zone) ending somewhere already visited;
    # short hops between NPCs of one camp don't count
    trips_back = sum(1 for k, p in enumerate(stops)
                     if k > 1 and dist(stops[k - 1], p) >= 15 and any(dist(p, o) < NEAR for o in stops[:k - 1]))
    return travel, trips_back


def violations(Q, seq, lo, hi, loose=()):
    """Rules a route must keep. Hard (HARD each, never traded away): accept -> objectives ->
    turn-in per quest, prerequisites turned in first. Soft (1 each): at most LOG_SIZE quests
    held, and no quest picked up far above the level the player has reached (simulated from the
    share of quests handed in). The optimizer keeps a route only when its total is no worse than
    the greedy route's, so with equal weights it used to buy off a level-gate miss with a turn-in
    placed before its accept."""
    accepted, ready, done = set(), set(), set()
    bad = 0
    for v, q in seq:
        i = q["id"]
        if v == "accept":
            if q["preAll"] and not all(p in done or p not in Q for p in q["preAll"]):
                bad += HARD
            if q["preAny"] and not any(p in done or p not in Q for p in q["preAny"]):
                bad += HARD
            if len(accepted) - len(done) >= LOG_SIZE:
                bad += 1
            # the game's real gate is the quest's minimum level; the player's level is simulated
            # from progress through the zone (arrive ~1 below its range, leave at the top)
            if (q["minLevel"] or 0) > lo - 1 + (hi - lo + 2) * len(done) / max(1, len(Q)) + 1:
                bad += 1
            accepted.add(i)
            if not q["hasObjectives"] or i in loose:     # loose: its complete step is put back later
                ready.add(i)
        elif v == "complete":
            if i not in accepted:
                bad += HARD
            ready.add(i)
        else:
            if i not in ready:
                bad += HARD
            done.add(i)
    return bad


HARD = 1000


REGION_R = 7.0        # map units: steps this close to a region's centre are "the same area"
SWITCH = 10.0         # cost of leaving an area, in map units: favours finishing one area before the next


AWAY = (-150.0, 50.0)  # stand-in spot for steps in another zone: one far-off area, so trips out are
                       # bundled and put where they cost least instead of wherever greedy left them


def fixed_positions(zone, seq):
    """{(verb, id): (x, y)} per step; steps in another zone sit at AWAY; steps without
    coordinates borrow the step before them."""
    pos, last = {}, None
    for v, q in seq:
        loc = step_loc(zone, v, q)
        p = step_xy(zone, v, q) or (AWAY if loc and loc[0] != zone.map else None) or last
        pos[(v, q["id"])] = p
        last = p
    first = next((p for p in pos.values() if p), (50.0, 50.0))
    return {k: p or first for k, p in pos.items()}


def regions(pos):
    """Group step positions into areas: densest point first, everything within REGION_R joins it."""
    pts = list(dict.fromkeys(pos.values()))
    dense = sorted(pts, key=lambda p: (-sum(1 for o in pts if dist(p, o) < REGION_R), p))
    centres, label = [], {}
    for p in dense:
        k = next((i for i, c in enumerate(centres) if dist(c, p) < REGION_R), None)
        if k is None:
            centres.append(p)
            k = len(centres) - 1
        label[p] = k
    return {key: label[p] for key, p in pos.items()}


def area_changes(zone, steps):
    """How often the route leaves an area it comes back to later (the back-and-forth a player sees)."""
    pos = fixed_positions(zone, steps)
    reg = regions(pos)
    seen, prev, back = set(), None, 0
    for v, q in steps:
        r = reg[(v, q["id"])]
        if r != prev:
            back += r in seen
            seen.add(r)
            prev = r
    return back


def optimize(zone, Q, steps, lo, hi):
    """Simulated annealing on travel plus a fixed cost per area change, from several seeds; keeps
    the cheapest route that breaks no more rules than the greedy one."""
    seq = list(steps)
    if len(seq) < 6:
        return seq
    # objectives nobody can place ride along with their turn-in: "finish it, then hand it in"
    # (pinned to whatever came before them, they used to drag whole areas around)
    loose = {q["id"] for v, q in seq if v == "complete" and not step_loc(zone, v, q)}
    turned = {q["id"] for v, q in seq if v == "turnin"}
    loose &= turned
    seq = [(v, q) for v, q in seq if not (v == "complete" and q["id"] in loose)]
    if len(seq) < 6:
        return reattach(steps, seq, loose)
    base_bad = violations(Q, seq, lo, hi, loose)
    pos = fixed_positions(zone, seq)
    reg = regions(pos)
    runs = [anneal(Q, seq, lo, hi, base_bad, pos, reg, seed=k, loose=loose) for k in range(4)]
    return reattach(steps, min(runs, key=lambda s: route_cost(s, pos, reg)), loose)


def reattach(steps, seq, loose):
    """Put each loose `complete` step back right before its quest's turn-in."""
    if not loose:
        return seq
    by_id = {q["id"]: (v, q) for v, q in steps if v == "complete" and q["id"] in loose}
    out = []
    for v, q in seq:
        if v == "turnin" and q["id"] in by_id:
            out.append(by_id[q["id"]])
        out.append((v, q))
    return out


def route_cost(s, pos, reg):
    keys = [(v, q["id"]) for v, q in s]
    return sum(dist(pos[a], pos[b]) + (SWITCH if reg[a] != reg[b] else 0) for a, b in zip(keys, keys[1:]))


def anneal(Q, seq, lo, hi, base_bad, pos, reg, iters=None, seed=1, loose=()):
    """Lift a run of 1-30 steps and drop it anywhere else. Early on it accepts a slightly worse
    route so whole area visits can be regrouped later. Rule checks run only on moves it would
    accept. Keeps the best route."""
    import random
    rng = random.Random(seed)
    n = len(seq)
    iters = iters or min(1_500_000, 7500 * n)
    cur = list(seq)
    K = lambda s, k: (s[k][0], s[k][1]["id"])

    def leg(a, b):
        return dist(pos[a], pos[b]) + (SWITCH if reg[a] != reg[b] else 0)

    cur_cost = route_cost(cur, pos, reg)
    best, best_cost = list(cur), cur_cost
    t0, t1 = 12.0, 0.05
    maxL = max(2, min(30, n // 3))
    for it in range(iters):
        T = t0 * (t1 / t0) ** (it / iters)
        L = min(maxL, int(rng.expovariate(1 / 5)) + 1)
        i = rng.randint(1, n - L)
        j = rng.randint(1, n - L)          # insert index in the list without the segment
        if j == i:
            continue
        a, s0, s1 = K(cur, i - 1), K(cur, i), K(cur, i + L - 1)
        b = K(cur, i + L) if i + L < n else None
        gain = leg(a, s0) + (leg(s1, b) - leg(a, b) if b else 0)
        rest = cur[:i] + cur[i + L:]
        left = K(rest, j - 1)
        right = K(rest, j) if j < len(rest) else None
        add = leg(left, s0) + (leg(s1, right) - leg(left, right) if right else 0)
        delta = add - gain
        if delta < 0 or rng.random() < math.exp(-delta / T):
            cand = rest[:j] + cur[i:i + L] + rest[j:]
            if violations(Q, cand, lo, hi, loose) <= base_bad:
                cur, cur_cost = cand, cur_cost + delta
                if cur_cost < best_cost - 1e-9:
                    best, best_cost = list(cur), cur_cost
    return best


# ---------------------------------------------------------------- flights
_FM = {}
_NAMES = {}
FLY_MIN_LEG = 45          # map units: a dock this close is walked to, not flown to
# Flights inside a zone: the same travel-time rule as Onward's flight advice (Travel.lua). Taxis
# make ~25 yd/s along the straight line, plus ~15 s to talk, take off and land; a flight goes in
# when it saves 30 s and 15% of the run. You run 7 yd/s, or ride 11.2 from MOUNT_LEVEL.
TAXI_SPEED, FLIGHT_OVERHEAD, MIN_SAVE, NEW_SHARE = 25.0, 15.0, 30.0, 0.15
RUN_SPEED, MOUNT_SPEED, MOUNT_LEVEL = 7.0, 11.2, 40
_YD = {}


def yard_scale(m):
    """Yards per map unit (0-100) along x and y for a uiMap, from the game's UiMapAssignment
    (a zone map is rarely square: Stranglethorn is 6381 yd wide and 4254 tall)."""
    if not _YD:
        import csv
        path = pathlib.Path(__file__).resolve().parent / "data" / "db2" / "1.60.1.70938" / "UiMapAssignment.csv"
        for r in csv.DictReader(open(path, encoding="utf-8")):
            if r["OrderIndex"] == "0":
                _YD[int(r["UiMapID"])] = ((float(r["Region_4"]) - float(r["Region_1"])) / 100,
                                          (float(r["Region_3"]) - float(r["Region_0"])) / 100)
    return _YD.get(m, (40.0, 40.0))


def ydist(m, a, b):
    """Yards between two points on map m."""
    sx, sy = yard_scale(m)
    return math.hypot((a[0] - b[0]) * sx, (a[1] - b[1]) * sy)


def flight_saves(m, p0, p1, a, b, level):
    """Does flying a -> b (flight master spots) beat running p0 -> p1 on map m?"""
    v = MOUNT_SPEED if level >= MOUNT_LEVEL else RUN_SPEED
    walk = ydist(m, p0, p1) / v
    fly = ydist(m, p0, a) / v + ydist(m, a, b) / TAXI_SPEED + FLIGHT_OVERHEAD + ydist(m, b, p1) / v
    return walk - fly >= max(MIN_SAVE, NEW_SHARE * walk)


def step_loc(zone, verb, q):
    """(map, (x, y)) of a step, any zone."""
    if verb == "complete":
        return (zone.map, q["obj"]) if q["obj"] else q.get("objFar")
    loc = q["start"] if verb == "accept" else q["finish"]
    return (loc[0], loc[1]) if loc else None


def flight_masters_for(zone):
    from questiedb import flight_masters, map_names
    key = zone.faction[0]
    if key not in _FM:
        _FM[key] = flight_masters(zone.db, zone.a2m, key)
    if not _NAMES:
        _NAMES.update(map_names())
    return _FM[key]


_INNS = {}
HUB = 12             # map units: steps this close to an inn count as that town's hub
MIN_HUB_STEPS = 6    # a guide gets a "set your hearthstone" step only at a real quest hub


def inns_for(zone):
    """[((x, y), name)] innkeepers on this zone's map friendly to its faction."""
    from questiedb import flight_masters, INNKEEPER
    key = zone.faction[0]
    if key not in _INNS:
        _INNS[key] = flight_masters(zone.db, zone.a2m, key, INNKEEPER)
    return _INNS[key].get(zone.map, [])


def add_home(zone, entries):
    """Insert ("home", inn) before the first step at the guide's busiest inn town: the place you
    come back to most is where your hearthstone should take you."""
    inns = inns_for(zone)
    if not inns:
        return entries
    pts = [(k, step_xy(zone, v, q)) for k, (v, q) in enumerate(entries) if v not in ("fly", "home", "boat")]
    best, best_n = None, 0
    for xy, name in inns:
        n = sum(1 for _, p in pts if p and dist(p, xy) < HUB)
        if n > best_n:
            best, best_n = (xy, name), n
    if not best or best_n < MIN_HUB_STEPS:
        return entries
    first = next(k for k, p in pts if p and dist(p, best[0]) < HUB)
    inn = {"map": zone.map, "xy": best[0], "name": best[1]}
    return entries[:first] + [("home", inn)] + entries[first:]


def nearest_fm(fms, m, xy):
    best = None
    for p, name in fms.get(m, []):
        d = dist(p, xy)
        if best is None or d < best[0]:
            best = (d, p, name)
    return best


# Between continents there are no flights: boats and zeppelins (the same docks as Travel.lua's
# CROSSINGS). faction None = anyone.
CROSSINGS = [
    ("boat", None, (1434, (25.8, 73.1), "Booty Bay"), (1413, (63.7, 38.6), "Ratchet")),
    ("zeppelin", "H", (1434, (31.3, 29.2), "Grom'gol"), (1411, (50.8, 13.6), "Orgrimmar")),
    ("zeppelin", "H", (1420, (60.8, 58.8), "Undercity"), (1411, (50.6, 12.6), "Orgrimmar")),
    ("boat", "A", (1437, (4.6, 57.1), "Menethil Harbor"), (1445, (71.6, 56.4), "Theramore")),
    ("boat", "A", (1437, (4.8, 63.6), "Menethil Harbor"), (1439, (32.4, 43.8), "Auberdine")),
]
_CONT = {}


def continent(m):
    """The continent a uiMap is on, from the game's AreaTable (via Questie's area -> map table)."""
    if not _CONT:
        import csv
        from questiedb import area_to_uimap
        path = pathlib.Path(__file__).resolve().parent / "data" / "db2" / "1.60.1.70938" / "AreaTable.csv"
        conts = {int(r["ID"]): r["ContinentID"] for r in csv.DictReader(open(path, encoding="utf-8"))}
        for area, um in area_to_uimap().items():
            if area in conts:
                _CONT.setdefault(um, conts[area])
    return _CONT.get(m)


def crossing(zone, m0, p0, m1, p1):
    """The boat or zeppelin from continent(m0) to continent(m1) that makes the trip shortest:
    (kind, (map, xy, name) here, (map, xy, name) there), or None. Docks on another map than the
    start / end count as a flight away (60 map units)."""
    c0, c1 = continent(m0), continent(m1)
    best = None
    for kind, fac, A, B in CROSSINGS:
        if fac and fac != zone.faction[0]:
            continue
        for here, there in ((A, B), (B, A)):
            if continent(here[0]) == c0 and continent(there[0]) == c1:
                cost = (dist(p0, here[1]) if here[0] == m0 else 60) + (dist(there[1], p1) if there[0] == m1 else 60)
                if best is None or cost < best[0]:
                    best = (cost, (kind, here, there))
    return best and best[1]


def add_flights(zone, steps, level=1):
    """Insert ("fly", leg) entries where a route changes zone (fly out and back), or makes a long
    run inside the zone that two of its flight masters cut short. A change of continent becomes
    fly to the dock's flight master, ("boat", crossing), fly on from the far dock's flight master."""
    fms = flight_masters_for(zone)
    out, pos = [], None

    def fly(a, b, ma, mb):
        (_, pa, na), (_, pb, nb) = a, b
        out.append(("fly", {"from": (ma, pa, na), "to": (mb, pb, nb), "zone": _NAMES.get(mb, "")}))

    for verb, q in steps:
        loc = step_loc(zone, verb, q)
        if loc and pos and continent(pos[0]) != continent(loc[0]):
            (m0, p0), (m1, p1) = pos, loc
            cx = crossing(zone, m0, p0, m1, p1)
            if cx:
                kind, here, there = cx
                a, dock_a = nearest_fm(fms, m0, p0), nearest_fm(fms, here[0], here[1])
                if a and dock_a and a[1] != dock_a[1] and not (here[0] == m0 and dist(p0, here[1]) < FLY_MIN_LEG):
                    fly(a, dock_a, m0, here[0])
                out.append(("boat", {"kind": kind, "from": here, "to": there}))
                dock_b, b = nearest_fm(fms, there[0], there[1]), nearest_fm(fms, m1, p1)
                if dock_b and b and dock_b[1] != b[1] and not (there[0] == m1 and dist(there[1], p1) < FLY_MIN_LEG):
                    fly(dock_b, b, there[0], m1)
            out.append((verb, q))
            pos = loc
            continue
        if loc and pos:
            (m0, p0), (m1, p1) = pos, loc
            a, b = nearest_fm(fms, m0, p0), nearest_fm(fms, m1, p1)
            leg = None
            if a and b and m0 != m1:
                leg = (a, b, m0, m1)
            elif a and b and m0 == m1 and a[1] != b[1] and flight_saves(m0, p0, p1, a[1], b[1], level):
                leg = (a, b, m0, m1)
            if leg:
                (_, pa, na), (_, pb, nb), ma, mb = leg
                out.append(("fly", {"from": (ma, pa, na), "to": (mb, pb, nb), "zone": _NAMES.get(mb, "")}))
        out.append((verb, q))
        if loc:
            pos = loc
    return out


def group_away(zone, Q, steps, lo, hi):
    """Pull steps in another zone next to the previous step in that same zone when the rules allow,
    so one trip (and one flight) covers them."""
    seq = list(steps)
    base = violations(Q, seq, lo, hi)
    k = 0
    while k < len(seq):
        loc = step_loc(zone, *seq[k])
        if loc and loc[0] != zone.map:
            j = k - 1
            while j >= 0:
                lj = step_loc(zone, *seq[j])
                if lj and lj[0] == loc[0]:
                    break
                j -= 1
            if 0 <= j < k - 1:
                cand = seq[:j + 1] + [seq[k]] + seq[j + 1:k] + seq[k + 1:]
                if violations(Q, cand, lo, hi) <= base:
                    seq = cand
        k += 1
    return seq


def fmt_at(loc):
    if not loc:
        return ""
    m, (x, y) = loc[0], loc[1]
    return f" |at {m} {x:.1f},{y:.1f}"


def guide_id(name, faction, band=None):
    base = "".join(ch if ch.isalnum() else "-" for ch in name.lower()).strip("-")
    while "--" in base:
        base = base.replace("--", "-")
    return f"{base}-{faction[0].lower()}" + (f"-{band}" if band else "")


TIER_TAG = {1: " |value mid", 2: " |value low"}


def gate_tags(zone, q):
    """What the game asks before it offers the quest, for the accept step: |lvl <minimum level>,
    |pre a,b (all turned in) and |preany a,b (one of them). The addon holds the step back until
    they're met instead of pointing at a quest giver with nothing to offer. A breadcrumb leads to
    a quest without being needed for it, so it is left out."""
    out = ""
    if (q.get("minLevel") or 0) > 1:
        out += f" |lvl {q['minLevel']}"
    if q.get("preAll"):
        out += " |pre " + ",".join(str(p) for p in q["preAll"])
    any_ = [p for p in q.get("preAny") or [] if zone.db.quest(p, "breadcrumbForQuestId") != q["id"]]
    if any_:
        out += " |preany " + ",".join(str(p) for p in any_)
    return out


def flight_tiers(zone, entries, tiers):
    """A flight is only worth taking when a quest it serves is kept: out-legs take the lowest
    tier of the steps after them (until the next flight), return legs the steps before them."""
    out = {}
    fly_idx = [i for i, (v, _) in enumerate(entries) if v in ("fly", "boat")]
    for n, i in enumerate(fly_idx):
        leg = entries[i][1]
        prev_i = fly_idx[n - 1] if n > 0 else -1
        next_i = fly_idx[n + 1] if n + 1 < len(fly_idx) else len(entries)
        if leg["to"][0] != zone.map:   # boats: from/to are (map, xy, name) like flights
            seg = entries[i + 1:next_i]
        elif leg["from"][0] != zone.map:
            seg = entries[prev_i + 1:i]
        else:
            seg = []
        ts = [tiers.get(q["id"], 0) for v, q in seg if v not in ("fly", "home", "boat")]
        out[i] = min(ts) if ts else 0
    return out


def render(zone, steps, leftovers, levels, name, faction, gid=None, next_id=None, tiers=None):
    tiers = tiers or {}
    gid = gid or guide_id(name, faction)
    clean = lambda t: str(t).replace("|", "/").replace("]]", "] ]")
    out = [
        f"-- DRAFT {name} ({faction}) generated {datetime.date.today()} by tools/draft_guide.py",
        "-- from Questie's Forever database (GPL-3.0). The order is computed, not played:",
        "-- play it with /ow rec running and fix what feels wrong. Coordinates are spawn medoids.",
        "Onward:RegisterGuide{",
        f'  id = "{gid}", title = "{name} ({levels[0]}-{levels[1]})", faction = "{faction}", zone = "{name}",',
        f"  levels = {{ {levels[0]}, {levels[1]} }},",
    ]
    if next_id:
        out.append(f'  next = "{next_id}",')
    out.append("  steps = [[")
    entries = add_home(zone, add_flights(zone, steps, levels[0]))
    ftiers = flight_tiers(zone, entries, tiers)
    for idx, (verb, q) in enumerate(entries):
        if verb == "home":
            x, y = q["xy"]
            out.append(f"home |npc {clean(q['name'])} |at {q['map']} {x:.1f},{y:.1f}  -- set your hearthstone at the inn")
            continue
        if verb == "boat":
            (fm, fp, fn), (tm, tp, tn) = q["from"], q["to"]
            out.append(f"goto {fm} {fp[0]:.1f},{fp[1]:.1f} 15 |note Take the {q['kind']} to {clean(tn)}"
                       f"{TIER_TAG.get(ftiers.get(idx, 0), '')}  -- {q['kind']} {clean(fn)} to {clean(tn)}")
            continue
        if verb == "fly":
            (fm, fp, fn), (tm, tp, tn) = q["from"], q["to"]
            where = f"{q['zone']} ({clean(tn)})" if q["zone"] and tm != zone.map else clean(tn)
            out.append(f"fly {tm} {tp[0]:.1f},{tp[1]:.1f} |from {fm} {fp[0]:.1f},{fp[1]:.1f} |npc {where}"
                       f"{TIER_TAG.get(ftiers.get(idx, 0), '')}  -- flight master {clean(fn)}")
            continue
        title = f"  -- {clean(q['name'])} ({q['level']})"
        who = TIER_TAG.get(tiers.get(q["id"], 0), "")
        if q["classes"]:
            who += " |class " + ",".join(q["classes"])
        if q["races"]:
            who += " |race " + ",".join(q["races"])
        if q.get("group"):
            who += " |group " + q["group"]
        if verb == "accept":
            loc = q["start"]
            npc = f" |npc {clean(loc[2])}" if loc and loc[2] else ""
            note = f" |note Starts from {clean(q['startItem'])}" if q["startItem"] else ""
            # a quest that starts from an item names it; one with no place to send you (a drop
            # nobody has placed, a giver the data has no spawn for) is |loose: the addon doesn't
            # wait on it, and takes it from there once it's in your log or the item is in your bags
            item = f" |startitem {q['startItemId']}" if q.get("startItemId") else ""
            loose = "" if loc else " |loose"
            out.append(f"accept {q['id']}{npc}{fmt_at(loc)}{note}{item}{loose}{who}{gate_tags(zone, q)}{title}")
        elif verb == "complete":
            at = f" |at {zone.map} {q['obj'][0]:.1f},{q['obj'][1]:.1f}" if q["obj"] else fmt_at(q.get("objFar"))
            mobs = f" |mobs {';'.join(q['mobs'])}" if q.get("mobs") else ""
            use = f" |item {q['useItem']}" if q.get("useItem") else ""
            # the separate camps it can be done at, with their spawn counts: the addon leads to the
            # nearest and offers the others
            areas = (" |areas " + ";".join(f"{x:.1f},{y:.1f}:{n}" for (x, y), n in q["areas"])) if q.get("areas") and q["obj"] else ""
            out.append(f"complete {q['id']}{at}{areas}{use}{mobs}{who}{title}")
        else:
            loc = q["finish"]
            npc = f" |npc {clean(loc[2])}" if loc and loc[2] else ""
            out.append(f"turnin {q['id']}{npc}{fmt_at(loc)}{who}{title}")
    out.append("]]}")
    if leftovers:
        out.append("")
        out.append("-- Not routed (far above the zone's level range, or no reachable path):")
        for q in sorted(leftovers, key=lambda q: q["level"]):
            out.append(f"--   {q['id']}  {clean(q['name'])} ({q['level']})")
    return "\n".join(out) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--zone", required=True)
    ap.add_argument("--map", type=int, required=True)
    ap.add_argument("--faction", choices=("Alliance", "Horde"), required=True)
    ap.add_argument("--out")
    a = ap.parse_args()
    db = QuestieDB()
    zone = Zone(db, a.map, a.faction)
    steps, left, levels = route(zone)
    text = render(zone, steps, left, levels, a.zone, a.faction)
    out = pathlib.Path(a.out or (pathlib.Path(__file__).parent.parent / "Onward" / "Guides" / f"{a.zone.replace(' ', '')}_{a.faction}.lua"))
    out.write_text(text, encoding="utf-8")
    nocoord = sum(1 for v, q in steps if (v == "complete" and not q["obj"]) or (v != "complete" and not (q["start"] if v == "accept" else q["finish"])))
    print(f"{a.zone} {a.faction}: {len(zone.quests)} quests, {len(steps)} steps, {len(left)} not routed, {nocoord} steps without coordinates -> {out}")


if __name__ == "__main__":
    main()
