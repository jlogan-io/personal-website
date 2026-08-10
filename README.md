# jlogan.io

Personal site, built with [Hugo](https://gohugo.io/) using a vendored copy of the
[anatole](https://github.com/lxndrblz/anatole) theme.

Write markdown locally, push to `main`, and the live site rebuilds and deploys
itself.

---

## The everyday loop

```bash
./scripts/new-post.sh "My Post Title"   # scaffold content/posts/YYYYMMDD-slug/
hugo server -D                          # preview on localhost:1313, drafts shown
git add . && git commit -m "..." && git push
```

Push to `main` → GitHub Actions builds → rsync to the server → live in about a
minute. Nothing is built or copied by hand.

### Publishing a draft

New posts start with `draft: true`. They are visible in `hugo server -D` and are
excluded from production builds. To publish, set `draft: false` and push.

### Rolling back

`git revert <commit> && git push`. The next build redeploys the previous state —
the server holds no state of its own beyond the files rsync puts there.

---

## Local setup

You need **Hugo extended**, at the same version CI uses:

```bash
hugo version   # must report 'extended' and v0.131.0
```

The `extended` build is not optional: the theme compiles SCSS via
`resources.ToCSS`, and the standard build cannot do that. The version is pinned
in `.github/workflows/deploy.yml` (`HUGO_VERSION`). Bump it there and locally
together, as a deliberate commit — the vendored theme already emits deprecation
warnings that become hard errors in later Hugo releases.

macOS: `brew install hugo` installs the extended build.

---

## Content conventions

Posts are **page bundles**: a directory per post containing `index.md` plus its
images, so images are referenced by plain filename.

```
content/posts/20250611-tpm-companion/
├── index.md
└── thumbnail-image.png
```

### Taxonomies are singular

`hugo.toml` configures `category`, `series` and `tag` — **not** the plural
`categories`/`tags`. Using the plural form is not an error: Hugo parses it, and
the terms silently never register. One post shipped with `tags:` and its nine
tags were invisible on the site until it was caught. `scripts/new-post.sh`
generates the correct keys.

### Front matter

```yaml
---
title: "Post Title"
date: 2025-06-11
draft: false
author: Jonathan Logan
category:
  - Blog          # or: Home Lab
tag:
  - example
toc: true
thumbnail: "posts/20250611-tpm-companion/thumbnail-image.png"
---
```

`thumbnail` is relative to the site root, not to the post directory.

---

## Repository layout

| Path | Purpose |
|---|---|
| `content/` | The site's markdown. This is the only directory you normally edit. |
| `themes/anatole/` | The theme, **vendored** (not a submodule). Committed in full. |
| `assets/` | Custom CSS/JS layered over the theme. |
| `static/` | Files copied verbatim to the site root (favicons, images). |
| `archetypes/` | Front matter template for new posts. |
| `scripts/` | `new-post.sh`, plus the server inspection scripts. |
| `deploy/` | Server-side config: nginx, docker compose, provisioning. |
| `.github/workflows/` | The build-and-deploy pipeline. |

`public/` and `resources/_gen/` are build output and are **git-ignored**. They
used to be committed, which is how a stale `hugo server` build — complete with
`http://localhost:1313/` in its sitemap — ended up tracked in the repository.
CI owns them now; do not commit them back.

---

## How the deploy works

```
git push main
   │
   ▼
GitHub Actions  ─ hugo --minify --gc --baseURL https://jlogan.io/
   │            ─ verification gate (see below)
   ▼
rsync over SSH  ─ deploy key caged by rrsync to /srv/jlogan.io/html
   │
   ▼
Lightsail  ─ nginx container (no published ports)
   │       ─ Traefik / Pangolin terminates TLS and routes jlogan.io to it
   ▼
https://jlogan.io
```

The site is served from the Lightsail instance rather than tunnelled back to the
home server, so its availability does not depend on a home internet connection.

### The verification gate

Before anything is deployed, the workflow refuses the build if:

- `index.html`, `sitemap.xml` or `404.html` is missing
- `sitemap.xml` contains `localhost` — i.e. it was built with a dev baseURL
- the sitemap has fewer than 30 URLs, or fewer than 5 posts were built

That last check matters because the deploy uses `rsync --delete`: a truncated
build would otherwise delete the live site rather than update it.

### Required repository secrets

| Secret | Value |
|---|---|
| `DEPLOY_SSH_KEY` | Private half of the deploy keypair |
| `DEPLOY_HOST` | Lightsail public IP or hostname |
| `DEPLOY_USER` | `deploy` |
| `SSH_KNOWN_HOSTS` | `ssh-keyscan -H <host>` output |

Host keys are pinned. `StrictHostKeyChecking` is never disabled.

---

## Server setup

One-time, on the Lightsail instance. See `deploy/setup-lightsail.sh` — it
creates the deploy user, installs the config, cages the deploy key with
`rrsync`, validates the nginx config and starts the container.

```bash
# on your workstation -- the private key must never touch the server
ssh-keygen -t ed25519 -f ~/.ssh/jlogan-deploy -C "github-actions-jlogan-io" -N ""

# on the Lightsail box, from a checkout of this repo
sudo bash deploy/setup-lightsail.sh --pubkey ~/jlogan-deploy.pub
```

Then create the Pangolin resource by hand (the script prints the exact
settings). Two things are easy to get wrong:

- **Pangolin resources default to requiring SSO.** Leaving that on puts a login
  wall in front of a public website.
- **A `*.jlogan.io` wildcard certificate does not cover the bare apex.**
  `jlogan.io` needs its own certificate or an added SAN.

### Inspection scripts

`scripts/inspect-lightsail.sh` and `scripts/inspect-homeserver.sh` are read-only.
They report what is running, which Docker network Traefik is on, which
certificates cover which names, and — on the home server — whether any content
there has drifted from git. Run them with `bash -s` over SSH and read the
output; they change nothing.

---

## Known rough edges

- The vendored theme triggers two Hugo deprecation warnings
  (`.Site.GoogleAnalytics`, `.Site.DisqusShortname`). Harmless on 0.131.0; they
  become build errors in a future Hugo, which is the main reason the version is
  pinned.
- `deploy/nginx.conf` carries 301 redirects for `/Posts/`, `/refrences/` and
  `/tags/` — paths the old hand-built site served that a clean build no longer
  produces. Removing them will 404 existing inbound links.
