#!/usr/bin/env bash
set -euo pipefail

yum_prereqs_install() {
  sudo yum -y remove docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || true

  run_sh "$SCRIPTDIR" "yum_install" \
    "curl" "git" "grep" "sed" "jq" \
    "newt" "htpasswd"
}
