#!/usr/bin/env bash
set -euo pipefail

password_crypt() {
  local USER
  local PASS
  local FILE

  FILE=${1:-"$BASEDIR/.htpasswd"}
  USER=${2:-"$(run_sh "$SCRIPTDIR" "env_get" "USER_NAME")"}
  PASS=${3:-"$(run_sh "$SCRIPTDIR" "env_get" "PASSWORD")"}

  touch "$FILE"
  htpasswd -db "$FILE" "$USER" "$PASS"

  run_sh "$SCRIPTDIR" "secrets_remove"
}
