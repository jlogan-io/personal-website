---
title: "Rebuilding CoPlay as a Desktop Application"
date: 2026-01-18
author: Jonathan Logan
category:
  - Blog
tag:
  - AI
  - Program Management
  - CoPlay
  - Electron
toc: true
draft: true
description: The Flask prototype proved the idea. Making it usable by anyone else meant starting over.
---

I wrote up the multi-agent system I had built for my own program management
work, and people liked it. The architecture diagram did the rounds. What that
post could not tell you, because I did not know it yet, is that the version I
had built was the easy half of the problem.

It worked. It worked genuinely well. It also had exactly one user, and that user
had written it.

## What the Flask app actually proved

The CrowdStrike-era build was a Python Flask application talking to the OpenAI
API, pulling from Jira, Bitbucket, Confluence and Zoom, with MySQL underneath
for history. It cut my manual reporting effort by about 85%, and that number was
real.

What it proved was narrow and important: if you ground a model in a program's
own record, the output stops being generic. That is the whole thesis, and one
prototype was enough to establish it.

What it did not prove is that anyone other than me could use it.

## The problem with a server

The Flask app assumed a server, and a server assumes that program data leaves
the machine it lives on. For my own use inside one organisation that was
manageable. As soon as I imagined a second PMO, or a second company, it became
the first question anyone would ask and the hardest one to answer well.

So the rebuild that became CoPlay is a desktop application. Electron, React and
TypeScript, with the program data held in a local SQLite database on the user's
own machine. Retrieval runs locally too: documents are chunked, embedded with
Amazon Titan, and stored in the same SQLite file using sqlite-vec, so there is
no external vector database in the picture at all.

That decision cost me a great deal of convenience. It is also the reason the
tool is deployable in an enterprise PMO, where "where does our program data go"
is not a rhetorical question. Model calls go out to AWS Bedrock. The corpus does
not.

## Everything it knew, it knew from me

A tool you build for yourself inherits your assumptions without ever stating
them. Mine assumed a particular way of naming epics, because that is how I named
them. It assumed meetings had agendas, because mine did. It assumed the reader
of a status report already knew what the program was for.

None of that is written down anywhere in the code. It is simply absent from the
list of things the code handles.

The first time the assistant ran against someone else's programs, the output was
confident and wrong in a way that was hard to argue with. It had the right
shape. It just described a program that did not exist.

## What generalising actually cost

I had assumed this would be a matter of configuration. Expose some options, let
people set their conventions, ship it. That was wrong twice over.

The conventions are not the interesting variable. What varies between portfolios
is what counts as a risk, what counts as done, and who the report is for. Those
are judgement calls, and judgement calls do not go in a settings file.

And once a tool has more than one user, being wrong stops being a nuisance and
becomes a liability. When I was the only user I could glance at a generated
report and know instantly whether it had understood the week. Someone reading
their own program's report for the first time has no such calibration. They have
to trust it or check it by hand, and if they check it by hand the tool has cost
them time rather than saved it.

## Where it is now It reached proof of concept this month, which means the
retrieval path works end to end against a real program and the output is worth
reading. That is a lower bar than it sounds. It is also the bar the Flask
version cleared eight months ago, and the difference is that this one clears
it on someone else's machine with their own data. What remains is the
unglamorous half: test coverage, code signing and notarisation, an auto-
updater, and enough review discipline that I am not the only person who can
safely change it. None of that is interesting in itself. It is what "someone
else can rely on this" costs when written out as a bill of materials.

## What I would tell myself in May

Build the thing for yourself first. I would not change that. You cannot design a
tool for program management by interviewing people about program management, and
a working artefact to react to beats any amount of requirements gathering.

But do not confuse the prototype working with the problem being solved. The
prototype proves the idea is possible. It tells you almost nothing about whether
it survives contact with people who did not build it, and that second question
is the one that decides whether any of it mattered.

I am about two months into answering it, and the answer has already required
throwing away code I was fond of.
