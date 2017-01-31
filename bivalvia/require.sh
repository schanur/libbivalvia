BIVALVIA_PATH="${0}"


source ${BIVALVIA_PATH}/debug.sh
source ${BIVALVIA_PATH}/numerical.sh

function require_failed {
    echo "Abort!" >&2
    stack_trace
    exit 1
}

# Check if the binary/script filename exists in a path specified in the PATH variable. If no match is found, an error message is printed to stderr and the script terminates with an error.
function require_executable {
    local EXECUTABLE_NAME=${1}
    local EXECUTABLE_FOUND=1

    which ${EXECUTABLE_NAME} > /dev/null 2>/dev/null || EXECUTABLE_FOUND=0
    if [ ${EXECUTABLE_FOUND} -ne 1 ]; then
        echo "${EXECUTABLE_NAME} not found. Abort!" >&2
        require_failed
    fi
}

function require_exists {
    local FILENAME=${1}

    if [ ! -e ${FILENAME} ]; then
        echo "File not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_file {
    local FILENAME=${1}

    if [ ! -f ${FILENAME} ]; then
        echo "File not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_directory {
    local FILENAME=${1}

    if [ ! -d ${FILENAME} ]; then
        echo "Directory not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_file_or_directory {
    local FILENAME=${1}

    if [[ ! -f ${FILENAME} && ! -d ${FILENAME} ]]; then
        echo "File not found: ${FILENAME}" >&2
        require_failed
    fi
}

function require_sybolic_link {
    local LINK_NAME=${1}

    if [ ! -h ${LINK_NAME} ]; then
        echo "Symbolic link not found: ${LINK_NAME}" >&2
        require_failed
    fi
}

function require_block_special {
    local BLOCK_FILENAME=${1}

    if [ ! -b ${BLOCK_FILENAME} ]; then
        echo "Block special: ${BLOCK_FILENAME}" >&2
        require_failed
    fi
}

function require_variable {
    local VARIABLE_NAME=${1}

    if [ ! -v ${LINK_NAME} ]; then
        echo "Variable not set: ${LINK_NAME}" >&2
        require_failed
    fi
}

function require_numeric_value {
    local VARIABLE=${1}

    if [ $(is_number ${VARIABLE}) -ne 1 ]; then
        echo "Variable is no numeric value: ${VARIABLE}" >&2
        require_failed
    fi
}

function require_equal_numeric_value {
    local ACTUAL_VALUE=${1}
    local EXPECTED_VALUE=${2}

    require_numeric_value ${ACTUAL_VALUE}
    require_numeric_value ${EXPECTED_VALUE}

    if [ ${ACTUAL_VALUE} != ${EXPECTED_VALUE} ]; then
        echo "Variable has not expected numeric value: ${LINK_NAME}" >&2
        require_failed
    fi
}
