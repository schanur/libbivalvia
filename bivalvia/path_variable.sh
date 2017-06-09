BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


source ${BIVALVIA_PATH}/debug.sh


# Returns 1 if the file given as parameter sets the PATH variable. 0
# otherwise.
function file_sets_path_variable {
    FILENAME=${1}

    if [ -r "${FILENAME}" ]; then
        stack_trace
    else
        echo "File does not exist. Abort!"
        exit 1
    fi
}

# Checks if the $SHELL.rc file sets a PATH contains a directory.
# Parameter:
#   1) $SHELL.rc file name.
#   2) Path to look for.
# Returns 1 if PATH variable contains the specified path. 0
# otherwise.
function path_variable_contains_scripts_path {
    local SHELL_RC_FILE=${1}
    local CONTAINS_PATH=0

    # We have 3 possible cases:
    #   1) We found the path variable once.
    #      -> We ar
    if [  ]; then
        true
    fi

    return ${CONTAINS_PATH}
}
