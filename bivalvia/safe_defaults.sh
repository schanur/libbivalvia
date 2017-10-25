# Sets stricter language handling (exit on error, exit on unset
# variables, exit on pipe error and exit on sigint) and give a strack
# trace on each of these events.

BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/debug.sh"


function default_exit_trap {
    set +xv
    echo "EXIT received."
    stack_trace
}

function default_sigint_trap {
    echo "SIGINT received."
    stack_trace
    exit 1
}

function default_sigterm_trap {
    echo "SIGTERM received."
    stack_trace
    exit 1
}

function default_sigpipe_trap {
    echo "SIGPIPE received."
    stack_trace
    exit 1
}

function default_err_trap {
    echo "ERR received."
    stack_trace
    exit 1
}

function default_nounset_trap {
    echo "NOUNSET received."
    stack_trace
    exit 1
}


set -o errexit -o nounset -o pipefail


# trap "default_exit_trap"    EXIT
trap "default_sigint_trap"  SIGINT
trap "default_sigterm_trap" SIGTERM
trap "default_sigpipe_trap" SIGPIPE
trap "default_err_trap"     ERR
# trap "default_nounset_trap" NOUNSET
