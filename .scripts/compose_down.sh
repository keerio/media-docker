#!/usr/bin/env bash
set -euo pipefail

compose_down() {
  sudo docker-compose down --remove-orphans \
    > /dev/null 2>&1 || err "Error occured stopping services."
}
