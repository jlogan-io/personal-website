---
title: "Driving Adoption of a Tool Nobody Requested"
date: 2026-02-09
author: Jonathan Logan
category:
  - Blog
tag:
  - Program Management
  - AI
  - CoPlay
  - Leadership
toc: true
draft: true
description: The hardest risks on this project were organizational, not technical.
---

No one asked me to build CoPlay. There was no ticket, no mandate, and no
stakeholder waiting for a demo. I built it because the coordination tax on my
own week had become unsustainable, and then I had the more interesting problem
of finding out whether anyone else wanted it.

Program management is the discipline of getting things adopted across teams that
did not ask for them. It was mildly humbling to discover how little that helped
when the thing being adopted was mine.

## The risk changed character twice

When we kept a risk register for this project, the most instructive thing in it
was not any individual entry. It was that the dominant risk moved twice.

Early on the dominant risk was technical feasibility, and an already-working
prototype retired most of it. That is the advantage of starting from something
operational rather than a proposal.

What replaced it was organisational. Program managers unconvinced that an
assistant supports rather than supplants their judgement represent a threat that
no amount of engineering resolves. You cannot ship your way out of someone
believing the tool is there to do their job rather than the tedious parts of it.

By the fifth week the dominant risk had moved again, to evidentiary credibility.
A time-savings claim with no quality check behind it is vulnerable on exactly the
grounds the research literature identifies, and being vulnerable there would have
undone the adoption work regardless of how good the tool was.

Three different risks. Only the first one was about software.

## Why a demo does not work

My instinct was to show people. Book time, walk through the capabilities,
generate a status report in front of them.

Demos produce enthusiasm and no behaviour change. People would say it looked
genuinely useful, mean it, and then not use it. The gap is not scepticism. It is
that adopting a tool means changing a routine that currently works, and a demo
gives someone a reason to be impressed without giving them a reason to change on
Tuesday morning.

We ended up structuring the adoption work around ADKAR, which sounds more formal
than it felt. The useful part was that it moved the operative question from what
we were building to how someone would actually change their behaviour. A
stakeholder presentation builds awareness. A live demonstration against the
user's own workflow builds desire, which is different from a demo against mine.
Onboarding supplies knowledge and ability. Feedback channels provide the
reinforcement that decides whether week three happens.

Twenty four people used the beta. That number is small enough that every one of
them was a conversation.

## Traceability is the trust lever

The single most useful thing anyone told me came out of a peer review in week
four: the lever is traceability, not accuracy.

I had been treating trust as a function of being right. Get the output good
enough and people will rely on it. That is wrong, or at least insufficient.
People rely on things they can check. An assistant that is right 95% of the time
and offers no way to verify any particular claim is less usable than one that is
right 90% of the time and shows its sources, because the second one lets a
program manager spend thirty seconds confirming the bit they doubt.

That reframed the faithfulness work entirely. Grading output against its sources
started as quality assurance. It turned out to be a change management mechanism,
because citable grounding is what lets someone verify rather than believe.

## What the executive review asked about

The first external gate was an executive review in July. The questions were not
about capability. They were about data privacy, output reliability, and workflow
integration, in that order.

That ordering is worth sitting with. Nobody asked whether it could write a status
report. They asked where the program data went, how they would know when it was
wrong, and what it would break.

Those became the change management agenda for the rest of the project, and two
of the three were already answered by architecture decisions made much earlier
for different reasons. Keeping program data local stopped being a technical
preference and became the answer to the first question anyone senior asked.

## What I would tell another program manager

Build it for yourself, prove it on your own work, and then expect to spend more
effort on adoption than on engineering. Not because people are resistant, but
because you are asking them to change something that currently functions, on the
strength of a promise, using a tool that sometimes gets things wrong.

The engineering is the part you control. The adoption is the part that decides
whether any of it mattered.
