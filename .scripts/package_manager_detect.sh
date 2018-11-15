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
      if [[ $distro = "dnf" ]] ; then
        if [[ -v "dnf" ]] ; then
          PACKAGE_MAN="dnf"
        elif [[ -v "yum" ]] ; then
          PACKAGE_MAN="yum"
        fi
      else
        PACKAGE_MAN="${DISTROMAP[$distro]}"
      fi
    fi
  done

  info "Detected package manager as: $PACKAGE_MAN"
  echo "$PACKAGE_MAN"
}
