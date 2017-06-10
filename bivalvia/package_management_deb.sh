BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


function deb_package_is_installed {
    local PACKAGE_EXISTS=1

    dpkg -l "$1" &>/dev/null || PACKAGE_EXISTS=0

    echo ${PACKAGE_EXISTS}
}

function installed_deb_packages {
    dpkg -l -- \
        | sed -e 's/\ \ /\ /g' \
        | cut -f 2 -d ' ' \
        | tail -n +6
}

function installed_deb_packages_without_arch {
    dpkg -l -- \
        | sed -e 's/\ \ /\ /g' \
        | cut -f 2 -d ' ' \
        | tail -n +6 \
        | cut -f 1 -d ':'
}
