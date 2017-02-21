#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"


source ${BIVALVIA_PATH}/software_testing.sh
source ${BIVALVIA_PATH}/csv.sh


test_function_stdout csv_get_field    'a'    1 'a,b,cd,ef'
test_function_stdout csv_get_field    'b'    2 'a,b,cd,ef'
test_function_stdout csv_get_field    'cd'   3 'a,b,cd,ef'
test_function_stdout csv_get_field    'ef'   4 'a,b,cd,ef'

test_function_stdout csv_field_count  1      'a'
test_function_stdout csv_field_count  2      ','
test_function_stdout csv_field_count  3      ',,'
test_function_stdout csv_field_count  4      ',,,'
test_function_stdout csv_field_count  5      'aa1,bbb2,,,ccc33'
test_function_stdout csv_field_count  6      'aa1,bbb2,,,ccc33,'

test_function_stdout csv_field_exists 0      ''   'ab'
test_function_stdout csv_field_exists 1      'ab' 'ab'
test_function_stdout csv_field_exists 1      '12' ',,12,,'
test_function_stdout csv_field_exists 1      'ab' ',,ab,ab'
test_function_stdout csv_field_exists 1      'ab' ',,ab,ab,'
test_function_stdout csv_field_exists 0      'ba' ',,ab,ab,'

test_function_stdout csv_push_back    ',a'   'a' ''
test_function_stdout csv_push_back    ',,a'  'a' ','
test_function_stdout csv_push_back    'a,,b' 'b' 'a,'
