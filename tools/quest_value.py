"""Quest value: XP per minute for every quest in a route, and which quests each mode keeps.

XP      Questie's classic XP table (QuestXP/xpDB-classic.lua), overridden by its Forever traces
        (xpDB-traces.lua: XP measured from ~1M real player sessions). Quests with neither get the
        median XP of known quests of the same level.
Time    = extra travel the quest adds to the finished route (route length with its steps minus
        without them) + objective work + talking. Objective work reads the counts from the quest
        text ("Kill 10 ...", "Bring 8 ..."): kills ~22s each, item drops ~1.7 kills per item,
        objects ~15s, exploring ~20s. Deliveries and talk quests cost only their travel.
Modes   all       every quest
        efficient drops quests under half the zone's median XP/min
        fastest   drops quests under 80% of the median
Chains  a quest is kept when it pays for itself, or when it unlocks kept follow-ups and the chain
        together (prerequisites + follow-up) clears the bar. A kept quest always keeps its
        prerequisites, so routes stay valid.
"""
import math
import re
from statistics import median

from questiedb import FOREVER, lua_list

YARDS_PER_UNIT = 35          # map unit (1% of a zone's width) in yards, typical classic zone
KILL_S, OBJECT_S, EXPLORE_S, TALK_S = 22, 15, 20, 12
DROP_FACTOR = 1.7            # kills per quest item from a creature
THRESHOLDS = {"efficient": 0.5, "fastest": 0.75}   # share of the zone's median XP/min
MIN_XP_SHARE = {"efficient": 0.85, "fastest": 0.60}  # never leave more XP than this behind
CHEAP_S = 120                                         # quests under 2 min are always kept

_XP = None


def load_xp():
    global _XP
    if _XP is None:
        _XP = {}
        base = FOREVER / "QuestieDB" / "support" / "Forever" / "QuestXP"
        for name in ("xpDB-classic.lua", "xpDB-traces.lua"):          # traces win
            text = (base / name).read_text(encoding="utf-8")
            for q, lvl, xp in re.findall(r"\[(\d+)\]\s*=\s*\{\s*(\d+)\s*,\s*(\d+)\s*\}", text):
                _XP[int(q)] = (int(lvl), int(xp))
    return _XP


def xp_for(q, level, _by_level={}):
    xp = load_xp()
    if q in xp:
        return xp[q][1], True
    if not _by_level:
        groups = {}
        for lvl, v in xp.values():
            groups.setdefault(lvl, []).append(v)
        _by_level.update({lvl: median(v) for lvl, v in groups.items()})
    near = min(_by_level, key=lambda l: abs(l - (level or 1)))
    return _by_level[near], False


def run_speed(level):
    return 11.0 if (level or 0) >= 40 else 7.0      # yd/s: mounted from 40


def mob_xp(level):
    """classic XP for killing a same-level mob"""
    return 45 + 5 * max(1, level or 1)


def objective_seconds(db, qid):
    """(seconds of objective work, number of kills it takes)"""
    q_obj = db.quest(qid, "objectives")
    if not q_obj and not db.quest(qid, "triggerEnd"):
        return 0.0, 0
    groups = q_obj if isinstance(q_obj, dict) else dict(enumerate(lua_list(q_obj), 1))
    text = " ".join(t.decode("utf-8", "replace") if isinstance(t, bytes) else (t or "")
                    for t in lua_list(db.quest(qid, "objectivesText")))
    # "Kill 10 Kobold Vermin", "Bring 8 pieces", "8 Farholde Priests and 12 Farholde Scouts";
    # never "Page 4", "Chapter 2" or a list like "Pages 18, 20, 21 and 24"
    counts = [min(int(n), 30) for n in re.findall(
        r"(?<![Pp]age )(?<![Pp]ages )(?<!Chapter )(?<!, )\b(\d{1,2})\s+(?!and\b|or\b)[A-Za-z]", text)]
    source_item = db.quest(qid, "sourceItemId")
    secs, kills = 0.0, 0.0
    k = 0

    def take():
        nonlocal k
        c = counts[k] if k < len(counts) else 1
        k += 1
        return c

    for _ in lua_list(groups.get(1)):                    # creatures
        n = take()
        secs += n * KILL_S
        kills += n
    for _ in lua_list(groups.get(2)):                    # objects
        secs += take() * OBJECT_S
    for e in lua_list(groups.get(3)):                    # items
        item = lua_list(e)[0]
        if item == source_item:                          # delivering the item you were given
            continue
        n = take()
        if db.field("Item-", item, 2):                   # npcDrops: kill for it
            secs += n * KILL_S * DROP_FACTOR
            kills += n * DROP_FACTOR
        else:
            secs += n * OBJECT_S
    for _ in lua_list(groups.get(5)):                    # kill credit
        n = take()
        secs += n * KILL_S
        kills += n
    if db.quest(qid, "triggerEnd"):
        secs += EXPLORE_S
    return secs, kills


def marginal_travel(zone, steps):
    """{questId: map units of route travel that disappear when the quest's steps are removed}"""
    from draft_guide import step_xy, dist
    pts, owners = [], []
    last = None
    for v, q in steps:
        p = step_xy(zone, v, q) or last
        pts.append(p)
        owners.append(q["id"])
        last = p
    first = next((p for p in pts if p), (50.0, 50.0))
    pts = [p or first for p in pts]

    def total(idx):
        return sum(dist(pts[a], pts[b]) for a, b in zip(idx, idx[1:]))

    full = list(range(len(pts)))
    base = total(full)
    out = {}
    for qid in set(owners):
        keep = [i for i in full if owners[i] != qid]
        out[qid] = max(0.0, base - total(keep))
    return out


def score(zone, Q, steps):
    """{questId: {xp, normXp, measured, seconds, rate, normRate}}.
    `normXp` scales XP against the expected XP of a quest at that same level, so level 1-4
    starter quests in a 1-12 zone aren't penalized for paying less raw XP than level 10 quests."""
    travel = marginal_travel(zone, steps)
    out = {}
    for qid, q in Q.items():
        quest_xp, measured = xp_for(qid, q["level"])
        base_xp, _ = xp_for(-1, q["level"])
        work, kills = objective_seconds(zone.db, qid)
        secs = travel.get(qid, 0.0) * YARDS_PER_UNIT / run_speed(q["level"]) + work + 2 * TALK_S
        xp = quest_xp + kills * mob_xp(q["level"])        # the kills pay XP too
        norm_xp = xp / max(1.0, base_xp)
        mins = secs / 60.0
        out[qid] = {"xp": xp, "normXp": norm_xp, "questXp": quest_xp, "measured": measured,
                    "seconds": secs, "rate": xp / mins, "normRate": norm_xp / mins}
    return out


def select(Q, scores, mode):
    """Set of quest ids kept in `mode`."""
    if mode == "all" or not Q:
        return set(Q)
    total_xp = sum(s["normXp"] for s in scores.values()) or 1
    solo = {qid for qid, q in Q.items() if not q.get("group")}
    solo_xp = sum(scores[qid]["normXp"] for qid in solo)
    # Compute the median rate over solo quests when available so heavy-elite zones don't skew solo selection
    rate_pool = [scores[qid]["normRate"] for qid in solo] if len(solo) >= 5 else [s["normRate"] for s in scores.values()]
    bar = THRESHOLDS[mode] * median(rate_pool)
    for _ in range(30):                     # lower the bar until enough of the zone's XP (and solo XP) is kept
        keep = _select(Q, scores, bar)
        ok_all = sum(scores[q]["normXp"] for q in keep) / total_xp >= MIN_XP_SHARE[mode]
        ok_solo = not solo_xp or (sum(scores[q]["normXp"] for q in keep if q in solo) / solo_xp >= MIN_XP_SHARE[mode])
        if ok_all and ok_solo:
            return keep
        bar *= 0.9
    return keep


def _select(Q, scores, bar):
    parents = {qid: [p for p in q["preAll"] if p in Q] for qid, q in Q.items()}
    any_of = {qid: [p for p in q["preAny"] if p in Q] for qid, q in Q.items()}

    def needed(qid, seen=None):
        """prerequisites (in this zone) a quest needs: all of preAll, the best of preAny, recursively"""
        seen = seen if seen is not None else set()
        out = []
        for p in parents[qid]:
            if p not in seen:
                seen.add(p)
                out += [p] + needed(p, seen)
        if any_of[qid] and not any(p in seen for p in any_of[qid]):
            p = max(any_of[qid], key=lambda p: scores[p]["normRate"])
            seen.add(p)
            out += [p] + needed(p, seen)
        return out

    keep = set()
    for qid in sorted(Q, key=lambda i: -scores[i]["normRate"]):
        if qid in keep:
            continue
        chain = [qid] + [p for p in needed(qid) if p not in keep]
        nxp = sum(scores[c]["normXp"] for c in chain)
        secs = sum(scores[c]["seconds"] for c in chain)
        if secs <= CHEAP_S or nxp / (secs / 60.0) >= bar:
            keep.update(chain)
    return keep


def tiers(zone, Q, steps):
    """{questId: 0 always | 1 dropped in fastest | 2 dropped in efficient and fastest}, scores, report"""
    sc = score(zone, Q, steps)
    fast = select(Q, sc, "fastest")
    eff = select(Q, sc, "efficient") | fast
    tier = {qid: 0 if qid in fast else (1 if qid in eff else 2) for qid in Q}
    total_xp = sum(s["xp"] for s in sc.values()) or 1
    total_s = sum(s["seconds"] for s in sc.values()) or 1

    def summary(kept):
        return (sum(sc[q]["xp"] for q in kept) / total_xp, sum(sc[q]["seconds"] for q in kept) / total_s, len(kept))
    report = {"all": (1.0, 1.0, len(Q)), "efficient": summary(eff), "fastest": summary(fast),
              "measured": sum(1 for s in sc.values() if s["measured"]) / max(1, len(sc)),
              "hours": total_s / 3600}
    return tier, sc, report
