#!/usr/bin/env bash
set -euo pipefail

user_create() {
  local USER
  local PASS
  local -a RETURN

  USER=${1:-}
  PASS=${2:-1}
  RETURN=("$1" "$2")

  log 6 "Attempting to create system user: ${USER}."
  sudo useradd -p "${PASS}" -d /home/"${USER}" \
    -m -g users -s /bin/bash "${USER}" \
    > /dev/null 2>&1 || log 3 "Failed to create user."

  echo "${RETURN[@]}"
}
