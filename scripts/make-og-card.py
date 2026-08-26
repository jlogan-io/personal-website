#!/usr/bin/env python3
"""Render the 1200x630 social share card.

The design package ships og-card.png drawn in Georgia as a stand-in for
Newsreader. This redraws it in the real typeface, keeping the delivered
layout: measurements below were taken from that reference, not invented.

    python3 scripts/make-og-card.py            # writes assets/images/og-card.png
    python3 scripts/make-og-card.py --check    # report only

Requires Pillow and the two Newsreader variable fonts plus Barlow. Fonts are
fetched on demand and cached; they are not committed.
"""
import argparse, os, sys, urllib.request

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    sys.exit("Pillow is required: pip install Pillow")

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CACHE = os.path.join(ROOT, ".cache", "fonts")
OUT = os.path.join(ROOT, "assets", "images", "og-card.png")
MARK = os.path.join(ROOT, "assets", "images", "mark-brass.png")

GF = "https://github.com/google/fonts/raw/main/ofl"
FONTS = {
    "Newsreader.ttf":        f"{GF}/newsreader/Newsreader%5Bopsz,wght%5D.ttf",
    "Newsreader-Italic.ttf": f"{GF}/newsreader/Newsreader-Italic%5Bopsz,wght%5D.ttf",
    "Barlow-Medium.ttf":     f"{GF}/barlow/Barlow-Medium.ttf",
}

# Sampled from the delivered reference card.
W, H = 1200, 630
BG      = (25, 31, 40)     # --bg
STRIP   = (36, 44, 56)     # --divider, the 30px foot
NAME    = (242, 240, 234)  # --warm-96
BRASS   = (219, 170, 95)   # --brass
ROLE    = (168, 176, 189)  # --cool-74
LEFT    = 80
MARK_XY, MARK_D = (58, 58), 103
NAME_TOP, TAG_TOP, ROLE_TOP = 227, 341, 446
STRIP_TOP = 600

TEXT_NAME = "Jonathan Logan"
TEXT_TAG  = "Engineer by training, program manager by passion."
TEXT_ROLE = "Staff Technical Program Manager  ·  PlayStation  ·  San Diego"


def font(name, size, weight):
    os.makedirs(CACHE, exist_ok=True)
    path = os.path.join(CACHE, name)
    if not os.path.exists(path):
        print(f"  fetching {name}")
        urllib.request.urlretrieve(FONTS[name], path)
    f = ImageFont.truetype(path, size)
    try:
        f.set_variation_by_axes([weight, min(size, 72)])  # weight, optical size
    except Exception:
        pass  # static face; nothing to vary
    return f


def draw_at_top(d, xy, text, f, fill):
    """Place text by the top of its ink, not its ascender, so the result lines
    up with measurements taken off the reference image."""
    x, y = xy
    d.text((x - f.getbbox(text)[0], y - f.getbbox(text)[1]), text, font=f, fill=fill)


def build():
    im = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(im)
    d.rectangle([0, STRIP_TOP, W, H], fill=STRIP)

    if os.path.exists(MARK):
        mark = Image.open(MARK).convert("RGBA").resize((MARK_D, MARK_D), Image.LANCZOS)
        im.paste(mark, MARK_XY, mark)

    draw_at_top(d, (LEFT, NAME_TOP), TEXT_NAME, font("Newsreader.ttf", 93, 600), NAME)
    draw_at_top(d, (LEFT, TAG_TOP),  TEXT_TAG,  font("Newsreader-Italic.ttf", 44, 400), BRASS)
    draw_at_top(d, (LEFT, ROLE_TOP), TEXT_ROLE, font("Barlow-Medium.ttf", 32, 500), ROLE)
    return im


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="report without writing")
    a = ap.parse_args()
    im = build()
    if a.check:
        print(f"would write {W}x{H} -> {os.path.relpath(OUT, ROOT)}")
    else:
        os.makedirs(os.path.dirname(OUT), exist_ok=True)
        im.save(OUT, optimize=True)
        print(f"wrote {os.path.relpath(OUT, ROOT)} ({os.path.getsize(OUT)//1024}KB)")
