#!/usr/bin/env bash
set -euo pipefail

app_is_supported() {
  local APP
  local UARCH

  APP=${1:-}
  UARCH=${2:-}

  log 7 "Checking if ${APP} is supported by ${UARCH}."
  if [[ -f "${CONTAINDIR}/${APP}/${APP}-${UARCH}.yaml" ]] ; then
    log 7 "${APP} is supported by ${UARCH}."
    echo 0
    return 0
  else
    log 7 "${APP} is not supported by ${UARCH}."
    echo 1
    return 1
  fi
}
