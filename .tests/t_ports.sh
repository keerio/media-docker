#!/usr/bin/env bash

# test ports_collide
t_ports() {
  local -a COMPOSE_FILES
  local -a APPS
  local -a ALLPORTS
  local -a PARSEDPORTS
  local COMPOSE

  run_sh "$SCRIPTDIR" "apt_install" "jq"
  run_sh "$SCRIPTDIR" "yq_install"

  APPS=$(run_sh "$SCRIPTDIR" "dir_array" "$CONTAINDIR")
  PARSEDPORTS=("")
  COMPOSE_FILES=("")

  for app in ${APPS[@]} ; do
    if [[ ! "$app" = "traefik" ]] && [[ ! "$app" = "watchtower" ]] ; then
      COMPOSE_FILES=("${COMPOSE_FILES[@]}" \
        "${CONTAINDIR}/${app}/${app}-port.yaml")
    fi
  done

  COMPOSE=$(run_sh "$SCRIPTDIR" "yq_build" \
    ${COMPOSE_FILES[@]})
  
  echo "$COMPOSE" >> "${TESTDIR}/docker-compose-test.yml"

  ALLPORTS=($(yq read -t "${TESTDIR}/docker-compose-test.yml" \
    services.*.ports \
    | cut -c5- ))

  for port in "${ALLPORTS[@]}" ; do
    IFS=":" read -ra port <<< "$port"

    info "Checking for collisions on port: ${port[0]}."

    if [[ $(run_sh "${SCRIPTDIR}" "array_contains" \
      "${port[0]}" "${PARSEDPORTS[@]}") -eq 0 ]] ; then
        err "Collision found on port: "${port[0]}""
    else
      PARSEDPORTS=("${PARSEDPORTS[@]}" "$(echo "${port[0]}" | tr -d "\r")")
    fi
  done

  success "No port collisions detected."
}
