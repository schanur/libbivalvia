BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

# source "${BIVALVIA_PATH}/csv.sh"
# source "${BIVALVIA_PATH}/error.sh"
# source "${BIVALVIA_PATH}/require.sh"


# A filesystem backed key value store where keys are the filenames and
# the value is stored in the file.  You can provide a path name
# yourself to allow persistent object store or create a volatile
# object store in memory which lives under '/dev/shm/'.
#
# We do not hash the keys. So depending on your filesystem some
# characters are not allowed as keys. At least '/' is forbidden. On
# some filesystems there are maybe more characters that are not
# allowed as filenames. On some filesystems you are maybe not even
# case sensitive (Mac OS X?).


# Create a volatile object store in memory and print the path where
# the object store is created. Volatile object stores live under
# /dev/shm/$USERNAME/$OBJECT_STORE_NAME/
#
# Parameters: 1. Object store name
#
#
function object_store__create_volatile {
    local OBJECT_STORE_NAME="${1}"
    local OBJECT_STORE_PATH="/dev/shm/$(whoami)/${STORE_NAME}"
}


function object_store__clear {
    true
}


function object_store__destroy {
    true
}
