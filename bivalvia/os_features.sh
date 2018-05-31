BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


# Print 1 if your distribution has systemd installed. 0 otherwise.
function os_has_systemd {
    local SYSTEMD_AVAILABLE=1

    which systemctl > /dev/null || SYSTEMD_AVAILABLE=0

    echo "${SYSTEMD_AVAILABLE}"
}
