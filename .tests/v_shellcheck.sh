#!/usr/bin/env bash
set -euo pipefail

v_shellcheck(){
  shellcheck --version \
    || err "Shellcheck not running correctly."

  cd "${BASEDIR}"
  local ERRS
  ERRS=$(find . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
    | xargs -0 shellcheck -e SC1090 -e SC2016 -e SC2026 \
    || true)

  if [[ -n ${ERRS} ]]
  then
    find . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
      | xargs -0 shellcheck -e SC1090 -e SC2016 -e SC2026 -e SC1117
    err "Shellcheck found errors."
  fi

  success "Shellcheck validated with no errors!"
}
