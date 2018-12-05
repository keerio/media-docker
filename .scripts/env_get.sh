#!/usr/bin/env bash
set -euo pipefail

env_get() {
  local KEY
  local FILE
  local SEP
  local VAL

  KEY=${1:-}
  FILE=${2:-".env"}
  SEP=${3:-"="}

  VAL=$(grep "$KEY" "$FILE" | xargs || true)
  IFS="$SEP" read -ra VAL <<< "$VAL"
  if [[ ${VAL[1]+"${VAL[1]}"} ]] ; then
    echo "${VAL[1]}" | tr -d "\r"
  fi
}
