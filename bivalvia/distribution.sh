BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/require.sh"


function distribution_pretty_name {
    cat /etc/os-release | grep -e "^PRETTY_NAME=" | cut -f 2 -d "=" | cut -f 2 -d '"'
}

function distribution_name {
    cat /etc/os-release | grep -e "^NAME="        | cut -f 2 -d "=" | cut -f 2 -d '"'
}

function distribution_id {
    cat /etc/os-release | grep -e "^ID="          | cut -f 2 -d "=" | cut -f 2 -d '"'
}
