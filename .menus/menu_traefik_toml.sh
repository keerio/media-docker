#!/usr/bin/env bash
set -euo pipefail

menu_traefik_toml() {
  local FILE="${DIRECTORY}/traefik/traefik.toml"
  local DOMAIN
  local EMAIL_ADDRESS

  local -a OPTIONS
  OPTIONS+=("DOMAIN" "Domain for usage with Traefik reverse proxy.")
  OPTIONS+=("EMAIL_ADDRESS" "Email for usage with Traefik reverse proxy.")

  local SELECTION
  SELECTION=$(whiptail --fb --clear --title "media-docker Configuration" \
    --cancel-button "Exit" --menu "Select a traefik item to update." 0 0 0 \
    "${OPTIONS[@]}" 3>&1 1>&2 2>&3 || echo "Exit")

  case $SELECTION in
    "Exit")
    ;;
    *)
      run_sh "$MENUDIR" "menu_env_update" \
        "$SELECTION" \
        "$(run_sh "$SCRIPTDIR" "env_get" "$SELECTION" "$BASEDIR/.env")"

      run_sh "$MENUDIR" "menu_traefik_toml"
      exit
    ;;
  esac

  DOMAIN=$(run_sh "$SCRIPTDIR" "env_get" "DOMAIN")
  EMAIL_ADDRESS=$(run_sh "$SCRIPTDIR" "env_get" "EMAIL_ADDRESS")

  run_sh "$MENUDIR" "menu_user"
  run_sh "$SCRIPTDIR" \
    "password_crypt" "${DIRECTORY}/traefik/traefik.passwd"

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
