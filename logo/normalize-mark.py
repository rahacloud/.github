#!/usr/bin/env python3
"""Normalize a client or partner logo into a spec-compliant Raha Cloud mark tile.

Every tile in `logo/clients/` is 600x400 on pure white, with the mark centred and
scaled for *optical* balance rather than a naive bounding-box fit. Fitting logos
to their bounding box makes wide wordmarks (TalaLand) tower over tall stacked
lockups (Hamravesh); scaling purely by ink area overcorrects and blows up thin
line art. We blend the two, then clamp to a hard box so nothing overflows.

Usage:
    ./normalize-mark.py <input.png> <slug>          # -> clients/<slug>.png
    ./normalize-mark.py <input.png> <slug> --crop WxH+X+Y   # pre-crop first
"""

import argparse
import subprocess
import sys
from pathlib import Path

from PIL import Image

CANVAS = (600, 400)  # final tile size
FIT_BOX = (480, 300)  # nominal box used for the bounding-box fit term
HARD_BOX = (540, 340)  # nothing may exceed this, whatever the blend says
TARGET_INK = 24_000  # target ink pixels after scaling, for the area term
INK_THRESHOLD = 235  # luminance below this counts as ink, not background
TRIM_FUZZ = "8%"  # tolerance for trimming the off-white source backgrounds


def trim(src: Path, dst: Path, crop: str | None) -> None:
    """Crop to the region of interest and strip surrounding background."""
    cmd = ["magick", str(src)]
    if crop:
        cmd += ["-crop", crop, "+repage"]
    cmd += ["-fuzz", TRIM_FUZZ, "-trim", "+repage", str(dst)]
    subprocess.run(cmd, check=True)


def ink_pixels(path: Path) -> int:
    """Count non-background pixels — our proxy for how much the mark occupies."""
    im = Image.open(path).convert("L")
    data = im.get_flattened_data() if hasattr(im, "get_flattened_data") else im.getdata()
    return sum(1 for p in data if p < INK_THRESHOLD)


def scale_for(size: tuple[int, int], ink: int) -> float:
    """Blend a bounding-box fit with an ink-area fit, then clamp to HARD_BOX."""
    w, h = size
    fit = min(FIT_BOX[0] / w, FIT_BOX[1] / h)
    area = (TARGET_INK / ink) ** 0.5
    blended = (fit * area) ** 0.5
    return min(blended, HARD_BOX[0] / w, HARD_BOX[1] / h)


def render(trimmed: Path, dst: Path) -> None:
    im = Image.open(trimmed)
    scale = scale_for(im.size, ink_pixels(trimmed))
    w, h = (max(1, round(d * scale)) for d in im.size)

    mark = im.convert("RGBA").resize((w, h), Image.LANCZOS)
    tile = Image.new("RGB", CANVAS, "white")
    tile.paste(mark, ((CANVAS[0] - w) // 2, (CANVAS[1] - h) // 2), mark)
    tile.save(dst, optimize=True)
    print(f"{dst.name}: {im.size[0]}x{im.size[1]} -> {w}x{h} (scale {scale:.3f})")


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("source", type=Path, help="raw logo file")
    ap.add_argument("slug", help="lowercase client slug, e.g. talaland")
    ap.add_argument("--crop", help="ImageMagick crop geometry applied first")
    ap.add_argument(
        "--out",
        type=Path,
        default=Path(__file__).parent / "clients",
        help="output directory (default: logo/clients)",
    )
    args = ap.parse_args()

    args.out.mkdir(parents=True, exist_ok=True)
    staged = args.out / f".{args.slug}.trim.png"
    try:
        trim(args.source, staged, args.crop)
        render(staged, args.out / f"{args.slug}.png")
    finally:
        staged.unlink(missing_ok=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
