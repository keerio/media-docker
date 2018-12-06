#!/usr/bin/env bash

# test compose generation
t_compose() {
  local -a ENABLED_APPS
  local -a COMPOSE_FILES
  local COMPOSE
  local PROXY="N"
  local TRAEFIK_AUTH="N"

  ENABLED_APPS=$(run_sh "$SCRIPTDIR" "apps_active_list" "${TESTDIR}/.appsAll")
  LE_DNS_PROV=$(run_sh "$SCRIPTDIR" "env_get" "LE_CHLG_PROV")

  info "Copying .env"
  sudo cp "${BASEDIR}/.env" "${TESTDIR}/.env" || err "Failure copying .env"

  info "Building docker-compose.yml"

  COMPOSE_FILES=("${CONTAINDIR}/start.yaml")

  for app in ${ENABLED_APPS[@]} ; do
    COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
      "${CONTAINDIR}/${app}/${app}.yaml")

    COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
      "${CONTAINDIR}/${app}/${app}-x86_64.yaml")

    if [[ ! "$app" = "traefik" ]] && [[ ! "$app" = "watchtower" ]] ; then
      COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
        "${CONTAINDIR}/${app}/${app}-traefik.yaml")
      
      COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
        "${CONTAINDIR}/${app}/${app}-auth.yaml")
          
      COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
        "${CONTAINDIR}/${app}/${app}-port.yaml")
    fi
  done

  COMPOSE_FILES=("${COMPOSE_FILES[@]}" "${CONTAINDIR}/end.yaml")

  COMPOSE=$(run_sh "$SCRIPTDIR" "yq_build" \
    ${COMPOSE_FILES[@]}) || err "Failed to build docker-compose.yml"

  echo "$COMPOSE" >> "${TESTDIR}/docker-compose.yml"

  info "Validating docker-compose configuration."
  cd "${TESTDIR}" || err "Failed to change to test directory."
  sudo docker-compose config || err "Failed to validate docker-compose config."

  info "Bringing up Docker stack."
  if [[ ! $(sudo docker network ls \
    | grep proxied) ]] ; then
      sudo docker network create proxied \
        > /dev/null 2>&1 || err "Error occured creating Docker network."
  fi
  sudo docker-compose up -d --remove-orphans \
    || err "Failure bringing up Docker stack."

  info "Taking down Docker stack"
  sudo docker-compose down || err "Failure taking down Docker stack."

  success "Docker stack generation validated."
}
