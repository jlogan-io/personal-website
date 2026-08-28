---
title: "The prototype worked. That was the easy part."
date: 2025-09-15
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - Program Management
  - CoPlay
  - Adoption
toc: true
draft: true
description: A tool that serves one program manager is not the same tool that serves fourteen portfolios.
---

I wrote about the multi-agent system I built for my own program management work,
and the post did well. People liked the architecture diagram. What that post did
not say, because I did not know it yet, is that the version I had built was the
easy half of the problem.

It worked. It worked genuinely well. It also had exactly one user, and that user
had written it.

## Everything it knew, it knew from me

A tool you build for yourself inherits all of your assumptions without ever
stating them. Mine assumed a particular way of naming Jira epics, because that
is how I named them. It assumed meetings had agendas, because mine did. It
assumed the person reading the status report already knew what the program was
for, because I did.

None of that is written down anywhere in the code. It is just absent from the
list of things the code handles.

The first time someone else pointed it at their programs, the output was
confident and wrong in a way that was hard to argue with. It looked like a
status report. It had the right shape. It just described a program that did not
exist.

## What generalising actually meant

I had assumed this would be a matter of adding configuration. Let people set
their own conventions, expose a few options, ship it. That was wrong twice over.

The first problem is that the conventions are not the interesting variable. What
varies between portfolios is what counts as a risk, what counts as done, and who
the report is for. Those are judgement calls, and judgement calls do not go in a
settings file.

The second problem is that once a tool has more than one user, being wrong stops
being a nuisance and starts being a liability. When I was the only user I could
glance at a generated status report and know instantly whether it had understood
the week. Someone reading their own program's report for the first time has no
such calibration. They have to trust it, or check it entirely by hand, and if
they check it entirely by hand the tool has cost them time rather than saved it.

## The rebuild

I ended up rebuilding rather than extending. The prototype had a single pipeline
with the steps hard-wired in the order I happened to want them. What replaced it
was a set of modular capabilities that could be composed per portfolio, which is
how it ended up at thirty-seven of them.

That sounds like an architecture decision. It was really an organisational one.
Modularity mattered because it let a portfolio adopt three capabilities without
adopting all thirty-seven, and partial adoption turned out to be the only kind
that actually happens.

## What I would tell myself in May

Build the thing for yourself first. That part I would not change. You cannot
design a tool for program management by interviewing people about program
management, and having a working artefact to react to is worth more than any
amount of requirements gathering.

But do not confuse the prototype working with the problem being solved. The
prototype proves the idea is possible. It tells you almost nothing about whether
it survives contact with people who did not build it, and that second question
is the one that determines whether anything you built matters in a year.

Mine took most of a year to answer, and the answer required throwing away code I
was proud of.
