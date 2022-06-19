BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/error.sh"


# Prints "1" if hostname (1st paramter) is resolvable by DNS. "0"
# otherwise.
function hostname_is_resolvable {
    local HOSTNAME="${1}"
    local HOSTNAME_RESOLVABLE=1

    host "${1}" &>/dev/null || HOSTNAME_RESOLVABLE=0

    echo ${HOSTNAME_RESOLVABLE}
}
