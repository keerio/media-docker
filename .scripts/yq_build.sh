#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

yq_build(){
  log 7 "Running yq build process."
  local COMPOSE_FILE
  COMPOSE_FILE=$(sudo yq m -a "$@")
  echo "$COMPOSE_FILE"
}
