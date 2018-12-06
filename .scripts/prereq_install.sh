#!/usr/bin/env bash
set -euo pipefail

prereq_install() {
  local NOREMOVE
  local PACKAGE_MAN

  NOREMOVE=${1:-"N"}
  PACKAGE_MAN=$(run_sh "${SCRIPTDIR}" \
    "package_manager_detect")

  case $PACKAGE_MAN in
    apt)
      run_sh "$SCRIPTDIR" "apt_prereqs_install" "${NOREMOVE}"
    ;;
    dnf)
      run_sh "$SCRIPTDIR" "dnf_prereqs_install" "${NOREMOVE}"
    ;;
    yum)
      run_sh "$SCRIPTDIR" "yum_prereqs_install" "${NOREMOVE}"
    ;;
    pacman)
      run_sh "$SCRIPTDIR" "pacman_prereqs_install" "${NOREMOVE}"
    ;;
    emerge)
      run_sh "$SCRIPTDIR" "emerge_prereqs_install" "${NOREMOVE}"
    ;;
    zypp)
      run_sh "$SCRIPTDIR" "zypper_prereqs_install" "${NOREMOVE}"
    ;;
    *)
      err "Could not detect package manager."
    ;;
  esac

  if [[ ! $(command -v "docker") ]] ; then
    run_sh "$SCRIPTDIR" "docker_install"
  fi

  if [[ ! $(command -v "docker-compose") ]] ; then
    run_sh "$SCRIPTDIR" "compose_install"
  fi

  if [[ ! $(command -v "yq") ]] ; then
    run_sh "$SCRIPTDIR" "yq_install"
  fi
}
