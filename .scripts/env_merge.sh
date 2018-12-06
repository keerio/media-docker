#!/usr/bin/env bash
# shellcheck disable=SC2207
set -euo pipefail

env_merge() {
  local CURRENT_ENV
  local TEMPLATE_ENV
  local TEMP_FILE
  local CURRENT_KEYS

  CURRENT_ENV=${1:-".env"}
  TEMPLATE_ENV=${2:-}
  TEMP_FILE="$(mktemp)"

  touch "${CURRENT_ENV}"
  sudo cp "${CURRENT_ENV}" "${TEMP_FILE}"
  run_sh "$SCRIPTDIR" file_backup "${CURRENT_ENV}"
  sudo cp "${TEMPLATE_ENV}" "${CURRENT_ENV}"

  CURRENT_KEYS=($(run_sh "$SCRIPTDIR" "env_list_keys" "${TEMP_FILE}"))

  for key in "${CURRENT_KEYS[@]}" ; do
    local val
    val=$(run_sh "$SCRIPTDIR" "env_get" "${key}" "${TEMP_FILE}")
    run_sh "${SCRIPTDIR}" "env_set" "${key}" "${val}" "${CURRENT_ENV}"
  done
}
