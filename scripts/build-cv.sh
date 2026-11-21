#!/usr/bin/env bash
# Compiles cv/daniel-rama-cv.tex and copies the PDF to public/ so the website serves it.
set -euo pipefail

SRC=cv/daniel-rama-cv.tex
OUT=cv/build
DEST=public/cv/daniel-rama-cv.pdf

mkdir -p "$OUT"

# Run twice so hyperref's link/bookmark data is up to date.
for _ in 1 2; do
  if ! pdflatex -interaction=nonstopmode -halt-on-error -file-line-error \
       -output-directory="$OUT" "$SRC" > /dev/null; then
    echo "LaTeX failed. Error from $OUT/daniel-rama-cv.log:" >&2
    grep -A3 -E '^(.*:[0-9]+:|!)' "$OUT/daniel-rama-cv.log" >&2 || tail -20 "$OUT/daniel-rama-cv.log" >&2
    exit 1
  fi
done

cp "$OUT/daniel-rama-cv.pdf" "$DEST"
echo "CV built -> $DEST"

overfull=$(grep -c '^Overfull' "$OUT/daniel-rama-cv.log" || true)
if [ "$overfull" -gt 0 ]; then
  echo "Warning: $overfull line(s) run past the margin (see 'Overfull' in $OUT/daniel-rama-cv.log)." >&2
fi
