#!/usr/bin/env bash
# shellcheck disable=SC2140
set -euo pipefail

yq_install() {
  local REPO
  local YQ_VERSION
  local URL
  local PARSEDARCH
  local -A ARCHMAP

  ARCHMAP[x86_64]=amd64
  ARCHMAP[aarch64]=arm64
  ARCHMAP[armhf]=arm

  PARSEDARCH="${ARCHMAP[$ARCH]}"

  REPO="mikefarah/yq"
  YQ_VERSION=$(run_sh "$SCRIPTDIR" \
    "github_latest_release" "$REPO")
  URL="https://github.com/mikefarah/yq/releases/download/"\
"${YQ_VERSION}/yq_$(uname -s)_$PARSEDARCH"

  log 6 "Installing yq."
  sudo curl -fsSL "$URL" -o /usr/local/bin/yq \
    > /dev/null 2>&1 \
    || log 3 "Error downloading yq."

  sudo chmod +x /usr/local/bin/yq \
    > /dev/null 2>&1 \
    || log 3 "Error installing yq."

  log 6 "yq installed"
}
