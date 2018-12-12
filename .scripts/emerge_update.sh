#!/usr/bin/env bash
set -euo pipefail

emerge_update() {
  log 6 "Updating emerge repositories."
  sudo emerge -u world > /dev/null 2>&1 \
    || log 3 "Error occurred updating emerge repositories."
  log 6 "Cleaning up remnants of unused packages."
  sudo emerge --depclean > /dev/null 2>&1 \
    || log 3 "Failed to clean up unused packages."
  sudo eclean distfiles > /dev/null 2>&1 \
    || log 3 "Failed to cleanup cache from emerge."
}
