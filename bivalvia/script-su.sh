BIVALVIA_PATH="$(dirname $BASH_SOURCE)"

# Runs the script with the same parameters as root.
function run_as_root {
    if [ "${USER}" != "root" ]; then
        echo "Root privileges are required.
Please enter root password to continue or CTRL+C to abort."
        su root -c "echo && ${0} ${*}"
        exit
    fi
}
