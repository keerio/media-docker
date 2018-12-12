#!/usr/bin/env bash
set -euo pipefail

self_update() {
  local DIRECTORY
  local REPO
  local BRANCH

  DIRECTORY=${1:-}
  REPO="$(run_sh "$SCRIPTDIR" "env_get" "REPOSITORY")"
  BRANCH="$(run_sh "$SCRIPTDIR" "env_get" "BRANCH")"

  log 6 "Updating media-docker from Git."

  if [ -d "${DIRECTORY}/.git/" ] ; then
    log 6 "Pulling changes from Git."
    sudo git -C "${DIRECTORY}" pull origin "${BRANCH}" \
      > /dev/null 2>&1 || log 3 "Error occured when updating from Git."
  else
    log 6 "Git repository not in place, installing."
    sudo rm -r "${DIRECTORY}" && mkdir "${DIRECTORY}" && cd "${DIRECTORY}"
    git clone -b "${BRANCH}" "${REPO}" "${DIRECTORY}"
  fi

  log 7 "Changing to ${DIRECTORY}."
  cd "${DIRECTORY}"

  log 6 "Setting ${SOURCENAME} to executable."
  sudo chmod +x "${SOURCENAME}" \
    > /dev/null 2>&1 \
      || log 3 "Error occurred while making $SOURCENAME executable."
}
