# [![media-docker](/docs/assets/img/md-logo.png)](https://media-docker.com/)

![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/joskore/media-docker.svg)
[![GitHub issues](https://img.shields.io/github/issues/joskore/media-docker.svg)](https://github.com/joskore/media-docker/issues)
[![Build Status](https://travis-ci.com/joskore/media-docker.svg?branch=master)](https://travis-ci.com/joskore/media-docker) [![Join the chat at https://gitter.im/joskore/media-docker](https://badges.gitter.im/joskore/media-docker.svg)](https://gitter.im/joskore/media-docker?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
![GitHub](https://img.shields.io/github/license/joskore/media-docker.svg)
![GitHub forks](https://img.shields.io/github/forks/joskore/media-docker.svg?style=social&label=Fork)


a short and sweet way to get a full-blown media stack running on a server from scratch in minutes.

## what it is

with this package, you'll get a media server environment capable of finding, grabbing, downloading, and presenting: movies, tv, books, and music. it does this (relatively) securely, prioritizing usenet but with an option for torrenting-over-VPN.

traefik reverse-proxying is available for access via nice URLs without exposing ports to the outside world, as long as you have a publically accessible domain you should be clear to use this without issue.

watchtower is available to keep all of your docker containers up-to-date.

## installation

installation is omega-easy! just make sure that you have git installed and are a sudo-capable user and run one of the two sets of commands in your terminal to install:

```bash
bash -c "$(curl -sL dl.media-docker.com)"
```

*or*

```bash
git clone https://github.com/keerio/media-docker
cd media-docker
chmod +x media-docker.sh
sudo ./media-docker.sh
```

regardless of the method chosen from above, after the initial run completes, you can execute media-docker from anywhere by running:

```bash
sudo media-docker
```

## documentation

- [supported services](https://media-docker.com/docs/services/)
- [system requirements](https://media-docker.com/docs/requirements/)
- [component files](https://media-docker.com/docs/files/)
- [supported vpn providers](https://github.com/haugene/docker-transmission-openvpn#supported-providers)

## thanks!

this very much stands on the shoulders of those who came before, all this has done is made the deployment process simple and straightforward to configure.
