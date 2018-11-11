#!/usr/bin/env bash
set -euo pipefail

compose_install() {
  local COMPOSE_VERSION
  COMPOSE_VERSION=${1:-}
  info "Installing Docker Compose."
  sudo curl -fsSL https://github.com/docker/compose/releases/download/"${COMPOSE_VERSION}"/docker-compose-"$(uname -s)"-"$(uname -m)" \
    -o /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || err "Error downloading Docker Compose."
  
  sudo chmod +x /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || err "Error installing Docker Compose."
  
  success "Docker Compose installed"
}