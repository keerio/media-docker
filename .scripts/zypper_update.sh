#!/usr/bin/env bash
set -euo pipefail

zypper_update() {
  info "Updating zypper repositories."
  sudo zypper up -n > /dev/null 2>&1 \
    || err "Error occurred updating zypper repositories."
  info "Cleaning up remnants of unused packages."
  sudo zypper rm -u -n > /dev/null 2>&1 \
    || err "Failed to clean up unused packages."
  sudo zypper clean -n > /dev/null 2>&1 \
    || err "Failed to cleanup cache from zypper."
}
