#!/usr/bin/env bash
set -euo pipefail

yum_update() {
  log 6 "Updating yum repositories."
  sudo yum -y update > /dev/null 2>&1 \
    || log 3 "Error occurred updating yum repositories."
  log 6 "Cleaning up remnants of unused packages."
  sudo yum -y autoremove > /dev/null 2>&1 \
    || log 3 "Failed to clean up unused packages."
  sudo yum -y clean all > /dev/null 2>&1 \
    || log 3 "Failed to cleanup cache from yum."
}
