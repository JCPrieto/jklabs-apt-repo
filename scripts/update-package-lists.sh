#!/usr/bin/env bash
set -euo pipefail

PACKAGES_FILE="${1:-repo/dists/stable/main/binary-amd64/Packages}"
REPO_ROOT="${2:-.}"

if [ ! -f "$PACKAGES_FILE" ]; then
  echo "Packages file not found: $PACKAGES_FILE"
  exit 1
fi

README_FILE="$REPO_ROOT/README.md"
INDEX_FILE="$REPO_ROOT/index.html"

if [ ! -f "$README_FILE" ] || [ ! -f "$INDEX_FILE" ]; then
  echo "Expected documentation files not found in: $REPO_ROOT"
  exit 1
fi

mapfile -t PACKAGE_ROWS < <(
  awk -F': ' '
    /^Package: / { pkg=$2 }
    /^Version: / && pkg != "" { print pkg "\t" $2; pkg="" }
  ' "$PACKAGES_FILE" | sort -u
)

md_tmp="$(mktemp)"
html_tmp="$(mktemp)"
trap 'rm -f "$md_tmp" "$html_tmp"' EXIT

if [ "${#PACKAGE_ROWS[@]}" -eq 0 ]; then
  printf '%s\n' '- _Sin paquetes publicados todavía_' > "$md_tmp"
  printf '%s\n' '        <li><em>Sin paquetes publicados todavía</em></li>' > "$html_tmp"
else
  for row in "${PACKAGE_ROWS[@]}"; do
    pkg="${row%%$'\t'*}"
    ver="${row#*$'\t'}"
    printf -- '- `%s` (`%s`)\n' "$pkg" "$ver" >> "$md_tmp"
    printf '        <li><code>%s</code> (<code>%s</code>)</li>\n' "$pkg" "$ver" >> "$html_tmp"
  done
fi

replace_block() {
  file="$1"
  start_marker="$2"
  end_marker="$3"
  block_file="$4"

  awk \
    -v start="$start_marker" \
    -v end="$end_marker" \
    -v insert_file="$block_file" '
      BEGIN {
        while ((getline line < insert_file) > 0) {
          content = content line ORS
        }
      }
      index($0, start) {
        print
        printf "%s", content
        in_block = 1
        seen_start = 1
        next
      }
      index($0, end) {
        in_block = 0
        seen_end = 1
        print
        next
      }
      !in_block { print }
      END {
        if (!seen_start || !seen_end) {
          exit 2
        }
      }
    ' "$file" > "$file.tmp"

  mv "$file.tmp" "$file"
}

replace_block "$README_FILE" "<!-- PACKAGES-LIST:START -->" "<!-- PACKAGES-LIST:END -->" "$md_tmp"
replace_block "$INDEX_FILE" "<!-- PACKAGES-LIST:START -->" "<!-- PACKAGES-LIST:END -->" "$html_tmp"
