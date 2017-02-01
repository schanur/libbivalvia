BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


# Prints a field in a comma separated list, aka CSV. The first
# argument is the field index, the second argument is the CSV line.
function csv_get_field {
    local FIELD_INDEX=$1
    shift
    local LINE=${*}
    local FIELD

    FIELD=$(${LINE} | cut -d ',', -f${INDEX})
    echo ${FIELD}
}
