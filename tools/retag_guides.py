"""Rewrite the |class and |race tags of the generated zone guides in place, without re-routing.

    python retag_guides.py            dry run: what would change
    python retag_guides.py --write

Uses the same rule as draft_guide.Zone.who(): a quest's own race/class limits narrowed by its
prerequisites, with Forever's Skyborne races counted. Re-running draft_all.py would also apply it,
but it re-routes every zone from Questie's current data; this keeps the routes as they are.
Steps for quests no race or class of the guide's faction can get are removed.
"""
import argparse
import pathlib
import re

from questiedb import QuestieDB
from draft_guide import (ALL_CLASSES, ALLIANCE, CLASS_BITS, CLASSIC_ALLIANCE, CLASSIC_HORDE, HORDE, RACE_BITS,
                         SKYBORNE_ALLIANCE, SKYBORNE_HORDE, Zone, bits_to_tokens)

DRAFT = pathlib.Path(__file__).resolve().parent.parent / "SloppyQuesting" / "Guides" / "Draft"
STEP = re.compile(r"^(accept|complete|turnin) (\d+)")
TAG = re.compile(r" \|(class|race) [^|]*?(?=  -- | \||$)")


def judge(db, faction):
    z = Zone.__new__(Zone)
    z.db, z._who = db, {}
    alliance = faction == "Alliance"
    z.bit = ALLIANCE if alliance else HORDE
    z.classic = CLASSIC_ALLIANCE if alliance else CLASSIC_HORDE
    z.skyborne = SKYBORNE_ALLIANCE if alliance else SKYBORNE_HORDE
    return z


def tags(z, q):
    races, classes = z.who(q)
    if not (races and classes):
        return None
    out = ""
    if classes != ALL_CLASSES:
        out += " |class " + ",".join(bits_to_tokens(classes, CLASS_BITS))
    if races != z.bit:
        out += " |race " + ",".join(bits_to_tokens(races, RACE_BITS))
    return out


def retag(text, z):
    lines, changes = [], []
    for line in text.split("\n"):
        m = STEP.match(line)
        if not m:
            lines.append(line)
            continue
        new_tags = tags(z, int(m.group(2)))
        if new_tags is None:
            changes.append(("drop", line))
            continue
        body, sep, comment = line.partition("  -- ")
        body = TAG.sub("", body).rstrip() + new_tags
        new = body + (sep + comment if sep else "")
        if new != line:
            changes.append((line, new))
        lines.append(new)
    return "\n".join(lines), changes


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--write", action="store_true")
    a = ap.parse_args()
    db = QuestieDB()
    judges = {f: judge(db, f) for f in ("Alliance", "Horde")}
    total = 0
    for path in sorted(DRAFT.glob("*.lua")):
        faction = "Alliance" if "_Alliance" in path.name else "Horde"
        text = path.read_text(encoding="utf-8")
        new, changes = retag(text, judges[faction])
        for old, line in changes:
            print(f"{path.name}: {'DROP ' + line if old == 'drop' else line}")
        total += len(changes)
        if changes and a.write:
            path.write_text(new, encoding="utf-8")
    print(f"{total} step lines {'changed' if a.write else 'would change'}")


if __name__ == "__main__":
    main()
