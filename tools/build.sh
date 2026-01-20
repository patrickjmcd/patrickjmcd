#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out"
CSS="$ROOT/styles/resume.css"
SRC="$ROOT/README.md"

mkdir -p "$OUT"

pandoc "$SRC" \
  --from gfm \
  --to html5 \
  --standalone \
  --metadata pagetitle="Patrick J. McDonagh — Resume" \
  --css "$CSS" \
  -o "$OUT/resume.html"


weasyprint --base-url "$ROOT" \
  "$OUT/resume.html" \
  "$OUT/Patrick_McDonagh_Resume.pdf"

echo "Built: $OUT/Patrick_McDonagh_Resume.pdf"
