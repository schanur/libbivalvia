#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"


source ${BIVALVIA_PATH}/software_testing.sh
source ${BIVALVIA_PATH}/string.sh


# fill_ellipsis 8  "Te  st Tes"
# exit 1
test_function_stdout fill_ellipsis "..."         3  Test
test_function_stdout fill_ellipsis "Test"        4  Test
test_function_stdout fill_ellipsis "Test  "      6  Test
test_function_stdout fill_ellipsis "Test..."     7  TestTest
test_function_stdout fill_ellipsis "Test    "    8  Test
test_function_stdout fill_ellipsis "T..."        4  "Te st"
test_function_stdout fill_ellipsis "Te st"       5  "Te st"
test_function_stdout fill_ellipsis "Te st "      6  "Te st"
# test_function_stdout fill_ellipsis "Te  st "     7  "Te  st"
# test_function_stdout fill_ellipsis "Te  s..."    8  "Te  st Tes"
