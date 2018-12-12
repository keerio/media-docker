#!/usr/bin/env bash
set -euo pipefail

pacman_upgrade() {
  log 6 "Upgrading packages from pacman."
  sudo pacman -Syu > /dev/null 2>&1 \
    || log 3 "Error occurred while updating packages from pacman."
}
