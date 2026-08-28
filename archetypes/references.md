---
# A reference, shown on the Experience page under "On the record".
name: '{{ replace .File.ContentBaseName "-" " " | title }}'
title: Their Job Title
org: Company
# Optional, e.g. "managed Jonathan directly". Appended to the caption.
relationship: ''
weight: 1

# The shorter pull quote for the home page. Only the reference marked
# `featured: true` is used there.
summary: >-
  The short version of the quote.
featured: false
---

The quote as it appears on the Experience page, without quotation marks —
the template adds them.
