---
title: CrowdStrike in GCP
role: Lead EPM
org: CrowdStrike
period: 2024 — 25
weight: 4
badges:
  - "Deploys: 6 mo → under 1 mo"
  - 5 environments

summary: >-
  A multi-year, multi-phase initiative establishing CrowdStrike's core cloud
  infrastructure in Google Cloud Platform — CI/CD first, then Edge Services
  ingesting sensor data at scale in a hybrid architecture.
highlights:
  - Migrated AWS-based CI/CD — Kubernetes clusters, pipelines, internal tooling — into GCP, standing up five environments in Phase 1.
  - Cut core infrastructure deployment from six months to under one by streamlining provisioning and automation.
  - Aligned CrowdStrike and Google executive stakeholders on strategy, blockers and delivery.

featured: true
kicker: CrowdStrike · 2024–25
home_summary: >-
  Core cloud stood up in Google Cloud Platform — CI/CD, Kubernetes and Edge
  Services. Deploy times fell from six months to under one.
---

CrowdStrike's core development stack lived in AWS. Building a second home in
Google Cloud Platform was a multi-year effort with a specific end state: Edge
Services running at scale in GCP, ingesting sensor data efficiently as part of
a hybrid architecture rather than a second copy of the first one.

## Phase 1: the ground floor

Nothing could be onboarded until there was somewhere to onboard it to. In Phase 1 I drove the move of our AWS-based CI/CD infrastructure into GCP,
including the Kubernetes clusters, the deployment pipelines and the internal
tooling. We stood up five environments: one development, one staging, and
three production. That gave the
organization full CI/CD and testing capability in GCP before any
customer-facing service depended on it.

## Six months to under one

Deployment time for core infrastructure fell from six months to under one. I got there by working directly with engineering teams on three unglamorous
things: streamlining provisioning workflows, optimizing pipeline automation,
and removing the manual bottlenecks that had built up in the existing process.
None of them was dramatic on its own. The compounding is where the number came from.

## Phase 2: Edge Services

With the foundation in place, I shifted focus to the services that actually
meet customer traffic. We onboarded sensor data ingestion, third-party data
ingestion, and the custom networking underneath both into the hybrid
architecture.

## Coordination was the real work

Execution ran across TechOps, Platform Features, Platform Scale, ProdSec,
InfoSec and Sensor, spread over multiple time zones, with dependencies that did
not respect team boundaries. I drove that coordination day to day. I also
worked directly with GCP leadership to clear integration blockers and align
technical strategy, and with our own VPs and Directors to shape roadmap
priorities, sequence the phased migration, and plan resourcing across the
platform and infrastructure groups.
