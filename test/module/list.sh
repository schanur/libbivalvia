#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"


source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/list.sh"


test_function_stdout list_is_empty    1              ""
test_function_stdout list_is_empty    0              "\n"
test_function_stdout list_is_empty    0              "a\nb\n"

test_function_stdout list_size        0              ""
test_function_stdout list_size        1              "\n"
test_function_stdout list_size        1              "a\n"
test_function_stdout list_size        2              "a\nb\n"

test_function_stdout list_count_value 0              "c"       "a\nb"
test_function_stdout list_count_value 1              "b"       "a\nb"
test_function_stdout list_count_value 2              "b"       "a\nb\nb"

test_function_stdout list_add         "a\nb\nc\nd\n" "a\nb\n"  "c\nd\n"
test_function_stdout list_add         "a\n"          ""        "a\n"
test_function_stdout list_add         "a\n"          "a\n"     ""

# test_function_stdout list_sub         "\n"           "a\nb\n"    "a\nb\n"
# test_function_stdout list_sub         "b\n"          "a\nb\n"    "a\n"
# test_function_stdout list_sub         "a\nb"       "a\nb\n"    "c\n"
