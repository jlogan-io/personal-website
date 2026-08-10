#!/usr/bin/env bash
# Read-only inspection of the Lightsail instance running Pangolin.
#
# Purpose: capture the exact values the deploy config needs -- above all the
# Docker network name Traefik is attached to, which the site container must
# join. Nothing here writes, installs, restarts or deletes anything.
#
# Usage:
#   ssh lightsail 'bash -s' < scripts/inspect-lightsail.sh > lightsail-report.txt 2>&1
# or copy it over and run:
#   bash inspect-lightsail.sh > lightsail-report.txt 2>&1
#
# Then paste lightsail-report.txt back into the chat.
#
# Safe to share: secrets are redacted below. Skim it before pasting anyway.
#
# No `set -e` on purpose -- a probe that fails is itself a useful answer, and we
# want the whole report rather than an early exit.

section() { printf '\n\n===== %s =====\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }
# Redact anything that looks like a credential before it reaches the transcript.
redact() {
  sed -E 's/((secret|password|passwd|token|key|apikey|api_key|client_secret)[[:space:]]*[:=][[:space:]]*).*/\1<REDACTED>/I'
}
SUDO=""
if [ "$(id -u)" -ne 0 ] && have sudo && sudo -n true 2>/dev/null; then SUDO="sudo -n"; fi

section "HOST"
hostname -f 2>/dev/null || hostname
uname -a
[ -r /etc/os-release ] && . /etc/os-release && echo "OS: $PRETTY_NAME"
echo "Date: $(date -Is)"
echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
echo "Running as uid $(id -u); passwordless sudo: ${SUDO:-no}"

section "RESOURCES (headroom for one more small container)"
echo "--- disk ---"; df -h / /srv /var 2>/dev/null | sort -u
echo "--- memory ---"; free -m
echo "--- cpu ---"; nproc

section "LISTENING PORTS (check for conflicts before adding anything)"
if have ss; then $SUDO ss -tlnp 2>/dev/null || ss -tln
elif have netstat; then $SUDO netstat -tlnp 2>/dev/null || netstat -tln
else echo "neither ss nor netstat available"; fi

section "DOCKER CONTAINERS"
if have docker && docker info >/dev/null 2>&1; then
  docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
else
  echo "docker not present or not accessible to this user -- rerun with sudo"
fi

section "DOCKER COMPOSE PROJECTS"
docker compose ls 2>/dev/null

section "DOCKER NETWORKS  <<< MOST IMPORTANT SECTION >>>"
# The site container must attach to whichever network Traefik is on, so it can
# be reached by container name with no published ports.
docker network ls 2>/dev/null
echo ""
echo "--- network membership per running container ---"
for c in $(docker ps --format '{{.Names}}' 2>/dev/null); do
  nets=$(docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}({{$v.IPAddress}}) {{end}}' "$c" 2>/dev/null)
  printf '%-28s %s\n' "$c" "$nets"
done
echo ""
echo "--- full inspect of every non-default network ---"
for n in $(docker network ls --format '{{.Name}}' 2>/dev/null | grep -v -E '^(bridge|host|none)$'); do
  echo "########## $n ##########"
  docker network inspect "$n" \
    --format 'Name: {{.Name}}
Driver: {{.Driver}}
Subnet: {{range .IPAM.Config}}{{.Subnet}}{{end}}
Attachable: {{.Attachable}}
Containers: {{range .Containers}}{{.Name}}({{.IPv4Address}}) {{end}}' 2>/dev/null
done

section "TRAEFIK"
TRAEFIK=$(docker ps --format '{{.Names}}' 2>/dev/null | grep -i traefik | head -1)
if [ -n "$TRAEFIK" ]; then
  echo "container: $TRAEFIK"
  docker exec "$TRAEFIK" traefik version 2>/dev/null
  echo "--- command line flags (entrypoints, providers, certresolvers) ---"
  docker inspect -f '{{range .Config.Cmd}}{{println .}}{{end}}' "$TRAEFIK" 2>/dev/null
  echo "--- mounts (where its config lives on disk) ---"
  docker inspect -f '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' "$TRAEFIK" 2>/dev/null
else
  echo "no container with 'traefik' in the name is running"
fi

section "PANGOLIN STACK FILES"
# Find the compose file for the Pangolin stack and read its config.
for d in /opt/pangolin /srv/pangolin /root/pangolin /home/*/pangolin /opt/stack /root; do
  [ -d "$d" ] || continue
  find "$d" -maxdepth 3 \( -name 'docker-compose*.y*ml' -o -name 'config.yml' -o -name 'traefik*.y*ml' -o -name 'dynamic*.y*ml' \) 2>/dev/null | head -20
done | sort -u | while read -r f; do
  echo ""
  echo "########## $f ##########"
  $SUDO cat "$f" 2>/dev/null | redact
done

section "PANGOLIN DOMAIN + CERT CONFIG  <<< APEX vs WILDCARD >>>"
# A *.jlogan.io wildcard cert does NOT cover the bare apex jlogan.io.
# We need to know which the current setup issues.
$SUDO find /opt /srv /root /home -maxdepth 5 -path '*pangolin*' -name 'config.yml' 2>/dev/null | while read -r f; do
  echo "########## $f ##########"
  $SUDO cat "$f" 2>/dev/null | redact
done
echo "--- domains mentioned in any config under the stack dirs ---"
$SUDO grep -rIn --include='*.yml' --include='*.yaml' --include='*.toml' \
  -E 'jlogan\.io|base_?domain|domains?:|certresolver|acme' \
  /opt /srv /root 2>/dev/null | grep -v -E 'Binary|\.git/' | head -40 | redact

section "ISSUED CERTIFICATES (which SANs are actually covered)"
for f in $($SUDO find /opt /srv /root -maxdepth 6 -name 'acme*.json' 2>/dev/null | head -5); do
  echo "########## $f ##########"
  if have jq; then
    $SUDO jq -r '.. | .Certificates? // empty | .[]? | .domain | (.main, (.sans[]? // empty))' "$f" 2>/dev/null | sort -u
  else
    # No jq: pull the domain fields out with grep rather than dumping the file,
    # which would leak the private keys stored alongside them.
    $SUDO grep -o '"main":"[^"]*"' "$f" 2>/dev/null | sort -u
    $SUDO grep -o '"sans":\[[^]]*\]' "$f" 2>/dev/null | sort -u
  fi
done

section "LIVE HTTP BEHAVIOUR FOR jlogan.io"
if have curl; then
  echo "--- from this box, following redirects ---"
  curl -sSI --max-time 10 https://jlogan.io 2>&1 | head -20
  echo "--- cert SANs presented for the apex ---"
  echo | timeout 10 openssl s_client -connect jlogan.io:443 -servername jlogan.io 2>/dev/null \
    | openssl x509 -noout -subject -issuer -dates -ext subjectAltName 2>/dev/null
fi

section "PUBLIC IP vs DNS (confirm apex already points here)"
echo "--- this box's public IP ---"
curl -sS --max-time 8 https://api.ipify.org 2>/dev/null; echo
echo "--- what jlogan.io resolves to ---"
if have dig; then dig +short jlogan.io A; dig +short www.jlogan.io
elif have host; then host jlogan.io; host www.jlogan.io
else getent hosts jlogan.io; fi

section "SSH SERVER (needed for the rsync deploy from GitHub Actions)"
$SUDO sshd -T 2>/dev/null | grep -E '^(port|passwordauthentication|pubkeyauthentication|permitrootlogin|allowusers|allowgroups)' \
  || grep -E '^\s*(Port|PasswordAuthentication|PubkeyAuthentication|PermitRootLogin|AllowUsers|AllowGroups)' /etc/ssh/sshd_config 2>/dev/null
echo "--- host key fingerprints (for the pinned known_hosts secret) ---"
for k in /etc/ssh/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_rsa_key.pub; do
  [ -r "$k" ] && ssh-keygen -lf "$k" 2>/dev/null
done
echo "--- rrsync available? (used to cage the deploy key) ---"
for p in /usr/bin/rrsync /usr/share/rsync/rrsync /usr/libexec/rsync/rrsync; do
  [ -x "$p" ] && echo "found: $p"
done
have rsync && rsync --version | head -1

section "HOST FIREWALL"
have ufw && $SUDO ufw status verbose 2>/dev/null
have firewall-cmd && $SUDO firewall-cmd --list-all 2>/dev/null
$SUDO iptables -S 2>/dev/null | head -30

section "EXISTING /srv LAYOUT"
ls -la /srv 2>/dev/null

section "DONE"
echo "Secrets were redacted, but skim this before pasting it back into the chat."
echo ""
echo "NOTE: the Lightsail firewall is configured in the AWS console, NOT on this"
echo "box -- iptables/ufw above do not show it. Confirm in the console that TCP"
echo "22 is reachable (needed for the rsync deploy) and that 80/443 are open."
