#!/usr/bin/env bash
set -euo pipefail

self_update() {
  local DIRECTORY
  local REPO
  local BRANCH

  DIRECTORY=${1:-}
  REPO="$(run_sh "$SCRIPTDIR" "env_get" "REPOSITORY")"
  BRANCH="$(run_sh "$SCRIPTDIR" "env_get" "BRANCH")"

  info "Updating media-docker from Git."

  if [ -d "${DIRECTORY}/.git/" ] ; then
    info "Pulling changes from Git."
    sudo git -C "${DIRECTORY}" pull origin "${BRANCH}" \
      > /dev/null 2>&1 || err "Error occured when updating from Git."
  else
    info "Git repository not in place, installing."
    sudo rm -r "${DIRECTORY}" && mkdir "${DIRECTORY}" && cd "${DIRECTORY}"
    git clone -b "${BRANCH}" "${REPO}" "${DIRECTORY}"
  fi

  cd "${DIRECTORY}"

  sudo chmod +x "${SOURCENAME}" \
    > /dev/null 2>&1 \
      || err "Error occurred while making $SOURCENAME executable."
}
