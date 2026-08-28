#!/usr/bin/env bash
#
# Scaffold a new post as a Hugo page bundle.
#
#   ./scripts/new-post.sh "The Art of Sending Quality Status Reports"
#
# Creates content/writing/YYYYMMDD-slug/index.md from archetypes/default.md,
# matching the layout the existing posts already use: a directory per post, with
# images living beside the markdown so they can be referenced by plain filename.
#
# The post starts as draft: true. Flip it to false when you want it live.

set -euo pipefail

die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$REPO_ROOT"

[ $# -ge 1 ] || die "usage: $0 \"Post Title\" [YYYY-MM-DD]"

TITLE="$1"
DATE="${2:-$(date +%Y-%m-%d)}"

# Validate an explicitly-passed date rather than silently producing a directory
# named after a typo. `date -d` is GNU-only and this repo is authored on macOS,
# whose BSD date spells the same thing `date -j -f`. Try both.
datestamp_of() {
  date -j -f "%Y-%m-%d" "$1" +%Y%m%d 2>/dev/null \
    || date -d "$1" +%Y%m%d 2>/dev/null
}
DATESTAMP=$(datestamp_of "$DATE") \
  || die "not a valid date: $DATE (expected YYYY-MM-DD)"
[ -n "$DATESTAMP" ] || die "not a valid date: $DATE (expected YYYY-MM-DD)"

# Title -> slug: lowercase, non-alphanumerics to dashes, collapse and trim.
SLUG=$(printf '%s' "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
[ -n "$SLUG" ] || die "title produced an empty slug: $TITLE"

BUNDLE="content/writing/${DATESTAMP}-${SLUG}"
[ -e "$BUNDLE" ] && die "$BUNDLE already exists"

command -v hugo >/dev/null 2>&1 || die "hugo is not installed.
Install the EXTENDED build (this site compiles SCSS and will not build without
it), matching the version CI uses -- see README.md."

# `hugo new` applies archetypes/default.md, keeping the archetype the single
# source of truth for front matter shape.
hugo new "${BUNDLE}/index.md" >/dev/null

# Fix up the two fields the archetype cannot fill in itself:
#
#   title     - the archetype derives it from the directory name, which for a
#               page bundle includes the YYYYMMDD prefix ("20250611 Tpm
#               Companion"). Replace it with the title as typed.
#   thumbnail - a site-root-relative path that has to name this bundle,
#               e.g. writing/20250611-tpm-companion/thumbnail-image.png
#   date      - `hugo new` always stamps "now". If a date was passed it has to
#               win, or a post scheduled for next week is dated today and
#               publishes immediately. Plain YYYY-MM-DD, matching the existing
#               posts rather than hugo's RFC-3339 default.
#
# awk rather than sed: titles legitimately contain quotes, slashes, pipes and
# ampersands, all of which are live characters in a sed replacement.
THUMB_PATH="writing/${DATESTAMP}-${SLUG}/thumbnail-image.png"
awk -v title="$TITLE" -v thumb="$THUMB_PATH" -v postdate="$DATE" '
  # Only rewrite the first occurrence of each, so a later line in the body that
  # happens to start with "title:" is left alone.
  !done_title && /^title:/ {
    gsub(/"/, "\\\"", title)          # escape quotes for the YAML string
    print "title: \"" title "\""
    done_title = 1
    next
  }
  !done_thumb && /^thumbnail:/ {
    print "thumbnail: \"" thumb "\""
    done_thumb = 1
    next
  }
  !done_date && /^date:/ {
    print "date: " postdate
    done_date = 1
    next
  }
  { print }
' "${BUNDLE}/index.md" > "${BUNDLE}/index.md.tmp"
mv "${BUNDLE}/index.md.tmp" "${BUNDLE}/index.md"

cat <<EOF

Created ${BUNDLE}/index.md

Next:
  1. Drop a thumbnail at ${BUNDLE}/thumbnail-image.png
     (or clear the thumbnail: line in the front matter)
  2. Write the post
  3. Preview:  hugo server -D        # -D shows drafts
  4. Publish:  set draft: false, then commit and push to main

Reminder: taxonomies in this site are SINGULAR -- category and tag, not
categories/tags. The plural form parses fine but the terms silently never
register, which is how one post's tags went missing for months.
EOF
