#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"
TEST_DATA_PATH="$(dirname "${BASH_SOURCE[0]}")/../data"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/filesystem.sh"


DATA_PATH="${BIVALVIA_PATH}/../test/data/filesystem"
FILE_SIZE_FUNC_DATA_PATH="${DATA_PATH}/func_file_size"


test_function_stdout file_size                     0     "${FILE_SIZE_FUNC_DATA_PATH}/empty"
test_function_stdout file_size                     10    "${FILE_SIZE_FUNC_DATA_PATH}/10_byte"
