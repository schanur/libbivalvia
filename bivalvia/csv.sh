BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


# Very simple CSV module. It currently does not support encapsulation
# of fields (for example: "a","b","c").



# Prints a field in a comma separated list, aka CSV. The first
# argument is the field index, the second argument is the CSV line.
function csv_get_field {
    local FIELD_INDEX=${1}
    local FIELD_VALUE
    shift
    local CSV_LINE=${*}

    FIELD_VALUE=$(echo ${CSV_LINE} | cut -d ',' -f ${FIELD_INDEX})
    echo ${FIELD_VALUE}
}

function csv_field_count {
    local CSV_LINE=${*}
    local FIELD_COUNT=0

    echo "${CSV_LINE}" | sed -e 's/,/\n/g' | wc -l
}

function csv_field_exists {
    local FIELD_STR="${1}"
    local FIELD_EXISTS=0
    shift
    local CSV_LINE=${*}

    if [ $(echo "${CSV_LINE}" | sed -e 's/,/\n/g' | egrep -c "^${FIELD_STR}\$" || true) -ne 0 ]; then
        FIELD_EXISTS=1
    fi

    echo ${FIELD_EXISTS}
}

function csv_push_back {
    local NEW_FIELD="${1}"
    shift
    local CSV_LINE=${*}

    echo "${CSV_LINE},${NEW_FIELD}"
}
