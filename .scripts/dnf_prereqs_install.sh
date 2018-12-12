#!/usr/bin/env bash
set -euo pipefail

dnf_prereqs_install() {
  local NOREMOVE
  NOREMOVE=${1-:"N"}

  if [[ "${NOREMOVE}" = "N" ]] ; then
    log 6 "Removing legacy packages."
    sudo dnf -y remove docker docker-client \
      docker-client-latest docker-common \
      docker-latest docker-latest-logrotate \
      docker-logrotate docker-selinux \
      docker-engine-selinux docker-engine \
      > /dev/null 2>&1 \
      || true
  fi

  log 6 "Installing prerequisite packages."
  run_sh "$SCRIPTDIR" "dnf_install" \
    "curl" "git" "grep" "sed" "jq" \
    "newt" "httpd-tools"
}
