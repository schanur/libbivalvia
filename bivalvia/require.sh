BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


source ${BIVALVIA_PATH}/debug.sh
source ${BIVALVIA_PATH}/numerical.sh

function require_failed {
    echo "Abort!" >&2
    stack_trace
    exit 1
}

function require_parameters_not_empty {
    ALL_PARAMETERS=${*}

    if [ "${ALL_PARAMETERS}" = "" ]; then
        echo "Parameters are empty." >&2
        require_failed
    fi
}

# Check if the binary/script filename exists in a path specified in the PATH variable. If no match is found, an error message is printed to stderr and the script terminates with an error.
function require_executable {
    require_parameters_not_empty ${*}

    local EXECUTABLE_NAME=${1}
    local EXECUTABLE_FOUND=1

    which ${EXECUTABLE_NAME} > /dev/null 2>/dev/null || EXECUTABLE_FOUND=0
    if [ ${EXECUTABLE_FOUND} -ne 1 ]; then
        echo "${EXECUTABLE_NAME} not found." >&2
        require_failed
    fi
}

function require_exists {
    require_parameters_not_empty ${*}

    local FILENAME=${1}

    if [ ! -e ${FILENAME} ]; then
        echo "File not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_file {
    require_parameters_not_empty ${*}

    local FILENAME=${1}

    if [ ! -f ${FILENAME} ]; then
        echo "File not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_directory {
    require_parameters_not_empty ${*}

    local FILENAME=${1}

    if [ ! -d ${FILENAME} ]; then
        echo "Directory not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_file_or_directory {
    require_parameters_not_empty ${*}

    local FILENAME=${1}

    if [[ ! -f ${FILENAME} && ! -d ${FILENAME} ]]; then
        echo "File not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_sybolic_link {
    require_parameters_not_empty ${*}

    local LINK_NAME=${1}

    if [ ! -h ${LINK_NAME} ]; then
        echo "Symbolic link not found: ${LINK_NAME}" >&2
        require_failed
    fi
}

function require_block_special {
    require_parameters_not_empty ${*}

    local BLOCK_FILENAME=${1}

    if [ ! -b ${BLOCK_FILENAME} ]; then
        echo "Block special: ${BLOCK_FILENAME}" >&2
        require_failed
    fi
}

function require_variable {
    require_parameters_not_empty ${*}

    local VARIABLE_NAME=${1}

    if [ ! -v ${VARIABLE_NAME} ]; then
        echo "Variable not set: ${LINK_NAME}" >&2
        require_failed
    fi
}

function require_numeric_value {
    require_parameters_not_empty ${*}

    local VARIABLE=${1}

    if [ $(is_number ${VARIABLE}) -ne 1 ]; then
        echo "Variable is no numeric value: ${VARIABLE}" >&2
        require_failed
    fi
}

function require_larger_equal {
    require_parameters_not_empty ${*}

    local ACTUAL_VALUE=${1}
    local LIMIT=${2}

    require_numeric_value ${ACTUAL_VALUE}

    if [ ${ACTUAL_VALUE} -lt ${LIMIT} ]; then
        echo "Variable is too small: ${ACTUAL_VALUE}" >&2
        require_failed
    fi
}

function require_equal_numeric_value {
    require_parameters_not_empty ${*}

    local ACTUAL_VALUE=${1}
    local EXPECTED_VALUE=${2}

    require_numeric_value ${ACTUAL_VALUE}
    require_numeric_value ${EXPECTED_VALUE}

    if [ ${ACTUAL_VALUE} != ${EXPECTED_VALUE} ]; then
        echo "Variable has not expected numeric value: ${LINK_NAME}" >&2
        require_failed
    fi
}
