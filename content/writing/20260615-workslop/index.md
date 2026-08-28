---
title: "Workslop, and the number I could not defend"
date: 2026-06-15
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - CoPlay
  - Evaluation
  - Program Management
toc: true
draft: true
description: A 92% time saving with no quality check behind it is evidence of speed, not value.
---

The most impressive number this project produced is an aggregate time saving of
about 92%. It is also the number I trust least, and I want to explain why,
because the reasoning generalises well beyond this tool.

## Where 92% comes from

The derived model compares measured system turnaround against human authoring
effort inferred from word count. Across 191 artifacts and roughly 490,015 words,
at an assumed 400 words per hour, it gives about 1,225 estimated human hours
against 103 measured hours.

Three things make that an upper bound rather than a result.

It rests on one adjustable assumption. The industry range for authoring speed is
somewhere between 300 and 500 words per hour, and where you sit in that range
moves the headline considerably.

It compares unlike quantities. Human writing effort against elapsed system time
that includes deliberation is not a clean comparison.

And most importantly, no independent quality check stands behind it. The model
measures how fast text appeared. It says nothing about whether the text was any
good.

## Workslop

There is a term for the failure mode this exposes. Niederhoffer and colleagues
describe workslop as AI output that appears polished while carrying little real
signal, produced when generated content gets chained or pasted forward with
minimal human oversight.

The damage is not that it is bad. It is that it is plausible. Workslop can mask
coordination problems rather than solve them, and it can reduce net productivity
even while time-on-task falls. Every efficiency number gets better. The work
gets worse.

Which means a time-savings figure without an independent quality measure is
evidence of speed, not of value. That sentence is the whole argument, and it
applies to every AI efficiency claim I have seen presented internally at any
company I have worked for.

## Where the exposure actually sits

Automation did not land evenly across the work, and the uneven part is where the
risk concentrates.

Meeting preparation is effectively eliminated, running 95.7% zero-touch across
351 conversations. Meeting notes generate in a mean of 1.65 minutes. Those are
low-risk: the output is checkable in seconds and the cost of an error is small.

Status reporting is accelerated but not eliminated, at a median of 7.7 minutes.

Document authoring remains essentially human, at a mean of 48.8 minutes. That is
the largest untouched pool of time, and therefore the most tempting thing to
automate next. It is also where workslop exposure is highest, because a
consequential document is exactly the artifact whose errors travel furthest.

We deferred building that capability. Not because we ran out of time, but
because a mediocre automated draft of a consequential document is worse than no
draft at all.

## Measuring it instead

The capability we built instead grades generated artifacts against the source
chunks they claim to draw from. It is less visible than a new feature and it was
ranked highest by the decision analysis anyway, which was the clearest sign the
analysis was doing real work.

It is still in progress. 87 documents have been graded so far against a target
of 90% grounding, which is a fraction of the 535 stored artifacts, and the
labeled evaluation set is still being assembled. I am not going to claim the
indicator is met.

What the early results do establish is that the measurement is tractable and
that variation in grounding quality is real. Grading scores show essentially no
relationship to retrieval depth, with r = -0.069, which means grounding quality
is a property of the output rather than a function of how much context got
pulled in. You cannot fix faithfulness by retrieving harder.

## Why publish this

There is an obvious argument against writing it down. I built the thing, I have
quoted its numbers publicly, and cataloguing its weakest claim in the same voice
undercuts the pitch.

I think the opposite is true. An evaluation that produces only favourable
numbers is not an evaluation. It is marketing with a methodology section. The
94.3% action-item capture rate is worth something precisely because the 92% sits
next to it wearing a warning label.

The wider version concerns me more than the tool does. Organisations are
adopting AI into management workflows considerably faster than they are building
any capacity to judge whether it works. If the only people who understand the
failure modes are the people who built the systems, and those same people are
making the case for adoption, that is not a healthy arrangement.

So: 92%, as an upper bound, with the quality check still being built. That is
the honest version.
