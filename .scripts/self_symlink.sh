#!/usr/bin/env bash
set -euo pipefail

self_symlink() {
  log 7 "Checking if symlink for media-docker exists."
  if [[ -L "/usr/local/bin/media-docker" ]] \
    && [[ "$(readlink -f "${SOURCENAME}")" \
      != "$(readlink -f /usr/local/bin/media-docker)" ]] \
    && [[ "$(readlink -f "${BASEDIR}/${SOURCENAME}")" \
      != "$(readlink -f /usr/local/bin/media-docker)" ]]
  then
    log 7 "Removing old symlink."
    sudo rm "/usr/local/bin/media-docker" \
      || log 3 "Error occurred while removing old symlink"
  fi

  log 7 "Re-checking for existing media-docker symlink."
  if [[ ! -L "/usr/local/bin/media-docker" ]] ; then
    log 6 "Creating symlink for media-docker."
    sudo ln -s -T "${BASEDIR}/${SOURCENAME}" /usr/local/bin/media-docker \
      || log 3 "Error occurred while setting up symlink."
    sudo chmod +x "${BASEDIR}/${SOURCENAME}" > /dev/null 2>&1 \
      || log 3 "Error occurred while setting up symlink."
    log 6 "Created symlink for media-docker."
  fi
}
