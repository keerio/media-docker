#!/usr/bin/env bash
set -euo pipefail

pacman_update() {
  info "Updating pacman repositories."
  sudo pacman -Syu > /dev/null 2>&1 \
    || err "Error occurred updating pacman repositories."
  info "Cleaning up remnants of unused packages."
  sudo pacman -Qdtq | pacman -Rs - > /dev/null 2>&1 \
    || err "Failed to clean up unused packages."
  sudo pacman -Scc > /dev/null 2>&1 \
    || err "Failed to cleanup cache from pacman."
}
