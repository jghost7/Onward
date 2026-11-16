"""Draw Sloppy Questing's textures (white artwork, tinted in game with SetVertexColor) as 32-bit TGA.

    python make_media.py   -> SloppyQuesting/media/*.tga
Shapes are drawn 4x oversize and downsampled for clean anti-aliased edges.
"""
import math
import pathlib

from PIL import Image, ImageDraw, ImageFilter

OUT = pathlib.Path(__file__).resolve().parent.parent / "SloppyQuesting" / "media"
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


def icon(name, draw):
    size = 32
    s = size * SS
    img = canvas(size)
    draw(ImageDraw.Draw(img), s)
    save(img, name, size)


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


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    glass()
    grain()
    sheen()
    arrow()
    ring()
    circle()
    for name, f in (("gear", gear), ("next", chevron("right")), ("prev", chevron("left")),
                    ("collapse", chevron("up")), ("expand", chevron("down")), ("list", listicon),
                    ("nav", navicon), ("accept", exclaim), ("turnin", question), ("complete", target),
                    ("goto", pin), ("fly", wing), ("level", levelup), ("note", info)):
        icon(name, f)
    print("wrote", sorted(p.name for p in OUT.glob("*.tga")))


if __name__ == "__main__":
    main()
