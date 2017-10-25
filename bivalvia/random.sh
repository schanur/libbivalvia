BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/error.sh"


# Valid input is 1, 2, 4, 8.
function random_n_byte_decimal {
    local BYTES=${1}
    od -v -An -N${BYTES} -tu${BYTES} < /dev/urandom
}

function random_8_bit_decimal {
    random_n_byte_decimal 1
}

function random_16_bit_decimal {
    random_n_byte_decimal 2
}

function random_32_bit_decimal {
    random_n_byte_decimal 4
}

function random_64_bit_decimal {
    random_n_byte_decimal 8
}

function random {
    local RAND_MAX=$1
    local SOURCE_RAND_MAX=$(( (2 ** 32) - 1 ))
    local DIVISOR=$(( SOURCE_RAND_MAX / RAND_MAX ))
    local VALID_RANGE=$(( RAND_MAX * DIVISOR ))
    local VALID_RANGE_RANDOM_NUMBER
    local DIVIDED_RANDOM_NUMBER

    while [ 1 ]; do
        VALID_RANGE_RANDOM_NUMBER=$(random_32_bit_decimal)
        if [ ${VALID_RANGE_RANDOM_NUMBER} -le ${VALID_RANGE} ]; then
            break;
        fi
    done

    DIVIDED_RANDOM_NUMBER=$(( VALID_RANGE_RANDOM_NUMBER / DIVISOR ))

    echo ${DIVIDED_RANDOM_NUMBER}
}

function random_file_from_path {
    local SEARCH_PATH="${1}"

    find "${SEARCH_PATH}" -maxdepth 1 ! -type d | shuf -n 1
}

function random_file_from_path_recursive {
    local SEARCH_PATH="${1}"

    find "${SEARCH_PATH}" ! -type d | shuf -n 1
}
