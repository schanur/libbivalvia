BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/debug.sh"


function critical_error
{
    local ERR_MSG=${*}

    stack_trace
    echo
    echo "Error:"
    echo ${ERR_MSG}
    exit 1
}


function invalid_parameter_error
{
    local PARAMETER_NO="${1}"
    local PARAMETER_VALUE="${2}"

    critical_error "Invalid parameter ${PARAMETER_NO}: ${PARAMETER_VALUE}"
}


function not_implemented_error
{
    critical_error "Not implemented"
}
