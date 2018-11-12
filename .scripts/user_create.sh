#!/usr/bin/env bash
set -euo pipefail

user_create() {
  local USER
  local PASS
  local -a RETURN

  USER=${1:-}
  PASS=${2:-1}
  RETURN=("$1" "$2")

  sudo useradd -p "${PASS}" -d /home/"${USER}" \
    -m -g users -s /bin/bash "${USER}" \
    > /dev/null 2>&1 || err "Failed to create user."

  echo "${RETURN[@]}"
}
