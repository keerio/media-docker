#!/usr/bin/env bash
set -euo pipefail

compose_restart() {
  sudo docker-compose restart \
    > /dev/null 2>&1 || err "Error occured restarting services."
}
