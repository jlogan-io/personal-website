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
  "Hardware"  "A physical iPhone. The simulator need not apply." >}}

I have wanted to build this app for years.

Astronomy got to me early, and exoplanets in particular. The idea that we can
point an instrument at a star hundreds of light years away, watch it dim by a
fraction of a percent, and from that work out that a planet is there, how big
it is, and how long its year lasts, has never stopped seeming implausible to
me. We have found thousands of them. Most people could not name one.

The thing that turned an interest into a project happened while I was at
Northrop Grumman. Northrop was the prime contractor for the James Webb Space
Telescope, and I had the chance to see it during assembly. Standing in front of
it is different from seeing the photographs. It is enormous, and it is
obviously handmade. Thousands of people built that thing to sit a million miles
from Earth, unfolding itself on the way, with no possibility of anyone going
out to fix it. Then it worked.

What stayed with me was not the engineering, though the engineering is
staggering. It was the ambition of the question. We built that to go and look
at atmospheres of planets we will never visit, orbiting stars we can barely
see, on the chance that one of them might tell us something.

The archive those discoveries land in is a CSV file. That is the gap I wanted
to close.

## What it is

ExoExplorer browses the confirmed planetary systems of NASA's Exoplanet Archive
in 3D. Swipe in from the left edge, pick a system, and it renders with the host
star at the centre and its planets on their real orbits. Tap the star or any
planet for its physical data. It runs on an ordinary iPhone through Expo Go.

Six thousand planets is a number. Watching a system assemble itself around its
star, with the orbits at their real relative distances, is a different kind of
understanding. That was the whole point.

## Shipping the archive in the app

The app ships with a ~2 MB snapshot of `pscomppars`, which covers 6,354
planets across 4,764 systems, so first launch is instant and works offline. On
launch it refreshes from the live TAP service in the background, at most once
a day. The bundled seed and the live download share one CSV format, so one
parser serves both.

## The archive fights back

Most of the interesting engineering turned out to be defensive. `st_lum` is
log₁₀ of solar luminosity, so if you read a null as zero you get a confidently
wrong habitable zone. Semi-major axis is null for about 7% of planets, so I
recover it from Kepler's third law and flag it as derived. Half of all masses
are estimates, and the info panel says which kind. Spectral type is missing
63% of the time, so the class on screen is derived from temperature instead.
The eight-planet system is filed under KOI-351 rather than Kepler-90, so the
search index carries aliases and you can find it either way. Every one of
these has a test.

{{< pullquote >}}
Estimates are labelled as estimates and derived values as derived. I would
rather the app admit uncertainty than render a beautiful lie.
{{< /pullquote >}}

## Rendering on native GL

expo-gl is not a browser, and most of this section is me finding that out. The
canvas mounts once and never unmounts, because remounting is the documented
trigger for iOS crashes. Picking is a manual raycaster fired from a gesture
handler with oversized invisible hit spheres, since native pointer events have
long-standing propagation bugs. Star glow is additive sprites rather than a
bloom pass, because the multisample API a post-processing composer needs is a
stub that throws. Labels are plain React Native text projected into screen
space. None of it is glamorous. All of it keeps a planetarium running at
native resolution on a phone.
