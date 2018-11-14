#!/usr/bin/env bash
set -euo pipefail

apt_prereqs_install() {
  sudo add-apt-repository universe > /dev/null 2>&1 \
    || err "Error adding universe repository."

  sudo apt-get remove docker docker-engine docker.io \
    > /dev/null 2>&1 \
    || err "Error cleaning legacy packages."

  run_sh "$SCRIPTDIR" "apt_install" "apt-transport-https" \
    "ca-certificates" "curl" "software-properties-common" \
    "jq"

  if [[ ! $(command -v "docker") ]] ; then
    run_sh "$SCRIPTDIR" "docker_install"
  fi

  if [[ ! $(command -v "docker-compose") ]] ; then
    run_sh "$SCRIPTDIR" "compose_install"
  fi

  if [[ ! $(command -v "yq") ]] ; then
    run_sh "$SCRIPTDIR" "yq_install"
  fi

  return
}
