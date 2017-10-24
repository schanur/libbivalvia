#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/parse.sh"


DATA_PATH="${BIVALVIA_PATH}/../test/data/parse"
GLOBAL_CONFIG_PATH="${DATA_PATH}/bash_syntax_with_comments"


# test_function_stdout filter_out_indented_line_start_match    1              ""
test_function_stdout filter_active_bash_lines                "$(printf '\n1\n\n\n\n2\n\n3')"  "${GLOBAL_CONFIG_PATH}"
