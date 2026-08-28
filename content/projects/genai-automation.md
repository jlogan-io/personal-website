---
title: GenAI program-management automation
role: Lead EPM & Engineer
org: CrowdStrike
period: Jan — May 2025
weight: 5
badges:
  - −85% manual reporting
  - RAG · Flask · MySQL

summary: >-
  Architected and built a GenAI-powered web application that automates
  program-management workflows by aggregating and analyzing operational data
  across engineering platforms.
highlights:
  - Python Flask + OpenAI API generating meeting notes, risk logs and status reports from program data.
  - Integrated Jira, Bitbucket, Confluence and Zoom transcripts to contextualize cross-team activity.
  - Retrieval-augmented generation over MySQL-persisted history — risks inferred, summaries on demand.
---

Program management generates an enormous amount of writing that nobody enjoys
producing: meeting notes, risk logs, status reports, the same update rewritten
for three different audiences. Most of the underlying information already
exists, scattered across the tools the work happens in. This was an attempt to
close that gap — architected and built end to end, rather than specified and
handed off.

## What it is

A secure internal Python Flask application using the OpenAI API to generate
meeting notes, risk logs and status reports from both structured and
unstructured program data. It ran inside CrowdStrike, on real programs, for
real reporting cycles.

## Where the data came from

The value depended entirely on grounding. The app integrated with:

- **Jira** — issues and epics, for the state of the work
- **Bitbucket** — pull requests and branches, for what engineering was actually doing
- **Confluence** — documentation, for decisions and context
- **Zoom** — meeting transcripts, pulled and processed automatically

Zoom mattered more than expected. Automatically ingesting transcripts into the
GenAI engine is what made summaries action-oriented rather than descriptive:
the model had access to what was said and decided, not only to what had been
typed into a ticket afterwards.

## Retrieval, not recall

**MySQL** persisted historical artifacts, summaries, risks and dashboard states,
which gave the system both traceability and a corpus. Retrieval-augmented
generation over that history is what let it infer risks and produce progress
summaries aligned to internal engineering objectives, and answer questions in
natural language rather than only emitting reports on a schedule.

## The result

Piloted across Platform Scale programs, it **reduced manual reporting effort by
85%** and gave stakeholders real-time visibility into program health. The
reporting that remained was the part that genuinely needed a program manager's
judgement, which was the point.
