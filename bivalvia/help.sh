BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/io.sh"


declare -a GL_SECTION_POS_START
declare -a GL_SECTION_POS_END
GL_SECTION_CNT=0
PARSED=0


function clear_section_positions {
    local I

    for (( I=1 ; I<=5 ; I++ )); do
        GL_SECTION_POS_START[${I}]=0
        GL_SECTION_POS_END[${I}]=0
    done
}

function parse_section_positions {
    if [ ${PARSED} = "1" ]; then
        return
    fi
    local SCRIPT_NAME="${1}"
    local EMPTY_LINE
    local IN_SECTION=0
    local LINE_NO=1

    clear_section_positions
    while read LINE; do
        if   [ ${#LINE}      -eq  0  ]; then EMPTY_LINE=1 # Line containing only a newline is interpreted as empty line.
        elif [ "${LINE:0:1}" =   " " ]; then EMPTY_LINE=1 # Line that starts with a space character is also interpreted as empty line.
        elif [ "${LINE:0:1}" =   "#" ]; then EMPTY_LINE=0 # Character of text section to parse.
        elif [ ${IN_SECTION} -eq  1  ]; then echo "parse_section_positions: Parse error in line ${LINE_NO}. Abort"; exit 1
        else break # First script command. Stop section parsing.
        fi
        if [ ${EMPTY_LINE} -eq 1 ]; then
            if [ ${IN_SECTION} -eq 1 ]; then IN_SECTION=0 # Last section got closed.
            else true # Another empty line. Do nothing
            fi
        else
            if [ ${IN_SECTION} -eq 1 ]; then GL_SECTION_POS_END[${GL_SECTION_CNT}]=${LINE_NO} # Current section is at least one line longer.
            else
                # New section started.
                IN_SECTION=1
                (( GL_SECTION_CNT+=1 ))
                GL_SECTION_POS_START[${GL_SECTION_CNT}]=${LINE_NO}
                GL_SECTION_POS_END[${GL_SECTION_CNT}]=${LINE_NO}
            fi
        fi
        (( LINE_NO++ ))
    done <"${SCRIPT_NAME}"
    if [ ${IN_SECTION} -eq 1 ]; then echo "parse_section_positions: Parse error in line ${LINE_NO}. Still in section. Abort"; exit 1
    fi
    PARSED=1
    # print_section_positions # FIXME: Remove
}

function print_section_positions {
    local I

    for (( I=1 ; I<=5 ; I++ )); do
        echo "${I}: ${GL_SECTION_POS_START[${I}]} ${GL_SECTION_POS_END[${I}]}"
    done
}

# Print the text of a section of a script. The first parameter is the
# script filename. The second one is the section number.
# Currently allowed section numbers:
# 1) Shebang
# 2) Short description
# 3) Long description
# 4) Usage
function print_section {
    local SCRIPT_NAME="${1}"
    local SECTION_NUMBER=${2}
    local SECTION_LENGTH=$(expr ${GL_SECTION_POS_END[${SECTION_NUMBER}]} - ${GL_SECTION_POS_START[${SECTION_NUMBER}]} + 1)

    cat "${SCRIPT_NAME}" | tail -n +${GL_SECTION_POS_START[${SECTION_NUMBER}]} | head -n ${SECTION_LENGTH} | sed -e 's/^#\ //g' | sed -e 's/^#//g'
}


function shebang {
    local SCRIPT_FILENAME="${1}"

    parse_section_positions "${SCRIPT_FILENAME}"
    print_section           "${SCRIPT_FILENAME}" 1
}

function short_description {
    local SCRIPT_FILENAME="${1}"

    parse_section_positions "${SCRIPT_FILENAME}"
    print_section           "${SCRIPT_FILENAME}" 2
}

function long_description {
    local SCRIPT_FILENAME="${1}"

    parse_section_positions "${SCRIPT_FILENAME}"
    print_section           "${SCRIPT_FILENAME}" 3
}

function usage {
    local SCRIPT_FILENAME=${1}

    parse_section_positions "${SCRIPT_FILENAME}"
    print_section           "${SCRIPT_FILENAME}" 4
}

function has_short_description {
    local SECTION_EXISTS=0
    if [ ${GL_SECTION_CNT} -ge 2 ]; then
        SECTION_EXISTS=1
    fi

    echo ${SECTION_EXISTS}
}

function has_long_description {
    local SECTION_EXISTS=0
    if [ ${GL_SECTION_CNT} -ge 3 ]; then
        SECTION_EXISTS=1
    fi

    echo ${SECTION_EXISTS}
}

function has_usage {
    local SECTION_EXISTS=0
    if [ ${GL_SECTION_CNT} -ge 4 ]; then
        SECTION_EXISTS=1
    fi

    echo ${SECTION_EXISTS}
}

# Print the help section of a script, consisting of the script name,
# the short description and the long description.
function help {
    parse_section_positions "${SCRIPT_FILENAME}"
    if [ $(has_short_description) = "1" ]; then
        short_description "${SCRIPT_FILENAME}"
        echo
    fi
    if [ $(has_long_description) = "1" ]; then
        long_description "${SCRIPT_FILENAME}"
        echo
    fi
    if [ $(has_usage) = "1" ]; then
        usage ${SCRIPT_FILENAME}
        echo
    fi
}

# If the first parameter is "--help" or "-h", print the help to stdout
# and exit without error.
function parse_help_parameter {
    if [ ${#} -eq 1 ]; then
        case ${1} in
            '--help'|'-h'|'help')
                help
                exit 0
                ;;
        esac
    fi
}

# The script was called with a wrong number of arguments or the
# arguments cannot be parsed. We print the help section of the script
# and exit with error code 64.
function invalid_parameter_exit {
    help
    echo
    echo "Error: Invalid parameters."
    echo
    if [ ${#} -ne 0 ]; then
        echo "$*"
        echo
    fi
    echo "Abort!"

    # The proper exit code is defined in "sysexits.h"
    #define EX_USAGE        64      /* command line usage error */
    exit 64
}

parse_help_parameter "${@}"
