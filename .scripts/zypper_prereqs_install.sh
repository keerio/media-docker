#!/usr/bin/env bash
set -euo pipefail

zypper_prereqs_install() {
  sudo zypper rm -n docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || true

  run_sh "$SCRIPTDIR" "yum_install" \
    "curl" "git" "grep" "sed" "jq"
}
