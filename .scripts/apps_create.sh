#!/usr/bin/env bash
set -euo pipefail

apps_create() {
  local SOURCEDIR
  local DESTDIR

  SOURCEDIR=${1:-}
  DESTDIR=${2:-}

  if [[ ! -f "${DESTDIR}/.apps" ]] ; then
    sudo cp "${SOURCEDIR}/.apps" "${DESTDIR}/.apps" \
      > /dev/null 2>&1 || err "Error occured copying .apps."
  fi
}
