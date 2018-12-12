#!/usr/bin/env bash
set -euo pipefail

docker_install() {
  log 6 "Installing Docker."
  sudo curl -fsSL get.docker.com \
    | sudo bash \
    > /dev/null 2>&1 || log 3 "Failed to install Docker engine."
}
