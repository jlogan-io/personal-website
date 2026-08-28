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
of that sentence. The hard half was that more than five hundred service teams
depended on it, each with their own use case, and not one of them had asked for
a migration.

## Sunsetting without an outage

I ran the phased retirement of the legacy service, working with engineering and
operations to sequence the shutdown so that every dependent service moved
before its dependency disappeared. The service was Tier-1, so the standard was
zero unplanned downtime. That is what it was retired with.

## Five hundred conversations

There was no version of this that worked as a broadcast. I sat down with more than 500 AWS customer teams, assessed each one's
authorization use case, and defined a migration path to the right target. That meant Bindles for
resource-based authorization, or TEAMS for human-identity-based authorization.

Which of the two applied was rarely obvious from the outside, and getting it
wrong meant a team migrating twice. Most of the program's real work lived in
those assessments.

## Making the second hundred easier than the first

Five hundred bespoke migrations was never going to work, so I captured the
patterns as a set of reusable technical playbooks for BRASS, the API layer
supporting scalable authorization enforcement. Alongside the playbooks I gave
teams direct implementation support and integration guidance, which sped up
onboarding onto the modern stack and kept service interruptions small.

Throughout, I held alignment across product owners, software engineers and
security architects, so we hit the migration milestones without drifting out of
compliance with AWS security standards.
