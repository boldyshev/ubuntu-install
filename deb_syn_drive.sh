#!/bin/bash
# Install synology drive client on Ubuntu via deb package. Two types of deb package download URLs possible:
# https://global.download.synology.com/download/Utility/SynologyDriveClient/3.2.1-13271/Ubuntu/Installer/x86_64/synology-drive-client-13271.x86_64.deb
# https://global.synologydownload.com/download/Utility/SynologyDriveClient/3.3.0-15082/Ubuntu/Installer/x86_64/synology-drive-client-15082.x86_64.deb?model=DS218j&bays=2&dsm_version=7.1.1&build_number=42962

SCRIPT_DIR=$(dirname "${0}")

source "${SCRIPT_DIR}/deb.sh"
source "${SCRIPT_DIR}/config/install.conf"

# Extract attributess from DSM version data
dsm () {
    # Get DSM version data
    local dsm_attrs
    dsm_attrs=$(ssh queen@"${nas_ip}" 'cat /etc.defaults/VERSION')
    
    # Grep required field (productversion and buildnumber in this case)
    echo "${dsm_attrs} | grep -oP '(?<=$1=\")[0-9][.0-9]*'"
}

latest_release () {
    # Grep synology drive client latest release version from webpage
    local client_release_notes='https://www.synology.com/en-global/releaseNote/SynologyDriveClient'
    local client_release_regex='(?<=Version:\s)[0-9].[0-9].[0-9]-[0-9]+'
    local client_release_num
    client_release_num="$(curl -sL "${client_release_notes}" | grep -oP -m 1 "${client_release_regex}" )"
    local client_release_build
    client_release_build="$( echo "${client_release_num}" | grep -oP '([0-9]+){5}')"

    # Grep DSM version data via ssh
    local dsm_productversion
    dsm_productversion="$(dsm productversion)"
    local dsm_buildnumber
    dsm_buildnumber="$(dsm buildnumber)"

    # deb file name
    local deb_file="synology-drive-client-${client_release_build}.x86_64.deb"

    # Download URL
    local deb_url="https://global.synologydownload.com/download/Utility/SynologyDriveClient/${client_release_num}"
    local deb_url+="/Ubuntu/Installer/x86_64/${deb_file}?model=DS218j&bays=2&"
    local deb_url+="dsm_version=${dsm_productversion}&build_number=${dsm_buildnumber}"

    echo "${deb_file}" "${deb_url}"
}

main () {
    local install_mode="$1"

    # Choose client version to download
    if [[ $install_mode == "latest" ]]; then
        # Read two string values from latest_release function
        read -r deb_file deb_url <<< "$(latest_release)"
    else
        # Latest client is bugged on Ubuntu 22.04, specific version is used
        deb_file='synology-drive-client-13271.x86_64.deb'
        deb_url='https://global.download.synology.com/download/Utility/SynologyDriveClient/3.2.1-13271'
        deb_url+="/Ubuntu/Installer/x86_64/${deb_file}"
    fi
    
    deb_path="${downloads_path}/${deb_file}"
    deb_install "${deb_url}" "${deb_path}"
}

# Set argument1="latest" to install the latest available version
main "$@"
