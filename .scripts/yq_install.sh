#!/usr/bin/env bash
set -euo pipefail

yq_install() {
  local REPO
  local YQ_VERSION
  local URL

  REPO="mikefarah/yq"
  YQ_VERSION=$(run_sh "$SCRIPTDIR" \
    "github_latest_release" "$REPO")
  URL="https://github.com/mikefarah/yq/releases/download/" \
  "${YQ_VERSION}/yq_$(uname -s)_$(uname -m)"
  
  info "Installing yq."
  sudo curl -fsSL "$URL" -o /usr/local/bin/yq \
    > /dev/null 2>&1 \
    || err "Error downloading yq."

  sudo chmod +x /usr/local/bin/yq \
    > /dev/null 2>&1 \
    || err "Error installing yq."

  info "yq installed"
}
