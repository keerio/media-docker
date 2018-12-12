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

  log 6 "Starting docker-compose file generation test."

  log 6 "Copying .env"
  sudo cp "${BASEDIR}/.env" "${TESTDIR}/.env" || log 3 "Failure copying .env"

  log 6 "Building docker-compose.yml"

  log 6 "Adding head."
  COMPOSE_FILES=("${CONTAINDIR}/start.yaml")

  for app in ${ENABLED_APPS[@]} ; do
    log 6 "Adding service: ${app}"
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

  log 6 "Adding tail."
  COMPOSE_FILES=("${COMPOSE_FILES[@]}" "${CONTAINDIR}/end.yaml")

  log 6 "Running yq build process."
  COMPOSE=$(run_sh "$SCRIPTDIR" "yq_build" \
    ${COMPOSE_FILES[@]}) || log 3 "Failed to build docker-compose.yml"

  log 6 "Writing generated YAML to file."
  echo "$COMPOSE" >> "${TESTDIR}/docker-compose.yml"

  log 6 "Validating docker-compose configuration."
  cd "${TESTDIR}" || log 3 "Failed to change to test directory."
  sudo docker-compose config || log 3 "Failed to validate docker-compose config."

  log 6 "Bringing up Docker stack."
  if [[ ! $(sudo docker network ls \
    | grep proxied) ]] ; then
      sudo docker network create proxied \
        > /dev/null 2>&1 || log 3 "Error occured creating Docker network."
  fi
  sudo docker-compose up -d --remove-orphans \
    || log 3 "Failure bringing up Docker stack."

  log 6 "Taking down Docker stack"
  sudo docker-compose down || log 3 "Failure taking down Docker stack."

  log 6 "Docker stack generation validated."
}
