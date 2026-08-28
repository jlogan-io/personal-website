---
title: "Nobody asked for this"
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
description: Getting a PMO to adopt a tool it never requested, and the features nobody touched.
---

No one asked me to build CoPlay. There was no ticket, no mandate, and no
stakeholder waiting for a demo. I built it because the coordination tax on my
own week had become unsustainable, and then I had the more interesting problem
of finding out whether anyone else wanted it.

Program management is the discipline of getting things adopted across teams that
did not ask. It was slightly humbling to discover how little that helped when
the thing being adopted was mine.

## Why a demo does not work

My instinct was to show people. Book time, walk through the capabilities,
demonstrate the status report generating itself in seven minutes instead of
however long it usually took.

Demos produce enthusiasm and no behaviour change. People would say it looked
genuinely useful, mean it sincerely, and then not use it. The gap is not
scepticism. It is that adopting a tool means changing a routine that currently
works, and a demo gives someone a reason to be impressed without giving them a
reason to change on Tuesday morning.

What actually moved people was narrower. I stopped showing the system and
started asking what part of their week they most resented. Then I set up the one
capability that addressed it, on their programs, with their data, and left them
alone.

## Partial adoption is the only kind

I had built thirty-seven modular capabilities imagining that a portfolio would
adopt a coherent set of them. In practice every portfolio that came on board
adopted between two and four, and each picked a different two to four.

That was initially frustrating. It stopped being frustrating when I noticed the
alternative was adopting zero. A tool that requires wholesale commitment gets
evaluated as a decision, and decisions get deferred. A tool that solves one
irritating thing this week gets tried.

The modularity I had built for architectural reasons turned out to matter for
entirely organisational ones. That was luck rather than foresight, and I would
now design for it deliberately.

## The features nobody touched

A fair number of the thirty-seven have never been meaningfully used. Some of that
is discoverability, but most of it is that I built things which were interesting
to build rather than things which were annoying to do by hand.

The capabilities that got used share a shape. They take something a person did
every week, that they disliked, that had a clear correct answer, and that they
could check quickly. Status report drafting fits all four. So does action item
extraction, which is why the capture rate ended up being the number worth
measuring.

The ones that went unused tended to fail the last condition. If verifying the
output takes as long as producing it, nobody uses it twice, no matter how clever
it is.

## Trust is earned per-portfolio

The thing I underestimated most was that trust does not transfer. A portfolio
seeing the assistant work well for a neighbouring portfolio does not conclude
that it will work for them. They conclude that it worked over there.

Every portfolio ran its own informal trial where someone checked the output by
hand for a few weeks before relying on it. That is entirely rational, and it
means the adoption curve is not a curve at all. It is fourteen separate small
curves, each starting from zero.

Budgeting for that changed how I introduced it. Instead of a rollout I planned
for a series of first weeks, and made it as easy as possible for someone to
verify the assistant against reality while they still did not believe it.

## What I would tell another program manager

Build it for yourself, prove it on your own work, and then expect to spend
considerably more effort on adoption than on engineering. Not because people are
resistant, but because you are asking them to change something that currently
functions, on the strength of a promise, using a tool that occasionally gets
things wrong.

The engineering is the part you control. The adoption is the part that decides
whether any of it mattered.
