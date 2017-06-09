BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


# Do not include debug.sh here!

# source ${BIVALVIA_PATH}/require.sh


# "a bcd ef" => "3"
function longest_string_length {
    local STR_LIST="${*}"
    local MAX_STR_LENGTH=0

    for STR in ${STR_LIST}; do
        if [ ${#STR} -ge ${MAX_STR_LENGTH} ]; then
            MAX_STR_LENGTH=${#STR}
        fi
    done

    echo ${MAX_STR_LENGTH}
}

function fill_tail {
    local LENGTH=${1}
    local FILL_CHARACTER=${2}
    shift; shift
    local STRING="${@}"
    local FILL_CHARACTER_COUNT

    (( FILL_CHARACTER_COUNT=${LENGTH}-${#STRING} ))
    for I in $(seq 1 ${FILL_CHARACTER_COUNT}); do
        STRING="${STRING}${FILL_CHARACTER}"
    done

    echo -n "${STRING}"
}

function fill_front {
    local LENGTH=${1}
    local FILL_CHARACTER=${2}
    shift; shift
    local STRING="${@}"
    local FILL_CHARACTER_COUNT

    (( FILL_CHARACTER_COUNT=${LENGTH}-${#STRING} ))
    for I in $(seq 1 ${FILL_CHARACTER_COUNT}); do
        STRING="${FILL_CHARACTER}${STRING}"
    done

    echo -n "${STRING}"
}

function fill_ellipsis_tail {
    local FILL_LENGTH=${1}
    shift
    local STRING="$(echo -n ${@} | head -n 1)"
    local STR_LENGTH=${#STRING}

    if [ ${STR_LENGTH} -le ${FILL_LENGTH} ]; then
        fill_tail ${FILL_LENGTH} ' ' "${STRING}"
    else
        local CHARS_TO_PRINT
        (( CHARS_TO_PRINT = FILL_LENGTH - 3 ))
        echo -n "${STRING:0:${CHARS_TO_PRINT}}..."
    fi
}

function fill_ellipsis_front {
    local FILL_LENGTH=${1}
    shift
    local STRING="$(echo -n ${@} | head -n 1)"
    local STR_LENGTH=${#STRING}

    if [ ${STR_LENGTH} -le ${FILL_LENGTH} ]; then
        fill_front ${FILL_LENGTH} ' ' "${STRING}"
    else
        local CHARS_TO_PRINT
        local SUB_STRING
        (( CHARS_TO_PRINT = FILL_LENGTH - 3 ))
        if [ ${CHARS_TO_PRINT} -eq 0 ]; then
            echo -n "..."
        else
            echo -n "...${STRING: -${CHARS_TO_PRINT}}"
        fi
    fi
}
