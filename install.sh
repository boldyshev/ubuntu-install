#!/bin/bash
# Install apps and set configurations after fresh install of Ubuntu 22.04 or 24.04

RELEASE="$1"

# Color output
function echocolor() { # $1 = string
    COLOR='\033[0;32m' # green
    NC='\033[0m'
    printf "${COLOR}$1${NC}\n"
}

echocolor "Start install.sh script"

SCRIPT_DIR=$(dirname "${0}")

# Load config variables
source "${SCRIPT_DIR}/config/install.conf"

# Change symlink for resolv.conf to not use the DNS cache
echocolor "Change resolv.conf symlink"
sudo ln -sfn /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Change apt update server to Main (only for 22.04)
if [ $RELEASE == "22.04" ]; then
  echocolor "Change apt update server to Main"
  sudo sed -i 's|http://[a-z][a-z].archive|http://archive|g' /etc/apt/sources.list
fi

# Update packages
echocolor "apt update"
sudo apt update -y
echocolor "apt upgrade"
sudo apt upgrade -y

# Generate ssh key pair
echocolor "Generate ssh key"
ssh-keygen -t ed25519 -C "${user}@$(hostname)"

# Add public key to NAS
echocolor "Add ssh public key to NAS"
ssh-copy-id -i "/home/${user}/.ssh/id_ed25519.pub" "queen@${nas_ip}"

# Load application names from a list file and install them
echocolor "Installing apts"
xargs sudo apt install -y < "${SCRIPT_DIR}/config/list_apts"

sudo bash "${SCRIPT_DIR}/install_docker.sh"

echocolor "Installing snaps"
# can't install multiple snaps via xargs
# install in a loop won't show downloading progress
# while read p; do
#  sudo snap install $p
# done < "${SCRIPT_DIR}/config/list_snaps"

sudo snap install pycharm-community --classic
sudo snap install telegram-desktop
sudo snap install htop
sudo snap install code --classic
sudo snap install bitwarden
sudo snap install nmap
sudo snap install curl
sudo snap install slack
sudo snap install qbittorrent-arnatious
sudo snap install nvtop

# Install apps via .deb packages, continue if subscript fails
echocolor "Installing deb packages"
bash "${SCRIPT_DIR}/deb_chrome.sh"
#bash "${SCRIPT_DIR}/deb_jupyterlab.sh"
bash "${SCRIPT_DIR}/deb_syn_drive.sh"
bash "${SCRIPT_DIR}/deb_input_remapper.sh ${RELEASE}"

# Load gnome config
echocolor "Loading gnome config"
bash "${SCRIPT_DIR}/config_load.sh ${RELEASE}"

# Install ubuntu-restricted-extras (video codecs)
#echocolor "Install ubuntu-restricted-extras"
#sudo apt install -y ubuntu-restricted-extras

reboot
