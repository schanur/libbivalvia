#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/link.sh"
source "${BIVALVIA_PATH}/date.sh"


TEMP_TEST_BASE_PATH="/tmp/libbivalvia_test/link/$(timestamp)"


# Destination file exists. No link in link path
TEST_1_TARGET_PATH="${TEMP_TEST_BASE_PATH}/1/target"
TEST_1_LINK_PATH="${TEMP_TEST_BASE_PATH}/1/link"
TEST_1_TARGET_FILE="${TEST_1_TARGET_PATH}/target_file"
TEST_1_LINK_FILE="${TEST_1_LINK_PATH}/link_file"
mkdir -p "${TEST_1_TARGET_PATH}"
mkdir -p "${TEST_1_LINK_PATH}"
echo "1" > "${TEST_1_TARGET_FILE}"
backup_config_and_create_link "${TEST_1_TARGET_FILE}" "${TEST_1_LINK_FILE}"


# # Destination file exists. Relative link to target already exists.
# TEST_2_TARGET_PATH="${TEMP_TEST_BASE_PATH}/2/target"
# TEST_2_LINK_PATH="${TEMP_TEST_BASE_PATH}/2/link"
# TEST_2_TARGET_FILE="${TEST_2_TARGET_PATH}/target_file"
# TEST_2_LINK_FILE="${TEST_2_LINK_PATH}/link_file"
# mkdir -p "${TEST_2_TARGET_PATH}"
# mkdir -p "${TEST_2_LINK_PATH}"
# echo "2" > "${TEST_2_TARGET_FILE}"
# ln -s -r "${TEST_2_TARGET_FILE}" "${TEST_2_LINK_FILE}"
# backup_config_and_create_link "${TEST_2_TARGET_FILE}" "${TEST_2_LINK_FILE}"


# # Destination file exists. Absolute link to target already exists.
# TEST_3_TARGET_PATH="${TEMP_TEST_BASE_PATH}/3/target"
# TEST_3_LINK_PATH="${TEMP_TEST_BASE_PATH}/3/link"
# TEST_3_TARGET_FILE="${TEST_3_TARGET_PATH}/target_file"
# TEST_3_LINK_FILE="${TEST_3_LINK_PATH}/link_file"
# mkdir -p "${TEST_3_TARGET_PATH}"
# mkdir -p "${TEST_3_LINK_PATH}"
# echo "3" > "${TEST_3_TARGET_FILE}"
# ln -s "${TEST_3_TARGET_FILE}" "${TEST_3_LINK_FILE}"
# backup_config_and_create_link "${TEST_3_TARGET_FILE}" "${TEST_3_LINK_FILE}"




# Clean up.
# rm -r "${TEMP_TEST_BASE_PATH}"
