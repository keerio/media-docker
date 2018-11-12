#!/usr/bin/env bash
set -euo pipefail

compose_install() {
  local URL
  local COMPOSE_VERSION

  COMPOSE_VERSION=${1:-}
  URL="https://github.com/docker/compose/releases/download/" \
"${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"

  info "Installing Docker Compose."
  sudo curl -fsSL "$URL" -o /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || err "Error downloading Docker Compose."

  sudo chmod +x /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || err "Error installing Docker Compose."

  info "Docker Compose installed"
}
