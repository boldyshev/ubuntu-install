#!/bin/bash

RELEASE="$1"
SCRIPT_DIR=$(dirname "${0}")

source "${SCRIPT_DIR}/deb.sh"
source "${SCRIPT_DIR}/config/install.conf"

if [ $RELEASE == "22.04" ]; then
  # Extract latest release number from html with regex
  latest_release_page='https://github.com/sezanzeb/input-remapper/releases/latest'
  release_regex='(?<=Release\s)[0-9].[0-9].[0-9]'
  latest_release_num=$(curl -sL "${latest_release_page}" | grep -oP -m 1 "${release_regex}")

  # Create URL and file path
  deb_file="input-remapper-${latest_release_num}.deb"
  deb_url="https://github.com/sezanzeb/input-remapper/releases/download/${latest_release_num}/${deb_file}"
  deb_path="${downloads_path}/${deb_file}"

  deb_install "${deb_url}" "${deb_path}"
  sudo apt -f install -y
elif [ $RELEASE == "24.04" ]; then
  sudo apt install git python3-setuptools gettext
  git clone https://github.com/sezanzeb/input-remapper.git
  ./input-remapper/scripts/build.sh
  sudo apt install -f input-remapper/dist/input-remapper-2.0.1.deb
  rm -r input-remapper
fi

# Load config
cp -rp "${SCRIPT_DIR}/config/input-remapper-2" "${input_remapper_path}"

