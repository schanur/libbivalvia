BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/color.sh"
source "${BIVALVIA_PATH}/date.sh"
source "${BIVALVIA_PATH}/debug.sh"
source "${BIVALVIA_PATH}/numerical.sh"
source "${BIVALVIA_PATH}/string.sh"


GL_TEST_SUCC_COUNT=0
GL_TEST_ERROR_COUNT=0

GL_TEST_START_TIME=0
GL_TEST_END_TIME=0

# TODO: Calculate time of whole test suit. But is that really needed?
# GL_TEST_FIRST_START_TIME=0
# GL_TEST_LAST_END_TIME=0

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
    GL_TEST_START_TIME=$(ms_since_epoch)
}


function set_test_end_time {
    GL_TEST_END_TIME=$(ms_since_epoch)
}


function test_duration {
    local TEST_DURATION=$(numeric_diff ${GL_TEST_END_TIME} ${GL_TEST_START_TIME})

    echo ${TEST_DURATION}
}


function run_desc_tests_from_function {
    local MODULE_FILENAME="${1}"
    local FUNCTION_NAME="${2}"
}


function run_desc_tests_from_module {
    local MODULE_FILENAME="${1}"
}


# function print_test_desc {

# }


# function print_test_result {

# }


function print_comparison_in_plaintext_and_hex {
    local EXPECT_DESC="${1}"
    local EXPECT_VALUE="${2}"
    local ACTUAL_DESC="${3}"
    local ACTUAL_VALUE="${4}"

    echo "${EXPECT_DESC}: >> ${EXPECT_VALUE} <<"
    echo "${ACTUAL_DESC}: >> ${ACTUAL_VALUE} <<"

    echo    "${EXPECT_DESC}:"
    echo -n "${EXPECT_VALUE}" | hexdump -C
    echo    "${ACTUAL_DESC}:"
    echo -n "${ACTUAL_VALUE}" | hexdump -C
}


# For each test result mismatch in one of the three results types
# return code, stdout and stderr, print the expected and actual
# value. Return code is printed as integer only. Stdout and stderr are
# printed in plain text and hex.
function describe_test_failure {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}" EXPECTED_STDOUT_VALUE="${3}" EXPECTED_STDERR_VALUE="${4}"
    local ACTUAL_RETURN_VALUE="${5}"   ACTUAL_STDOUT_VALUE="${6}"   ACTUAL_STDERR_VALUE="${7}"

    if [  ${EXPECTED_RETURN_VALUE}  -ne  ${ACTUAL_RETURN_VALUE}  ]; then
        echo "Expected return value: >> ${EXPECTED_RETURN_VALUE} <<"
        echo "Actual return value:   >> ${ACTUAL_RETURN_VALUE} <<"
    fi
    if [ "${EXPECTED_STDOUT_VALUE}"  != "${ACTUAL_STDOUT_VALUE}" ]; then
        print_comparison_in_plaintext_and_hex "Expected stdout value" "${EXPECTED_STDOUT_VALUE}" "Actual stdout value" "${ACTUAL_STDOUT_VALUE}"
    fi
    if [ "${EXPECTED_STDERR_VALUE}"  != "${ACTUAL_STDERR_VALUE}" ]; then
        print_comparison_in_plaintext_and_hex "Expected stderr value" "${EXPECTED_STDERR_VALUE}" "Actual stderr value" "${ACTUAL_STDERR_VALUE}"
    fi

    stack_trace
}


# Check if 2 strings are equal. It shows a test summary line similar
# to test_function. Use this function if you want to unit test
# something that is not a function but that is also not trivial in
# time consumption.
function test_string_equal_with_duration {
    local EXPECTED_STRING="${1}"
    local ACTUAL_STRING="${2}"
    shift; shift
    local DESCRIPTION="$*"
    local TEST_SUCC=1

    # Print test description.
    echo -n "  "$(with_color yellow "desc: ")
    fill_ellipsis_tail 42 ' ' ${DESCRIPTION}                                      && echo -n " "
    fill_ellipsis_tail 32 ' ' "$(with_color yellow expected:) ${EXPECTED_STRING}" && echo -n " "
    fill_ellipsis_tail 30 ' ' "$(with_color yellow actual:) ${ACTUAL_STRING}"     && echo -n " "

    # Check if test was successful.
    test ${EXPECTED_STRING} = ${ACTUAL_STRING} || TEST_SUCC=0

    # Set all required variables for test result log string.
    if [ ${TEST_SUCC} -eq 1 ]; then
        TEST_STATUS_STR=${GL_TEST_SUCC_STATUS_STR}
        TEST_STATUS_COLOR=${GL_TEST_SUCC_STATUS_COLOR}
    else
        TEST_STATUS_STR=${GL_TEST_ERROR_STATUS_STR}
        TEST_STATUS_COLOR=${GL_TEST_ERROR_STATUS_COLOR}
    fi

    # Print test result.
    with_color yellow "test_status:"
         echo " $(with_color ${TEST_STATUS_COLOR} $(fill_tail ${GL_TEST_MAX_STATUS_STR_LEN} ' ' ${TEST_STATUS_STR}) \($(test_duration) ms\))"
}


# Similar to "test_string_equal_with_duration" but assume a test
# duration of 0 milliseconds.
function test_string_equal {
    local EXPECTED_STRING="${1}"
    local ACTUAL_STRING="${2}"
    local TEST_DURATION=0
    shift; shift
    local DESCRIPTION="$*"

    test_string_equal_with_duration "${EXPECTED_STRING}" "${ACTUAL_STRING}" "${TEST_DURATION}" "${DESCRIPTION}"
}


# Calling convention:
#  test_function function_name expected_return expected_stdout expected_stderr
function test_function {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}" EXPECTED_STDOUT_VALUE="${3}" EXPECTED_STDERR_VALUE="${4}"
    local ACTUAL_RETURN_VALUE ACTUAL_STDOUT_VALUE ACTUAL_STDERR_VALUE="" # TODO: We currently do not cover stderr values
    local RETURN_CORRECT=1 STDOUT_CORRECT=1 STDERR_CORRECT=1
    shift; shift; shift; shift

    local TEST_LOG_OUTPUT_STR TEST_STATUS_START_COLUMN TEST_RETURN_STATUS=0 TEST_DURATION TEST_SUCC=1 TEST_STATUS_STR
    local TEST_STATUS_COLOR
    local COLUMNS=$(tput cols)

    # (( TEST_STATUS_START_COLUMN = COLUMNS - GL_TEST_DISTANCE_TO_RIGHT_BORDER ))

    # Print test description.
    echo -n "  "
    echo -n $(with_color yellow "func: ")
    fill_ellipsis_tail 30 ' ' ${FUNCTION_NAME}                                     && echo -n " "
    fill_ellipsis_tail 30 ' ' "$(with_color yellow parm:) ${@}"                    && echo -n " "
    fill_ellipsis_tail 18 ' ' "$(with_color yellow ret:) ${EXPECTED_RETURN_VALUE}" && echo -n " "
    fill_ellipsis_tail 25 ' ' "$(with_color yellow out:) ${EXPECTED_STDOUT_VALUE}" && echo -n " "
    fill_ellipsis_tail 18 ' ' "$(with_color yellow err:) ${EXPECTED_STDERR_VALUE}"

    # Run the actual test.
    set_test_start_time
    ACTUAL_STDOUT_VALUE=$(${FUNCTION_NAME} "${@}")
    ACTUAL_RETURN_VALUE=${?}
    set_test_end_time
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

    # Print test result.
    with_color yellow "test_status:"
    echo " $(with_color ${TEST_STATUS_COLOR} $(fill_tail ${GL_TEST_MAX_STATUS_STR_LEN} ' ' ${TEST_STATUS_STR}) \(${TEST_DURATION} ms\))"

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

    test_function ${FUNCTION_NAME} ${EXPECTED_RETURN_VALUE} "" "" "${@}"
}


# Expect the return value 0 and no stderr output.
function test_function_stdout {
    local FUNCTION_NAME="${1}"
    local EXPECTED_STDOUT_VALUE="${2}"
    shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} 0 "${EXPECTED_STDOUT_VALUE}" "" "${@}"
}


# Expect the return value 0 and no stdout output.
function test_function_stderr {
    local FUNCTION_NAME="${1}"
    local EXPECTED_STDERR_VALUE="${2}"
    shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} 0 "" "${EXPECTED_STDERR_VALUE}" "${@}"
}


function test_function_return_and_stdout {
    local FUNCTION_NAME="${1}"
    local EXPECTED_RETURN_VALUE="${2}"
    local EXPECTED_STDOUT_VALUE="${3}"
    shift; shift; shift
    local PARAMETER="${@}"

    test_function ${FUNCTION_NAME} "${EXPECTED_RETURN_VALUE}" "${EXPECTED_STDERR_VALUE}" "" "${@}"
}


function test_condition {
    true
}


function test_path_exists {
    true
}


# # Calling convention:
# #  test_function function_name expected_return expected_stdout expected_stderr
# function test_function_manual {
#     local FUNCTION_NAME="${1}"
#     local EXPECTED_RETURN_VALUE="${2}" EXPECTED_STDOUT_VALUE="${3}" EXPECTED_STDERR_VALUE="${4}"
#     local ACTUAL_RETURN_VALUE ACTUAL_STDOUT_VALUE ACTUAL_STDERR_VALUE="" # TODO: We currently do not cover stderr values
#     local RETURN_CORRECT=1 STDOUT_CORRECT=1 STDERR_CORRECT=1
#     shift; shift; shift; shift
#     local PARAMETER="${@}"
#     # echo "${PARAMETER}"
#     local TEST_LOG_OUTPUT_STR TEST_STATUS_START_COLUMN TEST_RETURN_STATUS=0 TEST_DURATION TEST_SUCC=1 TEST_STATUS_STR
#     local TEST_STATUS_COLOR
#     local COLUMNS=$(tput cols)

#     # (( TEST_STATUS_START_COLUMN = COLUMNS - GL_TEST_DISTANCE_TO_RIGHT_BORDER ))

#     # Print test description.
#     echo -n "    "
#     echo -n $(with_color yellow "func: ")
#     fill_ellipsis_tail 30 ' ' ${FUNCTION_NAME}                                     && echo -n " "
#     fill_ellipsis_tail 40 ' ' "$(with_color yellow parm:) ${PARAMETER}"            && echo -n " "
#     fill_ellipsis_tail 18 ' ' "$(with_color yellow ret:) ${EXPECTED_RETURN_VALUE}" && echo -n " "
#     fill_ellipsis_tail 25 ' ' "$(with_color yellow out:) ${EXPECTED_STDOUT_VALUE}" && echo -n " "
#     fill_ellipsis_tail 25 ' ' "$(with_color yellow err:) ${EXPECTED_STDERR_VALUE}"

#     # Run the actual test.
#     set_test_start_time
#     ACTUAL_STDOUT_VALUE=$(${FUNCTION_NAME} ${PARAMETER})
#     ACTUAL_RETURN_VALUE=${?}
#     TEST_DURATION=$(test_duration)

#     # Check if test was successful.
#     test  ${EXPECTED_RETURN_VALUE}  -eq  ${ACTUAL_RETURN_VALUE}  || TEST_SUCC=0
#     test "${EXPECTED_STDOUT_VALUE}"   = "${ACTUAL_STDOUT_VALUE}" || TEST_SUCC=0
#     test "${EXPECTED_STDERR_VALUE}"   = "${ACTUAL_STDERR_VALUE}" || TEST_SUCC=0

#     # Set all required variables for test result log string.
#     if [ ${TEST_SUCC} -eq 1 ]; then
#         TEST_STATUS_STR=${GL_TEST_SUCC_STATUS_STR}
#         TEST_STATUS_COLOR=${GL_TEST_SUCC_STATUS_COLOR}
#     else
#         TEST_STATUS_STR=${GL_TEST_ERROR_STATUS_STR}
#         TEST_STATUS_COLOR=${GL_TEST_ERROR_STATUS_COLOR}

#     fi

#     with_color yellow "test_status:"
#     # Print test result.
#     echo " $(with_color ${TEST_STATUS_COLOR} $(fill_tail ${GL_TEST_MAX_STATUS_STR_LEN} ' ' ${TEST_STATUS_STR}) ${TEST_DURATION})"

#     if [ ${TEST_SUCC} -eq 0 ]; then
#         describe_test_failure ${FUNCTION_NAME} \
#                               "${EXPECTED_RETURN_VALUE}" "${EXPECTED_STDOUT_VALUE}" "${EXPECTED_STDERR_VALUE}" \
#                               "${ACTUAL_RETURN_VALUE}"   "${ACTUAL_STDOUT_VALUE}"   "${ACTUAL_STDERR_VALUE}"
#     fi
# }


function test_stats {
    local TOTAL_TEST_COUNT

    (( TOTAL_TEST_COUNT = GL_TEST_SUCC_COUNT + GL_TEST_ERROR_COUNT ))

    echo "Successful: ${GL_TEST_SUCC_COUNT}"
    echo "Failed:     ${GL_TEST_ERROR_COUNT}"
    echo "----------------"
    echo "Total:      ${TOTAL_TEST_COUNT}"
}
