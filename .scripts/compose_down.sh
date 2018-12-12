#!/usr/bin/env bash
set -euo pipefail

compose_down() {
  log 6 "Attempting to take down Docker stack."
  sudo docker-compose down --remove-orphans \
    > /dev/null 2>&1 || log 3 "Error occured taking down Docker stack."
}
