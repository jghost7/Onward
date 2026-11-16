"""What each quest mode keeps in sample zones: XP share vs time share, and the weakest quests.

    python value_report.py                  -> sample zones
    python value_report.py 1429:Alliance    -> one zone
"""
import sys

import draft_guide as D
import quest_value as V
from questiedb import QuestieDB, area_to_uimap

SAMPLES = [(1429, "Alliance", "Elwynn Forest"), (2548, "Alliance", "Riverglades"),
           (1434, "Horde", "Stranglethorn Vale"), (1413, "Horde", "The Barrens")]


def main():
    db, a2m = QuestieDB(), area_to_uimap()
    zones = SAMPLES
    if len(sys.argv) > 1:
        zones = [(int(a.split(":")[0]), a.split(":")[1], a) for a in sys.argv[1:]]
    for m, faction, name in zones:
        z = D.Zone(db, m, faction, a2m)
        core, _ = D.split_outliers(z.quests)
        steps, _, _ = D.route(z, core, presplit=True)
        tier, sc, rep = V.tiers(z, core, steps)
        print(f"{name} ({faction}): {len(core)} quests, about {rep['hours']:.1f} h, XP measured for {rep['measured'] * 100:.0f}%")
        for mode in ("efficient", "fastest"):
            xp, t, k = rep[mode]
            print(f"   {mode:9} keeps {k:3}: {xp * 100:3.0f}% of the XP in {t * 100:3.0f}% of the time"
                  f" = {xp / t:.2f}x XP per hour")
        worst = sorted(core, key=lambda q: sc[q]["rate"])[:5]
        for q in worst:
            s = sc[q]
            print(f"   weak: {core[q]['name'][:34]:34} {s['xp']:5.0f} xp  {s['seconds'] / 60:4.1f} min  {s['rate']:5.0f} xp/min")
        print()


if __name__ == "__main__":
    main()
