"""Draft guides for every open-world zone (classic + new Forever zones) for both factions.

    python draft_all.py            -> SloppyQuesting/Guides/Draft/*.lua + SloppyQuesting/Guides/Guides.xml

Skips dungeons, raids and battlegrounds. Zones whose quests span more than 10 levels are split
into level bands chained with `next`, so a band hands over to the next one when finished.
"""
import math
import multiprocessing
import os
import pathlib
import re
import time

from questiedb import FOREVER, QuestieDB, area_to_uimap
from draft_guide import Zone, area_changes, guide_id, render, route, split_outliers, stats
from quest_value import tiers as quest_tiers

ROOT = pathlib.Path(__file__).resolve().parent.parent
GUIDES = ROOT / "SloppyQuesting" / "Guides"
DRAFT = GUIDES / "Draft"
BATTLEGROUNDS = {1459, 1460, 1461, 2524}     # AV, WSG, AB, Darkspear Islands (PvP; givers sit in capitals)
CAPITALS = {1453, 1454, 1455, 1456, 1457, 1458}   # city quests are class/profession/war-effort, not leveling
MIN_QUESTS = 8
NEW_ZONES = {2548, 2521, 2482, 2652}   # Riverglades, Zephras Isle, Mount Hyjal, Shen'dralas


def map_names():
    text = (FOREVER / "QuestieDB" / "support" / "Forever" / "Zones" / "uiMapIdToAreaId.lua").read_text(encoding="utf-8")
    return {int(m): n.strip() for m, _, n in re.findall(r"\[(\d+)\]\s*=\s*(\d+),\s*--\s*(.+)", text)}


def bands(quests):
    """Split {id: q} into level bands of ~9 levels when the zone spans more than 10."""
    levels = sorted(q["level"] for q in quests.values())
    lo, hi = levels[len(levels) // 10], levels[-1]      # outliers were removed by split_outliers
    if hi - lo <= 10:
        return [quests], []
    n = math.ceil((hi - lo + 1) / 9)
    width = (hi - lo + 1) / n
    out = [dict() for _ in range(n)]
    for i, q in quests.items():
        k = min(n - 1, max(0, int((q["level"] - lo) // width)))
        out[k][i] = q
    out = [b for b in out if b]
    # fold bands too small to be a guide into a neighbour, unless the level gap is large:
    # then they are stragglers (a level 44 follow-up in Westfall) and get listed, not routed
    merged, dropped = [], []
    top = lambda b: max(q["level"] for q in b.values())
    bottom = lambda b: min(q["level"] for q in b.values())
    for b in out:
        if merged and len(b) < MIN_QUESTS:
            if bottom(b) - top(merged[-1]) <= 6:
                merged[-1].update(b)
            else:
                dropped += list(b.values())
        elif merged and len(merged[-1]) < MIN_QUESTS:
            merged[-1].update(b)
        else:
            merged.append(dict(b))
    return merged, dropped


_W = {}


def _init():
    _W["db"], _W["a2m"] = QuestieDB(), area_to_uimap()


def draft_zone(job):
    """One zone and faction -> [(level, file name, text, report row)]. Runs in a worker process."""
    m, name, faction, qids = job
    db, a2m = _W["db"], _W["a2m"]
    zone = Zone(db, m, faction, a2m, qids)
    if len(zone.quests) < MIN_QUESTS:
        return []
    core, outliers = split_outliers(zone.quests)
    parts, dropped = bands(core)
    outliers = outliers + dropped
    ids = [guide_id(name, faction, (k + 1) if len(parts) > 1 else None) for k in range(len(parts))]
    out = []
    for k, part in enumerate(parts):
        steps, left, levels = route(zone, part, presplit=True)
        if k == len(parts) - 1:
            left = left + outliers
        nxt = ids[k + 1] if k + 1 < len(parts) else None
        tier, _, rep = quest_tiers(zone, part, steps)
        text = render(zone, steps, left, levels, name, faction, ids[k], nxt, tier)
        fname = f"{re.sub(r'[^A-Za-z0-9]+', '', name)}_{faction}" + (f"_{k + 1}" if len(parts) > 1 else "") + ".lua"
        nocoord = sum(1 for v, q in steps if (v == "complete" and not q["obj"]) or
                      (v != "complete" and not (q["start"] if v == "accept" else q["finish"])))
        travel, _ = stats(zone, steps)
        gain = lambda mode: rep[mode][0] / rep[mode][1] if rep[mode][1] else 1
        row = (name + (" *" if m in NEW_ZONES else ""), faction, f"{levels[0]}-{levels[1]}", len(part), len(steps),
               nocoord, len(left), travel, area_changes(zone, steps), gain("efficient"), gain("fastest"), rep["hours"],
               sum(1 for q in part.values() if q.get("group")))
        out.append((levels[0], fname, text, row))
    return out


def main():
    t0 = time.time()
    db = QuestieDB()
    a2m = area_to_uimap()
    names = map_names()
    index = {}
    for q in db.ids("Quest-"):
        z = db.quest(q, "zoneOrSort")
        m = a2m.get(z) if z and z > 0 else None
        if m:
            index.setdefault(m, []).append(q)

    jobs = []
    for m in sorted(index, key=lambda m: names.get(m, "")):
        name = names.get(m)
        if not name or "dungeon" in name.lower() or m in BATTLEGROUNDS or m in CAPITALS:
            continue
        for faction in ("Alliance", "Horde"):
            jobs.append((m, name, faction, index[m]))
    # biggest zones first so the pool finishes evenly
    jobs.sort(key=lambda j: -len(j[3]))
    with multiprocessing.Pool(max(1, (os.cpu_count() or 2) - 1), initializer=_init) as pool:
        results = pool.map(draft_zone, jobs, chunksize=1)
    order = {(j[0], j[2]): k for k, j in enumerate(sorted(jobs, key=lambda j: (names.get(j[0], ""), j[2])))}
    results = [r for _, r in sorted(zip(jobs, results), key=lambda p: order[(p[0][0], p[0][2])])]

    DRAFT.mkdir(parents=True, exist_ok=True)
    for old in DRAFT.glob("*.lua"):
        old.unlink()
    for old in GUIDES.glob("Riverglades_*.lua"):      # superseded single-zone drafts
        old.unlink()
    files, rows = [], []
    for res in results:
        for lvl, fname, text, row in res:
            (DRAFT / fname).write_text(text, encoding="utf-8")
            files.append((lvl, fname))
            rows.append(row)

    xml = ['<Ui xmlns="http://www.blizzard.com/wow/ui/">',
           "    <!-- GENERATED by tools/draft_all.py from Questie's Forever database (GPL-3.0). -->",
           "    <!-- Hand-written or played guides go above the generated block. -->"]
    for _, f in sorted(files):
        xml.append(f'    <Script file="Draft\\{f}"/>')
    xml.append("</Ui>")
    (GUIDES / "Guides.xml").write_text("\n".join(xml) + "\n", encoding="utf-8")

    print(f"{'zone':28} {'faction':9} {'levels':7} {'quests':>6} {'steps':>6} {'nopin':>6} {'left':>5} {'travel':>7} {'back':>5}"
          f" {'group':>5} {'hours':>5} {'eff xp/h':>8} {'fast xp/h':>9}")
    for r in rows:
        print(f"{r[0]:28} {r[1]:9} {r[2]:7} {r[3]:6} {r[4]:6} {r[5]:6} {r[6]:5} {r[7]:7.0f} {r[8]:5}"
              f" {r[12]:5} {r[11]:5.1f} {r[9]:7.2f}x {r[10]:8.2f}x")
    hours = sum(r[11] for r in rows)
    print(f"{len(files)} guides, {sum(r[3] for r in rows)} quests, {sum(r[4] for r in rows)} steps, "
          f"{sum(r[5] for r in rows)} without pin, {sum(r[6] for r in rows)} not routed; "
          f"~{hours:.0f} h of questing at 'all'; {time.time() - t0:.0f}s")


if __name__ == "__main__":
    main()
