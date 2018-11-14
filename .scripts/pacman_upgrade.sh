#!/usr/bin/env bash
set -euo pipefail

pacman_upgrade() {
  info "Upgrading packages from pacman."
  sudo pacman -Syu > /dev/null 2>&1 \
    || err "Error occurred while updating packages from pacman."
}
