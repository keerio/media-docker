#!/usr/bin/env bash
set -euo pipefail

apt_prereqs_install() {
  sudo add-apt-repository universe \
    > /dev/null 2>&1 \
    || err "Error adding universe repository."

  sudo apt-get remove docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || true

  run_sh "$SCRIPTDIR" "apt_install" "apt-transport-https" \
    "ca-certificates" "software-properties-common" \
    "curl" "git" "grep" "sed" "jq" "htpasswd"
}
