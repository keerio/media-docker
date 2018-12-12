#!/usr/bin/env bash
set -euo pipefail

password_crypt() {
  local USER
  local PASS
  local FILE

  FILE=${1:-".htpasswd"}
  USER=${2:-}
  PASS=${3:-}

  log 7 "Attempting to encrypt value."

  log 7 "Ensuring htpasswd file: ${FILE} exists."
  touch "$FILE"

  log 7 "Attempting htpasswd."
  htpasswd -b "$FILE" "$USER" "$PASS"
}
