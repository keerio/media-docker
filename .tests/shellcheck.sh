#!/usr/bin/env bash
set -euo pipefail

shellcheck(){
  run_sh "$SCRIPTDIR" "apt_install" "xz-utils" "shellcheck" \
    || err "Failed to install shellcheck dependencies from apt."

  shellcheck --version \
    || err "Shellcheck not running correctly."

  local ERRS
  ERRS=$(find . -name '*.sh' -print0 | xargs -0 shellcheck || true)

  if [[ -n ${ERRS} ]]
  then
    find . -name '*.sh' -print0 | xargs -0 shellcheck
    err "Shellcheck found errors."
  fi 
}