#!/usr/bin/env bash

# test ports_collide
t_ports() {
  local -a COMPOSE_FILES
  local -a APPS
  local -a ALLPORTS
  local -a PARSEDPORTS
  local COMPOSE

  APPS=$(run_sh "$SCRIPTDIR" "dir_array" "$CONTAINDIR")
  PARSEDPORTS=("")
  COMPOSE_FILES=("")

  log 6 "Starting port collision test."

  for app in ${APPS[@]} ; do
    if [[ ! "$app" = "traefik" ]] && [[ ! "$app" = "watchtower" ]] ; then
      log 6 "Adding app: ${app} to test."
      COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
        "${CONTAINDIR}/${app}/${app}-port.yaml")
    fi
  done

  log 6 "Running yq build process."
  COMPOSE=$(run_sh "$SCRIPTDIR" "yq_build" \
    ${COMPOSE_FILES[@]})
  
  log 6 "Writing generated YAML to file."
  echo "$COMPOSE" >> "${TESTDIR}/docker-compose-test.yml"

  log 6 "Reading ports from file."
  ALLPORTS=($(yq read -t "${TESTDIR}/docker-compose-test.yml" \
    services.*.ports \
    | cut -c5- ))

  for port in "${ALLPORTS[@]}" ; do
    IFS=":" read -ra port <<< "$port"

    log 6 "Checking for collisions on port: ${port[0]}."

    if [[ $(run_sh "${SCRIPTDIR}" "array_contains" \
      "${port[0]}" "${PARSEDPORTS[@]}") -eq 0 ]] ; then
        log 3 "Collision found on port: "${port[0]}""
    else
      PARSEDPORTS=("${PARSEDPORTS[@]}" "$(echo "${port[0]}" | tr -d "\r")")
    fi
  done

  log 6 "No port collisions detected."
}
