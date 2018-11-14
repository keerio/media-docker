#!/usr/bin/env bash
set -euo pipefail

package_manager_detect() {
  declare -A DISTROMAP

  DISTROMAP[/etc/redhat-release]=dnf
  DISTROMAP[/etc/arch-release]=pacman
  DISTROMAP[/etc/gentoo-release]=emerge
  DISTROMAP[/etc/SuSE-release]=zypp
  DISTROMAP[/etc/debian_version]=apt

  for distro in "${!DISTROMAP[@]}" ; do
    if [[ -f $distro ]] ; then
      echo "${DISTROMAP[$distro]}"
      info "Detected package manager as: ${DISTROMAP[$distro]}"
      return
    fi
  done
}
