#!/usr/bin/env python3
"""Add a colored badge to a Cursor icon PNG file.

Usage: generate-icon.py <png_path> <hex_color>
  e.g. generate-icon.py icon_512x512.png "#0066CC"
"""

import sys
from PIL import Image, ImageDraw


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <png_path> <hex_color>", file=sys.stderr)
        sys.exit(1)

    img_path = sys.argv[1]
    color = sys.argv[2]

    img = Image.open(img_path).convert("RGBA")
    size = img.width

    badge_size = max(size * 30 // 100, 4)
    badge_offset = size - badge_size

    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    r = int(color[1:3], 16)
    g = int(color[3:5], 16)
    b = int(color[5:7], 16)

    cx = badge_offset + badge_size // 2
    cy = badge_offset + badge_size // 2
    radius = badge_size // 2

    draw.ellipse(
        [cx - radius, cy - radius, cx + radius, cy + radius],
        fill=(r, g, b, 220),
    )

    result = Image.alpha_composite(img, overlay)
    result.save(img_path)


if __name__ == "__main__":
    main()
