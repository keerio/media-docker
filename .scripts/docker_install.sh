#!/usr/bin/env bash
set -euo pipefail

docker_install() {
  info "Installing Docker pre-requisites and package."
  # check universe repository
  sudo add-apt-repository universe > /dev/null 2>&1 \
    || err "Error occurred when installing universe repository."
  success "Installed universe repository."

  # cleanup legacy docker packages
  sudo apt-get remove docker docker-engine docker.io > /dev/null 2>&1 \
    || err "Error occurred removing legacy Docker packages."
  success "Ensured legacy Docker packages are gone."

  # install docker gpg key
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    apt-key add - > /dev/null 2>&1 \
    || err "Error downloading Docker GPG key."
  success "Docker GPG key installed."

  # install docker repository
  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" \
    > /dev/null 2>&1 \
    || err "Error adding Docker repository."
  success "Docker repository added."

  # install docker-ce
  run_sh "apt_install" "docker-ce"
}