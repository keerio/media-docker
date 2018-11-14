#!/usr/bin/env bash
set -euo pipefail

docker_install() {
  BASEDIR="./"
  curl -fsSL get.docker.com \
    | bash \
    > /dev/null 2>&1 || err "Failed to install Docker engine."
}
