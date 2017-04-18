#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"
TEST_DATA_PATH="$(dirname ${BASH_SOURCE})/../data/search"


source ${BIVALVIA_PATH}/software_testing.sh
source ${BIVALVIA_PATH}/search.sh


test_function_stdout exact_string_match_count_in_file 1 "${TEST_DATA_PATH}/exact_string_match" 'bcd'
test_function_stdout exact_string_match_count_in_file 5 "${TEST_DATA_PATH}/exact_string_match" 'bcde'
test_function_stdout exact_string_match_count_in_file 1 "${TEST_DATA_PATH}/exact_string_match" 'abcde'
test_function_stdout exact_string_match_count_in_file 0 "${TEST_DATA_PATH}/exact_string_match" 'BcD'
