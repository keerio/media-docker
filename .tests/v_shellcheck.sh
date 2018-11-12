#!/usr/bin/env bash
set -euo pipefail

v_shellcheck(){
  export scversion="v0.4.6"
  wget "https://storage.googleapis.com/shellcheck/shellcheck-${scversion}.linux.x86_64.tar.xz"
  tar --xz -xvf shellcheck-"${scversion}".linux.x86_64.tar.xz
  cp shellcheck-"${scversion}"/shellcheck /usr/bin/

  shellcheck --version \
    || err "Shellcheck not running correctly."

  cd "${BASEDIR}"
  
  find . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
    | xargs -0 shellcheck -e SC1090 -e SC2016 -e SC2026 \
    || err "Shellcheck found errors."

  success "Shellcheck validated with no errors!"
}
