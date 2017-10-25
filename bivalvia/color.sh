declare -A COLOR_TABLE


COLOR_TABLE['red']=31
COLOR_TABLE['green']=32
COLOR_TABLE['yellow']=33
COLOR_TABLE['blue']=34
COLOR_TABLE['magenta']=35
COLOR_TABLE['cyan']=36
COLOR_TABLE['white']=37
COLOR_TABLE['color_reset']=0


function color_name_to_color_code {
    local COLOR_NAME="${1}"

    echo ${COLOR_TABLE["${COLOR_NAME}"]}
}

function color_escape_sequence {
    local COLOR_NAME="${1}"

    echo -ne "\033[$(color_name_to_color_code ${COLOR_NAME})m"
}

function with_color {
    local COLOR_NAME="${1}"
    shift
    local STR="$@"

    color_escape_sequence "${COLOR_NAME}"
    echo -n "${STR}"
    color_escape_sequence color_reset
}
