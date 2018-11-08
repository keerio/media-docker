#!/usr/bin/env bash
set -euo pipefail

docker_prune() {
  docker system prune -a --volumes --force \
    || err "Error occurred while pruning Docker system."
}