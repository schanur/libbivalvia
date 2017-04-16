BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


source ${BIVALVIA_PATH}/error.sh


# Returns the number of times the string was found in the file given
# by parameter 1.
function file__count_str_match {
    local FILENAME=${1}
    local SEARCH_STR=${2}
    local MATCH_CNT;

    if [ -r "${FILENAME}" ]; then
        MATCH_CNT="$(cat ${FILENAME} |grep -c ${SEARCH_STR})"
        echo ${MATCH_CNT}
    else
        echo "File does not exist. Abort!"
        exit 1
    fi

    echo ${NUM_CNT}
}

function file__replace_first_match {
    not_implemented_error
}

function file__replace_all_matches_in_file {
    not_implemented_error
}
