# media-docker
![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/joskore/media-docker.svg)
[![GitHub issues](https://img.shields.io/github/issues/joskore/media-docker.svg)](https://github.com/joskore/media-docker/issues)
![GitHub](https://img.shields.io/github/license/joskore/media-docker.svg)
![GitHub forks](https://img.shields.io/github/forks/joskore/media-docker.svg?style=social&label=Fork)

a short and sweet way to get a full-blown media stack running on a scratch server in minutes.

## what's included
with this package, you'll get a media server environment capable of finding, grabbing, downloading, and presenting: movies, tv, books, and music. it does this (relatively) securely, prioritizing usenet but with an option for torrenting-over-VPN.

traefik reverse-proxying is available for access via nice URLs without exposing ports to the outside world, as long as you have a publically accessible domain you should be clear to use this without issue.

watchtower is available to keep all of your docker containers up-to-date.

### services and where to access them
| service | purpose | url / ports |
| ------- | ------- | :---------: |
| plex | movie / tv / music interface | https://plex.${DOMAIN} <br> :32400 |
| ubooquity | book / comic interface | https://ubooquity.${DOMAIN}/ubooquity <br> https://admin-ubooquity.${DOMAIN}/ubooquity/admin <br> :2202 <br> :2203 |
| traefik | reverse proxy | https://traefik.${DOMAIN} <br> :80 <br> :443 |
| heimdall | dashboard | https://heimdall.${DOMAIN} <br> :80 <br> :443 |
| sabnzbd | nzb download | https://sab.${DOMAIN} <br> :8080 |
| nzbget | nzb download | https://nzbget.${DOMAIN} <br> :6789 |
| transmission | torrent download | https://transmission.${DOMAIN} <br> :9091 |
| hydra | nzb searcher | https://hydra.${DOMAIN} <br> :5075 |
| jackett | torznab searcher | https://jackett.${DOMAIN} <br> :9117 |
| sonarr | tv management | https://sonarr.${DOMAIN} <br> :8989 |
| radarr | movie management | https://radarr.${DOMAIN} <br> :7878 |
| lidarr | music management | https://lidarr.${DOMAIN} <br> :8686 |
| bazarr | subtitle management | https://bazarr.${DOMAIN} <br> :6767 |
| mylar | comic book management | https://mylar.${DOMAIN} <br> :8090 |
| lazylibrarian | book management | https://lazylibrarian.${DOMAIN} <br> :5299 |
| ombi | plex requests | https://ombi.${DOMAIN} <br> :3579 |
| tautulli | plex statistics | https://tautulli.${DOMAIN} <br> :8181 |
| oscarr | plex sonarr/radarr/bazarr dashboard | https://oscarr.${DOMAIN} <br> :5656 |
| cockpit | server statistics & management | :9090 |

## system requirements
Plex transcoding is the heaviest resource draw for this system, and the primary resource affected is CPU.

### hardware
#### minimum recommended
- CPU: Intel Core i3 3.0 GHz
- RAM: 8GB

#### recommended
- CPU: Intel Core i5 3.0GHz or better
- RAM: 12GB or better

#### tested
- CPU: Intel Core i7-4770, Intel Xeon E3-1245
- RAM: 4x RAM 8192 MB DDR3, 4x RAM 4096 MB DDR3 ECC

### operating system
#### minimum recommended
- Debian Jessie or better
- i.e. Ubuntu 14.04 or better

#### recommended
- Ubuntu 18.04

#### tested
- Ubuntu 14.04, Ubuntu 16.04, Ubuntu 17.04, Ubuntu 18.04
- Debian Stretch

## installation
installation is omega-easy!

1. have an Ubuntu machine available
2. be root
3. run `sudo git clone https://github.com/joshuhn/media-docker/ /media-docker/ && cd /media-docker/`
4. make sure that the script is executable (`chmod +x ./deploy.sh`)
5. run `./deploy.sh` and answer the questions it asks you
* to get your plex claim token, go to https://www.plex.tv/claim/. paste this entire code when prompted by the install process (or directly in the `.env` file in the PLEX_CLAIM_TOKEN variable) to claim your server with your account
6. use your newly configured media stack! hooray!

### non-apt systems
if you're running on a system that doesn't use the apt package manager, you unfortunately can't use the `./deploy.sh` script. it relies heavily on apt, so you'll need to perform the configuration manually. refer to the deploy.sh section below for details on what the script actually does.

if you're confident your system is configured appropriately, run `docker-compose up --force-recreate -d` from `/media-docker`.

## what are those?
### deploy.sh
a straightforward shell script that ensures your environment is configured as needed to ensure a solid media server. the process it takes is as follows:

1. perform local server configuration (sudo user setup, timezone)
2. cleanup legacy Docker packages
3. install and enable apt over HTTPS
4. grab and install Docker's official GPG key, add their managed repository to apt
5. install Docker CE & Docker Compose
6. install Cockpit for remote management
7. pre-configure Traefik (set your email & put files in place)
8. build the Docker container environment via docker-compose.yml
9. everything's functional!

all of the customizable bits (users, directories, email) are asked for in the interactive process, or can be pulled from the dotenv file. if anything fails, the shell script will tell you in big red text.

if you're feeling saucy and confident that your system is properly configured (or if you're running a non-apt system), you can bypass `.\deploy.sh` and run `docker-compose up --force-recreate -d` on your own.

### docker-compose.yml
this file is built by the `deploy.sh` process according to your selections through the installation. the source files are located in the `./container-config/` directory. each container option has two types, one for use with traefik (with labels and exposed ports configured appropriately) and one for direct port mapping between the host and the containers in the event that reverse-proxying is not desired.

after completion of the process, this file contains all of the instructions Docker Compose needs to pull, build, and configure the entire media environment. as with `.\deploy.sh`, all user-configurable items are requested by the install and are exposed for later configuration through the dotenv file.

all services are accessed via a Traefik reverse proxy for security. unfortunately, due to the complexity or poor design (or both) of Plex, it's also able to be reached directly. there's light at the end of that tunnel, though, as the Traefik team are currently working on a method of applying multiple routing labels to a single container. once that's implemented, we'll apply it here to make up for the needlessly many ports those services use.

### traefik.toml
you don't need to worry about this one, the only thing to change is your email address and domain name and `.\deploy.sh` takes care of this for you. if you don't use traefik, this file is wholly irrelevant

### .env
a simple dotenv file containing the variables necessary to configure and install all necessary components for the project.

| variable | function | example |
| -------- | -------- | ------- |
| USER_NAME | username for account that will be created by `./deploy.sh` | joshuhn |
| PASSWORD | password for account that will be created by `./deploy.sh` | iM@gr8Password! |
| PLEX_CLAIM_TOKEN | claim token for plex server from https://www.plex.tv/claim/ | claim-TcoQvJEUxjycmN8KdxGDx |
| BASE_DIR | base directory path for container storage | /mnt/meda/data/ |
| MEDIA_DIR | base directory path for media library storage | /mnt/media/data/media-library |
| DOWNLOAD_DIR | base directory path for downloads | /mnt/media/data/downloads |
| TIMEZONE | local timezone, set by `./deploy.sh` | America/Montevideo |
| DOMAIN | domain name for the media stack, used by traefik | media.com |
| COMPOSE_VERSION | version of docker-compose to pull from GitHub | 1.20.0-rc2 |
| VPN_PROVIDER | openvpn provider, supported values in the table below | NORDVPN |
| VPN_USER | openvpn username | joshuhn |
| VPN_PASS | openvpn password | iM@gr8Password! |
| EMAIL_ADDRESS | email used for let's encrypt | josh@email.me |

### vpn providers
the following is lifted wholesale from the base package's readme. the full text can be found [here.](https://github.com/haugene/docker-transmission-openvpn)

This is a list of providers that are bundled within the image. Feel free to create an issue if your provider is not on the list, but keep in mind that some providers generate config files per user. This means that your login credentials are part of the config an can therefore not be bundled. In this case you can use the custom provider setup described later in this readme. The custom provider setting can be used with any provider.

| Provider Name                | Config Value (`OPENVPN_PROVIDER`) |
|:-----------------------------|:-------------|
| Anonine | `ANONINE` |
| AnonVPN | `ANONVPN` |
| BlackVPN | `BLACKVPN` |
| BTGuard | `BTGUARD` |
| Cryptostorm | `CRYPTOSTORM` |
| Cypherpunk | `CYPHERPUNK` |
| FrootVPN | `FROOT` |
| FrostVPN | `FROSTVPN` |
| Giganews | `GIGANEWS` |
| HideMe | `HIDEME` |
| HideMyAss | `HIDEMYASS` |
| IntegrityVPN | `INTEGRITYVPN` |
| IPredator | `IPREDATOR` |
| IPVanish | `IPVANISH` |
| Ivacy | `IVACY` |
| IVPN | `IVPN` |
| Mullvad | `MULLVAD` |
| Newshosting | `NEWSHOSTING` |
| NordVPN | `NORDVPN` |
| OVPN | `OVPN` |
| Perfect Privacy | `PERFECTPRIVACY` |
| Private Internet Access | `PIA` |
| PrivateVPN | `PRIVATEVPN` |
| proXPN | `PROXPN` |
| PureVPN | `PUREVPN` |
| RA4W VPN | `RA4W` |
| SaferVPN | `SAFERVPN` |
| SlickVPN | `SLICKVPN` |
| Smart DNS Proxy | `SMARTDNSPROXY` |
| SmartVPN | `SMARTVPN` |
| TigerVPN | `TIGER` |
| TorGuard | `TORGUARD` |
| UsenetServerVPN | `USENETSERVER` |
| Windscribe | `WINDSCRIBE` |
| VPNArea.com | `VPNAREA` |
| VPN.AC | `VPNAC` |
| VPN.ht | `VPNHT` |
| VPNBook.com | `VPNBOOK` |
| VPNTunnel | `VPNTUNNEL` |
| VyprVpn | `VYPRVPN` |

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
