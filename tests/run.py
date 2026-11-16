"""Run Sloppy Questing headless under Lua 5.1 (lupa) with the WoW API mock. Exit code = failures."""
import pathlib
import re
import sys

from lupa import lua51

ROOT = pathlib.Path(__file__).resolve().parent.parent
ADDON = ROOT / "SloppyQuesting"


def toc_files():
    xmls = []
    for line in (ADDON / "SloppyQuesting.toc").read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#") and line.endswith(".lua"):
            yield ADDON / line.replace("\\", "/")
        elif line.endswith(".xml") and "Guides" in line:
            xmls.append(ADDON / line.replace("\\", "/"))
    for path in xmls:
        xml = re.sub(r"<!--.*?-->", "", path.read_text(encoding="utf-8"), flags=re.S)
        for name in re.findall(r'<Script file="([^"]+)"', xml):
            yield path.parent / name.replace("\\", "/")


def main():
    lua = lua51.LuaRuntime(unpack_returned_tuples=True)
    run = lua.eval("function(path, ...) local f, err = loadfile(path) if not f then error(err) end return f(...) end")
    run(str(ROOT / "tests" / "wowmock.lua"))
    ns = lua.table()
    before = set(lua.globals().keys())
    for path in toc_files():
        run(str(path), "SloppyQuesting", ns)
    # globals the addon may create; anything else is a leaked local (a typo or a local declared
    # after the code that uses it, like the guide list's tab state in 0.2.1)
    allowed = re.compile(r"^(SloppyQuesting\w*|SLASH_\w+|BINDING_.+)$")
    leaked = sorted(k for k in lua.globals().keys() if k not in before and not allowed.match(str(k)))
    try:
        failures = run(str(ROOT / "tests" / "test_sloppyquesting.lua"))
    finally:
        mock = lua.globals().MOCK
        for line in (mock.fails or {}).values() if mock.fails else []:
            print(line)
        for line in mock.printed.values():
            if line.startswith(("FAIL", "parsed")) or "passed" in line or "Sloppy Questing" in line:
                print(line)
        for err in mock.errors.values():
            print("ERROR", err)
    leaked += sorted(k for k in lua.globals().keys() if k not in before and k not in leaked
                     and not allowed.match(str(k)) and not str(k).startswith("MOCK"))
    if leaked:
        print("FAIL globals leaked by the addon:", ", ".join(map(str, leaked)))
    return int(failures or 0) + len(leaked)


if __name__ == "__main__":
    sys.exit(main())
