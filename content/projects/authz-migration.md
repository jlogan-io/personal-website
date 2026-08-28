---
title: Access Service deprecation & AuthZ migration
role: Lead TPM
org: AWS
period: 2023 — 24
weight: 6
badges:
  - 500+ teams migrated
  - Zero unplanned downtime

summary: >-
  The retirement of AWS Security's legacy internal authorization system and the
  migration of its customers to scalable, next-generation AuthZ platforms.
highlights:
  - Orchestrated the phased sunset of the legacy service with zero unplanned downtime.
  - Partnered personally with 500+ service teams on migration strategies — resource-based or human-identity AuthZ.
  - Built reusable migration playbooks that accelerated onboarding to the modern authorization stack.

featured: true
kicker: AWS · 2023–24
home_title: AuthZ migration at scale
home_summary: >-
  A legacy Tier-1 access service retired; 500+ service teams moved to
  next-generation platforms with zero unplanned downtime.
---

AWS Security's Access Service was an internal authorization system that could
no longer meet modern scalability requirements. Retiring it was the easy half
of the sentence. The hard half was that more than five hundred service teams
depended on it, each with their own use case, and none of them had asked for a
migration.

## Sunsetting without an outage

I orchestrated the phased retirement of the legacy service, working with
engineering and operations to sequence the shutdown so that dependent services
moved before their dependency disappeared. The service was Tier-1: the standard
was **zero unplanned downtime**, and that is what it was retired with.

## Five hundred conversations

The migration strategy could not be a broadcast. I partnered personally with
**500+ AWS customer teams** to assess each one's authorization use case and
define a migration path to the right target:

- **Bindles** — resource-based authorization
- **TEAMS** — human-identity-based authorization

Which of the two applied was rarely obvious from the outside, and getting it
wrong meant a team migrating twice. Most of the program's real work was in
those assessments.

## Making the second hundred easier than the first

Doing five hundred bespoke migrations was not viable, so the patterns that
emerged were captured as a suite of reusable technical migration playbooks for
**BRASS** (Bindles Resource Authorization System Service), the API layer
supporting scalable authorization enforcement. Alongside the playbooks I
provided direct implementation support and integration guidance, which
accelerated onboarding onto the modern stack while keeping service
interruptions to a minimum.

Throughout, the program held cross-functional alignment with product owners,
software engineers and security architects to hit migration milestones and stay
compliant with AWS security standards.
