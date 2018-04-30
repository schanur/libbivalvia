BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/message.sh"


function uuid_to_dev_filename {
    local UUID="${1}"
    local DEVICE_FILENAME="/dev/disk/by-uuid/${UUID}"

    echo "${DEVICE_FILENAME}"
}

function uuid_to_open_luks_dev_filename {
    local UUID="${1}"
    local DEVICE_FILENAME="/dev/disk/by-uuid/${UUID}"

    echo "${DEVICE_FILENAME}"
}


# Open LUKS encryption of a block device (given by UUID) and mount it
# with udisksctl.
function mount_luks_dev_by_key_file {
    true
}

# Unmount a block device (by UUID) and close the LUKS device.
function unmount_luks_dev {
    true
}
