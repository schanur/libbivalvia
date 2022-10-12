#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/object_store.sh"


STORE_NAME="unit_test_object_store"

test_function_stdout object_store__create_volatile "/dev/shm/$(whoami)/${STORE_NAME}" "${STORE_NAME}"

test_function_stdout object_store__clear

test_function_stdout object_store__destroy
