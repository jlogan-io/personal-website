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

Program management produces a lot of writing nobody enjoys producing. Meeting
notes, risk logs, status reports, the same update rewritten for three different
audiences. Most of the underlying information already exists, scattered across
the tools where the work actually happens. I built this to close that gap. I
architected it and wrote it, rather than specifying it and handing it off.

## What it is

I wrote a secure internal Python Flask application that uses the OpenAI API to
generate meeting notes, risk logs and status reports from program data, both
structured and unstructured. It ran inside CrowdStrike, on real programs, through real
reporting cycles.

## Where the data came from

The whole thing depended on grounding, so I pulled from four sources:

- **Jira** for issues and epics, so it knew the state of the work
- **Bitbucket** for pull requests and branches, so it knew what engineering was really doing
- **Confluence** for documentation, decisions and context
- **Zoom** for meeting transcripts, pulled and processed automatically

Zoom mattered more than I expected. Ingesting transcripts automatically is what
made the summaries action-oriented instead of merely descriptive. The model
could see what was said and decided, not just what someone typed into a ticket
afterwards.

## Retrieval, not recall

I used MySQL to hold the historical artifacts, summaries, risks and dashboard
states, which gave the system traceability and, more usefully, a corpus. Running
retrieval-augmented generation over that history is what let it infer risks,
produce progress summaries tied to real engineering objectives, and answer
questions in plain language instead of only emitting reports on a schedule.

## The result

We piloted it across Platform Scale programs. It cut manual reporting effort by
85% and gave stakeholders real-time visibility into program health. The
reporting that remained was the part that genuinely needed a program manager's
judgement, which was always the point.
