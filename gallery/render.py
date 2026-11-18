"""Render the Onward gallery cards (gallery.html) to 1920x1080 PNGs in gallery/out/.

    python gallery/render.py [card ...]

These are rendered mock-ups built from the addon's own colours and icons over blurred game scenery,
not game captures; swap in real captures as they come (see SHOTS.md).
"""
import functools
import http.server
import pathlib
import sys
import threading

from playwright.sync_api import sync_playwright

HERE = pathlib.Path(__file__).resolve().parent
CARDS = ["hero", "card", "travel", "picker", "looks", "party"]


def main():
    cards = sys.argv[1:] or CARDS
    out = HERE / "out"
    out.mkdir(exist_ok=True)
    # served over http: Chromium won't load CSS masks (the icons) from file:// pages
    handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(HERE))
    handler.log_message = lambda *a: None
    srv = http.server.ThreadingHTTPServer(("127.0.0.1", 0), handler)
    threading.Thread(target=srv.serve_forever, daemon=True).start()
    base = f"http://127.0.0.1:{srv.server_address[1]}/gallery.html"
    with sync_playwright() as p:
        b = p.chromium.launch()
        pg = b.new_page(viewport={"width": 1920, "height": 1080})
        for i, c in enumerate(cards):
            pg.goto(base + f"?c={c}")
            pg.wait_for_load_state("networkidle")
            pg.evaluate("document.fonts.ready")
            f = out / f"{CARDS.index(c) + 1:02d}-{c}.png"
            pg.screenshot(path=str(f))
            print("wrote", f)
        b.close()
    srv.shutdown()


if __name__ == "__main__":
    main()
