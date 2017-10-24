#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/random.sh"


# RANDOM_FILE_FROM_PATH__MIN_TRIES=50
RANDOM_FILE_FROM_PATH__MAX_TRIES=500


# Test if "random_file_from_path" function finds all 4 files
# (f1, f2, f3, f4).
set_test_start_time
RANDOM_FILE__DATA_PATH="${BIVALVIA_PATH}/../test/data/random/random_file_from_path"
RANDOM_FILE__FILE_COUNT=5 # FIXME: is 4. declare -A did not work. we had to insert an element to declare first.

declare -A RANDOM_FILE_MAP
RANDOM_FILE_MAP[1000]=1 # FIXME
I=0
while [ ${#RANDOM_FILE_MAP[@]} -ne ${RANDOM_FILE__FILE_COUNT} ] && [ ${I} -lt ${RANDOM_FILE_FROM_PATH__MAX_TRIES} ]; do
    RANDOM_FILE="$(random_file_from_path "${RANDOM_FILE__DATA_PATH}")"
    (( I = I + 1 ))
    RANDOM_FILE_MAP["${RANDOM_FILE}"]="1"
done
set_test_end_time
test_string_equal ${RANDOM_FILE__FILE_COUNT} ${#RANDOM_FILE_MAP[@]} "Find 4 rand files. Tries: ${I}"


# Test if "random_file_from_path_recursive" function finds all 4 files
# (f1, f2, f3, f4).
set_test_start_time
RANDOM_FILE_RECURSIVE__DATA_PATH="${BIVALVIA_PATH}/../test/data/random/random_file_from_path_recursive"
RANDOM_FILE_RECURSIVE__FILE_COUNT=5 # FIXME: is 4. declare -A did not work. we had to insert an element to declare first.

declare -A RANDOM_FILE_RECURSIVE_MAP
RANDOM_FILE_RECURSIVE_MAP[1000]=1 # FIXME
I=0
while [ ${#RANDOM_FILE_RECURSIVE_MAP[@]} -ne ${RANDOM_FILE_RECURSIVE__FILE_COUNT} ] && [ ${I} -lt ${RANDOM_FILE_FROM_PATH__MAX_TRIES} ]; do
    RANDOM_FILE="$(random_file_from_path_recursive "${RANDOM_FILE_RECURSIVE__DATA_PATH}")"
    (( I = I + 1 ))
    RANDOM_FILE_RECURSIVE_MAP["${RANDOM_FILE}"]="1"
done
set_test_end_time
test_string_equal ${RANDOM_FILE_RECURSIVE__FILE_COUNT} ${#RANDOM_FILE_RECURSIVE_MAP[@]} "Find 4 rand files rec. Tries: ${I}"
