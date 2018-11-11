BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


function terminal_width {
    local DIM=$(stty size)

    echo ${DIM#* }
}

function terminal_height {
    local DIM=$(stty size)

    echo ${DIM% *}
}
