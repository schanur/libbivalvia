BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

# Do not include "debug.sh"
source "${BIVALVIA_PATH}/numerical.sh"
source "${BIVALVIA_PATH}/network.sh"


BIVALVIA_REQUIRE__INIT=0
[[ -v BIVALVIA_REQUIRE__WAS_INIT ]] || BIVALVIA_REQUIRE__WAS_INIT=1; BIVALVIA_REQUIRE__INIT=1

if [ ${BIVALVIA_REQUIRE__INIT} -eq 1 ]; then
    [[ -v BIVALVIA_REQUIRE__TEST_FRAMEWORK_MODE                      ]] || BIVALVIA_REQUIRE__TEST_FRAMEWORK_MODE=0
    [[ -v BIVALVIA_REQUIRE__BIVALVIA_REQUIRE__STACK_TRACE_ON_FAILURE ]] || BIVALVIA_REQUIRE__STACK_TRACE_ON_FAILURE=1
    [[ -v BIVALVIA_REQUIRE__ERROR_STRING_ON_FAILURE                  ]] || BIVALVIA_REQUIRE__ERROR_STRING_ON_FAILURE=1
    [[ -v BIVALVIA_REQUIRE__EXIT_ON_FAILURE                          ]] || BIVALVIA_REQUIRE__EXIT_ON_FAILURE=1
fi


function require_failed {
    if [ ${BIVALVIA_REQUIRE__TEST_FRAMEWORK_MODE} -eq 1 ]; then
        echo "require_failed"
    else
        if [ ${BIVALVIA_REQUIRE__STACK_TRACE_ON_FAILURE} -eq 1 ]; then
            stack_trace
        fi

        if [ ${BIVALVIA_REQUIRE__ERROR_STRING_ON_FAILURE} -eq 1 ]; then
            local ERROR_STRING="${*}"
            echo ${ERROR_STRING} >&2
            echo "Abort!"        >&2
        fi

        if [ ${BIVALVIA_REQUIRE__EXIT_ON_FAILURE} ]; then
            exit 1
        fi
    fi
}


function require_parameters_not_empty {
    ALL_PARAMETERS=${*}

    if [ "${ALL_PARAMETERS}" = "" ]; then
        require_failed "Parameters are empty."
    fi
}


# Check if the binary/script filename exists in a path specified in the PATH variable. If no match is found, an error message is printed to stderr and the script terminates with an error.
function require_executable {
    require_parameters_not_empty ${*}

    local EXECUTABLE_NAME="${1}"
    local EXECUTABLE_FOUND=1

    which "${EXECUTABLE_NAME}" > /dev/null 2>/dev/null || EXECUTABLE_FOUND=0
    if [ ${EXECUTABLE_FOUND} -ne 1 ]; then
        require_failed "${EXECUTABLE_NAME} not found."
    fi
}


function require_exists {
    require_parameters_not_empty ${*}

    local FILENAME="${1}"

    if [ ! -e "${FILENAME}" ]; then
        require_failed "File not found: ${FILENAME}"
    fi
}


function require_file {
    require_parameters_not_empty ${*}

    local FILENAME="${1}"

    if [ ! -f "${FILENAME}" ]; then
        require_failed "File not found: ${FILENAME}"
    fi
}


function require_directory {
    require_parameters_not_empty ${*}

    local FILENAME="${1}"

    if [ ! -d "${FILENAME}" ]; then
        require_failed "Directory not found: ${FILENAME}"
    fi
}


function require_file_or_directory {
    require_parameters_not_empty ${*}

    local FILENAME="${1}"

    if [[ ! -f "${FILENAME}" && ! -d "${FILENAME}" ]]; then
        require_failed "File not found: ${FILENAME}"
    fi
}


function require_sybolic_link {
    require_parameters_not_empty ${*}

    local LINK_NAME="${1}"

    if [ ! -h "${LINK_NAME}" ]; then
        require_failed "Symbolic link not found: ${LINK_NAME}"
    fi
}


function require_block_special {
    require_parameters_not_empty ${*}

    local BLOCK_FILENAME="${1}"

    if [ ! -b "${BLOCK_FILENAME}" ]; then
        require_failed "Block special: ${BLOCK_FILENAME}"
    fi
}


function require_variable {
    require_parameters_not_empty ${*}

    local VARIABLE_NAME="${1}"

    if [ ! -v "${VARIABLE_NAME}" ]; then
        require_failed "Variable not set: ${LINK_NAME}"
    fi
}


function require_numeric_value {
    local REQUIRE_FAILED=0
    require_parameters_not_empty ${*}

    local VARIABLE="${1}"

    if [ $(is_number "${VARIABLE}") -ne 1 ]; then
        if [ "${REQUIRE_FAILED}" != "0" ]; then
            REQUIRE_FAILED=1
        fi
    fi

    if [ ${REQUIRE_FAILED} -eq 1 ]; then
        require_failed "Variable is no numeric value: ${VARIABLE}"
    fi
}


# Require that the first parameter is equal or larger than the second
# parameter.
function require_larger_equal {
    require_parameters_not_empty ${*}

    local ACTUAL_VALUE=${1}
    local LIMIT=${2}

    require_numeric_value ${ACTUAL_VALUE}

    if [ ${ACTUAL_VALUE} -lt ${LIMIT} ]; then
        require_failed "Variable is too small: ${ACTUAL_VALUE}"
    fi
}


# TODO: Implement. Define what hostname RFC/spec is used.
# function require_valid_hostname {

# }


function require_host_resolvable {
    local HOSTNAME="${1}"
    local HOSTNAME_RESOLVABLE

    HOSTNAME_RESOLVABLE=$(hostname_is_resolvable "${HOSTNAME}")
    if [ ${HOSTNAME_RESOLVABLE} -ne 1 ]; then
        require_failed "Cannot resolve hostname: ${HOSTNAME}"
    fi
}


function require_equal_numeric_value {
    require_parameters_not_empty ${*}

    local ACTUAL_VALUE=${1}
    local EXPECTED_VALUE=${2}

    require_numeric_value ${ACTUAL_VALUE}
    require_numeric_value ${EXPECTED_VALUE}

    if [ ${ACTUAL_VALUE} != ${EXPECTED_VALUE} ]; then
        require_failed "Variable has not expected numeric value: ${ACTUAL_VALUE}"
    fi
}
