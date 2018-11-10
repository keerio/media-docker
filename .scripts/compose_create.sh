#!/usr/bin/env bash
set -euo pipefail

compose_create() {
  local -a ENABLED_APPS
  local PROXY

  ENABLED_APPS=$(run_sh "$SCRIPTDIR" "apps_active_list" "$BASEDIR/.apps")
  PROXY=${1:-"N"}

  if [[ -f "${BASEDIR}/docker-compose.yml" ]]
  then
    run_sh "$SCRIPTDIR" "file_backup" "${BASEDIR}/docker-compose.yml"
  else
    echo >> "${BASEDIR}/docker-compose.yml"
  fi

  run_sh "$SCRIPTDIR" "file_append" \
    "${BASEDIR}/docker-compose.yml" \
    "${CONTAINDIR}/start"

  for app in ${ENABLED_APPS[@]} ; do
    if [[ "$PROXY" = "Y" ]]
    then
      run_sh "$SCRIPTDIR" "file_append" \
        "${BASEDIR}/docker-compose.yml" \
        "${CONTAINDIR}/${app}/${app}-traefik"
    else
      run_sh "$SCRIPTDIR" "file_append" \
        "${BASEDIR}/docker-compose.yml" \
        "${CONTAINDIR}/${app}/${app}-port"
    fi
  done

  run_sh "$SCRIPTDIR" "file_append" \
    "${BASEDIR}/docker-compose.yml" \
    "${CONTAINDIR}/end"
}