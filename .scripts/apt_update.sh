#!/usr/bin/env bash
set -euo pipefail

apt_update() {
  log 6 "Updating apt repositories."
  sudo apt-get -y update > /dev/null 2>&1 \
    || log 3 "Error occurred updating apt repositories."
  log 6 "Cleaning up remnants of unused packages."
  sudo apt-get -y autoremove > /dev/null 2>&1 \
    || log 3 "Failed to clean up unused packages."
  sudo apt-get -y autoclean > /dev/null 2>&1 \
    || log 3 "Failed to cleanup cache from apt."
}
