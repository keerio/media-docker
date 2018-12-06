#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

yq_build(){
  local COMPOSE_FILE
  COMPOSE_FILE=$(sudo yq m -a "$@")
  echo "$COMPOSE_FILE"
}
