#!/usr/bin/env bash
set -euo pipefail

emerge_update() {
  info "Updating emerge repositories."
  sudo emerge -u world > /dev/null 2>&1 \
    || err "Error occurred updating emerge repositories."
  info "Cleaning up remnants of unused packages."
  sudo emerge --depclean > /dev/null 2>&1 \
    || err "Failed to clean up unused packages."
  sudo eclean distfiles > /dev/null 2>&1 \
    || err "Failed to cleanup cache from emerge."
}
