BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


source ${BIVALVIA_PATH}/require.sh


function list_size {
    local LIST="${1}"
    local LIST_SIZE

    LIST_SIZE=$(echo -ne "${LIST}" | wc -l)

    echo ${LIST_SIZE}
}

function list_is_empty {
    local LIST="${1}"
    local LIST_IS_EMPTY=0

    if [ $(list_size "${LIST}") -eq 0 ]; then
        LIST_IS_EMPTY=1
    fi

    echo ${LIST_IS_EMPTY}
}


function list_count_value {
    local NEEDLE="${1}"

    local LIST="${2}"
    local VALUE_COUNT=0

    for VALUE in $(echo "${LIST}" |sed -e 's/\\n/\ /g'); do
        if [ "${VALUE}" = "${NEEDLE}" ]; then
            (( VALUE_COUNT = VALUE_COUNT + 1 ))
        fi
    done

    echo ${VALUE_COUNT}
}

function list_has_value {
    true
}

function list_new {
    echo -n ""
}

function list_add {
            local LIST_1="${1}"
            local LIST_2="${2}"

            echo "${LIST_1}${LIST_2}"
}

# Warning: Has quadratic computation complexity.
# function list_sub {
#     local LIST_1="$(echo -e ${1})"
#     local LIST_2="$(echo -e ${2})"
#     # local LIST_2="$(echo ${2} | sed -e 's///g'"
#     local LIST_SUB=""
#     local FIRST_ITEM=1
#     local FILTER_ITEM

#     for ITEM_1 in $(echo ${LIST_1} | sed -e 's/\n/ /g'); do
#         FILTER_ITEM=0
#         # echo $ITEM_1
#         for ITEM_2 in $(echo ${LIST_2} | sed -e 's/\n/ /g'); do
#             # echo -n "#${ITEM_1}# #${ITEM_2}#" >&2
#             if [ "${ITEM_1}" = "${ITEM_2}" ]; then
#                FILTER_ITEM=1
#                # echo break >&2
#                break
#             fi
#             # echo >&2
#         done
#         if [ ${FILTER_ITEM} -eq 0 ]; then
#             if [ ${FIRST_ITEM} -eq 1 ]; then
#                 FIRST_ITEM=0
#             else
#                 LIST_SUB="${LIST_SUB}\n"
#             fi
#             LIST_SUB="${LIST_SUB}${ITEM_1}"
#         fi
#     done
#     # echo "---"
#     echo ${LIST_SUB}
# }

# function list_unique {
#     local LIST="${1}"


# }
