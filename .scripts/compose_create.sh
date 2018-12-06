#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

compose_create() {
  local -a ENABLED_APPS
  local -a COMPOSE_FILES
  local COMPOSE
  local PROXY="N"
  local TRAEFIK_AUTH="N"

  ENABLED_APPS=$(run_sh "$SCRIPTDIR" "apps_active_list" "$BASEDIR/.apps")
  LE_DNS_PROV=$(run_sh "$SCRIPTDIR" "env_get" "LE_CHLG_PROV")

  if [[ $(run_sh "$SCRIPTDIR" "app_is_active" "traefik") -eq 0 ]] ; then
    PROXY="Y"
  fi

  if [[ "$(run_sh "$SCRIPTDIR" "env_get" "TRAEFIK_AUTH")" = "Y" ]] ; then
    TRAEFIK_AUTH="Y"
  fi

  if [[ -f "${BASEDIR}/docker-compose.yml" ]] ; then
    run_sh "$SCRIPTDIR" "file_backup" "${BASEDIR}/docker-compose.yml"
  else
    echo >> "${BASEDIR}/docker-compose.yml"
  fi

  COMPOSE_FILES=("${CONTAINDIR}/start.yaml")

  for app in ${ENABLED_APPS[@]} ; do
    if [[ $(run_sh "$SCRIPTDIR" "app_is_supported" \
      "$app" "$ARCH") == 0 ]] ; then
        COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
          "${CONTAINDIR}/${app}/${app}.yaml")

        COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
          "${CONTAINDIR}/${app}/${app}-${ARCH}.yaml")

        if [[ ! "$app" = "traefik" ]] && [[ ! "$app" = "watchtower" ]] ; then
          if [[ "$PROXY" = "Y" ]] ; then
            COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
              "${CONTAINDIR}/${app}/${app}-traefik.yaml")
            if [[ "$TRAEFIK_AUTH" = "Y" ]] ; then
              COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
                "${CONTAINDIR}/${app}/${app}-auth.yaml")
              info "adding auth to file"
            fi
          else
            COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
              "${CONTAINDIR}/${app}/${app}-port.yaml")
          fi
        fi
    else
      info "$app selected but is not supported by ${ARCH}, disabling."
      run_sh "$SCRIPTDIR" "env_set" "$app" "N" ".apps"
    fi
  done

  if [[ ${LE_DNS_PROV} != "HTTP" ]] ; then
    COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
      "${CONTAINDIR}/traefik/traefik-${LE_DNS_PROV}.yaml")
  fi

  COMPOSE_FILES=("${COMPOSE_FILES[@]}" "${CONTAINDIR}/end.yaml")

  COMPOSE=$(run_sh "$SCRIPTDIR" "yq_build" \
    ${COMPOSE_FILES[@]})

  echo "$COMPOSE" >> "${BASEDIR}/docker-compose.yml"
}
