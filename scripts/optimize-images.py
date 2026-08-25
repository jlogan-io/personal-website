#!/usr/bin/env python3
"""Shrink oversized site images in place.

The theme renders images with a plain <img src>, doing no Hugo image processing,
so whatever is committed is exactly what every visitor downloads. A 1700x1700
avatar displayed in a 250px box costs real page-load time for nothing.

This rescales images that are larger than they can ever be displayed, drops
fully-opaque alpha channels, and re-encodes PNGs with maximum compression.
Pixel data is resampled with Lanczos; nothing is cropped and aspect ratio is
preserved.

Usage:
    python3 scripts/optimize-images.py --check      # report only, change nothing
    python3 scripts/optimize-images.py              # apply

Requires Pillow:  pip install Pillow
"""

import argparse
import os
import sys

try:
    from PIL import Image
except ImportError:
    sys.exit("Pillow is required: pip install Pillow")

# Max width per location, chosen from how each image is actually displayed.
#   avatar     - rendered in a 250px box (assets/css/custom.css), 2x for retina
#   thumbnails - post headers and og:image; 1200px is the useful ceiling
#   screenshots- in-post screenshots that a reader may want to read detail in
RULES = [
    ("static/images/jonathanlogan.png", 500),
    ("static/images/", 1600),
    ("content/posts/", 1600),
]
THUMBNAIL_MAX = 1200

EXTS = {".png", ".jpg", ".jpeg", ".webp"}
# Below this, re-encoding is not worth the churn in git history.
MIN_BYTES = 150 * 1024


def max_width_for(path: str) -> int:
    if os.path.basename(path).startswith("thumbnail"):
        return THUMBNAIL_MAX
    for prefix, width in RULES:
        if path.startswith(prefix):
            return width
    return 1600


def human(n: int) -> str:
    return f"{n / 1024 / 1024:.2f}MB" if n >= 1024 * 1024 else f"{n / 1024:.0f}KB"


def optimize(path: str, apply: bool) -> tuple[int, int]:
    before = os.path.getsize(path)
    with Image.open(path) as im:
        im.load()
        orig_size, orig_mode = im.size, im.mode
        target = max_width_for(path)

        if im.width > target:
            height = round(im.height * target / im.width)
            im = im.resize((target, height), Image.LANCZOS)

        # An alpha channel that is fully opaque is 25% of the pixel data spent
        # storing the number 255 over and over.
        if im.mode == "RGBA":
            alpha = im.getchannel("A")
            if alpha.getextrema() == (255, 255):
                im = im.convert("RGB")

        note = ""
        if orig_size != im.size:
            note += f" {orig_size[0]}x{orig_size[1]}->{im.size[0]}x{im.size[1]}"
        if orig_mode != im.mode:
            note += f" {orig_mode}->{im.mode}"

        if not apply:
            print(f"  {human(before):>8}  {path}{note or ' (re-encode only)'}")
            return before, before

        fmt = (im.format or "").upper() or os.path.splitext(path)[1][1:].upper()
        if fmt == "JPG":
            fmt = "JPEG"

        # Write to a temp file first and keep it only if it is actually smaller.
        # Downscaling can INCREASE a PNG's size: resampling a limited-palette
        # screenshot invents intermediate colours that compress worse than the
        # flat originals. Silently shipping a bigger file would defeat the point.
        tmp = path + ".opt.tmp"
        try:
            if fmt == "PNG":
                im.save(tmp, "PNG", optimize=True, compress_level=9)
            elif fmt == "JPEG":
                im.save(tmp, "JPEG", quality=85, optimize=True, progressive=True)
            else:
                im.save(tmp, fmt, quality=85, method=6)

            candidate = os.path.getsize(tmp)
            if candidate < before:
                os.replace(tmp, path)
            else:
                print(f"  {human(before):>8}    (kept)  {path} - re-encoding "
                      f"would grow it to {human(candidate)}, left unchanged")
                return before, before
        finally:
            if os.path.exists(tmp):
                os.unlink(tmp)

    after = os.path.getsize(path)
    print(f"  {human(before):>8} -> {human(after):>8}  {path}{note}")
    return before, after


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true", help="report only")
    ap.add_argument("paths", nargs="*", default=None)
    args = ap.parse_args()

    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    os.chdir(root)

    if args.paths:
        candidates = args.paths
    else:
        candidates = []
        for base in ("content", "static", "assets"):
            for dirpath, _, files in os.walk(base):
                for f in files:
                    if os.path.splitext(f)[1].lower() in EXTS:
                        candidates.append(os.path.join(dirpath, f))

    todo = sorted(p for p in candidates if os.path.getsize(p) >= MIN_BYTES)
    if not todo:
        print("nothing over the size threshold")
        return 0

    print(f"{'checking' if args.check else 'optimizing'} {len(todo)} image(s) "
          f"over {human(MIN_BYTES)}:")
    total_before = total_after = 0
    for p in todo:
        b, a = optimize(p, apply=not args.check)
        total_before += b
        total_after += a

    if args.check:
        print(f"\ntotal: {human(total_before)} (run without --check to optimize)")
    else:
        saved = total_before - total_after
        pct = saved / total_before * 100 if total_before else 0
        print(f"\ntotal: {human(total_before)} -> {human(total_after)} "
              f"(saved {human(saved)}, {pct:.0f}%)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
