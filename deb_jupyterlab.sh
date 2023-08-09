#!/bin/bash
# Install JupyterLab Desktop 
# https://github.com/jupyterlab/jupyterlab-desktop/blob/master/user-guide.md

SCRIPT_DIR=$(dirname "${0}")

source "${SCRIPT_DIR}/deb.sh"
source "${SCRIPT_DIR}/config/install.conf"

deb_file='JupyterLab-Setup-Debian.deb'
deb_url="https://github.com/jupyterlab/jupyterlab-desktop/releases/latest/download/${deb_file}"
deb_path="${downloads_path}/${deb_file}"

deb_install "${deb_url}" "${deb_path}"

# Load config
cp -rp "${SCRIPT_DIR}/config/@jupyterlab" "${jupyter_lab_config}"
