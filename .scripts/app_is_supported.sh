#!/usr/bin/env bash
set -euo pipefail

app_is_supported() {
  local APP
  local UARCH

  APP=${1:-}
  UARCH=${2:-}

  if [[ -f "${CONTAINDIR}/${APP}/${APP}-${UARCH}.yaml" ]] ; then
    echo 0
    return 0
  else
    echo 1
    return 1
  fi
}
