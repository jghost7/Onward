"""Build a CurseForge-ready zip of the addon.

    python tools/package.py                 # package the current version
    python tools/package.py --bump patch    # 0.1.0 -> 0.1.1, then package (also: minor, major)
    python tools/package.py --version 0.2.0
    python tools/package.py --skip-tests    # not recommended

Steps: run the headless tests (a failure stops the build), write the version into
Onward.toc (the only place it lives; Core.lua reads it in game), make sure CHANGELOG.md has
an entry for it, zip the addon as dist/Onward-<version>.zip with a single top-level
Onward/ folder, then reopen the zip and check every file the TOC and Guides.xml load is in it.
An existing zip for the same version is never overwritten (bump the version instead).
"""
import argparse
import pathlib
import re
import subprocess
import sys
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
ADDON = ROOT / "Onward"
TOC = ADDON / "Onward.toc"
CHANGELOG = ADDON / "CHANGELOG.md"
DIST = ROOT / "dist"
SHIP = {".lua", ".toc", ".xml", ".tga", ".blp", ".txt", ".md", ".ttf"}
REQUIRED = ["Onward.toc", "LICENSE.txt", "CREDITS.txt", "Bindings.xml"]


def fail(msg):
    print("PACKAGE FAILED:", msg)
    sys.exit(1)


def current_version(text):
    m = re.search(r"^## Version:\s*(\S+)\s*$", text, re.M)
    if not m:
        fail("Onward.toc has no '## Version:' line")
    return m.group(1)


def bumped(version, part):
    nums = [int(n) for n in version.split(".")]
    while len(nums) < 3:
        nums.append(0)
    i = {"major": 0, "minor": 1, "patch": 2}[part]
    nums[i] += 1
    for j in range(i + 1, 3):
        nums[j] = 0
    return ".".join(map(str, nums))


def run_tests():
    print("running tests ...")
    r = subprocess.run([sys.executable, str(ROOT / "tests" / "run.py")], capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    tail = (r.stdout + r.stderr).strip().splitlines()[-6:]
    print("  " + "\n  ".join(tail))
    if r.returncode != 0:
        fail("tests failed (fix them, or --skip-tests if you really mean it)")


def loaded_files():
    """every file the game loads: TOC entries, plus the guide scripts listed in Guides.xml"""
    out = []
    for line in TOC.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            out.append(line.replace("\\", "/"))
    for xml in [f for f in out if f.endswith(".xml")]:
        text = re.sub(r"<!--.*?-->", "", (ADDON / xml).read_text(encoding="utf-8"), flags=re.S)
        base = str(pathlib.PurePosixPath(xml).parent)
        for name in re.findall(r'<(?:Script|Include) file="([^"]+)"', text):
            out.append(str(pathlib.PurePosixPath(base) / name.replace("\\", "/")))
    return out


def main():
    ap = argparse.ArgumentParser()
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--bump", choices=("patch", "minor", "major"))
    g.add_argument("--version")
    ap.add_argument("--skip-tests", action="store_true")
    a = ap.parse_args()

    toc_text = TOC.read_text(encoding="utf-8")
    old = current_version(toc_text)
    new = a.version or (bumped(old, a.bump) if a.bump else old)
    if not re.fullmatch(r"\d+\.\d+\.\d+", new):
        fail(f"version '{new}' is not N.N.N")
    out = DIST / f"Onward-{new}.zip"
    if out.exists():
        fail(f"{out.name} already exists: bump the version (--bump patch) rather than replacing a shipped build")

    if not a.skip_tests:
        run_tests()

    if new != old:
        TOC.write_text(re.sub(r"^## Version:.*$", f"## Version: {new}", toc_text, count=1, flags=re.M), encoding="utf-8")
        print(f"version {old} -> {new} (Onward.toc)")

    log = CHANGELOG.read_text(encoding="utf-8")
    if not re.search(rf"^## {re.escape(new)}\b", log, re.M):
        log = re.sub(r"^(# Changelog\s*\n)", rf"\1\n## {new}\n\n- (write what changed here before uploading)\n", log, count=1)
        CHANGELOG.write_text(log, encoding="utf-8")
        print(f"WARNING: CHANGELOG.md had no '## {new}' entry; added an empty one. Fill it in before uploading,")
        print("         then delete the zip and run this again (CurseForge shows the changelog to players).")

    for name in REQUIRED:
        if not (ADDON / name).exists():
            fail(f"missing {name}")

    DIST.mkdir(exist_ok=True)
    files = sorted(p for p in ADDON.rglob("*") if p.is_file() and p.suffix.lower() in SHIP
                   and not any(part.startswith(".") for part in p.relative_to(ADDON).parts))
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as z:
        for p in files:
            z.write(p, "Onward/" + p.relative_to(ADDON).as_posix())

    # check the zip as a player would get it
    with zipfile.ZipFile(out) as z:
        names = set(z.namelist())
    tops = {n.split("/")[0] for n in names}
    missing = [f for f in REQUIRED + loaded_files() if f"Onward/{f}" not in names]
    if tops != {"Onward"} or missing:
        out.unlink()
        fail(f"zip check: top folders {sorted(tops)}, missing {missing[:5]}")
    with zipfile.ZipFile(out) as z:
        toc_in_zip = z.read("Onward/Onward.toc").decode("utf-8")
    if current_version(toc_in_zip) != new:
        out.unlink()
        fail("zip's TOC version does not match")

    print(f"\nwrote {out}  ({out.stat().st_size / 1024:.0f} KB, {len(names)} files, all {len(loaded_files())} loaded files present)")
    print("""
Upload on CurseForge (project > Files > Upload File):
  - File: the zip above
  - Release type: Beta for test builds, Release once it's proven
  - Game version: the WoW Forever version (interface 16001)
  - Changelog: paste this version's entry from Onward/CHANGELOG.md
  - Relations: Questie and TomTom as Optional Dependencies""")


if __name__ == "__main__":
    main()
