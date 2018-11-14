#!/usr/bin/env bash
set -euo pipefail

dnf_update() {
  info "Updating dnf repositories."
  sudo dnf -y update > /dev/null 2>&1 \
    || err "Error occurred updating dnf repositories."
  info "Cleaning up remnants of unused packages."
  sudo dnf -y autoremove > /dev/null 2>&1 \
    || err "Failed to clean up unused packages."
  sudo dnf -y clean all > /dev/null 2>&1 \
    || err "Failed to cleanup cache from dnf."
}
