
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
