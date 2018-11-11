# [![media-docker](https://github.com/joskore/media-docker/raw/master/docs/logo.png)](https://media-docker.com/)

![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/joskore/media-docker.svg)
[![GitHub issues](https://img.shields.io/github/issues/joskore/media-docker.svg)](https://github.com/joskore/media-docker/issues)
![GitHub](https://img.shields.io/github/license/joskore/media-docker.svg)
![GitHub forks](https://img.shields.io/github/forks/joskore/media-docker.svg?style=social&label=Fork)

a short and sweet way to get a full-blown media stack running on a server from scratch in minutes.

## what's included
with this package, you'll get a media server environment capable of finding, grabbing, downloading, and presenting: movies, tv, books, and music. it does this (relatively) securely, prioritizing usenet but with an option for torrenting-over-VPN.

traefik reverse-proxying is available for access via nice URLs without exposing ports to the outside world, as long as you have a publically accessible domain you should be clear to use this without issue.

watchtower is available to keep all of your docker containers up-to-date.

## installation
installation is omega-easy!

1. have an Ubuntu machine available
2. be root
3. run `sudo git clone https://github.com/joshuhn/media-docker/ /media-docker/ && cd /media-docker/`
4. make sure that the script is executable (`chmod +x ./media-docker.sh`)
5. run `./media-docker.sh` and answer the questions it asks you
* to get your plex claim token, go to https://www.plex.tv/claim/. paste this entire code when prompted by the install process (or directly in the `.env` file in the PLEX_CLAIM_TOKEN variable) to claim your server with your account
6. use your newly configured media stack! hooray!

### non-apt systems
the installer process currently requires that your system be running apt, though support for other package managers is in progress.

## thanks!
this very much stands on the shoulders of those who came before, all this has done is made the deployment process simple.

this project makes use of the following Docker containers:
- plexinc\pms-docker
- linuxserver\ubooquity
- linuxserver\sabnzbd
- linuxserver\nzbget
- linuxserver\hydra
- linuxserver\jackett
- linuxserver\sonarr
- linuxserver\radarr
- linuxserver\lidarr
- linuxserver\heimdall
- linuxserver\ombi
- tautulli\tautulli
- haugene\transmission-openvpn
- haugene\transmission-openbpn-proxy
- traefik
- watchtower
