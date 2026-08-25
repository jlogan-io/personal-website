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

Push to `main` → GitHub Actions builds → GitHub Pages serves it → live in about
a minute. Nothing is built or copied by hand.

### Publishing a draft

New posts start with `draft: true`. They are visible in `hugo server -D` and are
excluded from production builds. To publish, set `draft: false` and push.

### Scheduling a post

Give the post a future date and it stays unpublished until that date passes:

```bash
./scripts/new-post.sh "Next Week's Post" 2026-09-01
```

Hugo excludes future-dated content from builds by default, and the workflow runs
on a daily schedule as well as on push, so the post goes live on the first build
after its date with nothing further to do. Set `draft: false` when you are done
writing — a draft stays a draft no matter what its date says.

Note that GitHub disables scheduled workflows in a repository with no activity
for 60 days. If the site has been dormant that long, a scheduled post needs a
push (or a manual run from the Actions tab) to go out.

### Rolling back

`git revert <commit> && git push`. The next build redeploys the previous state.

---

## Local setup

You need **Hugo extended**, at the same version CI uses:

```bash
hugo version   # must report 'extended' and v0.165.0
```

The `extended` build is not optional: the theme compiles SCSS via `css.Sass`,
and the standard build cannot do that. The version is pinned in
`.github/workflows/pages.yml` (`HUGO_VERSION`). Bump it there and locally
together, as a deliberate commit.

macOS: `brew install hugo` installs the extended build.

`scripts/optimize-images.py` needs Pillow (`pip install Pillow`). It is not
needed for a normal build.

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
tags were invisible on the site for months until it was caught.
`scripts/new-post.sh` generates the correct keys.

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

### Images

The theme renders plain `<img src>` with no Hugo image processing, so whatever
is committed is exactly what every visitor downloads. Run the optimizer before
committing anything large:

```bash
python3 scripts/optimize-images.py --check   # report only
python3 scripts/optimize-images.py           # apply
```

---

## Repository layout

| Path | Purpose |
|---|---|
| `content/` | The site's markdown. This is the only directory you normally edit. |
| `themes/anatole/` | The theme, **vendored** (not a submodule). Committed in full. |
| `assets/` | Custom CSS/JS layered over the theme. |
| `static/` | Files copied verbatim to the site root (favicons, images, CNAME). |
| `archetypes/` | Front matter template for new posts. |
| `scripts/` | `new-post.sh`, `optimize-images.py`. |
| `.github/workflows/` | Build and deploy, plus PR checks. |

`public/` and `resources/_gen/` are build output and are **git-ignored**. They
used to be committed, which is how a stale `hugo server` build — complete with
`livereload.js` — ended up tracked in the repository. CI owns them now; do not
commit them back.

---

## How the deploy works

```
git push main  (or the daily schedule, or a manual run)
   │
   ▼
GitHub Actions  ─ hugo --gc --minify
   │            ─ refuses the build if a dev build leaked in
   ▼
actions/deploy-pages
   │
   ▼
GitHub Pages  ─ custom domain from static/CNAME, DNS at Cloudflare
   │
   ▼
https://jlogan.io
```

`baseURL` comes from `hugo.toml` and nothing overrides it. It used to be
overridden with `configure-pages`'s `base_url` output, which reports
`http://jlogan.io` for this custom-domain setup and put plain `http://` into
every canonical URL, `og:url`, sitemap entry and RSS link on the live site.

---

## Known rough edges

- Several paths the old hand-built site served now 404: `/Posts/` (capital P),
  `/refrences/` (typo), `/tags/` (plural). Inbound links to them are broken.
- The headshot and post thumbnails are PNGs of photographs. Moving them through
  Hugo image processing and emitting WebP would cut them again.
