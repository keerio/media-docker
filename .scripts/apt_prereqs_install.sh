#!/usr/bin/env bash
set -euo pipefail

apt_prereqs_install() {
  sudo apt-get remove docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || err "Error cleaning legacy packages."

  run_sh "$SCRIPTDIR" "apt_install" "apt-transport-https" \
    "ca-certificates" "software-properties-common" \
    "curl" "git" "grep" "sed" "jq"
}
