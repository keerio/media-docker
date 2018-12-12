#!/usr/bin/env bash
# shellcheck disable=SC2140
set -euo pipefail

compose_install() {
  local REPO
  local URL
  local COMPOSE_VERSION

  REPO="docker/compose"
  COMPOSE_VERSION=$(run_sh "$SCRIPTDIR" \
    "github_latest_release" "$REPO")
  URL="https://github.com/docker/compose/releases/download/"\
"${COMPOSE_VERSION}/docker-compose-$(uname -s)-${ARCH}"

  log 6 "Installing Docker Compose."
  sudo curl -fsSL "$URL" -o /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || log 3 "Error downloading Docker Compose from URL: ${URL}."

  sudo chmod +x /usr/local/bin/docker-compose \
    > /dev/null 2>&1 \
    || log 3 "Error installing Docker Compose."

  log 6 "Docker Compose successfully installed."
}
