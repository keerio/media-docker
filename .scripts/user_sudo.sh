#!/usr/bin/env bash
set -euo pipefail

user_sudo() {
  local USER

  USER=${1:-}

  sudo usermod -aG sudo "${USER}" \
    > /dev/null 2>&1 || err "Error setting user as sudo-er."
}