#!/usr/bin/env bash
set -euo pipefail

pacman_install() {
  run_sh "$SCRIPTDIR" "pacman_update"
  shift

  log 7 "Starting pacman install process."
  sudo pacman -S --noconfirm "$@" \
    > /dev/null 2>&1 || log 3 "Error installing packages: $*."

  log 6 "Successfully installed requested package(s): $*."
  return 0
}
