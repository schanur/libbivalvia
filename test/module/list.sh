#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"


source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/list.sh"


test_function_stdout list_is_empty    0            "a"
test_function_stdout list_is_empty    0            "a\nb"

test_function_stdout list_count_value 0            "c" "a\nb"
test_function_stdout list_count_value 1            "b" "a\nb"
test_function_stdout list_count_value 2            "b" "a\nb\nb"

test_function_stdout list_add         "a\nb\nc\nd" "a\nb" "c\nd"

test_function_stdout list_sub         ""           "a\nb" "a\nb"
test_function_stdout list_sub         "b"          "a\nb" "a"
test_function_stdout list_sub         "a\nb"       "a\nb" "c"
