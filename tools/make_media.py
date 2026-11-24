"""Draw Onward's textures (white artwork, tinted in game with SetVertexColor) as 32-bit TGA.

    python make_media.py   -> Onward/media/*.tga
Shapes are drawn 4x oversize and downsampled for clean anti-aliased edges.
"""
import math
import pathlib
import re
import xml.etree.ElementTree as ET

from PIL import Image, ImageDraw, ImageFilter

OUT = pathlib.Path(__file__).resolve().parent.parent / "Onward" / "media"
LUCIDE = pathlib.Path(__file__).resolve().parent / "data" / "lucide"
SS = 4
W = (255, 255, 255, 255)


def canvas(size):
    return Image.new("RGBA", (size * SS, size * SS), (0, 0, 0, 0))


def save(img, name, size):
    img = img.resize((size, size), Image.LANCZOS)
    img.save(OUT / f"{name}.tga")


def arrow():
    """Navigation arrow pointing up: a swept chevron with a light top face and darker lower face,
    soft shadow underneath. Grey levels survive vertex tinting as shading."""
    size = 128
    s = size * SS
    img = canvas(size)
    shadow = canvas(size)
    tip, left, right, notch = (s * .5, s * .08), (s * .16, s * .88), (s * .84, s * .88), (s * .5, s * .66)
    ImageDraw.Draw(shadow).polygon([(x, y + s * .03) for x, y in (tip, left, notch, right)], fill=(0, 0, 0, 150))
    shadow = shadow.filter(ImageFilter.GaussianBlur(s * .025))
    img.alpha_composite(shadow)
    d = ImageDraw.Draw(img)
    d.polygon([tip, left, notch], fill=(255, 255, 255, 255))         # left face (lit)
    d.polygon([tip, notch, right], fill=(200, 200, 200, 255))        # right face (shade)
    d.line([tip, left, notch, right, tip], fill=(30, 30, 30, 255), width=int(s * .018), joint="curve")
    save(img, "arrow", size)


def ring():
    """Arrival marker: ring with a check."""
    size = 128
    s = size * SS
    img = canvas(size)
    d = ImageDraw.Draw(img)
    m = s * .12
    d.ellipse([m, m, s - m, s - m], outline=W, width=int(s * .07))
    d.line([(s * .32, s * .52), (s * .45, s * .65), (s * .70, s * .38)], fill=W, width=int(s * .085), joint="curve")
    save(img, "arrive", size)


def circle():
    size = 64
    s = size * SS
    img = canvas(size)
    ImageDraw.Draw(img).ellipse([s * .02, s * .02, s * .98, s * .98], fill=W)
    save(img, "circle", size)


def icon(name, draw, size=64):
    s = size * SS
    img = canvas(size)
    draw(ImageDraw.Draw(img), s)
    save(img, name, size)


# ---------------------------------------------------------------- Lucide SVG stroke rasterizer
# Lucide icons (ISC license) are 24x24 uniform round-cap/round-join strokes.
# We tessellate every SVG path/arc/cubic/circle/line/polygon into polylines and draw
# true round-capped capsules at 8x supersampling, then LANCZOS-downsample to 64x64 TGA.
_NUM_RE = re.compile(r"[-+]?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?")


def _arc_points(x1, y1, rx, ry, phi_deg, large_arc, sweep, x2, y2, steps=40):
    """W3C SVG 1.1 F.6.5 endpoint-to-center elliptical arc parametrization."""
    if rx == 0 or ry == 0 or (abs(x1 - x2) < 1e-9 and abs(y1 - y2) < 1e-9):
        return [(x2, y2)]
    rx, ry = abs(rx), abs(ry)
    phi = math.radians(phi_deg % 360.0)
    cp, sp = math.cos(phi), math.sin(phi)
    dx2, dy2 = (x1 - x2) * 0.5, (y1 - y2) * 0.5
    x1p = cp * dx2 + sp * dy2
    y1p = -sp * dx2 + cp * dy2
    lam = (x1p * x1p) / (rx * rx) + (y1p * y1p) / (ry * ry)
    if lam > 1.0:
        s = math.sqrt(lam)
        rx *= s
        ry *= s
    num = max(0.0, rx * rx * ry * ry - rx * rx * y1p * y1p - ry * ry * x1p * x1p)
    den = rx * rx * y1p * y1p + ry * ry * x1p * x1p
    coef = math.sqrt(num / den) if den > 1e-12 else 0.0
    if large_arc == sweep:
        coef = -coef
    cxp = coef * (rx * y1p / ry)
    cyp = coef * (-ry * x1p / rx)
    cx = cp * cxp - sp * cyp + (x1 + x2) * 0.5
    cy = sp * cxp + cp * cyp + (y1 + y2) * 0.5

    def ang(ux, uy, vx, vy):
        dot = ux * vx + uy * vy
        mag = math.hypot(ux, uy) * math.hypot(vx, vy)
        c = max(-1.0, min(1.0, dot / mag)) if mag > 1e-12 else 1.0
        a = math.acos(c)
        return -a if (ux * vy - uy * vx) < 0 else a

    ux, uy = (x1p - cxp) / rx, (y1p - cyp) / ry
    vx, vy = (-x1p - cxp) / rx, (-y1p - cyp) / ry
    t1 = ang(1.0, 0.0, ux, uy)
    dt = ang(ux, uy, vx, vy)
    if not sweep and dt > 0:
        dt -= 2.0 * math.pi
    elif sweep and dt < 0:
        dt += 2.0 * math.pi
    n = max(8, int(math.ceil(abs(dt) / (math.pi / 24))))
    pts = []
    for i in range(1, n + 1):
        t = t1 + dt * (i / n)
        ct, st = math.cos(t), math.sin(t)
        x = cp * rx * ct - sp * ry * st + cx
        y = sp * rx * ct + cp * ry * st + cy
        pts.append((x, y))
    return pts


def _parse_path(d):
    """Parse an SVG path `d` string into a list of polylines [(x, y), ...] (spec-compliant arc flags)."""
    i, n = 0, len(d)
    cmd = None
    x = y = sx = sy = 0.0
    polylines = []
    cur = []

    def skip_sep():
        nonlocal i
        while i < n and d[i] in " \t\r\n,":
            i += 1

    def flt():
        nonlocal i
        skip_sep()
        m = _NUM_RE.match(d, i)
        if not m:
            raise ValueError(f"expected number at pos {i} in {d!r}")
        i = m.end()
        return float(m.group(0))

    def flag():
        nonlocal i
        skip_sep()
        if i >= n or d[i] not in "01":
            raise ValueError(f"expected arc flag at pos {i} in {d!r}")
        v = int(d[i])
        i += 1
        return v

    while True:
        skip_sep()
        if i >= n:
            break
        if d[i].isalpha():
            cmd = d[i]
            i += 1
        if cmd in ("M", "m"):
            nx, ny = flt(), flt()
            if cmd == "m":
                nx, ny = x + nx, y + ny
            if cur:
                polylines.append(cur)
            x, y = sx, sy = nx, ny
            cur = [(x, y)]
            cmd = "L" if cmd == "M" else "l"
        elif cmd in ("L", "l"):
            nx, ny = flt(), flt()
            if cmd == "l":
                nx, ny = x + nx, y + ny
            x, y = nx, ny
            cur.append((x, y))
        elif cmd in ("H", "h"):
            nx = flt()
            x = x + nx if cmd == "h" else nx
            cur.append((x, y))
        elif cmd in ("V", "v"):
            ny = flt()
            y = y + ny if cmd == "v" else ny
            cur.append((x, y))
        elif cmd in ("C", "c"):
            x1, y1, x2, y2, nx, ny = flt(), flt(), flt(), flt(), flt(), flt()
            if cmd == "c":
                x1, y1, x2, y2, nx, ny = x + x1, y + y1, x + x2, y + y2, x + nx, y + ny
            for k in range(1, 25):
                t = k / 24.0
                mt = 1.0 - t
                px = mt**3 * x + 3 * mt**2 * t * x1 + 3 * mt * t**2 * x2 + t**3 * nx
                py = mt**3 * y + 3 * mt**2 * t * y1 + 3 * mt * t**2 * y2 + t**3 * ny
                cur.append((px, py))
            x, y = nx, ny
        elif cmd in ("A", "a"):
            rx, ry, rot = flt(), flt(), flt()
            large, sweep = flag(), flag()
            nx, ny = flt(), flt()
            if cmd == "a":
                nx, ny = x + nx, y + ny
            cur.extend(_arc_points(x, y, rx, ry, rot, large, sweep, nx, ny))
            x, y = nx, ny
        elif cmd in ("Z", "z"):
            if cur and (abs(x - sx) > 1e-6 or abs(y - sy) > 1e-6):
                cur.append((sx, sy))
            if cur:
                polylines.append(cur)
                cur = []
            x, y = sx, sy
            cmd = None
        else:
            raise ValueError(f"unsupported SVG path command {cmd!r}")
    if cur:
        polylines.append(cur)
    return polylines


def _svg_polylines(svg_path):
    """Extract all stroked polylines from a 24x24 Lucide SVG file."""
    root = ET.fromstring(svg_path.read_text(encoding="utf-8"))
    out = []
    for el in root.iter():
        tag = el.tag.split("}")[-1]
        if tag == "path":
            out.extend(_parse_path(el.attrib["d"]))
        elif tag == "line":
            out.append([(float(el.attrib["x1"]), float(el.attrib["y1"])),
                        (float(el.attrib["x2"]), float(el.attrib["y2"]))])
        elif tag == "circle":
            cx, cy, r = float(el.attrib["cx"]), float(el.attrib["cy"]), float(el.attrib["r"])
            pts = [(cx + r * math.cos(2 * math.pi * k / 64), cy + r * math.sin(2 * math.pi * k / 64))
                   for k in range(65)]
            out.append(pts)
        elif tag in ("polyline", "polygon"):
            nums = [float(v) for v in re.findall(r"[-+]?(?:\d+\.?\d*|\.\d+)", el.attrib["points"])]
            pts = [(nums[k], nums[k + 1]) for k in range(0, len(nums), 2)]
            if tag == "polygon" and pts:
                pts.append(pts[0])
            out.append(pts)
    return out


def _draw_strokes(polylines, size=64, stroke_width=2.2, pad=1.0):
    """Render 24x24 polylines as crisp white round-capped/round-joined strokes into a TGA image."""
    ss = 8
    s = size * ss
    img = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    scale = s / (24.0 + 2.0 * pad)
    off = pad * scale
    rad = stroke_width * scale * 0.5
    lw = max(1, int(round(stroke_width * scale)))

    def tx(pt):
        return (pt[0] * scale + off, pt[1] * scale + off)

    for poly in polylines:
        if not poly:
            continue
        pts = [tx(p) for p in poly]
        # Draw each segment + round joints/caps (including zero-length dots like `h.01`)
        if len(pts) == 1 or (len(pts) == 2 and math.hypot(pts[1][0] - pts[0][0], pts[1][1] - pts[0][1]) < rad * 0.3):
            cx, cy = pts[0]
            d.ellipse([cx - rad, cy - rad, cx + rad, cy + rad], fill=W)
            continue
        for a, b in zip(pts, pts[1:]):
            d.line([a, b], fill=W, width=lw)
        for px, py in pts:
            d.ellipse([px - rad, py - rad, px + rad, py + rad], fill=W)
    return img.resize((size, size), Image.LANCZOS)


def lucide_icon(name, svg_name, size=64, stroke_width=2.2, pad=0.5):
    img = _draw_strokes(_svg_polylines(LUCIDE / f"{svg_name}.svg"), size=size, stroke_width=stroke_width, pad=pad)
    img.save(OUT / f"{name}.tga")


def lucide_custom(name, paths, size=64, stroke_width=2.4, pad=0.5):
    """Render custom 24x24 paths using the exact same Lucide round-stroke language."""
    polys = []
    for p in paths:
        polys.extend(_parse_path(p))
    img = _draw_strokes(polys, size=size, stroke_width=stroke_width, pad=pad)
    img.save(OUT / f"{name}.tga")


def gear(d, s):
    c, r_out, r_in, teeth = s / 2, s * .42, s * .30, 8
    pts = []
    for k in range(teeth * 2):
        a0 = k * math.pi / teeth
        r = r_out if k % 2 == 0 else r_in
        for da in (-0.18, 0.18):
            a = a0 + da
            pts.append((c + r * math.cos(a), c + r * math.sin(a)))
    d.polygon(pts, fill=W)
    d.ellipse([c - s * .27, c - s * .27, c + s * .27, c + s * .27], fill=W)
    d.ellipse([c - s * .12, c - s * .12, c + s * .12, c + s * .12], fill=(0, 0, 0, 0))


def chevron(direction):
    def f(d, s):
        w = int(s * .13)
        if direction == "right":
            d.line([(s * .38, s * .22), (s * .66, s * .5), (s * .38, s * .78)], fill=W, width=w, joint="curve")
        elif direction == "left":
            d.line([(s * .62, s * .22), (s * .34, s * .5), (s * .62, s * .78)], fill=W, width=w, joint="curve")
        elif direction == "up":
            d.line([(s * .22, s * .62), (s * .5, s * .34), (s * .78, s * .62)], fill=W, width=w, joint="curve")
        else:
            d.line([(s * .22, s * .38), (s * .5, s * .66), (s * .78, s * .38)], fill=W, width=w, joint="curve")
    return f


def listicon(d, s):
    for y in (.27, .5, .73):
        d.ellipse([s * .14, s * (y - .06), s * .26, s * (y + .06)], fill=W)
        d.rounded_rectangle([s * .34, s * (y - .05), s * .86, s * (y + .05)], radius=s * .05, fill=W)


def navicon(d, s):
    d.polygon([(s * .5, s * .1), (s * .2, s * .88), (s * .5, s * .7), (s * .8, s * .88)], fill=W)


def exclaim(d, s):
    d.rounded_rectangle([s * .42, s * .14, s * .58, s * .64], radius=s * .08, fill=W)
    d.ellipse([s * .41, s * .72, s * .59, s * .9], fill=W)


def question(d, s):
    d.arc([s * .26, s * .1, s * .74, s * .54], start=190, end=90, fill=W, width=int(s * .14))
    d.line([(s * .5, s * .52), (s * .5, s * .66)], fill=W, width=int(s * .14))
    d.ellipse([s * .41, s * .74, s * .59, s * .92], fill=W)


def target(d, s):
    d.ellipse([s * .14, s * .14, s * .86, s * .86], outline=W, width=int(s * .1))
    d.ellipse([s * .38, s * .38, s * .62, s * .62], fill=W)


def pin(d, s):
    d.ellipse([s * .24, s * .1, s * .76, s * .62], fill=W)
    d.polygon([(s * .28, s * .46), (s * .72, s * .46), (s * .5, s * .92)], fill=W)
    d.ellipse([s * .40, s * .26, s * .60, s * .46], fill=(0, 0, 0, 0))


def wing(d, s):
    # stylised wing: three swept feathers
    for k, y in enumerate((.3, .48, .66)):
        d.polygon([(s * .12, s * (y + .12)), (s * (.88 - k * .12), s * (y - .12)), (s * (.80 - k * .12), s * (y + .02)),
                   (s * .2, s * (y + .2))], fill=W)


def levelup(d, s):
    d.polygon([(s * .5, s * .1), (s * .86, s * .5), (s * .62, s * .5), (s * .62, s * .9), (s * .38, s * .9),
               (s * .38, s * .5), (s * .14, s * .5)], fill=W)


def person(d, s):
    # who to talk to: a head over shoulders
    d.ellipse([s * .33, s * .1, s * .67, s * .44], fill=W)
    d.pieslice([s * .14, s * .52, s * .86, s * 1.24], 180, 360, fill=W)


def speech(d, s):
    # target someone to talk to: rounded speech bubble with tail and three cut-out dots
    d.rounded_rectangle([s * .11, s * .13, s * .89, s * .73], radius=s * .22, fill=W)
    d.polygon([(s * .24, s * .66), (s * .46, s * .70), (s * .17, s * .91)], fill=W)
    r = s * .06
    for cx in (.31, .50, .69):
        d.ellipse([s * cx - r, s * .43 - r, s * cx + r, s * .43 + r], fill=(0, 0, 0, 0))


def info(d, s):
    d.ellipse([s * .41, s * .1, s * .59, s * .28], fill=W)
    d.rounded_rectangle([s * .42, s * .38, s * .58, s * .9], radius=s * .07, fill=W)


# ---------------------------------------------------------------- glass skin (9-sliced in game)
GLASS = 64          # texture size of the sliced pieces
RADIUS = 12         # corner radius in texture px (slice margin = 16)


def rounded(size, radius, inset=0, fill=W, outline=None, width=1):
    s = size * SS
    img = canvas(size)
    d = ImageDraw.Draw(img)
    box = [inset * SS, inset * SS, s - inset * SS - 1, s - inset * SS - 1]
    d.rounded_rectangle(box, radius=radius * SS, fill=fill, outline=outline, width=width * SS)
    return img


def glass():
    # body: solid rounded shape, tinted and faded in game
    save(rounded(GLASS, RADIUS), "glass_body", GLASS)
    # rim: hairline outline
    save(rounded(GLASS, RADIUS, fill=None, outline=W, width=1), "glass_rim", GLASS)
    # top light: the outline's upper half only, fading down (lit top edge)
    rim = rounded(GLASS, RADIUS, fill=None, outline=W, width=1)
    fade = Image.new("L", rim.size, 0)
    fd = ImageDraw.Draw(fade)
    h = rim.size[1]
    for y in range(h):
        fd.line([(0, y), (rim.size[0], y)], fill=max(0, int(255 * (1 - y / (h * 0.45)))))
    rim.putalpha(Image.fromarray(__import__("numpy").minimum(__import__("numpy").array(rim.getchannel("A")),
                                                               __import__("numpy").array(fade))))
    save(rim, "glass_toplight", GLASS)
    # shadow: soft dark rounded rect, generous blur (sliced with a wide margin)
    size = 128
    s = size * SS
    sh = canvas(size)
    ImageDraw.Draw(sh).rounded_rectangle([s * .22, s * .22, s * .78, s * .78], radius=RADIUS * SS * 1.4, fill=(0, 0, 0, 255))
    sh = sh.filter(ImageFilter.GaussianBlur(s * .07))
    save(sh, "glass_shadow", size)


def grain():
    """Fine film grain, tiled across glass at low alpha: what makes flat transparency read as frost."""
    import random
    rnd = random.Random(7)
    size = 128
    img = Image.new("RGBA", (size, size))
    px = img.load()
    for y in range(size):
        for x in range(size):
            v = rnd.randint(0, 255)
            px[x, y] = (255, 255, 255, v)
    img = img.filter(ImageFilter.GaussianBlur(0.6))
    img.save(OUT / "grain.tga")


def sheen():
    """Vertical gradient (white at top -> clear), stretched over the upper part of a glass frame."""
    img = Image.new("RGBA", (8, 128))
    px = img.load()
    for y in range(128):
        a = int(255 * (1 - y / 127) ** 2.2)
        for x in range(8):
            px[x, y] = (255, 255, 255, a)
    img.save(OUT / "sheen.tga")


# Lucide icons (ISC license, tools/data/lucide/*.svg) baked to 64x64 white TGA sprites.
LUCIDE_ICONS = [
    ("gear",     "settings",            2.1),
    ("next",     "chevron-right",       2.4),
    ("prev",     "chevron-left",        2.4),
    ("collapse", "chevron-up",          2.4),
    ("expand",   "chevron-down",        2.4),
    ("list",     "list",                2.2),
    ("nav",      "navigation",          2.1),
    ("complete", "crosshair",           2.2),
    ("goto",     "map-pin",             2.2),
    ("fly",      "feather",             2.1),
    ("level",    "arrow-up",            2.4),
    ("note",     "info",                2.2),
    ("who",      "user",                2.2),
    ("talk",     "message-circle-more", 2.2),
    ("later",    "clock",               2.2),
    ("done",     "check",               2.5),
    ("lucky",    "clover",              2.1),
    ("unlucky",  "cloud-rain",          2.2),
]

# WoW's iconic bare ! and ? glyphs in the exact same 24x24 Lucide round-stroke weight,
# so they stay unmistakable at 11px inside upcoming step rows.
LUCIDE_QUEST_GLYPHS = [
    ("accept", ["M12 4v10.5", "M12 19.5h.01"], 2.8),
    ("turnin", ["M8.5 8.5a3.7 3.7 0 0 1 7.2 1.2c0 2.3-3.7 2.8-3.7 4.8", "M12 19.5h.01"], 2.6),
]


def icons():
    for name, svg, sw in LUCIDE_ICONS:
        lucide_icon(name, svg, size=64, stroke_width=sw)
    for name, paths, sw in LUCIDE_QUEST_GLYPHS:
        lucide_custom(name, paths, size=64, stroke_width=sw)
    lucide_icon("arrive", "circle-check", size=128, stroke_width=2.0)


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    glass()
    grain()
    sheen()
    arrow()
    circle()
    icons()
    print("wrote", sorted(p.name for p in OUT.glob("*.tga")))


if __name__ == "__main__":
    main()
