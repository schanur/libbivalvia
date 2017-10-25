BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/error.sh"
source "${BIVALVIA_PATH}/require.sh"


function files_in_path {
    local SEARCH_PATH="${1}"

    require_directory "${SEARCH_PATH}"
    find "${SEARCH_PATH}" -mindepth 1 -maxdepth 1

    # while IFS= read -r -d '' file
    # do
    #     echo "Playing file no. $count"
    #     play "$file"
    # done <   <(find mydir -mtime -7 -name '*.mp3' -print0)
    # local SEARCH_PATH="$1"
}

function file_basenames_in_path {
    local SEARCH_PATH="${1}"

    require_directory "${SEARCH_PATH}"
    find "${SEARCH_PATH}" -mindepth 1 -maxdepth 1

    # while IFS= read -r -d '' file
    # do
    #     echo "Playing file no. $count"
    #     play "$file"
    # done <   <(find mydir -mtime -7 -name '*.mp3' -print0)
    # local SEARCH_PATH="$1"
}

function files_and_dirs_in_path {
    local SEARCH_PATH="${1}"

    not_implemented_error
}

function files_in_path_recursive {
    local SEARCH_PATH="${1}"

    not_implemented_error
}

function files_and_dirs_in_path_recursive {
    local SEARCH_PATH="${1}"

    not_implemented_error
}
