BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


function filter_out_indented_line_start_match
{
    local FILENAME="${1}"
    local COMMENT_STR="${2}"

    cat ${FILENAME} |grep -e ""
}


function filter_active_bash_lines
{
    local FILENAME="${1}"

    cat "${FILENAME}" | sed -e 's/\ *#.*$//g'
}
