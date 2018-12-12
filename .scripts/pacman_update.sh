#!/usr/bin/env bash
set -euo pipefail

pacman_update() {
  log 6 "Updating pacman repositories."
  sudo pacman -Syu > /dev/null 2>&1 \
    || log 3 "Error occurred updating pacman repositories."
  log 6 "Cleaning up remnants of unused packages."
  sudo pacman -Qdtq | pacman -Rs - > /dev/null 2>&1 \
    || log 3 "Failed to clean up unused packages."
  sudo pacman -Scc > /dev/null 2>&1 \
    || log 3 "Failed to cleanup cache from pacman."
}
