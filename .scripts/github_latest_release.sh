#!/usr/bin/env bash
set -euo pipefail

github_latest_release() {
  log 7 "Grabbing latest release tag from GitHub."
  curl --silent "https://api.github.com/repos/$1/releases/latest" \
    | grep '"tag_name":' \
    | sed -E 's/.*"([^"]+)".*/\1/'
}
