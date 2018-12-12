#!/usr/bin/env bash
set -euo pipefail

apt_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  log 6 "Adding universe repository."
  sudo add-apt-repository universe \
    > /dev/null 2>&1 \
    || log 3 "Error adding universe repository."

  if [[ "${NOREMOVE}" = "N" ]] ; then
    log 6 "Removing legacy packages."
    sudo apt-get remove docker docker-engine docker.io \
      > /dev/null 2>&1 \
      || true
  fi

  log 6 "Installing prerequisite packages."
  run_sh "$SCRIPTDIR" "apt_install" "apt-transport-https" \
    "ca-certificates" "software-properties-common" \
    "curl" "git" "grep" "sed" "jq" "apache2-utils" \
    "xmlstarlet"
}
