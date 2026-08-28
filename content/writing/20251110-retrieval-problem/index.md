---
title: "24,500 documents and the retrieval problem"
date: 2025-11-10
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - RAG
  - CoPlay
  - Program Management
toc: true
draft: true
description: An assistant that cites the program in front of it, rather than its impression of how programs usually go.
---

The thing that makes an AI assistant useful inside a program management office
is not the model. It is whether the answer came from your program or from the
model's general sense of how programs tend to go.

Those two failure modes look identical on screen. Both produce fluent, plausible
paragraphs in the right register. Only one of them is about your work.

## Why the general answer is worse than no answer

If you ask a model with no grounding what the risks are on a platform migration,
it will tell you. The answer will be reasonable. It will mention dependency
sequencing, environment parity, and rollback planning, and it will be the same
answer for every platform migration anyone has ever run.

That is worse than silence, because it is shaped like insight. A program manager
skimming it can easily come away feeling informed. Nothing in the text signals
that the model has never seen their program.

So the entire design problem became grounding: making sure every claim traces
back to something in the corpus, and making it visible when it does not.

## The corpus

I point retrieval at roughly 24,500 documents spanning fourteen portfolios.
Meeting transcripts, tickets, documentation, status history. It is not a tidy
dataset. It is the accumulated exhaust of real programs, written by dozens of
people who had no expectation that anything would ever read it systematically.

Two things about that corpus shaped every decision I made downstream.

The first is that most of it is conversational. Meeting transcripts are not
documents. They are people interrupting each other, revisiting decisions, and
saying "we'll circle back" a great deal. Chunking that the way you would chunk a
specification produces fragments that are locally coherent and globally
meaningless.

The second is that recency matters more than similarity. A decision from last
Tuesday supersedes a decision from March, and a naive similarity search has no
idea that happened. It will happily retrieve both and let the model average
them.

## What I got wrong early

My first retrieval implementation optimised for the wrong thing. It was good at
finding passages that resembled the question, which is what the textbook tells
you to build, and bad at finding the passage that answered it.

The symptom was subtle. Answers were not wrong exactly. They were dated, or they
reflected the loudest voice in a meeting rather than the decision that came out
of it. That took a while to notice precisely because nothing looked broken.

What eventually helped was when I stopped relying on text similarity alone and
started treating the program's own structure as a retrieval signal. A ticket knows which epic
it belongs to. A meeting knows which portfolio convened it. A status report
knows what it superseded. That structure is free, it is already correct, and
using it narrowed the search space before similarity ever got involved.

## Making the grounding visible

The other half was refusing to hide uncertainty. If the assistant could not find
support for a claim in the corpus, the useful behaviour was to say so rather
than to fill the gap plausibly.

That is harder than it sounds, because a model asked to be careful tends to
become vague, and vague is its own kind of useless. What worked better for me
was attribution. I show which sources a summary drew on, so a reader can check
the one claim they doubt without re-reading the week.

The measurable version of this became the faithfulness audit in the capstone
evaluation, which grades output against the sources it claims to draw from. I
will write about that separately. The short version is that you cannot claim an
assistant is grounded unless you have tried, in good faith, to catch it not
being.

## The part worth keeping

Most of the engineering effort on this project went into retrieval, and almost
none of the interesting decisions were about the model. If I were starting again
I would spend even more of the budget there.

An ungrounded assistant is a very expensive way to generate text that sounds
like your job.
