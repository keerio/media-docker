#!/usr/bin/env bash
set -euo pipefail

env_create() {
  local SOURCEDIR
  local DESTDIR

  SOURCEDIR=${1:-}
  DESTDIR=${2:-}

  if [[ ! -f "${DESTDIR}/.env" ]]
  then
    sudo cp "${SOURCEDIR}/.env" "${DESTDIR}/.env" \
      > /dev/null 2>&1 || err "Error occured copying .env."
    
    run_sh "$SCRIPTDIR" "env_set" \
      "BASE_DIR" "$BASEDIR/" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR" "$BASEDIR/media/" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "DOWNLOAD_DIR" "$BASEDIR/downloads/" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "TIMEZONE" "$(run_sh "$SCRIPTDIR" "timezone_get")" "${DESTDIR}/.env"
  fi
}