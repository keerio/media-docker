#!/usr/bin/env bash
set -euo pipefail

self_config_delete() {
  log 7 "Checking if media-docker config temp file exists."
  if [[ -f "${BASEDIR}/.mdc" ]] ; then
    log 7 "Removing media-docker config temp file."
    sudo rm "${BASEDIR}/.mdc"
  fi
}
