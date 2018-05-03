BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/string.sh"
# source "${BIVALVIA_PATH}/require.sh"


function stack_trace {
    local I

    echo
    echo "Stack trace:"
    for (( I=0; I < 100; I++ )); do
        # FIXME: -v is not very portable.
        if [[ ! -v FUNCNAME[${I}] ]]; then
            break
        fi
        local FUNC=${FUNCNAME[${I}]}
        # local FUNC_PARAMETERS=${BASH_ARGV[${I}]}
        [ "$FUNC" = "" ] && func="MAIN"
        local LINE_NO="${BASH_LINENO[(( I - 1 ))]}"
        local SRC="${BASH_SOURCE[${I}]}"
        [ "$SRC" = "" ] && SRC=NO_FILE_SOURCE

        # echo ${I} ${FUNC} ${SRC} ${LINE_NO} >&2

        (fill_ellipsis_tail   3 ' ' "${I}"         && echo -n " ") >&2
        (fill_ellipsis_tail  30 ' ' "${FUNC}"      && echo -n " ") >&2
        (fill_ellipsis_front 40 ' ' "${SRC}"       && echo -n " ") >&2
        (fill_ellipsis_front  5 ' ' "${LINE_NO}"   && echo       ) >&2

    done
}


function dbg_msg {
    echo "${*}" >&2
}


# Print variable name and value.
#
# Example:
# print_var VAR1
# VAR1: abc
function print_var {
    local VARIABLE_NAME="${1}"
    local INDENTATION_DEPTH

    if [ ${#} -eq 2 ]; then
        INDENTATION_DEPTH=${2}
    else
        (( INDENTATION_DEPTH = ${#VARIABLE_NAME} + 2 ))
    fi

    fill_tail ${INDENTATION_DEPTH} ' ' "${VARIABLE_NAME}:"
    eval "echo \"\${${VARIABLE_NAME}}\""
}


# Print the names and value of all variable names in a proper
# aligned table.
#
# Example:
# print_var_list VAR1 VARIABLE2 ANOTHER_VAR
# VAR1:        abc
# VARIABLE2:   def
# ANOTHER_VAR: geh 123
function print_var_list {
    local VARIABLE_NAME_LIST=${*}
    local MAXIMUM_VARIABLE_NAME_LENGTH=$(longest_string_length ${VARIABLE_NAME_LIST})
    local VARIABLE_NAME

    (( MAXIMUM_VARIABLE_NAME_LENGTH += 2 )) # ": " at end.

    for VARIABLE_NAME in ${VARIABLE_NAME_LIST}; do
        print_var ${VARIABLE_NAME} ${MAXIMUM_VARIABLE_NAME_LENGTH}
    done
}
