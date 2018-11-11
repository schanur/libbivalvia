#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/terminal.sh"



# Terminal modules does not have any tests yet. It is hard to test
# interactive session features in a non interactive test harness.


## Enable COLUMNS and LINES variables for this script.
# shopt -s checkwinsize

# COLUMNS=$(tput columns)
# LINES=$(tput lines)

# test_function_stdout terminal_width  "${COLUMNS}"
# test_function_stdout terminal_height "${LINES}"
