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
description: The unit economics of agentic tooling, which is the first question anyone senior actually asks.
---

Every time I have shown an AI tool to an engineering leader, the second question
has been some version of "what does it cost to run". Almost nobody writing about
agentic systems answers it, which is strange, because it is the question that
decides whether the thing gets funded.

A completed agent run on CoPlay costs about 58 cents.

## What a run is

A run is one full pass of a capability over a real program: gathering the
relevant material, retrieving what matters, generating the output, and checking
it. A status report is a run. Extracting the action items from a week of
meetings is a run.

The unit matters more than the number. Cost per token is meaningless to anyone
making a decision, because nobody budgets in tokens. Cost per status report is
something a manager can reason about immediately, because they know how many
status reports their organisation produces.

## Where the money goes

The generation step is not the expensive part, which surprised me when I first
broke it down. Retrieval is.

A single run touches far more of the corpus than it uses. It has to, because
finding the right context means looking at a lot of context that turns out to be
wrong. Every document considered and discarded is paid for. The output people
actually see is the cheapest thing in the pipeline.

The second largest cost was rework. Early on, a meaningful share of runs
produced something that needed regenerating, usually because retrieval had
surfaced stale material. A run that has to happen twice costs twice, and that
does not appear anywhere in a pricing page.

## What brought it down

Three changes, in order of how much they mattered.

Narrowing the search space using program structure before similarity ever gets
involved. A ticket knows its epic; a meeting knows its portfolio. Using that to
cut candidates cheaply meant paying the model to consider far less.

Caching what does not change. A portfolio's structure, its standing
participants, its glossary of internal names. These get retrieved constantly
and change rarely, so I treat them as fixed context rather than fetching them
per run, which removed a surprising amount of repeated spend.

Failing earlier. If a run cannot find adequate grounding, the cheapest thing it
can do is stop and say so. That is also the most useful thing it can do, which
is a rare case of the honest behaviour and the economical behaviour being the
same behaviour.

## Why the number is worth publishing

At 58 cents, a portfolio generating a weekly status report spends about thirty
dollars a year on that capability. Whatever you think a program manager's hour
is worth, the arithmetic is not close.

That is the actual argument, and it only works if you know the number. Without
it, "we should use AI for reporting" is a matter of taste, and the conversation
turns on whoever is most enthusiastic. With it, the conversation turns on
whether the assistant's output is good enough to rely on, which is the question
that deserves the attention.

I would rather argue about quality than about whether the idea is sensible.

## The caveat

Unit cost is the easy part of the economics. It does not include the time I
spent building it, the time other people spent verifying it before they trusted
it, or the cost of the runs that produced something nobody used.

If I costed those honestly the number would be much larger and much less
flattering, which is exactly why the capstone evaluation includes a derived
time-savings model rather than stopping at cost per run. A tool that is cheap to
operate and expensive to trust is not cheap.
