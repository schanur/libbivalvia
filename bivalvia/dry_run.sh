BIVALVIA_PATH="$(dirname $BASH_SOURCE)"


DRY_RUN="0"

function run_or_simulate {
    local COMMAND="${*}"
    if [ ${DRY_RUN} != "0" ]; then
        echo "dry run: ${COMMAND}"
    else
        ${COMMAND}
    fi
}
