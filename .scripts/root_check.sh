#!/usr/bin/env bash
set -euo pipefail

root_check() {
  if [[ ${EUID} -ne 0 ]]; then
    log 4 "media-docker must be run as root."
    echo 1
    return 1
  fi

  echo 0
  return 0
}
