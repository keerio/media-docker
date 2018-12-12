#!/usr/bin/env bash
set -euo pipefail

apps_create() {
  local SOURCEDIR
  local DESTDIR

  SOURCEDIR=${1:-}
  DESTDIR=${2:-}

  log 6 "Creating .APPS."
  if [[ ! -f "${DESTDIR}/.apps" ]] ; then
    sudo cp "${SOURCEDIR}/.apps" "${DESTDIR}/.apps" \
      > /dev/null 2>&1 || log 3 "Error occured copying .apps."
  fi

  echo 0
  return 0
}
