# BIVALVIA_PATH="$(dirname $BASH_SOURCE)"

# echo ${BIVALVIA_PATH}

set -o errexit -o nounset -o pipefail


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

GL_TEST_SUCC_STATUS="OK"
GL_TEST_ERROR_STATUS="Failed"


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

function test_function {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}"
    local EXPECTED_STDOUT_VALUE="${3}"
    local EXPECTED_STDERR_VALUE="${4}"
    local ACTUAL_RETURN_VALUE
    local ACTUAL_STDOUT_VALUE
    local ACTUAL_STDERR_VALUE="" # TODO: We currently do not cover stderr values
    shift; shift; shift; shift
    local PARAMETER="${*}"
    local TEST_LOG_OUTPUT_STR
    local TEST_STATUS_START_COLUMN
    local TEST_RETURN_STATUS=0
    local TEST_DURATION
    local TEST_STATUS=${GL_TEST_SUCC_STATUS}
    local COLUMNS=$(tput cols)


    (( TEST_STATUS_START_COLUMN = COLUMNS - 9 ))
    TEST_LOG_OUTPUT_STR="Test: ${EXPECTED_STDOUT_VALUE} ${FUNCTION_NAME} ${PARAMETER}"
    # echo
    # print_var_list FUNCTION_NAME EXPECTED_RETURN_VALUE EXPECTED_STDOUT_VALUE EXPECTED_STDERR_VALUE PARAMETER TEST_LOG_OUTPUT_STR COLUMNS
    # echo

    echo $TEST_LOG_OUTPUT_STR

    # echo -n $(fill_tail ${TEST_LOG_OUTPUT_STR} ${TEST_STATUS_START_COLUMN} ' ')
    fill_tail "${TEST_LOG_OUTPUT_STR}" ${TEST_STATUS_START_COLUMN} ' '

    ### Run the actual test ###
    set_test_start_time
    ACTUAL_STDOUT_VALUE=$(${FUNCTION_NAME} ${PARAMETER})
    ACTUAL_RETURN_VALUE=${?}
    TEST_DURATION=$(test_duration)
    ### ################### ###

    test  ${EXPECTED_RETURN_VALUE}  -eq  ${ACTUAL_RETURN_VALUE}  || TEST_STATUS=${GL_TEST_ERROR_STATUS}
    test "${EXPECTED_STDOUT_VALUE}"  =  "${ACTUAL_STDOUT_VALUE}" || TEST_STATUS=${GL_TEST_ERROR_STATUS}
    test "${EXPECTED_STDERR_VALUE}"  =  "${ACTUAL_STDERR_VALUE}" || TEST_STATUS=${GL_TEST_ERROR_STATUS}

    echo "$(fill_tail ${TEST_STATUS} 6 ' ') ${TEST_DURATION}"
}

function test_function_stdout {
    local FUNCTION_NAME="${1}"
    local EXPECTED_STDOUT_VALUE="${2}"
    shift; shift
    local PARAMETER="${*}"


}

function test_stats {
    local TOTAL_TEST_COUNT

    (( TOTAL_TEST_COUNT = GL_TEST_SUCC_COUNT + GL_TEST_ERROR_COUNT ))

    echo "Successful: ${GL_TEST_SUCC_COUNT}"
    echo "Failed:     ${GL_TEST_ERROR_COUNT}"
    echo "----------------"
    echo "Total:      ${TOTAL_TEST_COUNT}"
}
