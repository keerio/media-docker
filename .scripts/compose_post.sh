#!/usr/bin/env bash
# shellcheck disable=SC2143
set -euo pipefail

compose_post() {
  log 6 "Running docker-compose post-processing."
  local APPENV="${BASEDIR}/.apps"

  local KODI_ENABLED
  local KODI_FIRST
  KODI_ENABLED=$(run_sh "$SCRIPTDIR" "env_get" \
    "kodi-headless" "$APPENV" || echo "N")
  KODI_FIRST=$(run_sh "$SCRIPTDIR" "env_get" \
    "KODI_FIRST_RUN" "${BASEDIR}/.env" || echo "N")

  if [[ "${KODI_ENABLED}" == "Y" ]] && [[ "${KODI_FIRST}" == "Y" ]] ; then
    log 7 "Kodi is enabled, run post-process."
    local KODI_CONFIG
    local KODI_DB_HOST
    local KODI_DB_USER
    local KODI_DB_PASS

    KODI_CONFIG="${BASEDIR}/kodi-headless/config/userdata/advancedsettings.xml"
    KODI_DB_HOST="kodi-mariadb"
    KODI_DB_USER="=$(run_sh "$SCRIPTDIR" "env_get" \
      "MARIADB_USER" "${BASEDIR}/.env")"
    KODI_DB_PASS="=$(run_sh "$SCRIPTDIR" "env_get" \
      "MARIADB_PASSWORD" "${BASEDIR}/.env")"

    log 6 "Setting database server host."
    run_sh "${SCRIPTDIR}" "xml_update" "${KODI_CONFIG}" \
      "/advancedsettings/videodatabase/host" "${KODI_DB_HOST}"
    run_sh "${SCRIPTDIR}" "xml_update" "${KODI_CONFIG}" \
      "/advancedsettings/musicdatabase/host" "${KODI_DB_HOST}"

    log 6 "Setting database user name."
    run_sh "${SCRIPTDIR}" "xml_update" "${KODI_CONFIG}" \
      "/advancedsettings/videodatabase/user" "${KODI_DB_USER}"
    run_sh "${SCRIPTDIR}" "xml_update" "${KODI_CONFIG}" \
      "/advancedsettings/musicdatabase/user" "${KODI_DB_USER}"

    log 6 "Setting database password."
    run_sh "${SCRIPTDIR}" "xml_update" "${KODI_CONFIG}" \
      "/advancedsettings/videodatabase/pass" "${KODI_DB_PASS}"
    run_sh "${SCRIPTDIR}" "xml_update" "${KODI_CONFIG}" \
      "/advancedsettings/musicdatabase/pas" "${KODI_DB_PASS}"
  fi
}
