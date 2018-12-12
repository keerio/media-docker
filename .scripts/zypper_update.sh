#!/usr/bin/env bash
set -euo pipefail

zypper_update() {
  log 6 "Updating zypper repositories."
  sudo zypper -n up > /dev/null 2>&1 \
    || log 3 "Error occurred updating zypper repositories."
  log 6 "Cleaning up remnants of unused packages."
  sudo zypper -n rm -u > /dev/null 2>&1 \
    || log 3 "Failed to clean up unused packages."
  sudo zypper -n clean > /dev/null 2>&1 \
    || log 3 "Failed to cleanup cache from zypper."
}
