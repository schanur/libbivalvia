#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/config.sh"


DATA_PATH="${BIVALVIA_PATH}/../test/data/config"
TEST_HOSTNAME="test_hostname"

GLOBAL_CONFIG_PATH="${DATA_PATH}/global_config"
NO_CONFIG_PATH="${DATA_PATH}/no_config"
PROFILE_AND_GLOBAL_CONFIG_PATH="${DATA_PATH}/profile_and_global_config"
PROFILE_CONFIG_PATH="${DATA_PATH}/profile_config"

GLOBAL_CONFIG_FILE="${GLOBAL_CONFIG_PATH}/global/test.conf"
PROFILE_AND_GLOBAL_CONFIG_FILE="${PROFILE_AND_GLOBAL_CONFIG_PATH}/profile/${TEST_HOSTNAME}/test.conf"
PROFILE_CONFIG_FILE="${PROFILE_CONFIG_PATH}/profile/${TEST_HOSTNAME}/test.conf"


set_config_hostname "${TEST_HOSTNAME}"


set_config_path "${GLOBAL_CONFIG_PATH}"

test_function_stdout global_config_file_exists     1 test.conf
test_function_stdout profile_config_file_exists    0 test.conf
test_function_stdout config_file_exists            1 test.conf

test_function_stdout absolute_config_file          "${GLOBAL_CONFIG_FILE}" test.conf

unset TEST_VAR


set_config_path "${NO_CONFIG_PATH}"

test_function_stdout global_config_file_exists     0 test.conf
test_function_stdout profile_config_file_exists    0 test.conf
test_function_stdout config_file_exists            0 test.conf

unset TEST_VAR


set_config_path "${PROFILE_AND_GLOBAL_CONFIG_PATH}"

test_function_stdout global_config_file_exists     1 test.conf
test_function_stdout profile_config_file_exists    1 test.conf
test_function_stdout config_file_exists            1 test.conf

test_function_stdout absolute_config_file          "${PROFILE_AND_GLOBAL_CONFIG_FILE}" test.conf

unset TEST_VAR


set_config_path "${PROFILE_CONFIG_PATH}"

test_function_stdout global_config_file_exists     0 test.conf
test_function_stdout profile_config_file_exists    1 test.conf
test_function_stdout config_file_exists            1 test.conf

test_function_stdout absolute_config_file          "${PROFILE_CONFIG_FILE}" test.conf

unset TEST_VAR

