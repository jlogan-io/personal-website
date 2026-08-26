---
title: Experience
menus:
  main:
    name: Experience
    weight: 200

# The old /references/ page folded into this one.
aliases:
  - /references/
  # The old site served this misspelling; Part A restored it and the redirect
  # must survive references becoming a non-rendering section.
  - /refrences/

# Role files in this folder feed the page but publish no URL of their own.
# Declared as an array with an explicit target: without it the render:never
# applies to this page too and the section stops rendering.
cascade:
  - build:
      render: never
      list: local
    target:
      path: '/experience/**'

heading: Twelve years of *complex problems, simple solutions.*
intro: >-
  A diverse portfolio of programs — architected, developed and delivered across
  defense, cloud, security and gaming. San Diego, CA · <email>

capabilities:
  - title: Program leadership
    body: 12+ years driving global initiatives across gaming, cloud and defense.
  - title: Cloud & systems
    body: AWS, GCP, OCI and distributed infrastructure at scale.
  - title: AI & data
    body: AI solutions for analytics, automation and decision support.
  - title: Gaming impact
    body: Programs powering PlayStation Network services worldwide.

references_heading: On the record

cta_body: A full PDF résumé — and further references — on request.
cta_label: Request the résumé
description: "Twelve years of complex problems, simple solutions: PlayStation, CrowdStrike, AWS and Northrop Grumman."
---
