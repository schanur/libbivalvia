BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/require.sh"


# Prints absolute path of file. If the parameter is a directory, the
# parent directory is printed.
function absolute_path {
    local FILE="${1}"
    local ABS_PATH

    require_exists "${FILE}"

    ABS_PATH="$(dirname $(readlink -f ${FILE}))"

    echo "${ABS_PATH}"
}


# Prints a file with absolute path.
function with_absolute_path {
    local FILE="${1}"
    local BASENAME
    local ABSOLUTE_PATH
    local WITH_ABSOLUTE_PATH

    require_exists "${FILE}"

    BASENAME="$(basename ${FILE})"
    ABSOLUTE_PATH="$(absolute_path ${FILE})"
    WITH_ABSOLUTE_PATH="${ABSOLUTE_PATH}/${BASENAME}"

    echo "${WITH_ABSOLUTE_PATH}"
}


# Print the directory name of the deepest path of the absolute path of
# the first parameter.
#
# Examples:
# "/home/user/local/test => test"
# ". => test" (if pwd is /home/user/local/test)
function deepest_path {
    local RELATIVE_PATH="${1}"
    local ABSOLUTE_PATH
    local DEEPEST_PATH

    ABSOLUTE_PATH="$(with_absolute_path ${RELATIVE_PATH})"
    DEEPEST_PATH="$(basename ${ABSOLUTE_PATH})"

    echo "${DEEPEST_PATH}"
}


## Maybe useful on systems where readlink is not supported or behaves
## differently (Mac OS).
# function with_absolute_path {
#     local ="$1"
#     if [ -d "$path" ]
#     then
#         echo "$(cd "$path" ; pwd)"
#     else
#         local b=$(basename "$path")
#         local p=$(dirname "$path")
#         echo "$(cd "$p" ; pwd)/$b"
#     fi
# }
