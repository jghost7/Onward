"""Turn your own screenshots into the zone pictures behind Onward's panel header.

In game: stand somewhere that looks like the zone, hide the UI (Alt+Z), take a screenshot
(Print Screen). Onward notes the zone and time of every screenshot (OnwardDB.shots). Then, with the
game closed or after /reload:

    python tools/make_zone_art.py --list           # which screenshots match which zone
    python tools/make_zone_art.py                  # newest screenshot per zone -> picture
    python tools/make_zone_art.py --map 2548 --file WoWScrnShot_111726_101500.jpg [--y 0.45]
    python tools/make_zone_art.py --map 2548 --remove

Each picture is a 512x64 band cut across the screenshot (centre at --y, 0 = top, 1 = bottom;
default 0.42, about the horizon), saved as Onward/media/zones/<uiMapID>.tga. Onward/ZoneShots.lua
lists the zones that have one; the panel shows it faded behind the header (Options > Panel >
Header art), and the zone map where there's none.
"""
import argparse
import datetime
import pathlib
import re
import sys
import time

from PIL import Image

ROOT = pathlib.Path(__file__).resolve().parent.parent
GAME = pathlib.Path(r"X:\World of Warcraft\_forever_")
SHOTS_DIR = GAME / "Screenshots"
OUT_DIR = ROOT / "Onward" / "media" / "zones"
LIST = ROOT / "Onward" / "ZoneShots.lua"
W, H = 512, 64
INK_MEAN = 48        # average brightness (0-255) of an ink strip before the panel's own fade
MATCH_S = 4          # a screenshot file is written within a few seconds of the event


def noted_shots():
    """[(epoch, map, zone, sub)] from every account's Onward saved variables."""
    out = []
    for sv in (GAME / "WTF" / "Account").glob("*/SavedVariables/Onward.lua"):
        text = sv.read_text(encoding="utf-8", errors="replace")
        m = re.search(r'\["shots"\]\s*=\s*\{(.*?)\n\t?\},?\s*\n', text, re.S)
        body = m.group(1) if m else ""
        for block in re.findall(r"\{(.*?)\}", body, re.S):
            t = re.search(r'\["t"\]\s*=\s*(\d+)', block)
            mp = re.search(r'\["map"\]\s*=\s*(\d+)', block)
            if t and mp:
                zone = re.search(r'\["zone"\]\s*=\s*"([^"]*)"', block)
                sub = re.search(r'\["sub"\]\s*=\s*"([^"]*)"', block)
                out.append((int(t.group(1)), int(mp.group(1)), zone and zone.group(1) or "", sub and sub.group(1) or ""))
    return sorted(set(out))


def screenshot_files():
    """[(epoch, path)]: WoWScrnShot_MMDDYY_HHMMSS.jpg is the local time it was taken."""
    out = []
    for p in SHOTS_DIR.glob("WoWScrnShot_*.*"):
        m = re.match(r"WoWScrnShot_(\d{6})_(\d{6})", p.stem)
        if not m:
            continue
        dt = datetime.datetime.strptime(m.group(1) + m.group(2), "%m%d%y%H%M%S")
        out.append((time.mktime(dt.timetuple()), p))
    return sorted(out)


def matches():
    """[(map, zone, sub, path, epoch)] for noted screenshots whose file is still there."""
    files = screenshot_files()
    out = []
    for t, mp, zone, sub in noted_shots():
        best = min(files, key=lambda f: abs(f[0] - t), default=None)
        if best and abs(best[0] - t) <= MATCH_S:
            out.append((mp, zone, sub, best[1], t))
    return out


def band(path, y):
    """The 8:1 band across a picture, centred at y (0 top, 1 bottom), as 512x64."""
    img = Image.open(path).convert("RGB")
    w, h = img.size
    left, right = int(w * 0.04), int(w * 0.96)
    bh = (right - left) // 8
    top = max(0, min(h - bh, int(h * y) - bh // 2))
    return img.crop((left, top, right, top + bh)).resize((W, H), Image.LANCZOS)


def make(path, mp, y):
    """A screenshot -> <map>.tga, shown as it is (faded) behind the header."""
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    out = OUT_DIR / f"{mp}.tga"
    band(path, y).save(out)
    return out


def make_ink(path, mp, y=0.5):
    """An ink-and-wash painting -> <map>_ink.tga: inverted to pale ink on black, which the panel
    draws additively, so the paper vanishes and only the brushwork shows on the dark glass."""
    from PIL import ImageOps
    from PIL import ImageStat
    s = ImageOps.autocontrast(ImageOps.invert(band(path, y).convert("L")), cutoff=1)
    # even out the strips: a dark painting (ash clouds) inverts to a bright band, so scale every
    # strip to the same average brightness and they all sit equally faint behind the header
    mean = ImageStat.Stat(s).mean[0] or 1
    k = min(1.0, INK_MEAN / mean)
    s = s.point(lambda v: int(v * k))
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    out = OUT_DIR / f"{mp}_ink.tga"
    Image.merge("RGB", (s, s, s)).save(out)   # grey: the header art never adds colour behind text
    return out


def write_list():
    """Onward/ZoneShots.lua: [map] = "shot" (<map>.tga, a screenshot: wins) or "ink" (<map>_ink.tga,
    a generated painting, tools/gen_zone_art.py)."""
    kinds = {}
    for p in OUT_DIR.glob("*.tga"):
        if p.stem.isdigit():
            kinds[int(p.stem)] = "shot"
        elif p.stem.endswith("_ink") and p.stem[:-4].isdigit():
            kinds.setdefault(int(p.stem[:-4]), "ink")
    lines = ["-- GENERATED by tools/make_zone_art.py: zones with a header picture in media/zones/:",
             '-- "shot" = <map>.tga from a screenshot, "ink" = <map>_ink.tga, a generated ink painting.',
             "local _, W = ...", "W.ZoneShots = {"]
    lines += [f'  [{m}] = "{kinds[m]}",' for m in sorted(kinds)]
    lines.append("}")
    LIST.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")
    return sorted(kinds)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--map", type=int)
    ap.add_argument("--file")
    ap.add_argument("--y", type=float, default=0.42)
    ap.add_argument("--remove", action="store_true")
    a = ap.parse_args()

    if a.remove:
        if not a.map:
            sys.exit("--remove needs --map")
        (OUT_DIR / f"{a.map}.tga").unlink(missing_ok=True)
        print("zones with a picture:", write_list())
        return
    if a.file:
        if not a.map:
            sys.exit("--file needs --map (the zone's uiMapID)")
        path = pathlib.Path(a.file)
        if not path.is_absolute():
            path = SHOTS_DIR / path
        print("wrote", make(path, a.map, a.y))
        print("zones with a picture:", write_list())
        return

    found = matches()
    if a.list or not found:
        if not found:
            print("No screenshots noted by Onward yet: in game, hide the UI (Alt+Z), press Print Screen in a zone, then /reload.")
        for mp, zone, sub, path, _ in found:
            print(f"{mp:6}  {zone}{' / ' + sub if sub else ''}  {path.name}")
        return
    newest = {}
    for mp, zone, sub, path, t in found:
        if a.map and mp != a.map:
            continue
        if mp not in newest or t > newest[mp][1]:
            newest[mp] = (path, t, zone)
    for mp, (path, _, zone) in sorted(newest.items()):
        print(f"{zone or mp}: {path.name} -> {make(path, mp, a.y).name}")
    print("zones with a picture:", write_list())


if __name__ == "__main__":
    main()
