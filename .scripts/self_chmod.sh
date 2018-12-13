#!/usr/bin/env bash
set -euo pipefail

self_chmod() {
  log 7 "Setting ${SOURCENAME} as executable"
  if [[ -f "${SOURCENAME}" ]] ; then
    sudo chmod +x "${SOURCENAME}"
  fi
}
