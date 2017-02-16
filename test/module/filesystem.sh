#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"
TEST_DATA_PATH=${BIVALVIA_PATH}../test/data


source ${BIVALVIA_PATH}/filesystem.sh


files_in_path ${TEST_DATA_PATH}$
