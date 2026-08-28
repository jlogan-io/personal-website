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

CrowdStrike's core development stack lived in AWS. Establishing a second home
in Google Cloud Platform was a multi-year, multi-phase effort with a specific
end state: Edge Services running at scale in GCP, ingesting sensor data
efficiently as part of a hybrid architecture rather than a second copy of the
first one.

## Phase 1: the ground floor

Nothing could be onboarded until there was somewhere to onboard it to. Phase 1
migrated the AWS-based CI/CD infrastructure — Kubernetes clusters, deployment
pipelines and internal tooling — into GCP, and stood up **five environments**:
one development, one staging and three production. That gave the organization
full CI/CD deployment and testing capability in GCP before any customer-facing
service depended on it.

## Six months to under one

The headline result was deployment time for core infrastructure falling **from
six months to under one**. That came from working directly with engineering
teams on three things: streamlining provisioning workflows, optimizing pipeline
automation, and removing the manual bottlenecks that had accumulated in the
existing process. None of the three was dramatic on its own; the compounding is
where the number came from.

## Phase 2: Edge Services

With the foundation in place, focus shifted to onboarding the services that
actually meet customer traffic — sensor data ingestion, third-party data
ingestion, and the custom networking underneath both — into the hybrid
architecture.

## Coordination as the real work

Execution ran across TechOps, Platform Features, Platform Scale, ProdSec,
InfoSec and Sensor, spread over multiple time zones, with interdependencies
that did not respect team boundaries. I drove that coordination, partnered with
GCP leadership directly to resolve integration blockers and align technical
strategy, and worked with internal VPs and Directors to shape roadmap
priorities, sequence the phased migration and align resource planning across
the platform and infrastructure groups.
