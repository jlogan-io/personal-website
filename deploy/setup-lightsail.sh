#!/usr/bin/env bash
#
# One-time provisioning of the jlogan.io static site on the Lightsail instance.
#
# What it does:
#   1. Creates a locked-down `deploy` system user (no password, no shell login)
#   2. Creates /srv/jlogan.io/{html}
#   3. Installs nginx.conf + docker-compose.yml + .env
#   4. Installs the deploy public key, caged with rrsync so it can ONLY write
#      into html/ -- it cannot get a shell
#   5. Validates the nginx config before starting anything
#   6. Brings up the container
#
# What it does NOT do: touch Traefik, Pangolin, DNS, or any existing container.
# The Pangolin resource is created by hand in the dashboard afterwards (the
# script prints the exact settings at the end).
#
# Usage, from the repo checked out on the Lightsail box:
#   sudo bash deploy/setup-lightsail.sh --pubkey ~/jlogan-deploy.pub
#
# Generate that keypair on your workstation first -- NOT on the server, so the
# private half never touches the box:
#   ssh-keygen -t ed25519 -f ~/.ssh/jlogan-deploy -C "github-actions-jlogan-io" -N ""
#
# Re-running is safe: every step checks before it acts.

set -euo pipefail

SITE_DIR=/srv/jlogan.io
DEPLOY_USER=deploy
PUBKEY_FILE=""
SKIP_UP=0

usage() { sed -n '2,30p' "$0"; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --pubkey)   PUBKEY_FILE="${2:?--pubkey needs a path}"; shift 2 ;;
    --user)     DEPLOY_USER="${2:?--user needs a name}"; shift 2 ;;
    --dir)      SITE_DIR="${2:?--dir needs a path}"; shift 2 ;;
    --skip-up)  SKIP_UP=1; shift ;;
    -h|--help)  usage 0 ;;
    *) echo "unknown argument: $1" >&2; usage 1 ;;
  esac
done

log()  { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || die "run with sudo"

SRC_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
for f in nginx.conf docker-compose.yml; do
  [ -r "$SRC_DIR/$f" ] || die "missing $SRC_DIR/$f -- run this from the repo checkout"
done

command -v docker >/dev/null 2>&1 || die "docker not installed"
docker compose version >/dev/null 2>&1 || die "docker compose plugin not available"

# ---------------------------------------------------------------------------
log "Creating deploy user: $DEPLOY_USER"
# --system: no aging/expiry. Shell is nologin -- the ONLY way in is the forced
# rrsync command installed below, so even a stolen key yields no shell.
if id "$DEPLOY_USER" >/dev/null 2>&1; then
  echo "user already exists, leaving it alone"
else
  useradd --system --create-home --home-dir "/home/$DEPLOY_USER" \
          --shell /usr/sbin/nologin "$DEPLOY_USER"
  echo "created"
fi
# Never allow password auth for this account regardless of sshd policy.
passwd --lock "$DEPLOY_USER" >/dev/null 2>&1 || true

# ---------------------------------------------------------------------------
log "Creating $SITE_DIR"
mkdir -p "$SITE_DIR/html"
# The deploy user owns only html/. Config files stay root-owned so a compromised
# deploy key cannot rewrite nginx.conf or the compose file.
chown -R "$DEPLOY_USER:$DEPLOY_USER" "$SITE_DIR/html"
chmod 755 "$SITE_DIR" "$SITE_DIR/html"

# ---------------------------------------------------------------------------
log "Installing config files"
install -o root -g root -m 0644 "$SRC_DIR/nginx.conf"        "$SITE_DIR/nginx.conf"
install -o root -g root -m 0644 "$SRC_DIR/docker-compose.yml" "$SITE_DIR/docker-compose.yml"

if [ -f "$SITE_DIR/.env" ]; then
  echo ".env already exists, keeping it"
else
  install -o root -g root -m 0644 "$SRC_DIR/.env.example" "$SITE_DIR/.env"
  warn "$SITE_DIR/.env created from the example -- you MUST set PANGOLIN_NETWORK"
  warn "to the Docker network Traefik is on, or 'docker compose up' will fail."
fi

# Fail early and clearly rather than letting compose emit a confusing error.
if grep -q '^PANGOLIN_NETWORK=CHANGEME' "$SITE_DIR/.env" 2>/dev/null; then
  NET_UNSET=1
  warn "PANGOLIN_NETWORK is still CHANGEME. Candidate networks on this host:"
  docker network ls --format '  {{.Name}}' 2>/dev/null | grep -v -E '^\s+(bridge|host|none)$' >&2 || true
  TRAEFIK=$(docker ps --format '{{.Names}}' 2>/dev/null | grep -i traefik | head -1 || true)
  if [ -n "$TRAEFIK" ]; then
    warn "traefik container '$TRAEFIK' is attached to:"
    docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}  {{$k}}{{"\n"}}{{end}}' "$TRAEFIK" >&2
  fi
else
  NET_UNSET=0
fi

# ---------------------------------------------------------------------------
log "Locating rrsync (cages the deploy key to one directory)"
RRSYNC=""
for p in /usr/local/bin/rrsync /usr/bin/rrsync /usr/share/rsync/rrsync \
         /usr/share/doc/rsync/scripts/rrsync; do
  [ -x "$p" ] && { RRSYNC="$p"; break; }
done
if [ -z "$RRSYNC" ]; then
  # Debian/Ubuntu ship it gzipped under /usr/share/doc; unpack to a real path.
  for gz in /usr/share/rsync/rrsync.gz /usr/share/doc/rsync/scripts/rrsync.gz; do
    if [ -r "$gz" ]; then
      gunzip -c "$gz" > /usr/local/bin/rrsync
      chmod 0755 /usr/local/bin/rrsync
      RRSYNC=/usr/local/bin/rrsync
      echo "unpacked $gz -> $RRSYNC"
      break
    fi
  done
fi
[ -n "$RRSYNC" ] || die "rrsync not found. Install it: apt-get install rsync
(Debian 12+ ships /usr/bin/rrsync). Without it the deploy key cannot be safely
restricted, and this script will not install an unrestricted key."
echo "using $RRSYNC"

# ---------------------------------------------------------------------------
log "Installing the deploy key"
SSH_DIR="/home/$DEPLOY_USER/.ssh"
AUTH="$SSH_DIR/authorized_keys"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
touch "$AUTH"
chmod 600 "$AUTH"
chown -R "$DEPLOY_USER:$DEPLOY_USER" "$SSH_DIR"

if [ -z "$PUBKEY_FILE" ]; then
  warn "no --pubkey given, skipping key install"
  warn "rerun with: sudo bash $0 --pubkey /path/to/jlogan-deploy.pub"
else
  [ -r "$PUBKEY_FILE" ] || die "cannot read $PUBKEY_FILE"
  PUBKEY=$(tr -d '\n\r' < "$PUBKEY_FILE")
  case "$PUBKEY" in
    ssh-ed25519\ *|ssh-rsa\ *|ecdsa-sha2-*\ *) ;;
    *) die "$PUBKEY_FILE does not look like an SSH public key. Did you pass the
private key by mistake? It must be the .pub half." ;;
  esac
  # Refuse a private key outright -- an easy and catastrophic mix-up.
  grep -q 'PRIVATE KEY' "$PUBKEY_FILE" && die "$PUBKEY_FILE contains a PRIVATE key. Pass the .pub file."

  # command= forces every session through rrsync no matter what the client asks
  # for; the no-* options strip the remaining ways an SSH session could be used
  # as a foothold.
  RESTRICT="command=\"$RRSYNC -wo $SITE_DIR/html\",no-agent-forwarding,no-port-forwarding,no-pty,no-user-rc,no-X11-forwarding"
  KEYBODY=$(echo "$PUBKEY" | awk '{print $1" "$2}')

  if grep -qF "$KEYBODY" "$AUTH" 2>/dev/null; then
    echo "key already present, refreshing its restrictions"
    grep -vF "$KEYBODY" "$AUTH" > "$AUTH.tmp" || true
    mv "$AUTH.tmp" "$AUTH"
  fi
  echo "$RESTRICT $PUBKEY" >> "$AUTH"
  chmod 600 "$AUTH"
  chown "$DEPLOY_USER:$DEPLOY_USER" "$AUTH"
  echo "installed, restricted to: $RRSYNC -wo $SITE_DIR/html"
fi

# ---------------------------------------------------------------------------
log "Validating nginx config"
# Catch syntax errors here rather than after the container is already live.
if docker run --rm -v "$SITE_DIR/nginx.conf:/etc/nginx/conf.d/default.conf:ro" \
     nginx:1.27-alpine nginx -t; then
  echo "config OK"
else
  die "nginx config failed validation -- not starting the container"
fi

# ---------------------------------------------------------------------------
if [ "$SKIP_UP" -eq 1 ]; then
  log "Skipping container start (--skip-up)"
elif [ "$NET_UNSET" -eq 1 ]; then
  warn "Not starting the container: PANGOLIN_NETWORK is unset in $SITE_DIR/.env"
  warn "Set it, then run: cd $SITE_DIR && docker compose up -d"
else
  log "Starting the container"
  ( cd "$SITE_DIR" && docker compose up -d )
  sleep 3
  docker ps --filter name=jlogan-web --format 'table {{.Names}}\t{{.Status}}'
fi

# ---------------------------------------------------------------------------
cat <<EOF


==========================================================================
Server side done. Remaining steps, in order:

1. PLACE A TEST FILE so the route can be verified before the real deploy:
     echo ok | sudo tee $SITE_DIR/html/index.html

2. CONFIRM THE CONTAINER SERVES IT, from Traefik's point of view:
     docker exec \$(docker ps --format '{{.Names}}' | grep -i traefik | head -1) \\
       wget -qO- http://jlogan-web/healthz
   Expect: ok
   If this fails, the container is not on Traefik's network -- fix
   PANGOLIN_NETWORK in $SITE_DIR/.env and re-run 'docker compose up -d'.

3. CREATE THE PANGOLIN RESOURCE in the dashboard:
     Site        : a LOCAL site (not a Newt tunnel -- the target is on this host)
     Domain      : jlogan.io          <-- the APEX, not a subdomain
     Target      : http -> jlogan-web -> port 80
     Auth        : DISABLED / public
                   ^ Pangolin defaults resources to requiring SSO. Leaving that
                     on puts a login wall in front of your public website.

   Apex certificates: a wildcard for *.jlogan.io does NOT cover bare jlogan.io.
   If Pangolin only holds a wildcard, the apex needs its own cert; Traefik's
   HTTP-01 challenge handles this once port 80 reaches it.

4. ADD THE GITHUB SECRETS (repo -> Settings -> Secrets -> Actions):
     DEPLOY_SSH_KEY    the PRIVATE half of the keypair (the file without .pub)
     DEPLOY_HOST       this box's public IP or hostname
     DEPLOY_USER       $DEPLOY_USER
     SSH_KNOWN_HOSTS   output of: ssh-keyscan -H <this host>

5. TEST THE DEPLOY PATH from your workstation before trusting CI with it:
     rsync -avn --delete ./public/ -e "ssh -i ~/.ssh/jlogan-deploy" $DEPLOY_USER@<host>:.
   The -n makes it a dry run. If rrsync rejects the trailing '.', drop it.
   A shell must be refused:
     ssh -i ~/.ssh/jlogan-deploy $DEPLOY_USER@<host>    # expect: rejected

6. Only once jlogan.io serves correctly from here, stop homeserveralpha from
   serving the site so a stale copy can never resurface.
==========================================================================
EOF
