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

# function expect_2_params {
#     true
# }

test_function        print_abc  0 "abc" ""

test_function_return do_nothing 0
test_function_stdout print_abc  "abc"
test_function_stdout print_abc  "abc" "def"
# test_function_stderr print_abc ""
