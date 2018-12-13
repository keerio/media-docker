#!/usr/bin/env bash
set -euo pipefail

self_chmod() {
  log 7 "Setting self as executable"
  if [[ -f "${BASEDIR}/media-docker.sh" ]] ; then
    sudo chmod +x "${BASEDIR}/media-docker.sh"
  fi
}
