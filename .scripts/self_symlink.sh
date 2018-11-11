#!/usr/bin/env bash
set -euo pipefail

self_symlink() {
  if [[ -L "/usr/local/bin/media-docker" ]] \
    && [[ "$(readlink -f "${SOURCENAME}")" \
      != "$(readlink -f /usr/local/bin/media-docker)" ]] \
    && [[ "$(readlink -f "${BASEDIR}/${SOURCENAME}")" \
      != "$(readlink -f /usr/local/bin/media-docker)" ]]
  then
    sudo rm "/usr/local/bin/media-docker" \
      || err "Error occurred while removing old symlink"
  fi

  if [[ ! -L "/usr/local/bin/media-docker" ]]
  then
    info "Creating symlink for media-docker."
    sudo ln -s -T "${BASEDIR}/${SOURCENAME}" /usr/local/bin/media-docker \
      || err "Error occurred while setting up symlink."
    sudo chmod +x "${BASEDIR}/${SOURCENAME}" > /dev/null 2>&1 \
      || err "Error occurred while setting up symlink."
    success "Created symlink for media-docker."
  fi
}