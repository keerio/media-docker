#!/usr/bin/env bash
set -euo pipefail

docker_install() {
  info "Installing Docker."
  sudo curl -fsSL get.docker.com \
    | sudo bash \
    > /dev/null 2>&1 || err "Failed to install Docker engine."
}
