BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


# Prints a field in a comma separated list, aka CSV. The first
# argument is the field index, the second argument is the CSV line.
function csv_get_field {
    local FIELD_INDEX=${1}
    local FIELD_VALUE
    shift
    local LINE=${*}

    FIELD_VALUE=$(echo ${LINE} | cut -d ',' -f ${FIELD_INDEX})
    echo ${FIELD_VALUE}
}
