BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


function cargo_package_is_installed {
    local PACKAGE_EXISTS=1

    dpkg -l "$1" &>/dev/null || PACKAGE_EXISTS=0

    echo ${PACKAGE_EXISTS}
}


function installed_cargo_packages {
    cargo install --list \
        | grep -e "^[a-z]"
        | cut -f 1 -d " "
}


function installed_cargo_packages_without_arch {
    installed_cargo_packages
}
