# Install application via deb package

deb_install () {
    local deb_url="$1"
    local deb_path="$2"

    wget "${deb_url}" -O "${deb_path}"  # download deb package
    sudo dpkg -i "${deb_path}"               # install
    rm "${deb_path}"                    # remove after install
}
