"""Compare the greedy route with the optimized one: travel distance and revisits.

    python route_report.py                 -> sample zones
    python route_report.py 1429:Alliance   -> one zone (uiMapId:faction)
"""
import sys
import time

import draft_guide as D
from questiedb import QuestieDB, area_to_uimap

SAMPLES = [(2548, "Alliance", "Riverglades"), (1429, "Alliance", "Elwynn Forest"),
           (1434, "Horde", "Stranglethorn Vale"), (1413, "Horde", "The Barrens"),
           (2521, "Horde", "Zephras Isle"), (1439, "Alliance", "Darkshore")]


def forced_returns(zone, Q):
    """Lower bound on hub returns the quest design forces: along a chain A -> B where A is handed
    in where B is picked up, and A's objectives are away from that spot, you must leave and come
    back before B exists. The longest such chain per hub needs (depth - 1) returns there at least."""
    xy = lambda loc: loc[1] if loc and loc[0] == zone.map else None
    hubs = []

    def hub_of(p):
        for k, h in enumerate(hubs):
            if D.dist(h, p) < D.NEAR:
                return k
        hubs.append(p)
        return len(hubs) - 1

    depth = {}

    def chain(q, seen=()):
        if q["id"] in depth:
            return depth[q["id"]]
        g = xy(q["start"])
        best = 1
        for p in q["preAny"] + q["preAll"]:
            pq = Q.get(p)
            if pq and p not in seen and g and xy(pq["finish"]) and D.dist(xy(pq["finish"]), g) < D.NEAR \
                    and pq["obj"] and D.dist(pq["obj"], g) >= D.NEAR:
                best = max(best, chain(pq, seen + (q["id"],)) + 1)
        depth[q["id"]] = best
        return best

    per_hub = {}
    for q in Q.values():
        g = xy(q["start"])
        if g:
            h = hub_of(g)
            per_hub[h] = max(per_hub.get(h, 1), chain(q))
    return sum(d - 1 for d in per_hub.values())


def main():
    db, a2m = QuestieDB(), area_to_uimap()
    zones = SAMPLES
    if len(sys.argv) > 1:
        zones = [(int(a.split(":")[0]), a.split(":")[1], a) for a in sys.argv[1:]]
    for m, faction, name in zones:
        z = D.Zone(db, m, faction, a2m)
        core, _ = D.split_outliers(z.quests)
        D.optimize_route = False
        s0, _, lv = D.route(z, core, presplit=True)
        t = time.time()
        D.optimize_route = True
        s1, _, _ = D.route(z, core, presplit=True)
        t0, r0 = D.stats(z, s0)
        t1, r1 = D.stats(z, s1)
        bad0, bad1 = D.violations(core, s0, *lv), D.violations(core, s1, *lv)
        print(f"{name:20} {faction:8} travel {t0:6.0f} -> {t1:6.0f} ({(1 - t1 / t0) * 100:3.0f}% less)  "
              f"trips back {r0:3} -> {r1:3} (forced by chains >= {forced_returns(z, core):2})  "
              f"rule breaks {bad0} -> {bad1}  {time.time() - t:5.1f}s")


if __name__ == "__main__":
    main()
