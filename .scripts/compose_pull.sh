#!/usr/bin/env bash
set -euo pipefail

compose_pull() {
  sudo docker-compose pull --include-deps \
    > /dev/null 2>&1 || err "Error occured pulling images."
}