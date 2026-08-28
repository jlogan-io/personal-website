---
title: "24,500 documents, and where they live"
date: 2025-11-10
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - RAG
  - CoPlay
  - SQLite
toc: true
draft: true
description: Retrieval that never leaves the machine, and why that constraint made the design better.
---

The thing that makes an AI assistant useful inside a program management office
is not the model. It is whether the answer came from your program or from the
model's general sense of how programs tend to go.

Those two failure modes look identical on screen. Both produce fluent, plausible
paragraphs in the right register. Only one of them is about your work.

## Why the general answer is worse than silence

Ask a model with no grounding what the risks are on a platform migration and it
will tell you. The answer will be reasonable. It will mention dependency
sequencing, environment parity and rollback planning, and it will be the same
answer for every platform migration anyone has ever run.

That is worse than silence, because it is shaped like insight. Someone skimming
it can come away feeling informed. Nothing in the text signals that the model has
never seen their program.

So the design problem became grounding, and grounding turned into an
architecture problem faster than I expected.

## The constraint that shaped everything

CoPlay is a desktop application, and program data stays on the user's machine.
That was not an aesthetic preference. In an enterprise PMO, "where does our
program data go" is the first question asked and the one most likely to end the
conversation.

Holding that line ruled out the obvious retrieval stack. No managed vector
database, no embedding service holding a copy of the corpus, no pipeline
shipping meeting transcripts somewhere for indexing.

What I ended up with instead: documents chunked and embedded with Amazon Titan,
with the vectors stored in the same local SQLite database as everything else
using sqlite-vec. Semantic search happens against a file on the user's disk.
Roughly 24,500 source documents become about 71,847 retrievable chunks, and none
of them leave. Only the retrieved context and the question go out to the model
on AWS Bedrock.

The constraint made the system simpler. There is one datastore, it is a file,
and backing it up is copying it.

## Retrieval is two steps, not one

The naive version of retrieval finds passages resembling the question. That is
what the tutorials build and it is not good enough, because resembling the
question and answering it are different properties.

The symptom is subtle. Answers are not wrong exactly. They are dated, or they
reflect the loudest voice in a meeting rather than the decision that came out of
it. Nothing looks broken, which is why it took me a while to see.

What helped was adding a reranking step: retrieve generously on similarity, then
score that candidate set properly before anything reaches the model. The first
pass is cheap and approximate. The second is expensive and picky, and it only
runs on a few dozen candidates rather than seventy thousand.

The corpus also has structure worth using before similarity gets involved at
all. A ticket knows its epic. A meeting knows its portfolio. A status report
knows what it superseded. That structure is free and already correct.

## The corpus is not a dataset

Two things about this material shaped every decision downstream.

Most of it is conversational. Meeting transcripts are not documents. They are
people interrupting each other, revisiting decisions and saying "we'll circle
back" a great deal. Chunking that the way you would chunk a specification gives
you fragments that are locally coherent and globally meaningless.

And recency is not the same as relevance, but it is not independent of it
either. A decision from last Tuesday supersedes one from March, and pure
similarity search has no idea that happened. It will retrieve both and let the
model average them.

## Making the grounding visible

The other half of this is refusing to hide uncertainty. If the assistant cannot
find support for a claim, the useful behaviour is to say so rather than fill the
gap plausibly.

That is harder than it sounds, because a model asked to be careful becomes
vague, and vague is its own kind of useless. What worked better was attribution.
Show which sources a summary drew on, so a reader can check the one claim they
doubt without re-reading the week.

That turned out to matter for a reason I had not anticipated. Traceability, not
accuracy alone, is what makes people willing to rely on the thing. Being right is
not sufficient if nobody can check.

The measurable version of this became a faithfulness audit that grades generated
artifacts against the source chunks they claim to draw from. I will write about
that separately, because the result is more interesting than the mechanism.

## What I would keep

Almost all the engineering effort went into retrieval, and almost none of the
interesting decisions were about the model. If I started again I would spend
even more of the budget there.

An ungrounded assistant is an expensive way to generate text that sounds like
your job.
