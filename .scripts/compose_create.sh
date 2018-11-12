#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

compose_create() {
  local -a ENABLED_APPS
  local PROXY="N"

  ENABLED_APPS=$(run_sh "$SCRIPTDIR" "apps_active_list" "$BASEDIR/.apps")

  if [[ $(run_sh "$SCRIPTDIR" "app_is_active" "traefik") -eq 0 ]] ; then
    PROXY="Y"
  fi

  if [[ -f "${BASEDIR}/docker-compose.yml" ]] ; then
    run_sh "$SCRIPTDIR" "file_backup" "${BASEDIR}/docker-compose.yml"
  else
    echo >> "${BASEDIR}/docker-compose.yml"
  fi

  run_sh "$SCRIPTDIR" "file_append" \
    "${BASEDIR}/docker-compose.yml" \
    "${CONTAINDIR}/start"

  for app in ${ENABLED_APPS[@]} ; do
    if [[ "$app" = "traefik" ]] || [[ "$app" = "watchtower" ]] ; then
      run_sh "$SCRIPTDIR" "file_append" \
        "${BASEDIR}/docker-compose.yml" \
        "${CONTAINDIR}/${app}/${app}"
    elif [[ "$PROXY" = "Y" ]] ; then
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
