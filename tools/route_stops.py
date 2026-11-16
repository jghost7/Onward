"""Print a zone route as stops (places you travel to) and mark each revisit.

    python route_stops.py 2548 Alliance
"""
import sys

import draft_guide as D
from questiedb import QuestieDB, area_to_uimap


def main():
    m, faction = int(sys.argv[1]), sys.argv[2]
    db, a2m = QuestieDB(), area_to_uimap()
    z = D.Zone(db, m, faction, a2m)
    core, _ = D.split_outliers(z.quests)
    steps, _, _ = D.route(z, core, presplit=True)
    stops = []
    for v, q in steps:
        p = D.step_xy(z, v, q)
        if p is None:
            continue
        tag = f"{v[0]}{q['id']}"
        if stops and D.dist(stops[-1][0], p) < D.NEAR:
            stops[-1][1].append(tag)
        else:
            stops.append((p, [tag]))
    for k, (p, acts) in enumerate(stops):
        rv = [j for j, (o, _) in enumerate(stops[:max(0, k - 1)]) if D.dist(o, p) < D.NEAR]
        mark = f"REVISIT of {rv[-1]}" if rv else ""
        print(f"{k:3} ({p[0]:4.0f},{p[1]:4.0f}) {' '.join(acts)[:70]:70} {mark}")


if __name__ == "__main__":
    main()
