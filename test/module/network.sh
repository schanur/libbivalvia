#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"


source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/network.sh"


test_function_stdout hostname_is_resolvable        1 127.0.0.1
test_function_stdout hostname_is_resolvable        0 127.0.0.2
test_function_stdout hostname_is_resolvable        1 google.com
test_function_stdout hostname_is_resolvable        0 yaq1xsw272.com # You can kid me by registering this domain.
