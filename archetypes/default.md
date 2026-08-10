---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: {{ .Date }}
draft: true
author: Jonathan Logan
# Taxonomies are configured SINGULAR in hugo.toml -- `category` and `tag`, not
# `categories`/`tags`. Using the plural form makes the terms silently vanish.
category:
  - Blog
tag:
  - example
toc: true
# Page-bundle relative path, e.g. posts/<this-dir>/thumbnail-image.png
thumbnail: ""
---
