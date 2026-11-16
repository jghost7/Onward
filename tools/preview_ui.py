"""Mock-up of Onward's glass UI over a real game screenshot (design preview, not a game capture).

    python preview_ui.py <screenshot.jpg> <out.png>

Uses the addon's own textures and its colours, sizes and layout. Like the game, it does NOT blur
the background: it only stacks tint, grain, sheen and rim, which is what WoW can actually draw.
Fonts: Arial Narrow (the addon's body font); the headline font (Friz Quadrata) is approximated.
"""
import random
import sys
import pathlib

from PIL import Image, ImageDraw, ImageFilter, ImageFont

MEDIA = pathlib.Path(__file__).resolve().parent.parent / "Onward" / "media"
K = 2.0                                   # screen px per UI unit (4K at a typical UI scale)
TINT = (14, 17, 23)
ACCENT = (12, 210, 157)                  # Ellesmere green #0CD29D (flat theme default)
PANEL = (17, 18, 20)
THEME = "flat"
BORDER = (0, 0, 0, 255)
STRIP = (0, 0, 0, int(255 * 0.35))
TEXT, SUB, DIM = (237, 240, 245), (158, 166, 179), (115, 122, 133)
COL = {"accept": (255, 209, 64), "turnin": (102, 217, 115), "complete": (115, 179, 255), "fly": (191, 153, 255)}
BODY = r"C:\Windows\Fonts\ARIALN.TTF"
HEAD = r"C:\Windows\Fonts\georgiab.ttf"


def font(path, size):
    return ImageFont.truetype(path, int(size * K))


def glass(base, x, y, w, h, alpha=0.72, corner=12):
    x, y, w, h, r = [int(v * K) if i < 4 else int(v * K) for i, v in enumerate((x, y, w, h, corner))]
    # shadow
    sh = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle([x - 4, y + 6, x + w + 4, y + h + 14], radius=r + 6, fill=(0, 0, 0, int(255 * 0.45)))
    base.alpha_composite(sh.filter(ImageFilter.GaussianBlur(14 * K / 2)))
    mask = Image.new("L", base.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([x, y, x + w, y + h], radius=r, fill=255)
    # tint
    layer = Image.new("RGBA", base.size, TINT + (int(255 * alpha),))
    base.paste(Image.alpha_composite(base, layer), (0, 0), mask)
    # grain
    rnd = random.Random(3)
    g = Image.new("L", (w, h))
    g.putdata([rnd.randint(0, 255) for _ in range(w * h)])
    g = g.filter(ImageFilter.GaussianBlur(0.6)).point(lambda v: int(v * 0.035))
    white = Image.new("RGBA", (w, h), (255, 255, 255, 0))
    white.putalpha(g)
    gl = Image.new("RGBA", base.size, (0, 0, 0, 0))
    gl.paste(white, (x, y))
    base.paste(Image.alpha_composite(base, gl), (0, 0), mask)
    # sheen
    sheen = Image.new("RGBA", base.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(sheen)
    for i in range(int(46 * K)):
        a = int(255 * 0.06 * (1 - i / (46 * K)) ** 2.2)
        sd.line([(x, y + i), (x + w, y + i)], fill=(255, 255, 255, a))
    base.paste(Image.alpha_composite(base, sheen), (0, 0), mask)
    # rim + lit top edge
    rim = Image.new("RGBA", base.size, (0, 0, 0, 0))
    rd = ImageDraw.Draw(rim)
    rd.rounded_rectangle([x, y, x + w, y + h], radius=r, outline=(255, 255, 255, int(255 * 0.09)), width=max(1, int(K)))
    top = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ImageDraw.Draw(top).rounded_rectangle([x, y, x + w, y + h], radius=r, outline=(255, 255, 255, int(255 * 0.22)), width=max(1, int(K)))
    fade = Image.new("L", base.size, 0)
    fd = ImageDraw.Draw(fade)
    for i in range(int(h * 0.45)):
        fd.line([(x, y + i), (x + w, y + i)], fill=int(255 * (1 - i / (h * 0.45))))
    top.putalpha(Image.fromarray(__import__("numpy").minimum(__import__("numpy").array(top.getchannel("A")), __import__("numpy").array(fade))))
    base.alpha_composite(rim)
    base.alpha_composite(top)


def flatpanel(base, x, y, w, h, alpha=0.85, strip=0):
    """flat theme: solid body, darker title strip, 1px black border (square corners)"""
    x, y, w, h = [int(v * K) for v in (x, y, w, h)]
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.rectangle([x, y, x + w, y + h], fill=PANEL + (int(255 * alpha),))
    base.alpha_composite(layer)
    if strip:
        layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
        ImageDraw.Draw(layer).rectangle([x + 1, y + 1, x + w - 1, y + int(strip * K)], fill=STRIP)
        base.alpha_composite(layer)
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    ImageDraw.Draw(layer).rectangle([x, y, x + w, y + h], outline=BORDER, width=max(1, int(K)))
    base.alpha_composite(layer)


def surface(base, x, y, w, h, alpha=0.72, corner=12, strip=0):
    if THEME != "glass":
        flatpanel(base, x, y, w, h, 0.85 if alpha >= 0.7 else alpha + 0.2, strip)
    else:
        glass(base, x, y, w, h, alpha, corner)


def icon(base, name, cx, cy, size, color, alpha=1.0):
    im = Image.open(MEDIA / f"{name}.tga").convert("RGBA").resize((int(size * K), int(size * K)), Image.LANCZOS)
    r, g, b, a = im.split()
    tinted = Image.merge("RGBA", (r.point(lambda v: v * color[0] // 255), g.point(lambda v: v * color[1] // 255),
                                   b.point(lambda v: v * color[2] // 255), a.point(lambda v: int(v * alpha))))
    base.alpha_composite(tinted, (int(cx * K - tinted.width / 2), int(cy * K - tinted.height / 2)))


def text(base, x, y, s, size, color, path=BODY, anchor="la"):
    d = ImageDraw.Draw(base)
    f = font(path, size)
    d.text((x * K + K, y * K + K), s, font=f, fill=(0, 0, 0, 150), anchor=anchor)
    d.text((x * K, y * K), s, font=f, fill=color, anchor=anchor)


def overlay(base, draw_fn):
    """draw translucent shapes blended over the image (ImageDraw alone overwrites alpha)"""
    layer = Image.new("RGBA", base.size, (0, 0, 0, 0))
    draw_fn(ImageDraw.Draw(layer))
    base.alpha_composite(layer)


def panel(base, X, Y):
    W, PAD = 310, 14
    H = 46 + 52 + 16 + 18 + 6 + 3 * 17 + PAD
    surface(base, X, Y, W, H, strip=30)
    text(base, X + PAD, Y + 11, "Thousand Needles (41-46)", 12, ACCENT)
    for i, name in enumerate(("collapse", "gear", "nav", "list", "next", "prev")):
        icon(base, name, X + W - 17 - i * 19, Y + 16, 14, ACCENT if name == "nav" else SUB)
    text(base, X + W - 17 - 5 * 19 - 14, Y + 12, "6/24", 11, DIM, BODY, "ra")
    bx, by = X + PAD, Y + 32
    overlay(base, lambda d: d.rectangle([bx * K, by * K, (bx + W - 2 * PAD) * K, (by + 2) * K], fill=(255, 255, 255, 18)))
    overlay(base, lambda d: d.rectangle([(bx - 3) * K, (by - 3) * K, (bx + (W - 2 * PAD) * 0.25 + 3) * K, (by + 5) * K], fill=ACCENT + (40,)))
    overlay(base, lambda d: d.rectangle([bx * K, by * K, (bx + (W - 2 * PAD) * 0.25) * K, (by + 2) * K], fill=ACCENT + (255,)))
    # current step card on its brighter inset
    cx, cy = X + PAD, Y + 46
    inset = Image.new("RGBA", base.size, (0, 0, 0, 0))
    box = [(cx - 8) * K, (cy - 8) * K, (X + W - PAD + 8) * K, (cy + 44) * K]
    if THEME != "glass":
        ImageDraw.Draw(inset).rectangle(box, fill=(255, 255, 255, 12), outline=(255, 255, 255, 16), width=int(K))
    else:
        ImageDraw.Draw(inset).rounded_rectangle(box, radius=10 * K, fill=(255, 255, 255, 12), outline=(255, 255, 255, 16), width=int(K))
    base.alpha_composite(inset)
    if THEME != "glass":
        overlay(base, lambda d: d.rectangle([cx * K, (cy - 1) * K, (cx + 20) * K, (cy + 19) * K], fill=COL["accept"] + (255,)))
    else:
        icon(base, "circle", cx + 10, cy + 9, 20, COL["accept"])
    icon(base, "accept", cx + 10, cy + 9, 12, TINT)
    text(base, cx + 28, cy, "Accept Razzeric's Tweaking", 14, TEXT, HEAD)
    text(base, cx + 28, cy + 20, "Razzeric  ·  80.3, 76.1  ·  214 yd", 12, SUB)
    # party
    py = cy + 52 + 16
    text(base, X + PAD, py, "Kaelen", 11, (105, 204, 240))
    text(base, X + PAD + 40, py, "3/8", 11, COL["complete"])
    text(base, X + PAD + 70, py, "Mira", 11, (255, 125, 10))
    text(base, X + PAD + 98, py, "ready", 11, COL["turnin"])
    # upcoming
    uy = py + 24
    overlay(base, lambda d: d.line([(X + PAD) * K, (uy - 6) * K, (X + W - PAD) * K, (uy - 6) * K], fill=(255, 255, 255, 18), width=int(K)))
    for i, (verb, s) in enumerate((("accept", "Accept Keeping Pace"), ("fly", "Fly to Stranglethorn Vale (Gyll)"),
                                   ("turnin", "Turn in Report Back to Fizzlebub"))):
        icon(base, verb, X + PAD + 6, uy + 8 + i * 17, 11, COL[verb], 0.85)
        text(base, X + PAD + 20, uy + 1 + i * 17, s, 12, DIM)


def arrow(base, cxu, yu):
    im = Image.open(MEDIA / "arrow.tga").convert("RGBA").resize((int(64 * K), int(64 * K)), Image.LANCZOS)
    im = im.rotate(-22, resample=Image.BICUBIC)
    r, g, b, a = im.split()
    c = (130, 224, 120)
    im = Image.merge("RGBA", (r.point(lambda v: v * c[0] // 255), g.point(lambda v: v * c[1] // 255), b.point(lambda v: v * c[2] // 255), a))
    base.alpha_composite(im, (int(cxu * K - im.width / 2), int(yu * K)))
    surface(base, cxu - 98, yu + 66, 196, 54, alpha=0.55, corner=10)
    text(base, cxu, yu + 73, "214 yd  ·  31s", 15, (255, 255, 255), HEAD, "ma")
    text(base, cxu, yu + 93, "Accept Razzeric's Tweaking", 12, TEXT, BODY, "ma")
    text(base, cxu, yu + 108, "Razzeric", 11, ACCENT, BODY, "ma")


def main():
    global THEME
    shot, out = sys.argv[1], sys.argv[2]
    THEME = sys.argv[3] if len(sys.argv) > 3 else "flat"
    if THEME == "flat":
        global HEAD
        HEAD = BODY          # flat theme: one clean face throughout
    if THEME == "onward":    # the logo's palette (Skin.lua S.ONWARD)
        global ACCENT, PANEL, BORDER, STRIP
        ACCENT, PANEL = (227, 193, 84), (10, 38, 38)
        BORDER, STRIP = (185, 121, 18, 178), (1, 23, 23, 166)
    base = Image.open(shot).convert("RGBA")
    sx = base.width / 3840
    if sx != 1:
        base = base.resize((3840, int(base.height / sx)))
    # panel over open terrain on the right, arrow high and centred (UI units)
    panel(base, 1330, 300)
    arrow(base, 960, 70)
    base.convert("RGB").save(out, quality=92)
    crop = base.crop((1700, 80, 3700, 1150)).convert("RGB")
    crop.save(out.replace(".png", "_detail.png"))
    print("wrote", out)


if __name__ == "__main__":
    main()
