---
title: "58 cents a run"
date: 2026-04-20
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - CoPlay
  - Program Management
  - Cost
toc: true
draft: true
description: What agentic tooling actually costs to operate, and what drives the variance.
---

Every time I have shown an AI tool to an engineering leader, the second question
has been some version of "what does it cost to run". Almost nobody writing about
agentic systems answers it, which is odd, because it is the question that
decides whether the thing gets funded.

Across the measured period CoPlay spent $423.22 in total, at $0.58 per completed
agent run.

## Why the unit matters more than the number

Cost per token is meaningless to anyone making a decision, because nobody
budgets in tokens. Cost per completed run is something a manager can reason
about immediately, because they know roughly how many status reports their
organisation produces in a month.

A run is one full pass of a capability over a real program: gathering the
relevant material, retrieving what matters, generating the output, and checking
it. A status report is a run. Extracting the action items from a week of
meetings is a run.

## What actually drives the cost

I assumed the answer would be retrieval, since a single run considers far more
of the corpus than it uses. I was wrong, and I only found out because I ran the
regression rather than trusting the intuition.

Regressing cost on agent iterations across 637 runs gives a slope of $0.0302 per
iteration, with r = 0.646 and an R-squared of 0.418. So iteration count explains
about 42% of the variance in what a run costs. The rest is prompt size, tool
calls and model routing.

That 42% is the useful part. It says the expensive runs are the ones that go
around the loop repeatedly, and it says something like 58% of the variance sits
somewhere I had not instrumented well enough to attribute. Both of those are
worth knowing, and neither is what I would have guessed.

It is worth stating plainly that this is association, not causation. More
iterations correlate with higher cost. Whether the iterations cause the cost or
both follow from the task being harder is not something a regression on
operational telemetry can settle.

## The bimodal problem

Status reporting has a median turnaround of 7.7 minutes. It also has a mean of
30.0 and a ninetieth percentile of 82.1, which tells you the distribution is not
remotely normal.

Splitting it apart: 22 single-turn requests resolved in about 0.9 minutes, while
40 iterated reports averaged 46.0 minutes across 11.3 exchanges. Those are two
different activities wearing the same name. Averaging across them describes
neither.

The cost story follows the same split, because iterations are what cost money. A
one-shot report is nearly free. A report someone argues with for eleven turns is
not, and it is also the one most likely to be genuinely useful, because the
arguing is where the judgement went in.

I do not think that is a problem to optimise away. It is a description of two
different jobs.

## What agent runs actually succeed at

Agent runs succeed 86.1% of the time. The remaining 14% is not evenly
distributed either: ingestion jobs fail at elevated rates from authentication
churn, which is a plumbing problem rather than a model problem.

That distinction matters for cost, because a failed ingestion means retrieval
runs against a stale corpus, and a well-generated answer over stale material is
the most expensive kind of wrong. It costs the same as a good one and takes
longer to catch.

Replacing static API keys with delegated authorization through MCP is on the
roadmap for exactly this reason.

## Why publish the number

At 58 cents, a portfolio generating a weekly status report spends about thirty
dollars a year on that capability. Whatever you think a program manager's hour
is worth, the arithmetic is not close.

That is the actual argument, and it only works if you know the number. Without
it, "we should use AI for reporting" is a matter of taste and the conversation
turns on whoever is most enthusiastic. With it, the conversation turns on
whether the output is good enough to rely on, which is the question that
deserves the attention.

I would rather argue about quality than about whether the idea is sensible.

## The caveat that matters

Unit cost is the easy part of the economics. It excludes the time I spent
building the thing, the time other people spent verifying it before they trusted
it, and the runs that produced something nobody used.

Costed honestly, the number is much larger and much less flattering. Which is
why the capstone evaluation pairs it with a derived time-savings model and a
faithfulness check rather than stopping at cost per run. A tool that is cheap to
operate and expensive to trust is not cheap.
