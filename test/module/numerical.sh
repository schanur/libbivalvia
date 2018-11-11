#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/numerical.sh"


test_function_stdout is_number                      1       '1'
test_function_stdout is_number                      1       '2'
test_function_stdout is_number                      1       '100'

test_function_stdout is_number                      0       '0.1'
test_function_stdout is_number                      0       '-1'
test_function_stdout is_number                      0       'a'


test_function_stdout fraction_to_percentage         0       0 1
test_function_stdout fraction_to_percentage         50      1 2
test_function_stdout fraction_to_percentage         100     1 1
test_function_stdout fraction_to_percentage         100     2 2


test_function_stdout decimal_fraction_to_percentage 50      0.5
test_function_stdout decimal_fraction_to_percentage 0       0.0
test_function_stdout decimal_fraction_to_percentage 100     1
test_function_stdout decimal_fraction_to_percentage 100     1.0
test_function_stdout decimal_fraction_to_percentage 200     2
test_function_stdout decimal_fraction_to_percentage 200     2.0
test_function_stdout decimal_fraction_to_percentage 290     2.9
test_function_stdout decimal_fraction_to_percentage 291.111 2.91111


test_function_stdout percentage_to_decimal_fraction 0.5     50
test_function_stdout percentage_to_decimal_fraction 0.5     50.000
test_function_stdout percentage_to_decimal_fraction 0       0
test_function_stdout percentage_to_decimal_fraction 1       100
test_function_stdout percentage_to_decimal_fraction 2       200
test_function_stdout percentage_to_decimal_fraction 2.9     290

test_function_stdout percentage_to_decimal_fraction 0       '0%'
test_function_stdout percentage_to_decimal_fraction 0.5     '50%'
test_function_stdout percentage_to_decimal_fraction 0.5     '50 %'
test_function_stdout percentage_to_decimal_fraction 0.5     '50  %'
test_function_stdout percentage_to_decimal_fraction 2.9111  '291.11 %'


test_function_stdout numeric_diff                   2       1 3
test_function_stdout numeric_diff                   2       3 1
test_function_stdout numeric_diff                   4       3 -1
