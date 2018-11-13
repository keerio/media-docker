#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

yq_build(){
  local COMPOSE_FILE
  COMPOSE_FILE=$(yq m "$@")
  echo "$COMPOSE_FILE"
}
