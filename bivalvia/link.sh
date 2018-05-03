BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/date.sh"
source "${BIVALVIA_PATH}/require.sh"
source "${BIVALVIA_PATH}/path.sh"


function ln_support_relative_linking {
    (ln --help |grep "\-r" || true) |wc -l
}


# Print link target to stdout.
function link_target {
    local LINK_NAME="${1}"

    require_sybolic_link "${LINK_NAME}"

    ls -la "${LINK_NAME}" |sed -e 's/.*\ ->\ //g'
}


# Returns the absolute path/filename of a link target. This works no
# matter the link target is already absolute or relative to the path
# of the link.
function absolute_link_target {
    readlink -f "${1}"
}
# function absolute_link_target {
#     local LINK_NAME=${1}
#     local LINK_TARGET
#     local ABS_LINK_TARGET

#     require_sybolic_link ${LINK_NAME}


#     LINK_TARGET=$(link_target ${LINK_NAME})
#     ABS_LINK_TARGET=${LINK_TARGET}
#     if [ ${LINK_TARGET:0:1} != "/" ]; then
#         ABS_LINK_TARGET="$(with_absolute_path ${LINK_NAME})"
# #        ABS_LINK_TARGET="$(with_absolute_path ${LINK_NAME})"
# # "/${ABS_LINK_TARGET}"
#     fi

#     echo ${ABS_LINK_TARGET}
# }


# Prints "1" if the symbolic link ($1) targets the file/directory
# ($2). "0" otherwise.
function links_to_target {
    local EXPECTED_LINK_TARGET="${1}"
    local LINK_NAME="${2}"
    local ABSOLUTE_EXPECTED_LINK_TARGET
    local RESOLVED_LINK_TARGET
    local ABSOLUTE_RESOLVED_LINK_TARGET
    local FUNCTION_LINKS_TO_TARGET=0

    require_sybolic_link "${LINK_NAME}"

    # absolute_link_target "${LINK_NAME}"
    ABSOLUTE_EXPECTED_LINK_TARGET="$(with_absolute_path ${EXPECTED_LINK_TARGET})"
    RESOLVED_LINK_TARGET="$(absolute_link_target ${LINK_NAME})"
    # echo
    # echo "0 PWD:                  $(pwd)"
    ABSOLUTE_RESOLVED_LINK_TARGET="$(realpath "${RESOLVED_LINK_TARGET}")"
    if [ "${ABSOLUTE_RESOLVED_LINK_TARGET}" = "${ABSOLUTE_EXPECTED_LINK_TARGET}" ]; then
        FUNCTION_LINKS_TO_TARGET=1
    fi
    # echo "1 LINK_NAME:                       ${LINK_NAME}"                     >&2
    # echo "2 EXPECTED_LINK_TARGET:            ${EXPECTED_LINK_TARGET}"          >&2
    # echo "3 ABSOLUTE_EXPECTED_LINK_TARGET:   ${ABSOLUTE_EXPECTED_LINK_TARGET}" >&2
    # echo "4 RESOLVED_LINK_TARGET:            ${RESOLVED_LINK_TARGET}"          >&2
    # echo "5 ABSOLUTE_RESOLVED_LINK_TARGET:   ${ABSOLUTE_RESOLVED_LINK_TARGET}" >&2
    echo ${FUNCTION_LINKS_TO_TARGET}
}


function create_link {
    local LINK_TARGET="${1}"
    local LINK_NAME="${2}"
    local CMD

    CMD="ln -s ${GL_RELATIVE_LINKING_SWITCH} ${LINK_TARGET} ${LINK_NAME}"
    echo "${CMD}"
    ${CMD}
}


# If file or directory with "${LINK_NAME}" exists, rename it to
# "${LINK_NAME}.dotfiles_backup". Create a symbolic link with the name
# "${LINK_NAME}" targeting ""{LINK_TARGET}" afterwards.
function backup_config_and_create_link {
    local LINK_TARGET="${1}"
    local LINK_NAME="${2}"
    local LINK_NAME_BASE_PATH="$(dirname "${LINK_NAME}")"
    local BACKUP_NAME="${LINK_NAME}.dotfiles_backup.$(timestamp)"
    local BACKUP_OLD_FILE=0
    local CREATE_LINK=0


    if [ -L "${LINK_NAME}" ]; then
        echo "Link filename already exists: ${LINK_NAME}"
        echo "Is symbolic link"
        require_file_or_directory "${LINK_TARGET}"

        FUNCTION_LINKS_TO_TARGET=$(links_to_target "${LINK_TARGET}" "${LINK_NAME}")
        if [ "${FUNCTION_LINKS_TO_TARGET}" = "1" ]; then
            echo "Ignore ${LINK_NAME}. Already links to the desired destination."
        else
            echo "Link exists but targets the wrong file."
            CREATE_LINK=1
            BACKUP_OLD_FILE=1
        fi
    fi

    if [ -e "${LINK_NAME}" -a ! -L "${LINK_NAME}" ]; then
            echo "Found original config."
            CREATE_LINK=1
            BACKUP_OLD_FILE=1
    fi

    if [ ! -e "${LINK_NAME}" -a ! -L "${LINK_NAME}" ]; then
            echo "Found no config at all. Create new link without creating backup."
            CREATE_LINK=1
    fi

    if [ "${BACKUP_OLD_FILE}" = "1" ]; then
        echo "Backup: ${LINK_NAME} -> ${BACKUP_NAME}"
        mv "${LINK_NAME}" "${BACKUP_NAME}"
    fi
    if [ ${CREATE_LINK} = "1" ]; then
        if [ ! -d "${LINK_NAME_BASE_PATH}" ]; then
            echo "Link source base path does not exist. Create directory: ${LINK_NAME_BASE_PATH}"
            mkdir -p "${LINK_NAME_BASE_PATH}"
        fi
        echo "Create link."
        create_link "${LINK_TARGET}" "${LINK_NAME}"
    fi
}


# Does the same as "backup_config_and_create_link" but interpret
# "§{LINK_TARGET}" relative to dotfiles repository and ${LINK_NAME}
# relative to the home directory of the user runncing the script.
function backup_user_config_and_create_dotfiles_link {
    local LINK_TARGET="${1}"
    local LINK_NAME="${2}"
    local ABSOLUTE_LINK_TARGET="${LINK_TARGET}"
    local ABSOLUTE_LINK_NAME="${HOME}/${LINK_NAME}"
    local FUNCTION_LINKS_TO_TARGET

    backup_config_and_create_link "${ABSOLUTE_LINK_TARGET}" "${ABSOLUTE_LINK_NAME}"
}


if [ $(ln_support_relative_linking) = "1" ]; then
    GL_RELATIVE_LINKING_SWITCH="-r"
else
    GL_RELATIVE_LINKING_SWITCH=""
fi
