#!/usr/bin/env bash
set -euo pipefail

secrets_remove() {
  log 7 "Removing secrets from ${BASEDIR}/.env"
  run_sh "$SCRIPTDIR" "env_set" "USER_NAME" "" "$BASEDIR/.env"
  run_sh "$SCRIPTDIR" "env_set" "PASSWORD" "" "$BASEDIR/.env"
}
