#!/usr/bin/env bash
set -euo pipefail

yum_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  if [[ "${NOREMOVE}" = "N" ]] ; then
    sudo yum -y remove docker docker-engine docker.io \
      > /dev/null 2>&1 \
      || true
  fi

  run_sh "$SCRIPTDIR" "yum_install" \
    "curl" "git" "grep" "sed" "jq" \
    "newt" "httpd-tools"
}
