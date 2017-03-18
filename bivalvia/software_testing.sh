# BIVALVIA_PATH="$(dirname $BASH_SOURCE)"

# echo ${BIVALVIA_PATH}

set -o errexit -o nounset -o pipefail


source ${BIVALVIA_PATH}/color.sh
source ${BIVALVIA_PATH}/date.sh
source ${BIVALVIA_PATH}/debug.sh # FIXME: Remove
source ${BIVALVIA_PATH}/numerical.sh
source ${BIVALVIA_PATH}/string.sh


GL_TEST_SUCC_COUNT=0
GL_TEST_ERROR_COUNT=0

GL_TEST_START_TIME=0
# GL_TEST_END_TIME=0

GL_TEST_FIRST_START_TIME=0
GL_TEST_LAST_END_TIME=0

GL_TEST_SUCC_STATUS_STR='OK'
GL_TEST_SUCC_STATUS_COLOR='green'

GL_TEST_ERROR_STATUS_STR='Failed'
GL_TEST_ERROR_STATUS_COLOR='red'

# Calculate the column position where to start printing the test
# status and timing informations.
GL_TEST_MAX_STATUS_STR_LEN=$(longest_string_length "${GL_TEST_SUCC_STATUS_STR}" "${GL_TEST_ERROR_STATUS_STR}")
GL_TEST_DISTANCE_FROM_RIGHT=3
GL_TEST_DISTANCE_TO_RIGHT_BORDER=0
(( GL_TEST_DISTANCE_TO_RIGHT_BORDER = GL_TEST_MAX_STATUS_STR_LEN + GL_TEST_DISTANCE_FROM_RIGHT ))

function set_test_start_time {
    # GL_TEST_FIRST_START_TIME
    GL_TEST_START_TIME=$(ms_since_epoch)
}

function test_duration {
    local TEST_END_TIME=$(ms_since_epoch)
    local TEST_DURATION=$(numeric_diff $(ms_since_epoch) ${GL_TEST_START_TIME})

    echo ${TEST_DURATION}
}

function run_desc_tests_from_function {
    local MODULE_FILENAME=${1}
    local FUNCTION_NAME=${2}
}

function run_desc_tests_from_module {
    local MODULE_FILENAME=${1}
}

# function print_test_desc {

# }

# function print_test_result {

# }

function describe_test_failure {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}" EXPECTED_STDOUT_VALUE="${3}" EXPECTED_STDERR_VALUE="${4}"
    local ACTUAL_RETURN_VALUE="${5}"   ACTUAL_STDOUT_VALUE="${6}"   ACTUAL_STDERR_VALUE="${7}"

    if [ ${EXPECTED_RETURN_VALUE}   -ne  ${ACTUAL_RETURN_VALUE} ]; then
        echo "Expected return value:  >> ${EXPECTED_RETURN_VALUE} <<"
        echo "Actual return value:    >> ${ACTUAL_RETURN_VALUE} <<"
    fi
    if [ "${EXPECTED_STDOUT_VALUE}"  != "${ACTUAL_STDOUT_VALUE}" ]; then
        echo "Expected stdout value:  >> ${EXPECTED_STDOUT_VALUE} <<"
        echo "Actual stdout value:    >> ${ACTUAL_STDOUT_VALUE} <<"
    fi
    if [ "${EXPECTED_STDERR_VALUE}"  != "${ACTUAL_STDERR_VALUE}" ]; then
        echo "Expected stderr value:  >> ${EXPECTED_STDERR_VALUE} <<"
        echo "Actual stderr value:    >> ${ACTUAL_STDERR_VALUE} <<"
    fi
}

# Calling convention:
#  test_function function_name expected_return expected_stdout expected_stderr
function test_function {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}" EXPECTED_STDOUT_VALUE="${3}" EXPECTED_STDERR_VALUE="${4}"
    local ACTUAL_RETURN_VALUE ACTUAL_STDOUT_VALUE ACTUAL_STDERR_VALUE="" # TODO: We currently do not cover stderr values
    local RETURN_CORRECT=1 STDOUT_CORRECT=1 STDERR_CORRECT=1
    shift; shift; shift; shift
    local PARAMETER="${@}"
    # echo "${PARAMETER}"
    local TEST_LOG_OUTPUT_STR TEST_STATUS_START_COLUMN TEST_RETURN_STATUS=0 TEST_DURATION TEST_SUCC=1 TEST_STATUS_STR
    local TEST_STATUS_COLOR
    local COLUMNS=$(tput cols)

    # (( TEST_STATUS_START_COLUMN = COLUMNS - GL_TEST_DISTANCE_TO_RIGHT_BORDER ))

    # Print test description.
    echo -n "  "
    echo -n $(with_color yellow "func: ")
    fill_ellipsis 30 ' ' ${FUNCTION_NAME}                                     && echo -n " "
    fill_ellipsis 30 ' ' "$(with_color yellow parm:) ${PARAMETER}"            && echo -n " "
    fill_ellipsis 18 ' ' "$(with_color yellow ret:) ${EXPECTED_RETURN_VALUE}" && echo -n " "
    fill_ellipsis 25 ' ' "$(with_color yellow out:) ${EXPECTED_STDOUT_VALUE}" && echo -n " "
    fill_ellipsis 18 ' ' "$(with_color yellow err:) ${EXPECTED_STDERR_VALUE}"

    # Run the actual test.
    set_test_start_time
    ACTUAL_STDOUT_VALUE=$(${FUNCTION_NAME} ${PARAMETER})
    ACTUAL_RETURN_VALUE=${?}
    TEST_DURATION=$(test_duration)

    # Check if test was successful.
    test  ${EXPECTED_RETURN_VALUE}  -eq  ${ACTUAL_RETURN_VALUE}  || TEST_SUCC=0
    test "${EXPECTED_STDOUT_VALUE}"   = "${ACTUAL_STDOUT_VALUE}" || TEST_SUCC=0
    test "${EXPECTED_STDERR_VALUE}"   = "${ACTUAL_STDERR_VALUE}" || TEST_SUCC=0

    # Set all required variables for test result log string.
    if [ ${TEST_SUCC} -eq 1 ]; then
        TEST_STATUS_STR=${GL_TEST_SUCC_STATUS_STR}
        TEST_STATUS_COLOR=${GL_TEST_SUCC_STATUS_COLOR}
    else
        TEST_STATUS_STR=${GL_TEST_ERROR_STATUS_STR}
        TEST_STATUS_COLOR=${GL_TEST_ERROR_STATUS_COLOR}

    fi

    with_color yellow "test_status:"
    # Print test result.
    echo " $(with_color ${TEST_STATUS_COLOR} $(fill_tail ${GL_TEST_MAX_STATUS_STR_LEN} ' ' ${TEST_STATUS_STR}) ${TEST_DURATION})"

    if [ ${TEST_SUCC} -eq 0 ]; then
        describe_test_failure ${FUNCTION_NAME} \
                              "${EXPECTED_RETURN_VALUE}" "${EXPECTED_STDOUT_VALUE}" "${EXPECTED_STDERR_VALUE}" \
                              "${ACTUAL_RETURN_VALUE}"   "${ACTUAL_STDOUT_VALUE}"   "${ACTUAL_STDERR_VALUE}"
    fi
}

# Expect no stderr output and no stderr output.
function test_function_return {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}"
    shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} ${EXPECTED_RETURN_VALUE} "" "" "${PARAMETER}"
}

# Expect the return value 0 and no stderr output.
function test_function_stdout {
    local FUNCTION_NAME="${1}"
    local EXPECTED_STDOUT_VALUE="${2}"
    shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} 0 "${EXPECTED_STDOUT_VALUE}" "" "${PARAMETER}"
}

# Expect the return value 0 and no stdout output.
function test_function_stderr {
    local FUNCTION_NAME="${1}"
    local EXPECTED_STDERR_VALUE="${2}"
    shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} 0 "" "${EXPECTED_STDERR_VALUE}" "${PARAMETER}"
}

function test_function_return_and_stdout {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}"
    local EXPECTED_STDOUT_VALUE="${3}"
    shift; shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} "${EXPECTED_RETURN_VALUE}" "${EXPECTED_STDERR_VALUE}" "" "${PARAMETER}"
}

function test_stats {
    local TOTAL_TEST_COUNT

    (( TOTAL_TEST_COUNT = GL_TEST_SUCC_COUNT + GL_TEST_ERROR_COUNT ))

    echo "Successful: ${GL_TEST_SUCC_COUNT}"
    echo "Failed:     ${GL_TEST_ERROR_COUNT}"
    echo "----------------"
    echo "Total:      ${TOTAL_TEST_COUNT}"
}
