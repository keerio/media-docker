#!/usr/bin/env bash
set -euo pipefail

docker_prune() {
  log 6 "Attempting to prune Docker system."
  docker system prune -a --volumes --force \
    || log 3 "Error occurred while pruning Docker system."
}
