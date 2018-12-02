#!/usr/bin/env bash
set -euo pipefail

self_update() {
  local DIRECTORY
  DIRECTORY=${1:-}
  info "Updating media-docker from Git."

  if [ -d "${DIRECTORY}/.git/" ] ; then
    info "Pulling changes from Git."
    sudo git -C "${DIRECTORY}" pull origin master \
      > /dev/null 2>&1 || err "Error occured when updating from Git."
  else
    info "Git repository not in place, installing."
    sudo rm -r "${DIRECTORY}" && mkdir "${DIRECTORY}" && cd "${DIRECTORY}"
    git clone https://github.com/joskore/media-docker/ "${DIRECTORY}"
  fi

  cd "${DIRECTORY}"

  sudo chmod +x "${SOURCENAME}" \
    > /dev/null 2>&1 \
      || err "Error occurred while making $SOURCENAME executable."
}
