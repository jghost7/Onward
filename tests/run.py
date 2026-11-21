"""Run Onward headless under Lua 5.1 (lupa) with the WoW API mock. Exit code = failures."""
import pathlib
import re
import sys

from lupa import lua51

ROOT = pathlib.Path(__file__).resolve().parent.parent
ADDON = ROOT / "Onward"


def toc_files():
    xmls = []
    for line in (ADDON / "Onward.toc").read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#") and line.endswith(".lua"):
            yield ADDON / line.replace("\\", "/")
        elif line.endswith(".xml") and "Guides" in line:
            xmls.append(ADDON / line.replace("\\", "/"))
    for path in xmls:
        xml = re.sub(r"<!--.*?-->", "", path.read_text(encoding="utf-8"), flags=re.S)
        for name in re.findall(r'<Script file="([^"]+)"', xml):
            yield path.parent / name.replace("\\", "/")


STEP = re.compile(r"^(accept|complete|turnin)\s+(\d+)")


def lint_guides():
    """Check every quest guide's steps against what the step engine assumes (Guide.lua):
    a quest's steps run accept -> complete(s) -> turn-in, carry the same filter tags (or one of them
    is filtered out and leaves the others stranded), an accept comes after the turn-in of its
    prerequisites (both |pre and local |preany) in the same guide, filter modes never strand a
    prerequisite, the quest log never exceeds 20 held quests, no level-0 promo quests appear, and
    no quest is accepted by two guides of one faction or depends on a later band of the same zone.
    Returns the problems as text lines."""
    bad, accepted_by, turned_in_by = [], {}, {}
    guide_records = []
    for path in toc_files():
        text = path.read_text(encoding="utf-8")
        if "Onward:RegisterGuide" not in text or 'kind = "profession"' in text:
            continue
        for gid, faction_body in re.findall(r'RegisterGuide\{\s*id\s*=\s*"([^"]+)"(.*?)\]\]', text, flags=re.S):
            faction = (re.search(r'faction\s*=\s*"([^"]*)"', faction_body) or [0, ""])[1]
            body = faction_body.split("[[", 1)[1] if "[[" in faction_body else ""
            pos, tags, pre, preany = {}, {}, {}, {}
            q_val, q_grp = {}, {}
            log_q, max_log = set(), 0
            for n, raw in enumerate(body.splitlines()):
                line = re.sub(r"\s+--.*$", "", raw.strip())
                m = STEP.match(line)
                if not m:
                    continue
                verb, q = m.group(1), int(m.group(2))
                opts = dict((o.strip().split(" ", 1) + [""])[:2] for o in line.split("|")[1:])
                at = pos.setdefault(q, {})
                if verb == "complete":
                    at["complete_first"] = min(at.get("complete_first", n), n)
                    at["complete_last"] = max(at.get("complete_last", n), n)
                else:
                    at.setdefault(verb, n)
                tags.setdefault(q, set()).add(tuple(opts.get(k) for k in ("value", "group", "class", "race")))
                q_val[q] = opts.get("value") or "core"
                q_grp[q] = opts.get("group") or ""
                if verb == "accept":
                    if re.search(r"\(0\)\s*$", raw):
                        bad.append(f"{gid}: level-0 quest {q}")
                    pre[q] = [int(x) for x in re.findall(r"\d+", opts.get("pre", ""))]
                    preany[q] = [int(x) for x in re.findall(r"\d+", opts.get("preany", ""))]
                    other = accepted_by.setdefault((faction, q), gid)
                    if other != gid:
                        bad.append(f"{gid}: quest {q} is also accepted by {other}")
                    log_q.add(q)
                    if len(log_q) > max_log:
                        max_log = len(log_q)
                elif verb == "turnin":
                    turned_in_by[(faction, q)] = gid
                    log_q.discard(q)
            if max_log > 20:
                bad.append(f"{gid}: holds up to {max_log} quests in the log at once (limit 20)")
            rank = {"core": 0, "mid": 1, "low": 2}
            for q, at in pos.items():
                a, cf, cl, t = at.get("accept"), at.get("complete_first"), at.get("complete_last"), at.get("turnin")
                if a is not None and cf is not None and cf < a:
                    bad.append(f"{gid}: complete {q} comes before its accept")
                if a is not None and t is not None and t < a:
                    bad.append(f"{gid}: turnin {q} comes before its accept")
                if cl is not None and t is not None and t < cl:
                    bad.append(f"{gid}: turnin {q} comes before its complete")
                if len(tags[q]) > 1:
                    bad.append(f"{gid}: steps of quest {q} carry different value/group/class/race tags")
                for p in pre.get(q, []):
                    pt = pos.get(p, {}).get("turnin")
                    if a is not None and pt is not None:
                        if pt > a:
                            bad.append(f"{gid}: accept {q} comes before the turn-in of its prerequisite {p}")
                        if rank[q_val[p]] > rank[q_val[q]]:
                            bad.append(f"{gid}: quest {q} ({q_val[q]}) depends on lower-value prerequisite {p} ({q_val[p]})")
                        if not q_grp[q] and q_grp[p]:
                            bad.append(f"{gid}: solo quest {q} depends on group prerequisite {p} ({q_grp[p]})")
                local_any = [p for p in preany.get(q, []) if pos.get(p, {}).get("turnin") is not None]
                if a is not None and local_any:
                    if all(pos[p]["turnin"] > a for p in local_any):
                        bad.append(f"{gid}: accept {q} comes before all local |preany turn-ins {local_any}")
                    if all(rank[q_val[p]] > rank[q_val[q]] for p in local_any):
                        bad.append(f"{gid}: quest {q} ({q_val[q]}) has all local |preany {local_any} dropped in stricter mode")
                    if not q_grp[q] and all(q_grp[p] for p in local_any):
                        bad.append(f"{gid}: solo quest {q} has all local |preany {local_any} marked group")
            guide_records.append((gid, faction, pre, preany, pos))
    for gid, faction, pre, preany, pos in guide_records:
        base_g = gid.rsplit("-", 1)[0] if gid[-1].isdigit() and "-" in gid else None
        if not base_g:
            continue
        for q in pos:
            for p in pre.get(q, []):
                og = turned_in_by.get((faction, p))
                if og and og.rsplit("-", 1)[0] == base_g and og > gid:
                    bad.append(f"{gid}: quest {q} depends on {p} in later band {og}")
            pa = preany.get(q, [])
            if pa and not any(pos.get(p, {}).get("turnin") is not None for p in pa):
                ogs = [turned_in_by.get((faction, p)) for p in pa if turned_in_by.get((faction, p))]
                if ogs and all(og.rsplit("-", 1)[0] == base_g and og > gid for og in ogs):
                    bad.append(f"{gid}: quest {q} |preany {pa} lives in later band {ogs}")
    return bad


def main():
    problems = lint_guides()
    for line in problems[:40]:
        print("FAIL guide", line)
    if len(problems) > 40:
        print(f"FAIL guide ... and {len(problems) - 40} more")
    print(f"guide check: {len(problems)} problems")
    lua = lua51.LuaRuntime(unpack_returned_tuples=True)
    run = lua.eval("function(path, ...) local f, err = loadfile(path) if not f then error(err) end return f(...) end")
    run(str(ROOT / "tests" / "wowmock.lua"))
    ns = lua.table()
    before = set(lua.globals().keys())
    for path in toc_files():
        run(str(path), "Onward", ns)
    # globals the addon may create; anything else is a leaked local (a typo or a local declared
    # after the code that uses it, like the guide list's tab state in 0.2.1)
    allowed = re.compile(r"^(Onward\w*|SLASH_\w+|BINDING_.+)$")
    leaked = sorted(k for k in lua.globals().keys() if k not in before and not allowed.match(str(k)))
    try:
        failures = run(str(ROOT / "tests" / "test_onward.lua"))
    finally:
        mock = lua.globals().MOCK
        for line in (mock.fails or {}).values() if mock.fails else []:
            print(line)
        for line in mock.printed.values():
            if line.startswith(("FAIL", "parsed")) or "passed" in line or "Onward" in line:
                print(line)
        for err in mock.errors.values():
            print("ERROR", err)
    leaked += sorted(k for k in lua.globals().keys() if k not in before and k not in leaked
                     and not allowed.match(str(k)) and not str(k).startswith("MOCK"))
    if leaked:
        print("FAIL globals leaked by the addon:", ", ".join(map(str, leaked)))
    return int(failures or 0) + len(leaked) + len(problems)


if __name__ == "__main__":
    sys.exit(main())
