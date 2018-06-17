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


# Prints the block device /dev/sdX of the disk drive or partition
# where the file is located. Both directories and regular files are
# allowed. Only the first step gets resolved. If the result is a
# loopback device it does not get resolved to the corresponding block
# device or file behind that.
function filename_to_block_device {
    local FILENAME="${1}"

    df "${FILENAME}" | tail -n 1 | tr -s " " | cut -f 1 -d " "
}
