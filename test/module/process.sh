#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"


source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/process.sh"


# sleep 10s &
# CHILD_PID=${!}
# test_function_stdout child_pid "${CHILD_PID}\n" ${$}
# kill ${CHILD_PID}

# test_function_stdout pid_to_command "/bin/bash ./test/module/process.sh" ${$}
