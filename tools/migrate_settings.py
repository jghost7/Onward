"""Carry Sloppy Questing settings over to Onward (the addon's name since 0.3.0).

    python tools/migrate_settings.py "X:\\World of Warcraft\\_forever_"            # dry run
    python tools/migrate_settings.py "X:\\World of Warcraft\\_forever_" --write    # do it

Run it with the game closed: WoW writes SavedVariables on logout, so a running client would
overwrite the result. For every SavedVariables\\SloppyQuesting.lua (account-wide and per
character) it writes Onward.lua next to it with the variables renamed. An existing Onward.lua is
never overwritten; the old files are left in place.
"""
import pathlib
import sys

RENAMES = [("SloppyQuestingCharDB", "OnwardCharDB"), ("SloppyQuestingDB", "OnwardDB")]


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    write = "--write" in sys.argv
    if not args:
        print(__doc__)
        return 1
    wtf = pathlib.Path(args[0]) / "WTF" / "Account"
    if not wtf.is_dir():
        print(f"no WTF\\Account folder under {args[0]}")
        return 1
    found = 0
    for old in sorted(wtf.rglob("SavedVariables/SloppyQuesting.lua")):
        found += 1
        new = old.with_name("Onward.lua")
        where = old.parent.relative_to(wtf)
        if new.exists():
            print(f"skip   {where}: Onward.lua already there")
            continue
        text = old.read_text(encoding="utf-8")
        for a, b in RENAMES:
            text = text.replace(a, b)
        if write:
            new.write_text(text, encoding="utf-8")
        print(f"{'wrote' if write else 'would write'}  {where}\\Onward.lua")
    if not found:
        print("no Sloppy Questing settings found")
    elif not write:
        print("dry run: add --write to copy them")
    return 0


if __name__ == "__main__":
    sys.exit(main())
