
source ${DOTFILES_PATH}/lib/bash/debug.sh


function critical_error {
    local ERR_MSG=${*}

    stack_trace
    echo
    echo "Error:"
    echo ${ERR_MSG}
    exit 1
}

function not_implemented_error {
    critical_error "Not implemented"
}
