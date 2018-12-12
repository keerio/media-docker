#!/usr/bin/env bash
set -euo pipefail

v_shellcheck(){
  log 6 "Running ShellCheck validation checks."
  export scversion="v0.5.0"

  log 6 "Downloading and installing ShellCheck."
  sudo wget "https://storage.googleapis.com/shellcheck/shellcheck-${scversion}.linux.x86_64.tar.xz"
  sudo tar --xz -xvf shellcheck-"${scversion}".linux.x86_64.tar.xz
  sudo cp shellcheck-"${scversion}"/shellcheck /usr/bin/
  sudo rm -r shellcheck-"${scversion}"/
  sudo rm shellcheck-${scversion}.linux.x86_64.tar.xz

  log 6 "Checking ShellCheck version."
  shellcheck --version \
    || log 3 "Shellcheck not running correctly."

  cd "${BASEDIR}"
  
  log 6 "Running ShellCheck validations."
  find . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
    | xargs -0 shellcheck -e SC1090 -e SC2016 -e SC2026 -e SC1117\
    || log 3 "Shellcheck found errors."

  log 6 "Shellcheck validated with no errors!"
}
