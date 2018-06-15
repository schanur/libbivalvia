#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"
TEST_DATA_PATH="$(dirname "${BASH_SOURCE[0]}")/../data"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/distribution.sh"


function os_release_id_known {
    local OS_RELEASE_ID="${1}"
    local ID_KNOWN=1

    (echo "
debian
fedora
" | grep -e "^${OS_RELEASE_ID}$") > /dev/null || ID_KNOWN=0

    echo ${ID_KNOWN}
}


function os_release_name_known {
    local OS_RELEASE_ID="${1}"
    local ID_KNOWN=1

    (echo "
Debian GNU/Linux
" | grep -e "^${OS_RELEASE_ID}$") > /dev/null || ID_KNOWN=0

    echo ${ID_KNOWN}
}


function os_release_pretty_name_known {
    local OS_RELEASE_ID="${1}"
    local ID_KNOWN=1

    (echo "
Debian GNU/Linux buster/sid
" | grep -e "^${OS_RELEASE_ID}$") > /dev/null || ID_KNOWN=0

    echo ${ID_KNOWN}
}


test_function_stdout os_release_id_known          1 "$(distribution_id)"
test_function_stdout os_release_name_known        1 "$(distribution_name)"
test_function_stdout os_release_pretty_name_known 1 "$(distribution_pretty_name)"
