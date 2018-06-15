#!/bin/bash

BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/bivalvia"
MODULE_TEST_PATH="$(dirname "${BASH_SOURCE[0]}")/test/module"


source "${BIVALVIA_PATH}/color.sh"


for MODULE_TEST_SCRIPT in $(find "${MODULE_TEST_PATH}" -mindepth 1 -maxdepth 1); do
    EXIT_CODE=0
    echo "${MODULE_TEST_SCRIPT}"
    "${MODULE_TEST_SCRIPT}" || EXIT_CODE=${?}
    if [ ${EXIT_CODE} -eq 1 ]; then
	echo 
	echo "$(with_color red "Test script exited with error code ${EXIT_CODE}: ${MODULE_TEST_SCRIPT}")"
	echo 
    fi
done
