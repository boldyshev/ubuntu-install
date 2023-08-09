#!/bin/bash
# Load Gnome configurations

SCRIPT_DIR=$(dirname "${0}")

source "${SCRIPT_DIR}/config/install.conf"

# Copy wallpapers to appropriate directory
cp -rp "${SCRIPT_DIR}/config/wallpaper.png" "${wallpapers_path}"

# Load dconf settings
dconf load / < "${SCRIPT_DIR}/config/dconf/$(hostname).dconf"

# Language
sudo cp -rp "${SCRIPT_DIR}/config/locale" "${locale_path}"
sudo timedatectl set-timezone "${time_zone}"
cp -rp "${SCRIPT_DIR}/config/pam_environment" "${pam_environment_path}"
