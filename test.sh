#!/bin/bash

BIVALVIA_PATH="$(dirname $BASH_SOURCE)/bivalvia"
TEST_PATH="$(dirname $BASH_SOURCE)/test"

# source

echo ${BIVALVIA_PATH}
for TEST_SCRIPT in $(find ${TEST_PATH} ${SEARCH_PATH} -mindepth 1 -maxdepth 1); do
    ${TEST_SCRIPT}
done
