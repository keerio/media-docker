#!/usr/bin/env bash
set -euo pipefail

compose_restart() {
  log 6 "Attempting to restart Docker stack."
  sudo docker-compose restart \
    > /dev/null 2>&1 || log 3 "Error occured restarting services."
}
