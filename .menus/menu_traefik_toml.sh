#!/usr/bin/env bash
set -euo pipefail

menu_traefik_toml() {
  local DIRECTORY
  local FILE
  local DOMAIN
  local EMAIL_ADDRESS

  DIRECTORY="$(run_sh "$SCRIPTDIR" "env_get" "BASE_DIR")"
  FILE="${DIRECTORY}/traefik/traefik.toml"

  if [[ -f "${FILE}" ]] ; then
    run_sh "$SCRIPTDIR" "file_backup" "${FILE}"
  else
    echo >> "${FILE}"
  fi

  run_sh "$MENUDIR" "menu_traefik_conf"

  DOMAIN=$(run_sh "$SCRIPTDIR" "env_get" "DOMAIN")
  EMAIL_ADDRESS=$(run_sh "$SCRIPTDIR" "env_get" "EMAIL_ADDRESS")

  run_sh "$MENUDIR" "menu_user"

  run_sh "$SCRIPTDIR" \
    "password_crypt" "${DIRECTORY}/traefik/traefik.passwd" \
    "$(run_sh "$SCRIPTDIR" "env_get" "USER_NAME")" \
    "$(run_sh "$SCRIPTDIR" "env_get" "PASSWORD")"

  run_sh "$SCRIPTDIR" "secrets_remove"

  run_sh "$MENUDIR" "menu_traefik_auth"

  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "defaultEntryPoints" "[\"http\",\"https\"]"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "web.address" ":8080"

  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "entryPoints.traefik.auth.basic.usersfile" "/traefik.passwd"

  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "entryPoints.http.address" ":80"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "entryPoints.http.redirect.entryPoint" "https"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "entryPoints.https.address" ":443"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "entryPoints.https.tls"

  run_sh "$SCRIPTDIR" "toml_write" "$FILE" \
    "docker.endpoint" "unix:///var/run/docker.sock"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "docker.domain" "$DOMAIN"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "docker.watch" "true"

  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.email" "$EMAIL_ADDRESS"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.storage" "acme.json"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.entryPoint" "https"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.onHostRule" "true"
  run_sh "$SCRIPTDIR" "toml_write" "$FILE" "acme.onDemand" "false"

  run_sh "$MENUDIR" "menu_le_challenge_select"
}