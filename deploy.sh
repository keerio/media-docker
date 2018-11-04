#!/bin/bash
#
# Perform initial setup and configuration of Docker environment for 
# full media server goodness.

## FUNCTIONS
info() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@"
}

err() {
  RED='\033[0;31m'
  NC='\033[0m' # No Color
  echo -e "${RED}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NC}" >&2
}

success() {
  GREEN='\033[0;32m'
  NC='\033[0m' # No Color
  echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@${NC}"
}

get_env_var() {
  VAR=$(grep "$1" "$2" | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo "${VAR[1]}" | tr -d "\r"
}

set_env_var() {
  sed -i '\|^'"$1"'=|{h;s|=.*|='"$2"'|};${x;\|^$|{s||'"$1"'='"$2"'|;H};x}' $3
}

append_file() {
  cat "$1" | sudo tee -a "$2" > /dev/null
}

apt_update() {
  sudo apt-get update &> /dev/null
  if [[ "$?" -ne "$SUCCESS" ]]
  then
    err "Error occurred updating apt packages."
    exit 1
  fi
  success "apt packages up-to-date."
}

apt_install() {
  apt_update

  sudo apt-get install -y "$1" "$2" "$3" "$4" "$5" &> /dev/null
  if [[ "$?" -ne "$SUCCESS" && "$?" -ne 9 ]]
    then
    err "Error installing packages."
  fi
  success "Successfully installed requested packages."
}

### EXECUTION
## ensure pre-reqs
# check root
ROOT_UID=0
if [[ "${UID}" -ne "${ROOT_UID}" ]]
then
  err "Must be root to perform this operation."
  exit 1
fi

# check apt
command -v apt-get &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Setup requires apt but doesn't appear to be installed."
  exit 1
fi

# check .env
if [ ! -f ./.env ]
then
  echo "# MEDIA SERVER CONFIG" >> .env
fi

# set docker-compose version
compose_version=1.23.1
set_env_var COMPOSE_VERSION "$compose_version" .env

## System Configuration
info "Performing system pre-configuration."

# set hostname
echo -n "Would you like to set your hostname? [yN]: "
read -r doSetHostname

case "$doSetHostname" in
  [Yy]* )
    currentHost=$(cat /etc/hostname)
    echo -n "Enter desired hostname: "
    read -r newHost
    sudo sed -i "s/$currentHost/$newHost/g" /etc/hosts
    sudo sed -i "s/$currentHost/$newHost/g" /etc/hostname
    set_env_var HOSTNAME "$newHost" .env
    echo "Hostname set to: $newHost. A reboot will be required to apply changes."
    ;;
  * )
    info "Skipping setting hostname."
    ;;
esac

# set timezone
timezone=$(get_env_var TIMEZONE .env)
echo -n "Would you like to set your timezone? [yN]: "
read -r doSetTimezone

case "$doSetTimezone" in
  [Yy]* ) 
    # set timezone or grab from .env if available
    while [ -z "$enteredTimezone" ]
    do
      echo -n "Enter timezone or accept timezone from .env (${timezone}): "
      read -r enteredTimezone
    
      if [ -z "$enteredTimezone" ]
      then
        if [ -z "$timezone" ]
        then 
          continue
        else
          enteredTimezone=$timezone
        fi
      fi
    done 

    sudo timedatectl set-timezone "${enteredTimezone}"
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Error setting timezone."
      exit 1
    else
      success "Timezone set to ${enteredTimezone}."
      set_env_var TIMEZONE "$enteredTimezone" .env
    fi
    ;;
  * ) 
    info "Skipping setting timezone."
    ;;
esac

## installation of repos and prereqs
# install universe repository
sudo add-apt-repository universe
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error occurred when installing universe repository."
  exit 1
else
  success "Installed universe repository."
fi

# remove old docker packages
sudo apt-get remove docker docker-engine docker.io &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error occurred removing legacy Docker packages."
  exit 1
else
  success "Ensured legacy Docker packages are gone."
fi

# install apt-over-https packages
info "Ensuring packages for apt-over-https are installed."
apt_install "apt-transport-https" "ca-certificates" "curl" "software-properties-common"

# install docker gpg key
info "Installing Docker GPG key."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
  apt-key add - &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error downloading Docker GPG key."
  exit 1
else
  success "Docker GPG key installed."
fi

# install docker repository
info "Adding Docker-managed apt repository."
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error adding Docker repository."
  exit 1
else
  success "Docker repository added."
fi

# install docker ce
info "Installing Docker CE."
apt_install "docker-ce"

# install docker-compose
info "Installing Docker Compose."
compose_version=$(get_env_var COMPOSE_VERSION .env)
info "Downloading Compose from GitHub."
sudo curl -fsSL https://github.com/docker/compose/releases/download/"${compose_version}"/docker-compose-"$(uname -s)"-"$(uname -m)" \
  -o /usr/local/bin/docker-compose \
  &> /dev/null
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Error downloading Docker Compose."
  exit 1
else
  sudo chmod +x /usr/local/bin/docker-compose > /dev/null
  if [[ "$?" -ne "$SUCCESS" ]]
  then
    err "Error installing Docker Compose."
    exit 1
  else
    success "Docker Compose installed."
  fi
fi

### optional set up
## user creation
username=$(get_env_var USER_NAME .env)
password=$(get_env_var PASSWORD .env)

echo -n "Would you like to create a new user? [yN]: "
read -r doCreateUser
case "$doCreateUser" in
  [Yy]* ) 
    # set username or grab from .env if available
    while [ -z "$enteredUserName" ]
    do
      echo -n "Enter username or accept username from .env (${username}): "
      read -r enteredUserName
    
      if [ -z "$enteredUserName" ]
      then
        if [ -z "$username" ]
        then 
          continue
        else
          enteredUserName=$username
        fi
      fi
    done 

    # set password or grab from .env if available
    while [ -z "$enteredPassword" ]
    do
      echo -n "Enter password or accept password from .env (${password}): "
      read -r enteredUserName
      
      if [ -z "$enteredPassword" ]
      then
        if [ -z "$password" ]
        then 
          continue
        else
          enteredPassword=$password
        fi
      fi
    done 

    # create the user
    sudo useradd -p "${enteredPassword}" -d /home/"${enteredUserName}" -m -g users -s /bin/bash "${enteredUserName}" &> /dev/null
    if [[ "$?" -ne "$SUCCESS" && "$?" -ne 9 ]]
    then
      err "Could not create user: ${enteredUserName}."
    else
      success "Created user: ${enteredUserName}."
    fi

    # set user as sudo-er
    sudo usermod -aG sudo "${username}" &> /dev/null
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Error setting user as sudo-er."
      exit 1
    else
      success "Set user as sudo-er."
    fi
    ;;
  * ) 
    info "Skipping user creation."
    ;;
esac

# cockpit install
echo -n "Would you like to install Cockpit? [yN]: "
read -r doInstallCockpit
case "$doInstallCockpit" in
  [Yy]* ) 
    info "Installing Cockpit."
    apt_install "cockpit"
    sudo systemctl enable cockpit.socket > /dev/null
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Cockpit auto-start failed."
      exit 1
    else
      success "Cockpit set to auto-start."
    fi
    ;;
  * ) 
    info "Skipping Cockpit install."
    ;;
esac

### Container set up and configuration
info "Beginning media server configuration."

## configure base directories
base_dir=$(get_env_var BASE_DIR .env)
while [ -z "$enteredBaseDir" ]
do
  echo -n "Enter full path to desired base directory or accept path from .env (${base_dir}): "
  read -r enteredBaseDir
  
  if [ -z "$enteredBaseDir" ]
  then
    if [ -z "$base_dir" ]
    then 
      continue
    else
      enteredBaseDir=$base_dir
    fi
  fi
done

# set environment variables for all three directories
set_env_var BASE_DIR "$enteredBaseDir" .env
set_env_var MEDIA_DIR "$enteredBaseDir/media" .env
set_env_var DOWNLOAD_DIR "$enteredBaseDir/downloads" .env

# check that the ancillary directories are what the user really wants
media_dir=$(get_env_var MEDIA_DIR .env)
while [ -z "$enteredMediaDir" ]
do
  echo -n "Enter full path to base directory or accept path from .env (${media_dir}): "
  read -r enteredMediaDir
  
  if [ -z "$enteredMediaDir" ]
  then
    if [ -z "$media_dir" ]
    then 
      continue
    else
      enteredMediaDir=$media_dir
    fi
  fi
done
set_env_var MEDIA_DIR "$enteredMediaDir" .env

download_dir=$(get_env_var DOWNLOAD_DIR .env)
while [ -z "$enteredDownloadDir" ]
do
  echo -n "Enter full path to base directory or accept path from .env (${download_dir}): "
  read -r enteredDownloadDir
  
  if [ -z "$enteredDownloadDir" ]
  then
    if [ -z "$download_dir" ]
    then 
      continue
    else
      enteredDownloadDir=$download_dir
    fi
  fi
done
set_env_var MEDIA_DIR "$enteredDownloadDir" .env

echo -n "Would you like to enable reverse proxying via Traefik? [Yn]: "
read -r doInstallTraefik
case "$doInstallTraefik" in 
  [Nn]* )
    info "Skipping Traefik configuration."
    ;;
  * )
    info "Setting up Traefik configuration."
    # traefik pre-configure
    # traefik domain setup
    domain=$(get_env_var DOMAIN .env)
    while [ -z "$enteredDomain" ]
    do
      echo -n "Enter base domain or accept domain from .env (${domain}): "
      read -r enteredDomain
      
      if [ -z "$enteredDomain" ]
      then
        if [ -z "$domain" ]
        then 
          continue
        else
          enteredDomain=$domain
        fi
      fi
    done

    set_env_var DOMAIN "$enteredDomain" .env

    sed -i "s/#DOMAIN#/${enteredDomain}/g" config/traefik.toml
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Traefik domain replace failed."
      exit 1
    fi

    # let's encrypt email setup
    email_address=$(get_env_var EMAIL_ADDRESS .env)
    while [ -z "$enteredEmail" ]
    do
      echo -n "Enter email for Let's Encrypt notifications or accept email from .env (${email_address}): "
      read -r enteredEmail
      
      if [ -z "$enteredEmail" ]
      then
        if [ -z "$email_address" ]
        then 
          continue
        else
          enteredEmail=$email_address
        fi
      fi
    done

    set_env_var EMAIL_ADDRESS "$enteredEmail" .env

    sed -i "s/#EMAIL_ADDRESS#/${enteredEmail}/g" config/traefik.toml
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Traefik email replace failed."
      exit 1
    fi

    # create traefik config directory and move files
    base_dir=$(get_env_var BASE_DIR .env)
    sudo mkdir -p "${base_dir}"/traefik/ > /dev/null
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Could not create Traefik directory."
      exit 1
    fi
    sudo cp config/traefik.toml "${base_dir}"/traefik/traefik.toml > /dev/null
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Could not copy Traefik config."
      exit 1
    fi
    sudo touch "${base_dir}"/traefik/acme.json > /dev/null
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Could not create acme.json file."
      exit 1
    fi
    sudo chmod 600 "${base_dir}"/traefik/acme.json > /dev/null
    if [[ "$?" -ne "$SUCCESS" ]]
    then
      err "Could not create acme.json file."
      exit 1
    fi
    success "Traefik configuration in place."
    ;;
esac

# start docker-compose
append_file container-config/start docker-compose.yml

## Plex
echo -n "Would you like to install the Plex container? [Yn]: "
read -r doInstallPlex
case "$doInstallPlex" in 
  [Nn]* )
    info "Skipping Plex configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/plex-port docker-compose.yml
        ;;
      * )
        append_file container-config/plex-traefik docker-compose.yml
        ;;
    esac
    success "Plex container enabled."
    ;;
esac

## Ubooquity
echo -n "Would you like to install the Ubooquity container? [Yn]: "
read -r doInstallUbooquity
case "$doInstallUbooquity" in 
  [Nn]* )
    info "Skipping Ubooquity configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/ubooquity-port docker-compose.yml
        ;;
      * )
        append_file container-config/ubooquity-traefik docker-compose.yml
        ;;
    esac
    success "Ubooquity container enabled."
    ;;
esac

## sabNZBd
echo -n "Would you like to install the sabNZBd container? [Yn]: "
read -r doInstallSab
case "$doInstallSab" in 
  [Nn]* )
    info "Skipping sabNZBd configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/sabnzbd-port docker-compose.yml
        ;;
      * )
        append_file container-config/sabnzbd-traefik docker-compose.yml
        ;;
    esac
    success "sabNZBd container enabled."
    ;;
esac

## NZBGet
echo -n "Would you like to install the NZBGet container? [yN]: "
read -r doInstallNzbGet
case "$doInstallNzbGet" in 
  * )
    info "Skipping NZBGet configuration."
    ;;
  [Yy]* )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/nzbget-port docker-compose.yml
        ;;
      * )
        append_file container-config/nzbget-traefik docker-compose.yml
        ;;
    esac
    success "NZBGet container enabled."
    ;;
esac

## NZBHydra
echo -n "Would you like to install the NZBHydra container? [Yn]: "
read -r doInstallNZBHydra
case "$doInstallNZBHydra" in 
  [Nn]* )
    info "Skipping NZBHydra configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/nzbhydra-port docker-compose.yml
        ;;
      * )
        append_file container-config/nzbhydra-traefik docker-compose.yml
        ;;
    esac
    success "NZBHydra container enabled."
    ;;
esac

## Jackett
echo -n "Would you like to install the Jackett container? [Yn]: "
read -r doInstallJackett
case "$doInstallJackett" in 
  [Nn]* )
    info "Skipping Jackett configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/jackett-port docker-compose.yml
        ;;
      * )
        append_file container-config/jackett-traefik docker-compose.yml
        ;;
    esac
    success "Jackett container enabled."
    ;;
esac

## Sonarr
echo -n "Would you like to install the Sonarr container? [Yn]: "
read -r doInstallSonarr
case "$doInstallSonarr" in 
  [Nn]* )
    info "Skipping Sonarr configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/sonarr-port docker-compose.yml
        ;;
      * )
        append_file container-config/sonarr-traefik docker-compose.yml
        ;;
    esac
    success "Sonarr container enabled."
    ;;
esac

## Radarr
echo -n "Would you like to install the Radarr container? [Yn]: "
read -r doInstallRadarr
case "$doInstallRadarr" in 
  [Nn]* )
    info "Skipping Radarr configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/radarr-port docker-compose.yml
        ;;
      * )
        append_file container-config/radarr-traefik docker-compose.yml
        ;;
    esac
    success "Radarr container enabled."
    ;;
esac

## Lidarr
echo -n "Would you like to install the Lidarr container? [Yn]: "
read -r doInstallLidarr
case "$doInstallLidarr" in 
  [Nn]* )
    info "Skipping Lidarr configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/lidarr-port docker-compose.yml
        ;;
      * )
        append_file container-config/lidarr-traefik docker-compose.yml
        ;;
    esac
    success "Lidarr container enabled."
    ;;
esac

## Heimdall
echo -n "Would you like to install the Heimdall container? [Yn]: "
read -r doInstallHeimdall
case "$doInstallHeimdall" in 
  [Nn]* )
    info "Skipping Heimdall configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/heimdall-port docker-compose.yml
        ;;
      * )
        append_file container-config/heimdall-traefik docker-compose.yml
        ;;
    esac
    success "Heimdall container enabled."
    ;;
esac

## Tautulli
echo -n "Would you like to install the Tautulli container? [Yn]: "
read -r doInstallTautulli
case "$doInstallTautulli" in 
  [Nn]* )
    info "Skipping Tautulli configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/tautulli-port docker-compose.yml
        ;;
      * )
        append_file container-config/tautulli-traefik docker-compose.yml
        ;;
    esac
    success "Tautulli container enabled."
    ;;
esac

## Ombi
echo -n "Would you like to install the Ombi container? [Yn]: "
read -r doInstallOmbi
case "$doInstallOmbi" in 
  [Nn]* )
    info "Skipping Ombi configuration."
    ;;
  * )
    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/ombi-port docker-compose.yml
        ;;
      * )
        append_file container-config/ombi-traefik docker-compose.yml
        ;;
    esac
    success "Ombi container enabled."
    ;;
esac
## Torrenting
echo -n "Would you like to install the Transmission / OpenVPN containers? [yN]: "
read -r doInstallTorrent
case "$doInstallTorrent" in 
  * )
    info "Skipping Transmission / OpenVPN configuration."
    ;;
  [Yy]* )
    info "Setting up Transmission / OpenVPN."
    # set provider
    vpn_provider=$(get_env_var VPN_PROVIDER .env)
    while [ -z "$enteredVpnProvider" ]
    do
      echo -n "Enter VPN provider or accept domain from .env (${vpn_provider}): "
      read -r enteredVpnProvider

      if [ -z "$enteredVpnProvider" ]
      then
        if [ -z "$vpn_provider" ]
        then
          continue
        else
          enteredVpnProvider=$vpn_provider
        fi
      fi
    done
    set_env_var VPN_PROVIDER "$enteredVpnProvider" .env

    # set username
    vpn_user=$(get_env_var VPN_USER .env)
    while [ -z "$enteredVpnUser" ]
    do
      echo -n "Enter VPN username or accept username from .env (${vpn_user}): "
      read -r enteredVpnUser

      if [ -z "$enteredVpnUser" ]
      then
        if [ -z "$vpn_user" ]
        then
          continue
        else
          enteredVpnUser=$vpn_user
        fi
      fi
    done
    set_env_var VPN_USER "$enteredVpnUser" .env

    # set password
    vpn_pass=$(get_env_var VPN_PASS .env)
    while [ -z "$enteredVpnPass" ]
    do
      echo -n "Enter VPN password or accept password from .env (${vpn_pass}): "
      read -r enteredVpnPass

      if [ -z "$enteredVpnPass" ]
      then
        if [ -z "$vpn_pass" ]
        then
          continue
        else
          enteredVpnPass=$vpn_pass
        fi
      fi
    done
    set_env_var VPN_PASS "$enteredVpnPass" .env

    case "$doInstallTraefik" in
      [Nn]* )
        append_file container-config/torrenting-port docker-compose.yml
        ;;
      * )
        append_file container-config/torrenting-traefik docker-compose.yml
        ;;
    esac
    success "Torrenting over VPN containers enabled."
    ;;
esac

## Watchtower
echo -n "Would you like to install the Watchtower container and enable automatic updates? [Yn]: "
read -r doInstallWatchtower
case "$doInstallWatchtower" in 
  [Nn]* )
    info "Skipping Watchtower configuration."
    ;;
  * )
    append_file container-config/watchtower docker-compose.yml
    success "Watchtower container enabled."
    ;;
esac

## finish
append_file container-config/end docker-compose.yml

case "$doInstallPlex" in 
  [Nn]* )
    ;;
  * )
    while [ -z "$plexClaim" ]
    do
      echo -n "Please enter your Plex claim token from https://www.plex.tv/claim/: "
      read -r plexClaim
    done
    set_env_var PLEX_CLAIM_TOKEN "$plexClaim" .env
    ;;
esac

# docker environment set up
info "Creating external Docker network."
sudo docker network create proxied &> /dev/null
info "Building the Docker containers."
sudo docker-compose up --force-recreate -d
if [[ "$?" -ne "$SUCCESS" ]]
then
  err "Docker build failed."
  exit 1
fi

# All done!
success "Successfully built media server Docker environment!"
exit 0
