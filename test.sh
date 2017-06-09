#!/bin/bash

BIVALVIA_PATH="   $(dirname "${BASH_SOURCE[0]}")/bivalvia"
MODULE_TEST_PATH="$(dirname "${BASH_SOURCE[0]}")/test/module"


for MODULE_TEST_SCRIPT in $(find "${MODULE_TEST_PATH}" "${MODULE_TEST_PATH}" -mindepth 1 -maxdepth 1); do
    echo "${MODULE_TEST_SCRIPT}"
    "${MODULE_TEST_SCRIPT}"
done
