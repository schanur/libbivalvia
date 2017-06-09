BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


function installed_deb_packages {
    dpkg -l -- \
        | sed -e 's/\ \ /\ /g' \
        | cut -f 2 -d ' ' \
        | tail -n +6

}
