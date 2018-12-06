#!/usr/bin/env bash
set -euo pipefail

secrets_remove() {
  run_sh "$SCRIPTDIR" "env_set" "USER_NAME" "" "$BASEDIR/.env"
  run_sh "$SCRIPTDIR" "env_set" "PASSWORD" "" "$BASEDIR/.env"
}
