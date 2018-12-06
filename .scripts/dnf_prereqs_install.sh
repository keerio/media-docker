#!/usr/bin/env bash
set -euo pipefail

dnf_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  if [[ "${NOREMOVE}" = "N" ]] ; then
    sudo dnf -y remove docker docker-engine docker.io \
      > /dev/null 2>&1 \
      || true
  fi

  run_sh "$SCRIPTDIR" "dnf_install" \
    "curl" "git" "grep" "sed" "jq" \
    "newt" "httpd-tools"
}
