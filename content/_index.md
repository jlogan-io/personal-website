---
# ---------------------------------------------------------------------------
# This file is the home page AND the site's settings.
#
# Anything here under "site-wide" is read by every template as
# site.Home.Params.* -- so your email, name and social links live in markdown
# rather than in hugo.toml. Change them here.
# ---------------------------------------------------------------------------

title: Home

# --- site-wide -------------------------------------------------------------
author: Jonathan Logan
wordmark: Jonathan Logan
email: jlogan3990@gmail.com
portrait: images/jonathanlogan.png
description: >-
  Staff Technical Program Manager at PlayStation. I lead teams building
  scalable systems at the intersection of cloud, AI and gaming.
social:
  - name: LinkedIn
    url: https://www.linkedin.com/in/jonathan-logan-99ab925b/
  - name: Instagram
    url: https://www.instagram.com/jlogan.io/

# --- hero ------------------------------------------------------------------
# Text wrapped in *asterisks* renders as the brass italic phrase.
heading: Engineer by training, *program manager by passion.*
intro: >-
  I'm Jonathan Logan — Staff Technical Program Manager at PlayStation, leading
  teams that build scalable systems at the intersection of cloud, AI and
  gaming. Twelve years of complex problems, simple solutions.
actions:
  - label: View experience
    url: /experience/
    primary: true
  - label: Selected work
    url: /projects/

# --- the four figures under the hero ---------------------------------------
stats:
  - value: 12+
    label: years leading programs
  - value: "3"
    label: clouds at scale — AWS, GCP, OCI
  - value: 500+
    label: teams migrated, zero downtime
  - value: 85%
    label: of reporting automated with GenAI

# --- section headings ------------------------------------------------------
experience_heading: Where I've worked
experience_link: The full record →
projects_heading: Work I'm proud of
projects_link: All programs →

# --- contact ---------------------------------------------------------------
contact_heading: Building at the intersection of cloud, AI and gaming? *Let's talk.*
contact_body: >-
  San Diego County, California. Email is the fastest route; the professional
  record lives on LinkedIn.

# The contact block above is a summary; the full "Say hello" page is its own
# section under content/contact/, so the home page must not alias that path.
---
