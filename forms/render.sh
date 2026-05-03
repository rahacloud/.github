#!/usr/bin/env bash
# Regenerate letterhead.pdf and (if needed) logo-trim.png from the source HTML.
#
# Usage: ./render.sh
# Requires: Google Chrome, ImageMagick (`magick`).

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HTML="$DIR/letterhead.html"
PDF="$DIR/letterhead.pdf"
LOGO_SRC="$DIR/../logo/logo.png"
LOGO_TRIM="$DIR/logo-trim.png"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# 1. Re-trim the cloud logo if the source has changed (or trim doesn't exist yet).
if [[ ! -f "$LOGO_TRIM" || "$LOGO_SRC" -nt "$LOGO_TRIM" ]]; then
  echo "Trimming $(basename "$LOGO_SRC") -> $(basename "$LOGO_TRIM")"
  bbox=$(magick "$LOGO_SRC" -channel A -threshold 5% -format "%@" info:)
  magick "$LOGO_SRC" -crop "$bbox" +repage "$LOGO_TRIM"
fi

# 2. Render the HTML to PDF via Chrome headless. The HTML's @page rule sets A4
#    with zero margin, so the orange accents bleed to the page edges.
echo "Rendering $(basename "$HTML") -> $(basename "$PDF")"
"$CHROME" \
  --headless=new \
  --disable-gpu \
  --no-margins \
  --no-pdf-header-footer \
  --virtual-time-budget=10000 \
  --print-to-pdf="$PDF" \
  "file://$HTML" 2>/dev/null

ls -lh "$PDF"
