BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/path.sh"


# Runs the script with the same parameters as root.
function run_as_root {
    local ABS_BINARY_FILENAME

    if [ "${USER}" != "root" ]; then
        # Absolute path to binary is needed because root user does not
        # have the same PATH variable.
        ABS_BINARY_FILENAME=$(with_absolute_path ${0})
        echo "Root privileges are required.
Please enter root password to continue or CTRL+C to abort."
        su root -l -c "echo && ${ABS_BINARY_FILENAME} ${*}"
        exit
    fi
}
