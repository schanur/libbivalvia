#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/list.sh"


NEW_LIST="$(list_new)"
test_function_stdout list_size        0               "${NEW_LIST}"

test_function_stdout list_size        0               $''
test_function_stdout list_size        1               $'a'
test_function_stdout list_size        2               $'a\nb'

test_function_stdout list_is_empty    1               $''
test_function_stdout list_is_empty    0               $'a'
test_function_stdout list_is_empty    0               $'a\nb'

test_function_stdout list_count_value 0               $'a\nb'      $'c'
test_function_stdout list_count_value 1               $'a\nb'      $'b'
test_function_stdout list_count_value 2               $'a\nb\nb'   $'b'

test_function_stdout list_add         $'a\nb\nc\nd'   $'a\nb'      $'c\nd'
test_function_stdout list_add         $'a'            $''          $'a'
test_function_stdout list_add         $'a'            $'a'         $''

# test_function_stdout list_sub         $''           'a\nb'    'a\nb'
# test_function_stdout list_sub         $'b'          'a\nb'    'a'
# test_function_stdout list_sub         $'a\nb'       'a\nb'    'c'

test_function_stdout list_contains    1               $'a\nb\nc'   $'a'
test_function_stdout list_contains    1               $'a\nb\nc'   $'b'
test_function_stdout list_contains    1               $'a\nb\nc'   $'c'
test_function_stdout list_contains    1               $'c\nc\nc'   $'c'
test_function_stdout list_contains    0               $'a\nb\nc'   $'d'
