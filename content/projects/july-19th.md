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
offline worldwide. I led the cross-functional response: a high-priority
initiative to re-architect how Channel Files are built, validated and released,
so that a single bad configuration could never again reach every customer at
once.

## Getting nine functions moving in the same direction

The response could not sit inside one team. Channel Files touch the sensor, the
detection platform, the deployment pipeline and the customer-facing
communications around all three. I directed and defined execution across Legal,
TechOps, Platform Features, Platform Scale, ProdSec, InfoSec, Data Science,
Detection Platform and Sensor — nine functions, each with its own backlog,
release cadence and definition of done.

The immediate work was sequencing: deciding what had to be true before anything
shipped, and which teams were on the critical path for each of those
conditions.

## Reprioritizing the company's backlog

A hardened continuous-deployment pipeline for Channel Files was not on anyone's
roadmap in July. Getting it built meant partnering with VPs and executive
leadership to reprioritize engineering backlogs company-wide — making the case
for what to stop, not just what to start, and holding that line while the
organization was under considerable external pressure.

## The ring-based model

The durable outcome was a change in how Channel Files reach customers at all. I
defined the delivery roadmap for a ring-based deployment model: releases move
outward through progressively larger rings of customer environments, with
validation gates between them, so problems surface against a small population
before they can reach a large one.

Staying technically fluent in the sensor architecture and the cloud
infrastructure underneath it was what made the roadmap credible — scope,
sequencing and risk decisions all depended on understanding what the pipeline
actually did.

## What shipped, and when

Initial remediation, design validation and production implementation roadmaps
were delivered **in under two weeks**. That speed mattered less as an
engineering achievement than as a signal: it was the artifact that let
leadership, customers and the teams themselves see that the problem was
understood and the path out was real.
