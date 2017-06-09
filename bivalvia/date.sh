BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


# Prints a number only timestamp in the format YYYYMMDDhhmmss.
function timestamp {
    date --rfc-3339=seconds |sed -e 's/[-\ :]//g' |sed -e 's/\+.*$//g'
}

function sec_since_epoch {
    date +%s
}

function ms_since_epoch {
    date +%s%N | cut -b1-13
}

function ns_since_epoch {
    date +%s%N
}
