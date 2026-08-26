---
title: "ExoExplorer: NASA's exoplanet archive in 3D, on an iPhone"
date: 2026-08-25
author: Jonathan Logan
category:
  - Home Lab
tag:
  - ios
  - expo
  - react native
  - three.js
  - nasa
  - astronomy
  - project
toc: true
draft: false
description: 6,354 confirmed planets on their real orbits, in Expo Go.
---

{{< bench
  "App"       "Expo SDK 54 · React Native · expo-router"
  "Rendering" "three.js via R3F on expo-gl"
  "Data"      "NASA Exoplanet Archive TAP (pscomppars)"
  "Hardware"  "A physical iPhone — the simulator need not apply" >}}

ExoExplorer browses the confirmed planetary systems of NASA's Exoplanet Archive
in 3D. Swipe in from the left edge, pick a system, and it renders with the host
star at the centre and its planets on their real orbits; tap the star or any
planet for its physical data. It runs on an ordinary iPhone through Expo Go.

## Shipping the archive in the app

The app ships with a ~2 MB snapshot of `pscomppars` — 6,354 planets across
4,764 systems — so first launch is instant and works offline. On launch it
refreshes from the live TAP service in the background, at most once a day. The
bundled seed and the live download share one CSV format, so one parser serves
both.

## The archive fights back

The interesting engineering is defensive. `st_lum` is log₁₀ of solar
luminosity — read a null as zero and you get a confidently wrong habitable
zone. Semi-major axis is null for ~7% of planets, so it's recovered from
Kepler's third law and flagged as derived. Half of all masses are estimates;
the info panel says which kind. Spectral type is missing 63% of the time, so
the displayed class is derived from temperature instead. And the eight-planet
system is filed under KOI-351, not Kepler-90 — the search index carries aliases
so you can find it anyway. Every one of these has a test.

{{< pullquote >}}
Estimates are labelled as estimates, derived values as derived — the app would
rather admit uncertainty than render a beautiful lie.
{{< /pullquote >}}

## Rendering on native GL

expo-gl is not a browser. The canvas mounts once and never unmounts —
remounting is the documented trigger for iOS crashes. Picking is a manual
raycaster from a gesture handler with oversized invisible hit spheres, because
native pointer events have long-standing propagation bugs. Star glow is
additive sprites rather than a bloom pass, since the multisample API a
post-processing composer needs is a stub that throws. Labels are plain React
Native text projected into screen space. None of it is glamorous; all of it
keeps a planetarium running at native resolution on a phone.
