---
title: "What it still gets wrong"
date: 2026-06-15
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - CoPlay
  - Program Management
  - Evaluation
toc: true
draft: true
description: The 5.7% is not random, and publishing the limitations is what makes the rest believable.
---

CoPlay captures 94.3% of tracked action items automatically. I have quoted that
number in a few places now, and it is accurate.

It is also the less interesting half of the sentence. The part worth writing
about is the 5.7%, because that share is not randomly distributed. It has a
shape, and the shape tells you where an assistant like this stops being useful.

## The misses are not random

If the failures were spread evenly across meetings and portfolios, the fix would
be a better model and the number would improve on its own over time. That is not
what the data showed.

The misses cluster around commitments that were never stated as commitments. A
meeting where someone says "I'll take a look at that" and everyone present
understands it as ownership. There is no verb the extractor can key on, no
assignee, and often no object. A human in the room knows an action item was
created. The transcript does not contain one.

They also cluster around decisions that got made by not being objected to.
Silence is meaningful in a program review and completely invisible in text.

## What that means for how I use it

I do not use the assistant to tell me what happened in a meeting I attended. I
use it to tell me what happened in the eleven I did not.

That distinction matters. For a meeting I was in, I already have the context that
the transcript lacks, so the assistant's version is at best a time saving and at
worst a subtly wrong record that displaces my own memory. For a meeting I missed,
an imperfect summary with visible sources beats nothing at all, and I know to
treat it as a lead rather than a fact.

The failure mode I actively guard against is the assistant becoming the record
rather than a pointer to the record. Once a generated summary is the thing people
cite, its errors stop being caught, because nobody goes back to the source.

## The things I check by hand

Three categories, every time.

Anything with a date attached. Dates in program conversation are frequently
provisional, and the assistant renders provisional and committed dates with the
same confidence. That is the error most likely to travel into a status report and
then into someone's plan.

Anything that names a person as responsible. Getting ownership wrong is not a
small error socially, even when it is a small error factually.

Anything that reports an absence. "No blockers were raised" is a claim about
something not happening, and retrieval is poor evidence for absence. It cannot
distinguish between nothing being said and nothing being found.

## Why publish this

There is an obvious argument against writing it down. I built the thing, I have
quoted its numbers publicly, and cataloguing its failures in the same voice
undercuts the pitch.

I think the opposite is true. An evaluation that produces only favourable numbers
is not an evaluation, it is marketing with a methodology section. The 94.3% is
worth something precisely because I went looking for the 5.7% and can tell you
what is in it.

The wider version of this concerns me more than the tool does. Organisations are
adopting AI into management workflows considerably faster than they are building
any capacity to judge whether it works. If the only people who understand the
failure modes are the people who built the systems, and those people are also the
ones making the case for adoption, that is not a healthy arrangement.

So: 94.3%, and here is the rest of it.
