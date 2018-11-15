#!/usr/bin/env bash
set -euo pipefail

dnf_prereqs_install() {
  sudo dnf -y remove docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || true

  run_sh "$SCRIPTDIR" "yum_install" \
    "curl" "git" "grep" "sed" "jq"
}
