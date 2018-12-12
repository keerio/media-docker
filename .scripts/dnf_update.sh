#!/usr/bin/env bash
set -euo pipefail

dnf_update() {
  log 6 "Updating dnf repositories."
  sudo dnf -y update > /dev/null 2>&1 \
    || log 3 "Error occurred updating dnf repositories."
  log 6 "Cleaning up remnants of unused packages."
  sudo dnf -y autoremove > /dev/null 2>&1 \
    || log 3 "Failed to clean up unused packages."
  sudo dnf -y clean all > /dev/null 2>&1 \
    || log 3 "Failed to cleanup cache from dnf."
}
