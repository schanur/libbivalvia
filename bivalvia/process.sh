BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

# Returns a newline separated list of child PIDs. Returns empty string
# if process have no child process.
function child_pid {
    local PID=${1}

    ps --ppid ${PID} | tail -n +2 | grep -v "${$}" | cut -f 1 -d ' '
}


function pid_to_command {
    local PID=${1}

    ps x | tr -s -s ' ' |egrep "^${PID} " | cut -f 5-1000 -d ' '
}
