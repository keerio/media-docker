#!/usr/bin/env bash
set -euo pipefail

apt_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  sudo add-apt-repository universe \
    > /dev/null 2>&1 \
    || err "Error adding universe repository."

  if [[ "${NOREMOVE}" = "N" ]] ; then
    sudo apt-get remove docker docker-engine docker.io \
      > /dev/null 2>&1 \
      || true
  fi

  run_sh "$SCRIPTDIR" "apt_install" "apt-transport-https" \
    "ca-certificates" "software-properties-common" \
    "curl" "git" "grep" "sed" "jq" "apache2-utils"
}
