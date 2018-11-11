BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


function is_number {
    local VARIABLE="${1}"
    local IS_NUMBER=1

    case ${VARIABLE} in
        ''|*[!0-9]*)
            IS_NUMBER=0
            ;;
    esac

    echo ${IS_NUMBER}
}


# Examples:
# 1 2 -> 50
function fraction_to_percentage {
    local NOMINATOR=${1}
    local DENOMINATOR=${2}
    local PERCENTAGE

    if [ ${DENOMINATOR} -eq 0 ]; then
        PERCENTAGE=100
    else
        (( PERCENTAGE = (NOMINATOR * 100) / DENOMINATOR ))
    fi

    echo -n ${PERCENTAGE}
}


# Examples:
# 0      -> 0
# 0.0    -> 0
# 0.1    -> 10
# 2.9111 -> 291.11
function decimal_fraction_to_percentage {
    local DECIMAL_FRACTION="${1}"

    # Remove trailing zeroes in the fractional part.
    # TODO: Make sed call recursive (and less redundant).
    echo "${DECIMAL_FRACTION} * 100" | bc \
        | sed -e 's/\.0*$//g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g'
}


# Convert percentage to decimal fraction. Input strings with trailing
# % characters are allowed.
# Examples:
# 0      -> 0
# 50     -> 0.5
# 100    -> 1
# 60%    -> 0.6
# 70 %   -> 0.7
# 12.1 % -> 0.121
function percentage_to_decimal_fraction {
    local PERCENTAGE="${1}"
    local PERCENTAGE_NUMBER
    # local DECIMAL_FRACTION

    PERCENTAGE_NUMBER="$(echo "${PERCENTAGE}" | sed -e 's/\ *%$//g')"
    # echo ${PERCENTAGE_NUMBER} >&2

    # TODO: Make sed call recursive (and less redundant).
    echo "${PERCENTAGE_NUMBER} * 0.01000000" | bc \
        | sed -e 's/^\./0\./g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/^\([0-9]*\.[0-9]*\)0/\1/g' \
              -e 's/\.$//g'
}


# "1 3" => "2"
# "3 1" => "2"
function numeric_diff {
    local A=${1}
    local B=${2}
    local DIFF

    if [ ${A} -le ${B} ]; then
        (( DIFF = B - A ))
    else
        (( DIFF = A - B ))
    fi

    echo ${DIFF}
}
