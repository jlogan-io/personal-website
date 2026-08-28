---
# A program. Ordered by `weight` -- lowest first.
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
role: Lead PM
org: Company
period: YYYY
weight: 1

# The first badge renders in brass as the headline metric; the rest are neutral.
badges:
  - The headline number
  - Supporting detail

# --- the card on /projects/ -------------------------------------------------
summary: >-
  The paragraph shown on the card, and again as the dek on this program's own
  page.
highlights:
  - What was done.
  - What changed, with a number in it.
  - A third.

# --- the card on the home page ----------------------------------------------
# Only `featured` programs appear there, and they get a shorter write-up.
featured: false
kicker: ''          # defaults to "<org> · <period>"
home_title: ''      # defaults to `title`, for when that is too long
home_summary: >-
  The shorter version, for the home page card.

# Set this only when the write-up already lives somewhere else -- the card
# links there and this file publishes no page of its own.
# link: /writing/some-post/
# build:
#   render: never
#   list: local
---

The long-form story. What the problem was, what you did about it, and what
changed as a result. Use `##` headings; they carry the article styling.
