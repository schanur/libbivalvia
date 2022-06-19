#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"


function print_abc {
    echo "abc"
}


function do_nothing {
    true
}


function echo_stdin {
    echo "${1}"
}


test_string_equal_with_duration ""   ""                                                             0 "Compare empty string"
test_string_equal_with_duration "-1" "-1"                                                           0 "Compare negative number as string"
test_string_equal_with_duration "1234567890+asdfghjkl#yxcvbnm,.-" "1234567890+asdfghjkl#yxcvbnm,.-" 0 "Compare special chars"

test_string_equal               ""   ""                                                               "Compare empty string. No duration."
test_string_equal               "-1" "-1"                                                             "Compare negative number as string. No duration."
test_string_equal               "1234567890+asdfghjkl#yxcvbnm,.-" "1234567890+asdfghjkl#yxcvbnm,.-"   "Compare special chars. No duration."


test_function                   print_abc  0 "abc"  ""

test_function_return            do_nothing 0
test_function_stdout            print_abc    "abc"
test_function_stdout            print_abc    "abc"  "def"


# TODO: software testing functions cut off newline at end of string if
# printed to stdout. But it is not that important.
test_function_stdout            echo_stdin   $'a\n' $'a\n'
