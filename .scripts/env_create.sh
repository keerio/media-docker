#!/usr/bin/env bash
set -euo pipefail

env_create() {
  local SOURCEDIR
  local DESTDIR

  SOURCEDIR=${1:-}
  DESTDIR=${2:-}

  if [[ ! -f "${DESTDIR}/.env" ]]
  then
    sudo cp "${SOURCEDIR}/.env" "${DESTDIR}/.env"
      > /dev/null 2>&1 || err "Error occured copying .env."
  fi
}