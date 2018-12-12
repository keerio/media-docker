#!/usr/bin/env bash
set -euo pipefail

compose_pull() {
  log 6 "Attempting to pull dependencies for Docker stack."
  sudo docker-compose pull --include-deps \
    > /dev/null 2>&1 || log 3 "Error occured pulling images."
}
