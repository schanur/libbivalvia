BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


function is_number {
    local IS_NUMBER=0

    case ${VARIABLE} in
        ''|*[!0-9]*)
            IS_NUMBER=1
            ;;
    esac

    echo ${IS_NUMBER}
}

function fraction_to_percentage {
    local NOMINATOR=${1}
    local DENOMINATOR=${2}
    local PERCENTAGE

    (( PERCENTAGE = (NOMINATOR * 100) / DENOMINATOR ))

    echo ${PERCENTAGE}
}

# "1 3" => "3"
# "3 1" => "3"
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
