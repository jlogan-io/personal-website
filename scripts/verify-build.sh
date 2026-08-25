#!/usr/bin/env bash
#
# Sanity-check a built site in public/ before it is allowed to ship.
#
#   ./scripts/verify-build.sh            # checks ./public
#   ./scripts/verify-build.sh some/dir   # checks some/dir
#
# Every check reports rather than aborting on the first failure, so one run
# tells you everything that is wrong. Exits non-zero if anything failed.

set -uo pipefail

DIR="${1:-public}"
FAILED=0

red()  { printf '\033[1;31m%s\033[0m\n' "$*"; }
green(){ printf '\033[1;32m%s\033[0m\n' "$*"; }

fail() { red   "  FAIL  $*"; FAILED=1; }
ok()   { green "  ok    $*"; }

[ -d "$DIR" ] || { red "no such directory: $DIR (run hugo first)"; exit 1; }

echo "verifying $DIR"

# --- the build produced the pages a site needs at all -----------------------
for f in index.html sitemap.xml 404.html index.xml; do
  if [ -s "$DIR/$f" ]; then ok "$f present"; else fail "$f missing or empty"; fi
done

# --- it is a release build, not a dev build ---------------------------------
# A `hugo server` build carries livereload.js and a localhost baseURL. Publishing
# one replaces the live site with something that points at 127.0.0.1.
if grep -rqs "livereload.js" "$DIR"; then
  fail "livereload.js found - this is a 'hugo server' build, not a release build"
else
  ok "no livereload.js"
fi

if grep -qsE 'localhost|127\.0\.0\.1' "$DIR/sitemap.xml"; then
  fail "sitemap.xml contains localhost - built with a dev baseURL"
else
  ok "sitemap.xml has no localhost"
fi

# --- absolute URLs use https -------------------------------------------------
# configure-pages reports this custom domain as http://, and passing that to
# --baseURL previously put plain http into every canonical URL and sitemap entry.
if grep -qs 'http://jlogan\.io' "$DIR/sitemap.xml" "$DIR/index.xml" "$DIR/index.html"; then
  fail "http://jlogan.io found in output - baseURL lost its scheme"
else
  ok "absolute URLs are https"
fi

# --- the build is complete, not truncated ------------------------------------
MIN_URLS=30
MIN_POSTS=4
# grep -o, not grep -c: the sitemap is minified onto a single line, so counting
# lines reports 1 no matter how many URLs it holds.
URLS=$(grep -o '<loc>' "$DIR/sitemap.xml" 2>/dev/null | wc -l | tr -d ' ')
POSTS=$(find "$DIR/posts" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')

if [ "$URLS" -ge "$MIN_URLS" ]; then ok "sitemap has $URLS URLs (min $MIN_URLS)"
else fail "sitemap has only $URLS URLs, expected at least $MIN_URLS"; fi

if [ "$POSTS" -ge "$MIN_POSTS" ]; then ok "$POSTS post pages built (min $MIN_POSTS)"
else fail "only $POSTS post pages built, expected at least $MIN_POSTS"; fi

# --- weight budget -----------------------------------------------------------
# The theme renders plain <img src> with no Hugo image processing, so whatever
# is committed is what every visitor downloads. These ceilings are set just above
# the current worst offenders; run scripts/optimize-images.py when one trips.
MAX_IMAGE_KB=1536      # 1.5MB
MAX_TOTAL_MB=12

BIG=$(find "$DIR" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \
        -o -name '*.webp' -o -name '*.gif' \) -size +${MAX_IMAGE_KB}k 2>/dev/null)
if [ -n "$BIG" ]; then
  fail "images over ${MAX_IMAGE_KB}KB:"
  while IFS= read -r f; do
    printf '          %6.2fMB  %s\n' "$(( $(stat -f%z "$f" 2>/dev/null || stat -c%s "$f") ))e-6" "$f" 2>/dev/null \
      || printf '          %s\n' "$f"
  done <<< "$BIG"
else
  ok "no image over ${MAX_IMAGE_KB}KB"
fi

TOTAL_MB=$(du -sk "$DIR" | awk '{printf "%.0f", $1/1024}')
if [ "$TOTAL_MB" -le "$MAX_TOTAL_MB" ]; then ok "total size ${TOTAL_MB}MB (max ${MAX_TOTAL_MB}MB)"
else fail "total size ${TOTAL_MB}MB exceeds ${MAX_TOTAL_MB}MB budget"; fi

echo
if [ "$FAILED" -eq 0 ]; then green "all checks passed"; else red "verification failed"; fi
exit "$FAILED"
