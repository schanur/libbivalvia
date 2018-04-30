# Module allows to create/check/destroy locks.


source "${BIVALVIA_PATH}/debug.sh"


# Globals
LF__LOCKFILE_LIST=""
LF__AUTO_CLEANUP=1
LF__VERBOSE_AUTO_CLEANUP=1


# If parameter is 1, program tries to delete all remaining lock on
# program exit. This includes different kinds of unexpected or
# erroneous exit conditions. If parameter is 0, no actions are
# undertaken on program exit. Default on program start is auto
# cleanup enabled.
function lf__set_auto_cleanup
{
    local NEW_OPT_VALUE="${1}"

    case "${NEW_OPT_VALUE}" in
        0|1)
            LF__AUTO_CLEANUP=${NEW_OPT_VALUE}
            ;;
        *)
            invalid_parameter_error 1 "${NEW_OPT_VALUE}"
            ;;
    esac
}


# If parameter is 1, for each lockfile that still exists on program
# exit, a short message is written to stdout. On 0, all actions are
# executed silently. Default on program start is no auto cleanup
# verbosity.
function lf__set_auto_cleanup_verbosity
{
    local NEW_OPT_VALUE="${1}"

    case "${NEW_OPT_VALUE}" in
        0|1)
            LF__AUTO_CLEANUP=${NEW_OPT_VALUE}
            ;;
        *)
            invalid_parameter_error 1 "${NEW_OPT_VALUE}"
            ;;
    esac
}


# Prints 1 if lock exists. 0 otherwise.
function lf__lock_exists
{
    local LOCKFILE="${1}"
    local LOCKFILE_EXISTS=0

    if [ -f "${LOCKFILE}" ]; then
        LOCKFILE_EXISTS=1
    fi

    echo -n ${LOCKFILE_EXISTS}
}


# Create a lock with the path of the parameter $1.  Prints 0 on
# success. 1 otherwise.
function lf__lock_create
{
    local ERR
    local LOCKFILE="${1}"

    lockfile -r 0 "${LOCKFILE}"
    ERR=$?
    if [ "${ERR}" != "0" ]; then
        echo -n 1
    else
        LF__LOCKFILE_LIST="${LF__LOCKFILE_LIST} ${LOCKFILE}"
        echo -n 0
    fi
    # If the program crashed for any particular reason, remove all
    # lockfiles.
    # trap "lf__destroy_lockfile_list" INT TERM EXIT
}


# Delete the lockfile with the path/name of the parameter.
# Returns 0 on success or error code on exit.
function lf__lock_destroy
{
    local ERR=1
    local DELETION_FAILED=0

    LOCKFILE_NAME="${1}"
    if [ -f "${LOCKFILE_NAME}" ]; then
        rm -f "${LOCKFILE_NAME}" || DELETION_FAILED=1
        if [ ${DELETION_FAILED} -eq 0 ]; then
            ERR=0
        fi
    fi

    echo ${ERR}
}


function lf__destroy_lockfile_list
{
    local LOCKFILE

    echo "Received signal"
    for LOCKFILE in ${LF__LOCKFILE_LIST}; do
        true
    done
    exit 0
}
