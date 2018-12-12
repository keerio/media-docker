#!/usr/bin/env bash
set -euo pipefail

package_manager_detect() {
  local PACKAGE_MAN
  declare -A DISTROMAP

  PACKAGE_MAN=

  DISTROMAP[/etc/redhat-release]=dnf
  DISTROMAP[/etc/arch-release]=pacman
  DISTROMAP[/etc/gentoo-release]=emerge
  DISTROMAP[/etc/SuSE-release]=zypp
  DISTROMAP[/etc/SUSE-brand]=zypp
  DISTROMAP[/etc/debian_version]=apt

  for distro in "${!DISTROMAP[@]}" ; do
    if [[ -f $distro ]] ; then
      if [[ "${DISTROMAP[$distro]}" = "dnf" ]] ; then
        if [[ "$(command -v "dnf")" ]] ; then
          PACKAGE_MAN="dnf"
        elif [[ "$(command -v "yum")" ]] ; then
          PACKAGE_MAN="yum"
        fi
      else
        PACKAGE_MAN="${DISTROMAP[$distro]}"
      fi
    fi
  done

  echo "$PACKAGE_MAN"
}
