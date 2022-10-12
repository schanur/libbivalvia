#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"
TEST_DATA_PATH="$(dirname "${BASH_SOURCE[0]}")/../data"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/service.sh"


