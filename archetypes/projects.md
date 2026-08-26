---
# A program on the Projects page. Ordered by `weight` -- lowest first.
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
role: Lead PM
org: Company
period: YYYY
weight: 1

# Shown on the home page card, if `featured` is true. Stands alone; not a
# truncation of the body.
summary: >-
  One or two sentences for the home page card.
featured: false
# Kicker on the home card. Defaults to "<org> · <period>" when left blank.
kicker: ''

# The first badge renders in brass as the headline metric; the rest are neutral.
badges:
  - The headline number
  - Supporting detail
---

The paragraph shown on the Projects page.

- What was done.
- What changed, with a number.
- A third.
