#!/usr/bin/env bash
# shellcheck disable=SC2207
set -euo pipefail

apps_active_list() {
  local FILE
  local -a RESULT
  local -a APPS

  APPS=()

  FILE=${1:-".apps"}

  RESULT=($(sudo grep "Y" "$FILE" | grep -v "#"))
  for res in "${RESULT[@]}" ; do
    IFS="=" read -ra res <<< "$res"
    APPS=("${APPS[@]}" "$(echo "$res" | tr -d "\r")")
  done

  echo "${APPS[@]}"
}
