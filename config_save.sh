#! /bin/bash
# Save current Gnome settings

SCRIPT_DIR=$(dirname "${0}")

source "${SCRIPT_DIR}/config/install.conf"

# Save wallpapers file
cp -rp "${wallpapers_path}" "${SCRIPT_DIR}/config"

# Save dconf settings
dconf dump / > "${SCRIPT_DIR}/config/dconf/$(hostname).dconf"

# Jupyter Lab Desktop App
mkdir -p "${jupyter_lab_config}"
cp -rp "${jupyter_lab_config}" "${SCRIPT_DIR}/config"

# Input remapper
cp -rp "${input_remapper_path}/input-remapper-2" "${SCRIPT_DIR}/config"

# Language
cp -rp "${locale_path}" "${SCRIPT_DIR}/config"
cp -rp "${pam_environment_path}" "${SCRIPT_DIR}/config"
