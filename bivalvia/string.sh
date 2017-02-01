BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


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
    local STRING=${1}
    local LENGTH=${2}
    local FILL_CHARACTER=${3}
    local FILL_CHARACTER_COUNT

    (( FILL_CHARACTER_COUNT=${LENGTH}-${#STRING} ))
    # echo ${FILL_CHARACTER_COUNT}
    for I in $(seq 1 ${FILL_CHARACTER_COUNT}); do
        STRING="${STRING}${FILL_CHARACTER}"
    done

    echo "${STRING}"
}
