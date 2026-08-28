---
# A role on the Experience page. Ordered by `weight` -- lowest first, so the
# most recent job is 1.
org: '{{ replace .File.ContentBaseName "-" " " | title }}'
role: Job Title
dates: Mon YYYY — present
location: San Diego, CA
weight: 1

# The one-line version, used for the row on the home page. Write it to stand
# alone -- it is not a truncation of the body below.
summary: >-
  One sentence on what this role is about.
---

The fuller paragraph shown on the Experience page. Two or three sentences.

- What you owned or drove.
- Another, ideally with a number in it.
- A third.
