#!/usr/bin/env bash
set -euo pipefail

env_set() {
  local KEY
  local VAL
  local FILE

  KEY=${1:-}
  VAL=${2:-}
  FILE=${3:-".env"}

  sed -i '\|^'"$KEY"'=|{h;s|=.*|='"$VAL"'|};
${x;\|^$|{s||'"$KEY"'='"$VAL"'|;H};x}' "$FILE"
}
