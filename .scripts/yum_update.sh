#!/usr/bin/env bash
set -euo pipefail

yum_update() {
  info "Updating yum repositories."
  sudo yum -y update > /dev/null 2>&1 \
    || err "Error occurred updating yum repositories."
  info "Cleaning up remnants of unused packages."
  sudo yum -y autoremove > /dev/null 2>&1 \
    || err "Failed to clean up unused packages."
  sudo yum -y clean all > /dev/null 2>&1 \
    || err "Failed to cleanup cache from yum."
}
