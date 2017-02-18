#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"
TEST_DATA_PATH="$(dirname ${BASH_SOURCE})/../data"


source "${BIVALVIA_PATH}/filesystem.sh"

# echo
# file "${TEST_DATA_PATH}"
# echo
echo
files_in_path "${TEST_DATA_PATH}/filesystem/3_files"

echo
