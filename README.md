# [![media-docker](https://github.com/joskore/media-docker/raw/master/docs/logo.png)](https://media-docker.com/)

![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/joskore/media-docker.svg)
[![GitHub issues](https://img.shields.io/github/issues/joskore/media-docker.svg)](https://github.com/joskore/media-docker/issues)
[![Build Status](https://travis-ci.com/joskore/media-docker.svg?branch=master)](https://travis-ci.com/joskore/media-docker) [![Join the chat at https://gitter.im/joskore/media-docker](https://badges.gitter.im/joskore/media-docker.svg)](https://gitter.im/joskore/media-docker?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
![GitHub](https://img.shields.io/github/license/joskore/media-docker.svg)
![GitHub forks](https://img.shields.io/github/forks/joskore/media-docker.svg?style=social&label=Fork)


a short and sweet way to get a full-blown media stack running on a server from scratch in minutes.

## what's included
with this package, you'll get a media server environment capable of finding, grabbing, downloading, and presenting: movies, tv, books, and music. it does this (relatively) securely, prioritizing usenet but with an option for torrenting-over-VPN.

traefik reverse-proxying is available for access via nice URLs without exposing ports to the outside world, as long as you have a publically accessible domain you should be clear to use this without issue.

watchtower is available to keep all of your docker containers up-to-date.

## services
a full list of available services and where to access them can be found in the wiki [here.](https://github.com/joskore/media-docker/wiki/services)

## system requirements
system requirements, along with tested configurations, can be found in the wiki [here.](https://github.com/joskore/media-docker/wiki/system-requirements)

## what are those??
an overview of the component files involved in this process can be found in the wiki [here.](https://github.com/joskore/media-docker/wiki/files)

## installation
installation is omega-easy!

1. be root
2. run `sudo git clone https://github.com/joshuhn/media-docker/ /media-docker/ && cd /media-docker/`
3. make sure that the script is executable (`chmod +x ./media-docker.sh`)
4. run `./media-docker.sh` and answer the questions it asks you
    * to get your plex claim token, go to https://www.plex.tv/claim/. paste this entire code when prompted by the install process (or directly in the `.env` file in the PLEX_CLAIM_TOKEN variable) to claim your server with your account
6. use your newly configured media stack! hooray!

### non-apt systems
the installer process currently requires that your system be running apt, though support for other package managers is in progress.

### vpn providers
a listing of supported VPN providers for torrenting-over-vpn, provided via the haugene\transmission-openvpn container, can be found in the container's repository [here.](https://github.com/haugene/docker-transmission-openvpn#supported-providers)

## thanks!
this very much stands on the shoulders of those who came before, all this has done is made the deployment process simple and straightforward to configure.
