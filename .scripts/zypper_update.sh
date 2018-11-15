#!/usr/bin/env bash
set -euo pipefail

zypper_update() {
  info "Updating zypper repositories."
  sudo zypper -n up > /dev/null 2>&1 \
    || err "Error occurred updating zypper repositories."
  info "Cleaning up remnants of unused packages."
  sudo zypper -n rm -u > /dev/null 2>&1 \
    || err "Failed to clean up unused packages."
  sudo zypper -n clean > /dev/null 2>&1 \
    || err "Failed to cleanup cache from zypper."
}
