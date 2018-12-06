#!/usr/bin/env bash
# shellcheck disable=SC2207
set -euo pipefail

env_list_keys() {
  local -a KEYS
  local -a RESULT
  local FILE

  FILE=${1:-".env"}

  RESULT=($(IFS='\r\n' sudo cat "$FILE"))
  for res in "${RESULT[@]}" ; do
    IFS="=" read -ra res <<< "$res"
    set +u
    KEYS=("${KEYS[@]}" "$(echo "${res[0]}" | tr -d "\r")")
    set -u
  done

  echo "${KEYS[@]}"
}
