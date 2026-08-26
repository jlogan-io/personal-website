---
title: Writing
aliases:
  - /posts/
  - /posts/page/1/
  - /Posts/
  - /Posts/page/1/
menus:
  main:
    name: Writing
    weight: 400
description: "Notes from the field: program craft, AI tooling, graduate work and the home lab."
heading: Notes from *the field.*
intro: >-
  Program craft, AI tooling, graduate work, and the occasional dispatch from
  the home lab.
# Page-bundle images are published by default, so the original PNGs shipped
# alongside the WebP versions actually referenced -- roughly 1MB per post that
# nothing links to. Processed variants still publish; only the untouched
# originals stop.
cascade:
  - build:
      publishResources: false
    target:
      path: '/writing/**'
---
