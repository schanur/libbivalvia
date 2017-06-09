#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"


source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/introspection.sh"

test_function_stdout list_functions  \
"list_functions
function_decl_line_no
function_description"    "${BIVALVIA_PATH}/introspection.sh"
