#!/usr/bin/env bash
# Read-only inspection of homeserveralpha.
#
# Purpose: find out what is actually being served from this machine and whether
# it has drifted from git. Nothing here writes, installs, restarts or deletes
# anything -- it only reads and prints.
#
# Usage:
#   ssh homeserveralpha 'bash -s' < scripts/inspect-homeserver.sh > homeserver-report.txt 2>&1
# or copy it over and run:
#   bash inspect-homeserver.sh > homeserver-report.txt 2>&1
#
# Then paste homeserver-report.txt back into the chat.
#
# Note: deliberately does NOT use `set -e`. Many probes below are expected to
# fail on any given host (no docker, no nginx, ...) and a failed probe is itself
# a useful answer. We want the whole report, not an early exit.

section() { printf '\n\n===== %s =====\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }
# Some probes need root; use sudo only when it is passwordless, never prompt.
SUDO=""
if [ "$(id -u)" -ne 0 ] && have sudo && sudo -n true 2>/dev/null; then SUDO="sudo -n"; fi

section "HOST"
hostname -f 2>/dev/null || hostname
uname -a
[ -r /etc/os-release ] && . /etc/os-release && echo "OS: $PRETTY_NAME"
echo "Date: $(date -Is)"
echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
echo "Running as uid $(id -u); passwordless sudo: ${SUDO:-no}"

section "LISTENING PORTS"
# Who is answering on 80/443 tells us which web server to inspect below.
if have ss; then $SUDO ss -tlnp 2>/dev/null || ss -tln
elif have netstat; then $SUDO netstat -tlnp 2>/dev/null || netstat -tln
else echo "neither ss nor netstat available"; fi

section "WEB SERVER PACKAGES / SERVICES"
for svc in nginx apache2 httpd caddy lighttpd docker; do
  if have systemctl; then
    state=$(systemctl is-active "$svc" 2>/dev/null)
    [ -n "$state" ] && [ "$state" != "inactive" ] && [ "$state" != "unknown" ] \
      && echo "$svc: $state"
  fi
done
echo "--- binaries present ---"
for b in nginx caddy httpd apache2 docker hugo git rsync; do
  printf '%-8s %s\n' "$b" "$(command -v "$b" || echo '-')"
done
echo "--- hugo version (if installed) ---"
have hugo && hugo version

section "DOCKER"
if have docker && docker info >/dev/null 2>&1; then
  docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
  echo "--- compose projects ---"
  docker compose ls 2>/dev/null
  echo "--- bind mounts per container (where docroots hide) ---"
  for c in $(docker ps --format '{{.Names}}'); do
    mounts=$(docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' "$c" 2>/dev/null)
    [ -n "$mounts" ] && { echo "[$c]"; echo "$mounts"; }
  done
else
  echo "docker not present or not accessible to this user"
fi

section "NGINX CONFIG (resolved)"
# -T dumps every included file, so we see the real root/server_name in one pass.
if have nginx; then $SUDO nginx -T 2>&1 | head -300; else echo "nginx not installed"; fi

section "CADDY CONFIG"
for f in /etc/caddy/Caddyfile /opt/caddy/Caddyfile ./Caddyfile; do
  [ -r "$f" ] && { echo "--- $f ---"; cat "$f"; }
done

section "APACHE VHOSTS"
if have apache2ctl; then $SUDO apache2ctl -S 2>&1 | head -60
elif have httpd; then $SUDO httpd -S 2>&1 | head -60
else echo "apache not installed"; fi

section "CANDIDATE DOCROOTS"
# Look for a built Hugo site: index.html next to a Hugo-generated sitemap.
for d in /var/www /var/www/html /srv /srv/www /usr/share/nginx/html /opt; do
  [ -d "$d" ] || continue
  echo "--- $d ---"
  ls -la "$d" 2>/dev/null | head -25
done
echo "--- directories containing both index.html and sitemap.xml ---"
$SUDO find /var/www /srv /opt /home /usr/share/nginx -maxdepth 4 -name sitemap.xml 2>/dev/null \
  | while read -r s; do
      d=$(dirname "$s")
      [ -f "$d/index.html" ] && echo "$d"
    done

section "HUGO SOURCE TREES ON THIS BOX"
# THIS IS THE HIGH-VALUE PROBE. If markdown was ever edited directly on this
# machine, it lives in one of these trees and has not reached GitHub.
$SUDO find / -xdev \( -path /proc -o -path /sys -o -path /var/lib/docker \) -prune -o \
  \( -name hugo.toml -o -name config.toml -o -name hugo.yaml \) -print 2>/dev/null \
  | grep -v -E '/(themes|exampleSite|node_modules|public)/' | head -20

section "GIT STATE OF EACH HUGO SOURCE TREE"
$SUDO find / -xdev \( -path /proc -o -path /sys -o -path /var/lib/docker \) -prune -o \
  \( -name hugo.toml -o -name config.toml \) -print 2>/dev/null \
  | grep -v -E '/(themes|exampleSite|node_modules|public)/' | head -20 \
  | while read -r cfg; do
      d=$(dirname "$cfg")
      [ -d "$d/.git" ] || continue
      echo ""
      echo "########## $d ##########"
      echo "--- branch / HEAD ---"
      git -C "$d" rev-parse --abbrev-ref HEAD 2>/dev/null
      git -C "$d" log --oneline -5 2>/dev/null
      echo "--- remotes ---"
      git -C "$d" remote -v 2>/dev/null
      echo "--- UNCOMMITTED CHANGES (drift lives here) ---"
      git -C "$d" status --porcelain 2>/dev/null
      echo "--- diffstat vs origin/main (unpushed commits) ---"
      git -C "$d" diff --stat origin/main 2>/dev/null
      git -C "$d" log --oneline origin/main..HEAD 2>/dev/null
      echo "--- untracked markdown (posts that exist ONLY here) ---"
      git -C "$d" ls-files --others --exclude-standard 2>/dev/null | grep -E '\.(md|png|jpg|jpeg|webp|svg)$'
      echo "--- content/ mtimes ---"
      [ -d "$d/content" ] && find "$d/content" -name '*.md' -printf '%TY-%Tm-%Td %p\n' 2>/dev/null | sort -r
    done

section "SERVED SITE FINGERPRINT"
# If there is no source tree, the built HTML is all we have to reconcile against.
for d in $($SUDO find /var/www /srv /opt /usr/share/nginx -maxdepth 4 -name sitemap.xml 2>/dev/null | xargs -r -n1 dirname | sort -u); do
  echo ""
  echo "########## $d ##########"
  echo "--- generator / title ---"
  grep -o '<meta name="generator"[^>]*>' "$d/index.html" 2>/dev/null
  grep -o '<title>[^<]*</title>' "$d/index.html" 2>/dev/null | head -1
  echo "--- newest 15 files (is this build newer than git commit e35fb19, 2025-09-26?) ---"
  find "$d" -type f -printf '%TY-%Tm-%Td %p\n' 2>/dev/null | sort -r | head -15
  echo "--- PUBLISHED URL SET (diffed against git's sitemap to find missing posts) ---"
  grep -o '<loc>[^<]*</loc>' "$d/sitemap.xml" 2>/dev/null | sed 's/<[^>]*>//g' | sort
done

section "LOCAL HTTP RESPONSE"
if have curl; then
  for u in http://localhost/ https://localhost/; do
    echo "--- $u ---"
    curl -sSk -o /dev/null -w 'http=%{http_code} size=%{size_download} time=%{time_total}s\n' --max-time 8 "$u" 2>&1
  done
fi

section "DONE"
echo "Paste this entire report back into the chat."
