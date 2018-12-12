#!/usr/bin/env bash
set -euo pipefail

menu_traefik_toml() {
  local DIRECTORY
  local FILE
  local DOMAIN
  local EMAIL_ADDRESS

  DIRECTORY="$(run_sh "$SCRIPTDIR" "env_get" "BASE_DIR")"
  FILE="${DIRECTORY}/traefik/traefik.toml"

  log 6 "Checking if traefik.toml exists."
  if [[ -f "${FILE}" ]] ; then
    log 6 "traefik.toml exists, backing up."
    run_sh "$SCRIPTDIR" "file_backup" "${FILE}"
  else
    log 6 "Creating traefik.toml."
    echo >> "${FILE}"
  fi

  log 7 "Opening Traefik configuration menu."
  run_sh "$MENUDIR" "menu_traefik_conf"

  DOMAIN=$(run_sh "$SCRIPTDIR" "env_get" "DOMAIN")
  EMAIL_ADDRESS=$(run_sh "$SCRIPTDIR" "env_get" "EMAIL_ADDRESS")

  log 7 "Opening Traefik user menu."
  run_sh "$MENUDIR" "menu_user"

  log 6 "Running Traefik password encryption process."
  run_sh "$SCRIPTDIR" \
    "password_crypt" "${DIRECTORY}/traefik/traefik.passwd" \
    "$(run_sh "$SCRIPTDIR" "env_get" "USER_NAME")" \
    "$(run_sh "$SCRIPTDIR" "env_get" "PASSWORD")"

  log 6 "Removing secrets from .ENV."
  run_sh "$SCRIPTDIR" "secrets_remove"

  log 7 "Opening Traefik authentication menu."
  run_sh "$MENUDIR" "menu_traefik_auth"

  log 6 "Starting TOML creation process."

  log 6 "Writing [web] block."
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "defaultEntryPoints" "[\"http\",\"https\"]"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "web.address" ":8080"

  log 6 "Writing [entryPoints.traefik.auth] block."
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "entryPoints.traefik.auth.basic.usersfile" "/traefik.passwd"

  log 6 "Writing [entryPoints] block."
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "entryPoints.http.address" ":80"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "entryPoints.http.redirect.entryPoint" "https"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "entryPoints.https.address" ":443"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "entryPoints.https.tls"

  log 6 "Writing [docker] block."
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "docker.endpoint" "unix:///var/run/docker.sock"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "docker.domain" "$DOMAIN"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "docker.watch" "true"

  log 6 "Writing [acme] block."
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.email" "$EMAIL_ADDRESS"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.storage" "acme.json"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.entryPoint" "https"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.onHostRule" "true"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.onDemand" "false"

  log 7 "Opening ACME challenge selection menu."
  run_sh "$MENUDIR" "menu_le_challenge_select"
}