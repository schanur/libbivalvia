BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


# Prints the content of multible lines of a file $1 starting at line
# $2 and ending at line $3.
function text_at_file_line_no_range {
    local FILENAME=${1}
    local START_LINE=${2}
    local END_LINE_NO=${3}
    local RANGE_LENGTH

    (( RANGE_LENGTH = END_LINE_NO - START_LINE ))
    cat ${FILENAME} | tail -n +${START_LINE} |head -n ${RANGE_LENGTH}
}

# Prints the content of a line of a file.
function text_at_file_line_no {
    local FILENAME=${1}
    local LINE_NO=${2}
    local END_LINE_NO

    (( END_LINE_NO = LINE_NO + 1 ))
    text_at_file_line_no_range ${FILENAME} ${LINE_NO} ${END_LINE_NO}
}
