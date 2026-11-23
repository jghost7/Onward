"""Download the official Lucide SVGs (ISC license) used by tools/make_media.py into tools/data/lucide/."""
import pathlib
import urllib.error
import urllib.request

OUT = pathlib.Path(__file__).resolve().parent / "data" / "lucide"
BASE = "https://raw.githubusercontent.com/lucide-icons/lucide/main/icons"

ICONS = [
    "settings",
    "chevron-right",
    "chevron-left",
    "chevron-up",
    "chevron-down",
    "list",
    "navigation",
    "crosshair",
    "target",
    "map-pin",
    "feather",
    "arrow-up",
    "info",
    "user",
    "message-circle-more",
    "message-circle",
    "circle-alert",
    "circle-question-mark",
    "circle-check",
]


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for name in ICONS:
        url = f"{BASE}/{name}.svg"
        try:
            with urllib.request.urlopen(url, timeout=15) as r:
                data = r.read()
            (OUT / f"{name}.svg").write_bytes(data)
            print("ok:", name)
        except urllib.error.HTTPError as e:
            print("skip:", name, e.code)
    # Also grab LICENSE for provenance
    with urllib.request.urlopen("https://raw.githubusercontent.com/lucide-icons/lucide/main/LICENSE", timeout=15) as r:
        (OUT / "LICENSE").write_bytes(r.read())
    print("done ->", OUT)


if __name__ == "__main__":
    main()
