---
title: ExoExplorer — exoplanets in 3D on iOS
role: Builder
org: Personal project
period: "2026"
weight: 2
badges:
  - 6,354 planets · 4,764 systems
  - Offline-first
  - Expo · three.js
---

An iOS app that renders the confirmed planetary systems of NASA's Exoplanet
Archive in 3D — host star at the centre, planets on their real orbits, physical
data a tap away. Expo + React Native, three.js on expo-gl.

- Ships an offline archive snapshot — 6,354 planets across 4,764 systems in ~2 MB — refreshed from the live TAP service in the background, at most once a day.
- Tested astronomy core: missing orbits recovered via Kepler's third law, Kopparapu habitable zones, spectral class derived from temperature — estimates flagged, never hidden.
- Native-GL pragmatism: a never-unmounted canvas, manual raycaster picking, and additive-sprite glow where post-processing can't run.
