#!/usr/bin/env bash
set -euo pipefail

zypper_prereqs_install() {
  sudo zypper -n rm docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || true

  run_sh "$SCRIPTDIR" "zypp_install" \
    "curl" "git-core" "grep" "sed" "jq" \
    "newt"
}
