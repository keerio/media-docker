#!/usr/bin/env bash
set -euo pipefail

v_bashate(){
  run_sh "$SCRIPTDIR" "apt_install" "python-bashate"

  cd "${BASEDIR}"
  find  . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
    | xargs -0 bashate -i E003 -v \
    || err "Bashate found errors."

  success "Bashate validated with no errors!"
}
