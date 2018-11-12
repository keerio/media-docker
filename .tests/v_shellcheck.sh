#!/usr/bin/env bash
set -euo pipefail

v_shellcheck(){
  export scversion="v0.5.0"
  sudo wget "https://storage.googleapis.com/shellcheck/shellcheck-${scversion}.linux.x86_64.tar.xz"
  sudo tar --xz -xvf shellcheck-"${scversion}".linux.x86_64.tar.xz
  sudo cp shellcheck-"${scversion}"/shellcheck /usr/bin/
  sudo rm -r shellcheck-"${scversion}"/
  sudo rm shellcheck-${scversion}.linux.x86_64.tar.xz

  shellcheck --version \
    || err "Shellcheck not running correctly."

  cd "${BASEDIR}"
  
  find . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
    | xargs -0 shellcheck -e SC1090 -e SC2016 -e SC2026 -e SC1117\
    || err "Shellcheck found errors."

  success "Shellcheck validated with no errors!"
}
