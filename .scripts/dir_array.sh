#!/usr/bin/env bash
set -euo pipefail

dir_array() {
  local BASE
  local -a DIRS

  BASE=${1:-}

  for d in $BASE/*/ ; do
    DIRS=("${DIRS[@]}" "$(echo $(basename "$d" | tr -d "/"))")
  done
  
  echo "${DIRS[@]}"
}