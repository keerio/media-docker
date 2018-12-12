#!/usr/bin/env bash
set -euo pipefail

dir_array() {
  local BASE
  local -a DIRS

  BASE=${1:-}
  DIRS=("")

  log 7 "Creating array from sub-directories of ${BASE}."
  for d in "$BASE"/*/ ; do
    DIRS=("${DIRS[@]}" "$(basename "$d" | tr -d "/")")
  done

  echo "${DIRS[@]}"
}
