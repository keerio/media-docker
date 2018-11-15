#!/usr/bin/env bash
set -euo pipefail

pacman_prereqs_install() {
  sudo pacman -Rs docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || true

  run_sh "$SCRIPTDIR" "pacman_install" \
    "curl" "git" "grep" "sed" "jq"
}
