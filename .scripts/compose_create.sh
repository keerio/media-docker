#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

compose_create() {
  local -a ENABLED_APPS
  local -a COMPOSE_FILES
  local COMPOSE
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

  COMPOSE_FILES=("${CONTAINDIR}/start.yaml")

  for app in ${ENABLED_APPS[@]} ; do
    COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
      "${CONTAINDIR}/${app}/${app}.yaml")
    if [[ ! "$app" = "traefik" ]] && [[ ! "$app" = "watchtower" ]] ; then
      if [[ "$PROXY" = "Y" ]] ; then
        COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
          "${CONTAINDIR}/${app}/${app}-traefik.yaml")
      else
        COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
          "${CONTAINDIR}/${app}/${app}-port.yaml")
      fi
    fi
  done

  COMPOSE_FILES=("${COMPOSE_FILES[@]}" "${CONTAINDIR}/end.yaml")

  COMPOSE=$(run_sh "$SCRIPTDIR" "yq_build" \
    ${COMPOSE_FILES[@]})

  echo "$COMPOSE" >> "${BASEDIR}/docker-compose.yml"
}
