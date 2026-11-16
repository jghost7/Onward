"""Draft a Sloppy Questing guide for one zone from Questie's Forever database.

    python draft_guide.py --zone Riverglades --map 2548 --faction Alliance

What it does:
  1. Collects the zone's quests (zoneOrSort in any area that maps to --map) for the faction.
  2. Locates every quest's giver, turn-in and objective area (creature / object / item-drop /
     trigger spawns -> medoid of the points on the zone map).
  3. Simulates a player: from the first hub, repeatedly takes the cheapest next action
     (accept / do objectives / turn in) respecting prerequisites, exclusive quests, a level gate
     and a 20-quest log, and bundles everything at the same spot into one stop.
The result is a computed route, not a played one: play it with /sq rec running and fix the order.
Data: Questie/QuestieDB (GPL-3.0), so generated guides are GPL-3.0 too.
"""
import argparse
import datetime
import math
import pathlib

from questiedb import QuestieDB, area_to_uimap, lua_list

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
            if db.quest(q, "zoneOrSort") not in self.areas:
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

    def finisher(self, q):
        fb = self.db.quest(q, "finishedBy") or {}
        fb = fb if isinstance(fb, dict) else dict(enumerate(lua_list(fb), 1))
        return self.place("npc", fb.get(1)) or self.place("obj", fb.get(2))

    def item_points(self, item):
        pts = []
        for n in lua_list(self.db.field("Item-", item, 2)):          # npcDrops
            pts += self.zone_points(self.db.npc(n, "spawns"))
        for o in lua_list(self.db.field("Item-", item, 3)):          # objectDrops
            pts += self.zone_points(self.db.obj(o, "spawns"))
        return pts

    def objective_points(self, q):
        pts = []
        obj = self.db.quest(q, "objectives")
        groups = obj if isinstance(obj, dict) else dict(enumerate(lua_list(obj), 1))
        for e in lua_list(groups.get(1)):                            # creatures
            pts += self.zone_points(self.db.npc(lua_list(e)[0], "spawns"))
        for e in lua_list(groups.get(2)):                            # objects
            pts += self.zone_points(self.db.obj(lua_list(e)[0], "spawns"))
        for e in lua_list(groups.get(3)):                            # items
            pts += self.item_points(lua_list(e)[0])
        for e in lua_list(groups.get(5)):                            # kill credit: [[npcIds], creditId, text]
            for n in lua_list(lua_list(e)[0]):
                pts += self.zone_points(self.db.npc(n, "spawns"))
        trig = self.db.quest(q, "triggerEnd")
        if trig:
            t = lua_list(trig)
            if len(t) > 1:
                pts += self.zone_points(t[1])
        for e in lua_list(self.db.quest(q, "extraObjectives")):
            e = lua_list(e)
            if e and isinstance(e[0], dict):
                pts += self.zone_points(e[0])
        return pts

    def mob_names(self, q, limit=4):
        """Names to /target for a quest: kill targets and kill credit first, then the mobs that
        drop its items, most common in this zone first (a drop list can run to dozens)."""
        obj = self.db.quest(q, "objectives")
        groups = obj if isinstance(obj, dict) else dict(enumerate(lua_list(obj), 1))
        kill, drop = [], []
        for e in lua_list(groups.get(1)):
            kill.append(lua_list(e)[0])
        for e in lua_list(groups.get(5)):
            kill += lua_list(lua_list(e)[0])
        for e in lua_list(groups.get(3)):
            for n in lua_list(self.db.field("Item-", lua_list(e)[0], 2)):
                k = len(self.zone_points(self.db.npc(n, "spawns")))
                if k:
                    drop.append((-k, n))
        ids = kill + [n for _, n in sorted(drop)]
        names = []
        for n in ids:
            name = s(self.db.npc(n, "name"))
            if name and name not in names and ";" not in name and "|" not in name:
                names.append(name)
        return names[:limit]

    def describe(self, q):
        db = self.db
        start, item = self.starter(q)
        pts = self.objective_points(q)
        texts = [s(t) for t in lua_list(db.quest(q, "objectivesText"))]
        races, classes = self.who(q)
        return {
            "classes": bits_to_tokens(classes, CLASS_BITS) if classes != ALL_CLASSES else [],
            # only worth a filter when narrower than the whole faction (e.g. dwarf+gnome start zone)
            "races": bits_to_tokens(races, RACE_BITS) if races != self.bit else [],
            "id": q, "name": s(db.quest(q, "name")) or f"quest {q}",
            "level": db.quest(q, "questLevel") or 0, "minLevel": db.quest(q, "requiredLevel") or 0,
            "start": start, "startItem": item, "finish": self.finisher(q),
            "obj": medoid(pts) if pts else None, "hasObjectives": bool(db.quest(q, "objectives") or db.quest(q, "triggerEnd")),
            "preAny": [p for p in lua_list(db.quest(q, "preQuestSingle")) if p],
            "preAll": [p for p in lua_list(db.quest(q, "preQuestGroup")) if p],
            "exclusive": [p for p in lua_list(db.quest(q, "exclusiveTo")) if p],
            "breadcrumbFor": db.quest(q, "breadcrumbForQuestId"),
            "text": texts[0] if texts else "",
            "mobs": self.mob_names(q),
            "group": self.group(q),
        }

    def drop_exclusive(self):
        # keep the lower id of each mutually exclusive set (deterministic; review by hand)
        for q in sorted(self.quests):
            if q in self.quests:
                for x in self.quests[q]["exclusive"]:
                    if x in self.quests and x > q:
                        del self.quests[x]


def dungeon_maps():
    from questiedb import map_names
    return {m for m, n in map_names().items() if "dungeon" in n.lower() or "raid" in n.lower()}


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
    return steps, leftovers, (lo, hi)


optimize_route = True


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


def violations(Q, seq, lo, hi):
    """Hard rules a route must keep: accept -> objectives -> turn-in per quest, prerequisites
    turned in first, at most LOG_SIZE quests held, and no quest picked up far above the level
    the player has reached (simulated from the share of quests handed in)."""
    accepted, ready, done = set(), set(), set()
    bad = 0
    for v, q in seq:
        i = q["id"]
        if v == "accept":
            if q["preAll"] and not all(p in done or p not in Q for p in q["preAll"]):
                bad += 1
            if q["preAny"] and not any(p in done or p not in Q for p in q["preAny"]):
                bad += 1
            if len(accepted) - len(done) >= LOG_SIZE:
                bad += 1
            # the game's real gate is the quest's minimum level; the player's level is simulated
            # from progress through the zone (arrive ~1 below its range, leave at the top)
            if (q["minLevel"] or 0) > lo - 1 + (hi - lo + 2) * len(done) / max(1, len(Q)) + 1:
                bad += 1
            accepted.add(i)
            if not q["hasObjectives"]:
                ready.add(i)
        elif v == "complete":
            if i not in accepted:
                bad += 1
            ready.add(i)
        else:
            if i not in ready:
                bad += 1
            done.add(i)
    return bad


REGION_R = 7.0        # map units: steps this close to a region's centre are "the same area"
SWITCH = 10.0         # cost of leaving an area, in map units: favours finishing one area before the next


def fixed_positions(zone, seq):
    """{(verb, id): (x, y)} per step; steps without coordinates borrow the step before them."""
    pos, last = {}, None
    for v, q in seq:
        p = step_xy(zone, v, q) or last
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
    base_bad = violations(Q, seq, lo, hi)
    pos = fixed_positions(zone, seq)
    reg = regions(pos)
    runs = [anneal(Q, seq, lo, hi, base_bad, pos, reg, seed=k) for k in range(4)]
    return min(runs, key=lambda s: route_cost(s, pos, reg))


def route_cost(s, pos, reg):
    keys = [(v, q["id"]) for v, q in s]
    return sum(dist(pos[a], pos[b]) + (SWITCH if reg[a] != reg[b] else 0) for a, b in zip(keys, keys[1:]))


def anneal(Q, seq, lo, hi, base_bad, pos, reg, iters=None, seed=1):
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
            if violations(Q, cand, lo, hi) <= base_bad:
                cur, cur_cost = cand, cur_cost + delta
                if cur_cost < best_cost - 1e-9:
                    best, best_cost = list(cur), cur_cost
    return best


# ---------------------------------------------------------------- flights
_FM = {}
_NAMES = {}
FLY_MIN_LEG = 45          # map units: shorter legs inside a zone are always walked


def step_loc(zone, verb, q):
    """(map, (x, y)) of a step, any zone."""
    if verb == "complete":
        return (zone.map, q["obj"]) if q["obj"] else None
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


def nearest_fm(fms, m, xy):
    best = None
    for p, name in fms.get(m, []):
        d = dist(p, xy)
        if best is None or d < best[0]:
            best = (d, p, name)
    return best


def add_flights(zone, steps):
    """Insert ("fly", leg) entries where a route changes zone (fly out and back), or makes a long
    run inside the zone that two of its flight masters cut short."""
    fms = flight_masters_for(zone)
    out, pos = [], None
    for verb, q in steps:
        loc = step_loc(zone, verb, q)
        if loc and pos:
            (m0, p0), (m1, p1) = pos, loc
            a, b = nearest_fm(fms, m0, p0), nearest_fm(fms, m1, p1)
            leg = None
            if a and b and m0 != m1:
                leg = (a, b, m0, m1)
            elif a and b and m0 == m1 and dist(p0, p1) >= FLY_MIN_LEG and a[1] != b[1]:
                cost = a[0] + b[0] + dist(a[1], b[1]) / 3.2 + 6
                if cost < 0.7 * dist(p0, p1):
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


def flight_tiers(zone, entries, tiers):
    """A flight is only worth taking when a quest it serves is kept: out-legs take the lowest
    tier of the steps after them (until the next flight), return legs the steps before them."""
    out = {}
    fly_idx = [i for i, (v, _) in enumerate(entries) if v == "fly"]
    for n, i in enumerate(fly_idx):
        leg = entries[i][1]
        prev_i = fly_idx[n - 1] if n > 0 else -1
        next_i = fly_idx[n + 1] if n + 1 < len(fly_idx) else len(entries)
        if leg["to"][0] != zone.map:
            seg = entries[i + 1:next_i]
        elif leg["from"][0] != zone.map:
            seg = entries[prev_i + 1:i]
        else:
            seg = []
        ts = [tiers.get(q["id"], 0) for v, q in seg if v != "fly"]
        out[i] = min(ts) if ts else 0
    return out


def render(zone, steps, leftovers, levels, name, faction, gid=None, next_id=None, tiers=None):
    tiers = tiers or {}
    gid = gid or guide_id(name, faction)
    clean = lambda t: str(t).replace("|", "/").replace("]]", "] ]")
    out = [
        f"-- DRAFT {name} ({faction}) generated {datetime.date.today()} by tools/draft_guide.py",
        "-- from Questie's Forever database (GPL-3.0). The order is computed, not played:",
        "-- play it with /sq rec running and fix what feels wrong. Coordinates are spawn medoids.",
        "SloppyQuesting:RegisterGuide{",
        f'  id = "{gid}", title = "{name} ({levels[0]}-{levels[1]})", faction = "{faction}", zone = "{name}",',
        f"  levels = {{ {levels[0]}, {levels[1]} }},",
    ]
    if next_id:
        out.append(f'  next = "{next_id}",')
    out.append("  steps = [[")
    entries = add_flights(zone, steps)
    ftiers = flight_tiers(zone, entries, tiers)
    for idx, (verb, q) in enumerate(entries):
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
            out.append(f"accept {q['id']}{npc}{fmt_at(loc)}{note}{who}{title}")
        elif verb == "complete":
            at = f" |at {zone.map} {q['obj'][0]:.1f},{q['obj'][1]:.1f}" if q["obj"] else ""
            mobs = f" |mobs {';'.join(q['mobs'])}" if q.get("mobs") else ""
            out.append(f"complete {q['id']}{at}{mobs}{who}{title}")
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
    out = pathlib.Path(a.out or (pathlib.Path(__file__).parent.parent / "SloppyQuesting" / "Guides" / f"{a.zone.replace(' ', '')}_{a.faction}.lua"))
    out.write_text(text, encoding="utf-8")
    nocoord = sum(1 for v, q in steps if (v == "complete" and not q["obj"]) or (v != "complete" and not (q["start"] if v == "accept" else q["finish"])))
    print(f"{a.zone} {a.faction}: {len(zone.quests)} quests, {len(steps)} steps, {len(left)} not routed, {nocoord} steps without coordinates -> {out}")


if __name__ == "__main__":
    main()
