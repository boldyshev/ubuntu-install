#!/bin/bash

SCRIPT_DIR=$(dirname ${0})

source "${SCRIPT_DIR}/deb.sh"
source "${SCRIPT_DIR}/config/install.conf"

deb_file='google-chrome-stable_current_amd64.deb'
deb_url="https://dl.google.com/linux/direct/${deb_file}"
deb_path="${downloads_path}/${deb_file}"

deb_install "${deb_url}" "${deb_path}"
