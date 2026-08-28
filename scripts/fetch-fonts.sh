#!/usr/bin/env bash
#
# Refresh the self-hosted webfonts in static/fonts/ and regenerate
# themes/slate/assets/css/fonts.css.
#
# Google Fonts serves different formats depending on the requesting browser, so
# this asks as a current Chrome to get woff2, then rewrites the @font-face URLs
# to local paths. Only the latin and latin-ext subsets are kept.
#
# Run this only when the typeface selection changes.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'
URL='https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;0,6..72,600;1,6..72,400;1,6..72,500&family=Barlow:wght@400;500;600&display=swap'

mkdir -p static/fonts
curl -sSf -A "$UA" "$URL" -o /tmp/gf.css
python3 - <<'PY'
import re, io, os, urllib.request
css = io.open('/tmp/gf.css', encoding='utf-8').read()
blocks = re.findall(r'/\* (.*?) \*/\s*(@font-face \{.*?\})', css, re.S)
keep = [(s, b) for s, b in blocks if s in ('latin', 'latin-ext')]
out = []
for subset, block in keep:
    url = re.search(r'url\((https://[^)]+\.woff2)\)', block).group(1)
    fam = re.search(r"font-family: '([^']+)'", block).group(1).lower().replace(' ', '-')
    style = 'italic' if 'font-style: italic' in block else 'normal'
    name = f"{fam}-{subset}-{style}-{os.path.basename(url)}"
    path = f'static/fonts/{name}'
    if not os.path.exists(path):
        urllib.request.urlretrieve(url, path)
    out.append(block.replace(url, f'/fonts/{name}'))
header = io.open('themes/slate/assets/css/fonts.css', encoding='utf-8').read().split('*/')[0] + '*/\n\n'
io.open('themes/slate/assets/css/fonts.css', 'w', encoding='utf-8').write(header + "\n\n".join(out) + "\n")
print(f'{len(out)} faces written')
PY
