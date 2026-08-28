---
title: July 19th incident response
role: Lead EPM
org: CrowdStrike
period: Aug 2024
weight: 3
badges:
  - Remediation roadmaps in under 2 weeks
  - 9 functions aligned

# --- the card on /projects/ -------------------------------------------------
summary: >-
  The cross-functional response to the critical global outage caused by a
  misconfigured Sensor Channel File — re-architecting the deployment process
  for safety, transparency and automation.
highlights:
  - Directed execution across nine functions — Legal, TechOps, Platform, ProdSec, InfoSec, Data Science, Detection and Sensor.
  - Partnered with VPs to reprioritize company-wide backlogs for a hardened continuous-deployment pipeline.
  - Defined the ring-based rollout that now delivers Channel Files gradually and safely to customer environments.

# --- the card on the home page ---------------------------------------------
featured: true
kicker: CrowdStrike · 2024
home_summary: >-
  The cross-functional response to the global Channel File outage — a hardened,
  ring-based deployment pipeline roadmapped in under two weeks.
---

On 19 July 2024 a misconfigured Sensor Channel File took CrowdStrike customers
offline worldwide. I led the cross-functional response. The goal was not just
to fix what broke that morning, but to re-architect how Channel Files get
built, validated and released, so a single bad configuration could never again
reach every customer at once.

## Getting nine functions moving together

This could not sit inside one team. Channel Files touch the sensor, the
detection platform, the deployment pipeline, and every customer-facing message
about all three. I directed execution across nine functions: Legal, TechOps,
Platform Features, Platform Scale, ProdSec, InfoSec, Data Science, Detection
Platform and Sensor. Each had its own backlog, its own release cadence, and its
own idea of what "done" meant.

I spent most of the first week on sequencing: working out what had to be true
before anything shipped, and which team sat on the critical path for each of
those conditions.

## Reprioritizing the company's backlog

A hardened continuous-deployment pipeline for Channel Files was on nobody's
roadmap in July. Getting it built meant working with VPs and executive
leadership to reprioritize engineering backlogs company-wide. That is mostly an
argument about what to stop doing, not what to start, and it had to hold while
the whole organization was under real external pressure.

## The ring-based model

The change I care most about is how Channel Files reach customers at all. I
defined the delivery roadmap for a ring-based deployment model. Releases now
move outward through progressively larger rings of customer environments, with
validation gates between them, so a problem shows up against a small population
long before it can reach a large one.

Staying fluent in the sensor architecture and the cloud infrastructure under it
is what made that roadmap credible. Every scope, sequencing and risk call
depended on actually understanding what the pipeline did.

## What shipped, and when

I delivered initial remediation, design validation and production
implementation roadmaps in under two weeks. The speed mattered less as an
engineering result than as a signal. It was the thing that let leadership,
customers and the teams themselves see that the problem was understood and the
way out was real.
