"""Generate the ink-and-wash zone pictures behind Onward's panel header (Gemini image API).

    python tools/gen_zone_art.py 2548 1429        # these zones (uiMapIDs)
    python tools/gen_zone_art.py --all            # every zone below that has no picture yet
    python tools/gen_zone_art.py --all --redo     # every zone, replacing what's there

Each zone gets a short terrain description written for this tool (landscape only: no names of the
game, its places or characters go into a prompt). The model paints a wide panorama; the tool keeps
the raw image in tools/data/zone_art/<map>.png and cuts the same 512x64 band make_zone_art.py uses,
inverted to pale ink on black (drawn additively in game), into Onward/media/zones/<map>_ink.tga,
then rewrites Onward/ZoneShots.lua. A screenshot made with make_zone_art.py wins for its zone.

Key: env GEMINI_API_KEY (sent as a header, never printed).
"""
import base64
import json
import os
import pathlib
import sys
import urllib.error
import urllib.request

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import make_zone_art as Z  # noqa: E402

ROOT = pathlib.Path(__file__).resolve().parent.parent
RAW = ROOT / "tools" / "data" / "zone_art"
MODEL = "gemini-3.1-flash-image"

STYLE = ("Ink and wash painting of a very wide panoramic landscape: {desc}. Loose, confident brushwork, soft "
         "grey and sepia ink washes with only a faint muted tint of colour, generous mist and empty paper, the "
         "horizon across the middle of the picture, distant shapes fading into the paper. Quiet and atmospheric. "
         "No people, no animals in the foreground, no text, no letters, no seals or stamps, no signature, no frame "
         "or border, no logos.")

ZONES = {
    1416: "snow-covered alpine mountains, a ruined stone keep on a ridge, dark pine forest below",
    1417: "rolling grassy highlands, a ring of standing stones, broken fortress walls, a rocky sea coast",
    1440: "an ancient twilight forest of enormous trees, still pools, dusk light between the trunks",
    1447: "an autumn forest of red and orange trees above sea cliffs, toppled marble columns of an old civilisation",
    1418: "arid red rock canyons and flat-topped mesas, huge bleached bones half buried in dust",
    1419: "a scorched wasteland of cracked red earth, jagged rocks, a vast stone gateway on the horizon",
    1428: "volcanic plains under ash clouds, glowing lava rivers, a dark mountain fortress in the distance",
    1439: "a misty moonlit coastline, dark pines, ruined slender towers along the shore",
    1443: "a barren grey plateau, bone-strewn plains, a few hide tents, dust in the air",
    1426: "a snowy mountain valley, a great stone gate cut into the mountainside, snow-laden pines",
    1411: "a red rocky desert, dry canyons, spiked wooden huts, a hot hazy coastline",
    1431: "a dark gloomy forest under a pale moon, crooked bare trees, an old graveyard and a lone house",
    1445: "a misty marsh of reeds and mangroves, still water, a stone fortress on a small island",
    1423: "blighted farmland under a sickly sky, dead trees, ruined villages, drifting fog",
    1429: "green meadows and oak woods, farmhouses and a winding road, a white stone city far away",
    1448: "a corrupted forest of twisted trees, thick unhealthy fog, dark still pools",
    1444: "a lush rainforest of giant trees, tall waterfalls, overgrown ancient ruins",
    1424: "green hills and farmland, a wooden village by a river, snowy mountains behind",
    1432: "a wide mountain lake held back by a massive stone dam, pines and rolling hills",
    2482: "a sacred forested mountain, a colossal tree crowning the summit, mist in the valleys",
    1412: "golden grassy plains, tall flat-topped mesas, a tent village on a high plateau",
    1433: "red rocky mountains around a lake, a stone bridge, a small town of timber houses",
    2548: "a broad river winding through grassy plains and glades, wooden harbour piers, misty hills beyond",
    1427: "a smoking volcanic gorge, iron bridges over a deep pit, black rock and embers",
    2652: "moonlit ruins of an ancient elegant city overgrown by forest, broken arches and quiet pools",
    1451: "a desert of pale dunes, strange towering hive mounds and spires rising from the sand",
    1421: "a grey misty pine forest by a cold sea, a ruined keep on a hill",
    1442: "tall rocky peaks and deep canyons, a scarred hillside of felled trees",
    1434: "a dense jungle around a river, crumbling stone temple ruins, a sheltered pirate cove",
    1435: "a dark swamp of still water and hanging moss, a half sunken temple",
    1446: "vast golden desert dunes, a distant sea, a small walled trading town",
    1438: "a twilight forest beneath a colossal tree, graceful curved buildings among the roots",
    1413: "a dry savanna of tall yellow grass and flat-crowned trees, distant rocky ridges",
    1425: "rugged forested hills, eyries on high peaks, overgrown stone ruins",
    1441: "a vast canyon of tall thin rock needles rising from salt flats",
    1420: "gloomy autumn fields with dead trees, a ruined chapel, an overcast sky",
    1449: "a prehistoric jungle in a great crater, giant ferns, a smoking volcano, steaming springs",
    1422: "bleak abandoned farmland, ruined farmhouses, a lone tall tower, grey sky",
    1436: "golden wheat fields, abandoned farms with windmills, scarecrows, the sea beyond",
    1437: "marshy lowlands of mud and reeds, rocky crags, a stone harbour fortress",
    1452: "a snowy forest valley, frozen lakes, steam rising from hot springs",
    2521: "a floating island high above the clouds, windswept cliffs and grass, wind-bent trees",
}


def key():
    k = os.environ.get("GEMINI_API_KEY")
    if k:
        return k
    import winreg
    with winreg.OpenKey(winreg.HKEY_CURRENT_USER, "Environment") as h:
        return winreg.QueryValueEx(h, "GEMINI_API_KEY")[0]


def generate(prompt):
    body = {"contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {"responseModalities": ["IMAGE"], "imageConfig": {"aspectRatio": "21:9", "imageSize": "1K"}}}
    req = urllib.request.Request(
        f"https://generativelanguage.googleapis.com/v1beta/models/{MODEL}:generateContent",
        data=json.dumps(body).encode(), headers={"x-goog-api-key": key(), "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=300) as r:
            data = json.load(r)
    except urllib.error.HTTPError as e:
        sys.exit(f"HTTP {e.code}: {e.read().decode()[:600]}")
    for part in data["candidates"][0]["content"]["parts"]:
        if "inlineData" in part:
            return base64.b64decode(part["inlineData"]["data"])
    sys.exit(f"no image returned: {json.dumps(data)[:400]}")


def main(argv):
    redo = "--redo" in argv
    if "--all" in argv:
        maps = [m for m in ZONES if redo or not (Z.OUT_DIR / f"{m}_ink.tga").exists()]
    else:
        maps = [int(a) for a in argv if a.isdigit()]
    unknown = [m for m in maps if m not in ZONES]
    if unknown:
        sys.exit(f"no description for {unknown}")
    RAW.mkdir(parents=True, exist_ok=True)
    for m in maps:
        raw = RAW / f"{m}.png"
        if redo or not raw.exists():
            raw.write_bytes(generate(STYLE.format(desc=ZONES[m])))
        print(m, "->", Z.make_ink(raw, m).name)
    print("zones with a picture:", Z.write_list())


if __name__ == "__main__":
    main(sys.argv[1:])
