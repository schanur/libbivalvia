#!/bin/bash

BIVALVIA_PATH="$(dirname $BASH_SOURCE)/bivalvia"
MODULE_TEST_PATH="$(dirname $BASH_SOURCE)/test/module"

# source

echo ${BIVALVIA_PATH}
for MODULE_TEST_SCRIPT in $(find ${MODULE_TEST_PATH} ${SEARCH_PATH} -mindepth 1 -maxdepth 1); do
    echo "${MODULE_TEST_SCRIPT}"

    ${MODULE_TEST_SCRIPT}
done
