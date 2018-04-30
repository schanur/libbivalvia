#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"
TEST_DATA_PATH="$(dirname "${BASH_SOURCE[0]}")/../data"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/block_dev.sh"


# DATA_PATH="${BIVALVIA_PATH}/../test/data/filesystem"
# FILE_SIZE_FUNC_DATA_PATH="${DATA_PATH}/func_file_size"


test_function_stdout uuid_to_dev_filename          "/dev/disk/by-uuid/fb7cb1da-37b6-45b1-9089-984e1373c36b" "fb7cb1da-37b6-45b1-9089-984e1373c36b"

# It is hard tot test uuid_to_open_luks_dev_filename. We need a small block device image
