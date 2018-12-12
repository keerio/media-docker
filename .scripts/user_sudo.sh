#!/usr/bin/env bash
set -euo pipefail

user_sudo() {
  local USER
  USER=${1:-}

  log 6 "Attempting to make ${USER} a sudo-er."
  sudo usermod -aG sudo "${USER}" \
    > /dev/null 2>&1 || log 3 "Error setting user as sudo-er."
}
