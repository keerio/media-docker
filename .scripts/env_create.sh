#!/usr/bin/env bash
set -euo pipefail

env_create() {
  local SOURCEDIR
  local DESTDIR

  SOURCEDIR=${1:-}
  DESTDIR=${2:-}

  log 7 "Checking if .ENV exists."
  if [[ ! -f "${DESTDIR}/.env" ]] ; then
    log 7 ".ENV does not exist, creating."
    sudo cp "${SOURCEDIR}/.env" "${DESTDIR}/.env" \
      > /dev/null 2>&1 || log 3 "Error occured copying .env."

    log 7 "Setting default .ENV values."
    run_sh "$SCRIPTDIR" "env_set" \
      "BASE_DIR" "$BASEDIR/" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "CONTAINER_DIR" "$BASEDIR/containers" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MOVIES" "$BASEDIR/media/Movies" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MUSIC" "$BASEDIR/media/Music" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_TV" "$BASEDIR/media/TV" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_BOOKS" "$BASEDIR/media/Books" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_COMICS" "$BASEDIR/media/Comics" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "DOWNLOAD_DIR" "$BASEDIR/downloads/" "${DESTDIR}/.env"
    run_sh "$SCRIPTDIR" "env_set" \
      "TIMEZONE" "$(run_sh "$SCRIPTDIR" "timezone_get")" "${DESTDIR}/.env"
  fi

  run_sh "$SCRIPTDIR" "env_merge" "${DESTDIR}/.env" "${SOURCEDIR}/.env"

  log 7 "Setting media directories where legacy media directory is set."
  local MEDIA_DIR
  MEDIA_DIR="$(run_sh "$SCRIPTDIR" "env_get" "MEDIA_DIR")"

  if [[ -n "${MEDIA_DIR}" ]] \
    && [[ -z "$(run_sh "$SCRIPTDIR" "env_get" "MEDIA_DIR_MOVIES")" ]] ; then
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MOVIES" "${MEDIA_DIR}/Movies" "${DESTDIR}/.env"
  fi

  if [[ -n "${MEDIA_DIR}" ]] \
    && [[ -z "$(run_sh "$SCRIPTDIR" "env_get" "MEDIA_DIR_MUSIC")" ]] ; then
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MOVIES" "${MEDIA_DIR}/Music" "${DESTDIR}/.env"
  fi

  if [[ -n "${MEDIA_DIR}" ]] \
    && [[ -z "$(run_sh "$SCRIPTDIR" "env_get" "MEDIA_DIR_TV")" ]] ; then
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MOVIES" "${MEDIA_DIR}/TV" "${DESTDIR}/.env"
  fi

  if [[ -n "${MEDIA_DIR}" ]] \
    && [[ -z "$(run_sh "$SCRIPTDIR" "env_get" "MEDIA_DIR_BOOKS")" ]] ; then
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MOVIES" "${MEDIA_DIR}/Books" "${DESTDIR}/.env"
  fi

  if [[ -n "${MEDIA_DIR}" ]] \
    && [[ -z "$(run_sh "$SCRIPTDIR" "env_get" "MEDIA_DIR_COMICS")" ]] ; then
    run_sh "$SCRIPTDIR" "env_set" \
      "MEDIA_DIR_MOVIES" "${MEDIA_DIR}/Comics" "${DESTDIR}/.env"
  fi

  if [[ -z "$(run_sh "$SCRIPTDIR" "env_get" "CONTAINER_DIR")" ]] ; then
    run_sh "$SCRIPTDIR" "env_set" \
      "CONTAINER_DIR" "${BASE_DIR}/" "${DESTDIR}/.env"
  fi

  echo 0
  return 0
}
