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
    a quest's steps run accept -> complete -> turn-in, carry the same filter tags (or one of them
    is filtered out and leaves the others stranded), an accept comes after the turn-in of a
    prerequisite the same guide holds, and no quest is accepted by two guides of one faction.
    Returns the problems as text lines."""
    bad, accepted_by = [], {}
    for path in toc_files():
        text = path.read_text(encoding="utf-8")
        if "Onward:RegisterGuide" not in text or 'kind = "profession"' in text:
            continue
        for gid, faction_body in re.findall(r'RegisterGuide\{\s*id\s*=\s*"([^"]+)"(.*?)\]\]', text, flags=re.S):
            faction = (re.search(r'faction\s*=\s*"([^"]*)"', faction_body) or [0, ""])[1]
            body = faction_body.split("[[", 1)[1] if "[[" in faction_body else ""
            pos, tags, pre = {}, {}, {}
            for n, raw in enumerate(body.splitlines()):
                line = re.sub(r"\s+--.*$", "", raw.strip())
                m = STEP.match(line)
                if not m:
                    continue
                verb, q = m.group(1), int(m.group(2))
                opts = dict((o.strip().split(" ", 1) + [""])[:2] for o in line.split("|")[1:])
                pos.setdefault(q, {}).setdefault(verb, n)
                tags.setdefault(q, set()).add(tuple(opts.get(k) for k in ("value", "group", "class", "race")))
                if verb == "accept":
                    pre[q] = [int(x) for x in re.findall(r"\d+", opts.get("pre", ""))]
                    other = accepted_by.setdefault((faction, q), gid)
                    if other != gid:
                        bad.append(f"{gid}: quest {q} is also accepted by {other}")
            for q, at in pos.items():
                a, c, t = at.get("accept"), at.get("complete"), at.get("turnin")
                if a is not None and c is not None and c < a:
                    bad.append(f"{gid}: complete {q} comes before its accept")
                if a is not None and t is not None and t < a:
                    bad.append(f"{gid}: turnin {q} comes before its accept")
                if c is not None and t is not None and t < c:
                    bad.append(f"{gid}: turnin {q} comes before its complete")
                if len(tags[q]) > 1:
                    bad.append(f"{gid}: steps of quest {q} carry different value/group/class/race tags")
                for p in pre.get(q, []):
                    pt = pos.get(p, {}).get("turnin")
                    if a is not None and pt is not None and pt > a:
                        bad.append(f"{gid}: accept {q} comes before the turn-in of its prerequisite {p}")
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
