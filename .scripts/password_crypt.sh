#!/usr/bin/env bash
set -euo pipefail

password_crypt() {
  local USER
  local PASS
  local FILE

  FILE=${1:-".htpasswd"}
  USER=${2:-}
  PASS=${3:-}

  touch "$FILE"
  htpasswd -db "$FILE" "$USER" "$PASS"
}
