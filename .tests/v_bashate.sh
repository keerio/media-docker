#!/usr/bin/env bash
set -euo pipefail

v_bashate(){
  log 6 "Running Bashate validation checks."
  
  cd "${BASEDIR}"
  find  . -name '*.sh' -not \( -path "./.tests/*" -prune \) -print0 \
    | xargs -0 bashate -i E003 -v \
    || log 3 "Bashate found errors."

  log 6 "Bashate validated with no errors!"
}
