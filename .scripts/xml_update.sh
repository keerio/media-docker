#!/usr/bin/env bash
# shellcheck disable=SC2068
set -euo pipefail

xml_update(){
  local FILE=${1:-}
  local KEY=${2:-}
  local VAL=${3:-}
  local OUTPUT

  run_sh "${SCRIPTDIR}" "file_backup" "${FILE}"

  log 7 "Attempting to update ${KEY} in ${FILE} with value: ${VAL}."
  OUTPUT=$(sudo xmlstarlet ed -u "${KEY}" -v "${VAL}" "${FILE}" \
    || log 4 "Error occurred while updating ${KEY} in ${FILE}.")

  echo "${OUTPUT}" | sudo tee "${FILE}"
}
