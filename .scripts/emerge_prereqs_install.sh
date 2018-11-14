#!/usr/bin/env bash
set -euo pipefail

emerge_prereqs_install() {
  sudo emerge -C docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || err "Error cleaning legacy packages."

  run_sh "$SCRIPTDIR" "emerge_install" \
    "curl" "git" "grep" "sed" "jq"
}
