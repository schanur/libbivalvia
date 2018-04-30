#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"


source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/lockfile.sh"


TEST_RUN_PATH="${BIVALVIA_PATH}/../2test/run/lockfile"


# Cleanup old test runs.
if [ -d "${TEST_RUN_PATH}" ]; then
    rm -f "${TEST_RUN_PATH}"/file*.lock || true
else
    mkdir -p "${TEST_RUN_PATH}"
fi


# Create a single lock.
LOCKFILE2="${TEST_RUN_PATH}/file2.lock"
test_function_stdout lf__lock_exists  0 "${LOCKFILE2}"
test_function_stdout lf__lock_create  0 "${LOCKFILE2}"
test_function_stdout lf__lock_exists  1 "${LOCKFILE2}"
test_function_stdout lf__lock_destroy 0 "${LOCKFILE2}"
test_function_stdout lf__lock_exists  0 "${LOCKFILE2}"

# Test with 2 locks which exist at the same time.
LOCKFILE3="${TEST_RUN_PATH}/file3.lock"
LOCKFILE4="${TEST_RUN_PATH}/file4.lock"
test_function_stdout lf__lock_exists  0 "${LOCKFILE3}"
test_function_stdout lf__lock_exists  0 "${LOCKFILE4}"
test_function_stdout lf__lock_create  0 "${LOCKFILE3}"
test_function_stdout lf__lock_create  0 "${LOCKFILE4}"
test_function_stdout lf__lock_exists  1 "${LOCKFILE3}"
test_function_stdout lf__lock_exists  1 "${LOCKFILE4}"
test_function_stdout lf__lock_destroy 0 "${LOCKFILE3}"
test_function_stdout lf__lock_destroy 0 "${LOCKFILE4}"
test_function_stdout lf__lock_exists  0 "${LOCKFILE3}"
test_function_stdout lf__lock_exists  0 "${LOCKFILE4}"
