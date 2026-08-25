---
author: Jonathan Logan
title: Projects
date: 2025-05-21
description: Professional Projects
contact: false
menus:
  main:
    name: Projects
    weight: 300
---

Welcome to my professional project portfolio—a showcase of the high-impact programs I’ve led across cybersecurity, cloud infrastructure, AI tooling, and defense. From navigating a global outage at CrowdStrike with urgency and precision, to building scalable cloud infrastructure in GCP, pioneering GenAI-powered program automation, and driving large-scale authorization migrations at AWS, each initiative reflects my commitment to technical excellence, cross-functional alignment, and strategic execution. Whether managing mission-critical systems for national defense or delivering AI-integrated solutions for modern enterprises, I lead with clarity, resilience, and a deep understanding of complex systems at scale.

## CrowdStrike July 19th Incident Response
### Lead Engineering Program Manager / CrowdStrike
#### August 2024

Led the cross-functional response to a critical global outage stemming from a misconfigured Sensor Channel File, which impacted customers worldwide on July 19th 2024. This high-priority initiative re-architected the Channel File deployment process to increase safety, transparency, and automation.

- **Directed and Defined** execution across multiple cross-functional teams, including Legal, TechOps, Platform Features, Platform Scale, ProdSec, InfoSec, Data Science, Detection Platform, and Sensor.

- Partnered with VPs and executive leadership to **rapidly reprioritize company-wide engineering backlogs**, enabling expedited implementation of a hardened continuous deployment (CD) pipeline for Channel Files.

- **Defined the delivery roadmap** of a new ring-based deployment model to gradually and safely roll out Channel Files to customer environments.

- **Maintained deep technical fluency** in CrowdStrike’s sensor architecture and cloud infrastructure to align program execution with long-term platform strategy.

- Delivered initial remediation, design validation, and production implementation roadmaps **in under two weeks**, restoring customer trust and mitigating future risk.



## CrowdStrike in GCP
### Lead Engineering Program Manager / CrowdStrike
#### March 2024 to May 2025
Led a multi-year, multi-phase initiative to establish CrowdStrike’s core cloud infrastructure in Google Cloud Platform (GCP), enabling Edge Services to run at scale and ingest sensor data efficiently. This strategic effort began with migrating CrowdStrike’s AWS-based CI/CD infrastructure—including Kubernetes clusters, deployment pipelines, and internal tooling—into GCP. Once foundational environments were established, focus shifted to onboarding critical Edge Services such as Sensor data ingestion, 3rd party data ingestion, and custom networking into CrowdStrike’s hybrid cloud architecture.

- Reduced core infrastructure deployment times **from 6 months to under 1 month** by working closely with engineering teams to streamline provisioning workflows, optimize pipeline automation, and remove manual deployment bottlenecks.

- **Drove cross-functional execution** across TechOps, Platform Features, Platform Scale, ProdSec, InfoSec, and Sensor teams, coordinating technical delivery and interdependencies across multiple time zones.

- Established 1 development, 1 staging, and 3 production GCP environments as part of Phase 1, enabling full CI/CD deployment and testing capability in GCP.

- **Partnered with GCP leadership** to resolve integration blockers, align technical strategy, and provide regular delivery updates to CrowdStrike and Google executive stakeholders.

- Collaborated with internal VPs and Directors to **shape roadmap priorities**, sequence phased migrations, and align resource planning across platform and infrastructure groups.

## GenAI-Enabled Program Management Automation Tool
### Lead Engineering Program Manager and Lead Engineer / CrowdStrike
#### Jan 2025 - May 2025
Led the architecture and delivery of a GenAI-powered Flask web application that automated key program management workflows by aggregating and analyzing operational data across engineering platforms.

- Developed a secure internal Python Flask app that leveraged the OpenAI API to generate meeting notes, risk logs, and status reports from structured and unstructured program data

- Integrated with Jira (issues, epics), Bitbucket (PRs, branches), Confluence (documentation), and Zoom (meeting transcripts) to ingest and contextualize cross-functional team activity

- Leveraged Zoom to automatically pull and process meeting transcripts into the GenAI engine for accurate, action-oriented summaries and decision tracking

- Employed MySQL for persistent storage of historical artifacts, summaries, risks, and dashboard states to support traceability and reporting

- Enabled natural language interaction and retrieval-augmented generation (RAG) to infer risks and generate progress summaries aligned with internal engineering objectives

- Piloted across Platform Scale programs, reducing manual reporting efforts by 85% and enabling real-time program health visibility across stakeholders

## Access Service Deprecation & AuthZ Migration Program
### Lead Technical Program Manager / Amazon Web Services
#### Mar 2023 - Mar 2024
Led the deprecation and replacement of AWS Security’s legacy Access Service—an internal authorization (AuthZ) system unable to meet modern scalability requirements. I spearheaded the customer migration strategy across 500+ service teams, ensuring seamless transitions to scalable, next-generation AuthZ platforms. My role required deep technical engagement with customer teams, system architecture knowledge, and hands-on support in designing and executing individualized migration plans.

- Orchestrated the phased retirement of the legacy Access Service, collaborating with engineering and operations teams to sunset the service with zero unplanned downtime.

- Personally partnered with 500+ AWS customers to assess their unique AuthZ use cases and define migration strategies tailored to either Bindles (resource-based AuthZ) or TEAMS (human identity-based AuthZ).

- Developed and maintained a suite of reusable technical migration playbooks to streamline adoption of BRASS (Bindles Resource Authorization System Service), the API layer supporting scalable AuthZ enforcement.

- Provided direct implementation support and integration guidance, accelerating customer onboarding to the modern authorization stack while minimizing service interruptions.

- Drove cross-functional alignment with product owners, software engineers, and security architects to meet migration milestones and maintain compliance with AWS security standards.

## F-22 Sustainment & Repairs Program
### Lead Program Manager / Northrop Grumman 
#### Nov 2020 - Mar 2022
As the lead Program Manager for Northrop Grumman’s F-22 Repairs Line, I oversaw a complex, multi-year, multimillion-dollar effort to maintain and repair advanced avionics systems—specifically software-defined radios and power amplifier modules—for Lockheed Martin and the U.S. Air Force. I led cross-functional teams, negotiated high-value defense contracts, and served as the principal interface with senior customer stakeholders, while maintaining direct accountability for profit and loss reporting to company executive leadership.

- Directed execution of the F-22 software-defined radio and power amplifier module repairs, aligning engineering, production, and logistics across internal and external partners.

- Served as the primary customer interface with Lockheed Martin, overseeing technical program delivery and managing weekly performance reporting.

- Wrote, proposed, and negotiated a $25M follow-on 5-year repair contract, securing long-term revenue and expanding the program’s strategic footprint.

- Reported Earned Value Management (EVM), schedule performance, and program profitability to Northrop Grumman VP leadership, ensuring transparent and accurate forecasting.

- Led diverse engineering teams and cross-functional stakeholders to meet repair timelines, reduce operational bottlenecks, and deliver consistently high-quality outputs.