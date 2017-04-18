
# Returns the number of lines in the file $1 that are an exact match
# of the string $2. That means there are no characters in front of or
# behind the string.
function exact_string_match_count_in_file {
    local FILENAME=${1}
    local SEARCH_STR=${2}
    local MATCH_CNT

    MATCH_CNT=$(cat "${FILENAME}" | egrep -c "^${SEARCH_STR}\$")

    echo ${MATCH_CNT}
}
