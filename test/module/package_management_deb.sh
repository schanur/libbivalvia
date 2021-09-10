#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/package_management_deb.sh"


test_function_stdout deb_package_available_in_repos 1 'emacs'
test_function_stdout deb_package_available_in_repos 0 'package-which-does-not-exist'
