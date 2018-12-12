#!/usr/bin/env bash
set -euo pipefail

pacman_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  if [[ "${NOREMOVE}" = "N" ]] ; then
    log 6 "Removing legacy packages."
    sudo pacman -Rs docker docker-engine docker.io \
      > /dev/null 2>&1 \
      || true
  fi

  log 6 "Installing prerequisite packages."
  run_sh "$SCRIPTDIR" "pacman_install" \
    "curl" "git" "grep" "sed" "jq" \
    "libnewt" "apache-tools"
}
