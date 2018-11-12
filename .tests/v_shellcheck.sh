#!/usr/bin/env bash
set -euo pipefail

v_shellcheck(){
  run_sh "$SCRIPTDIR" "apt_install" "xz-utils" "shellcheck" \
    || err "Failed to install shellcheck dependencies from apt."

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
      | xargs -0 shellcheck -e SC1090 -e SC2016 -e SC2026
    err "Shellcheck found errors."
  fi

  success "Shellcheck validated with no errors!"
}
