BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/list.sh"


GL_PACKAGE_MANAGEMENT_DEB__AVAILABLE_PACKAGE_CACHE=""


function deb_package_cache_available_package_list {
    GL_PACKAGE_MANAGEMENT_DEB__AVAILABLE_PACKAGE_CACHE="$(apt-cache search . | cut -f 1 -d ' ')"
}


function deb_package_available_in_repos {
    local PACKAGE_NAME="${1}"

    if [ "${GL_PACKAGE_MANAGEMENT_DEB__AVAILABLE_PACKAGE_CACHE}" = "" ]; then
        deb_package_cache_available_package_list
    fi
    list_contains "${GL_PACKAGE_MANAGEMENT_DEB__AVAILABLE_PACKAGE_CACHE}" "${PACKAGE_NAME}"
}


function deb_package_is_installed {
    local PACKAGE_INSTALLED=1

    dpkg -l "$1" &>/dev/null || PACKAGE_INSTALLED=0

    echo ${PACKAGE_INSTALLED}
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
