BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

# source "${BIVALVIA_PATH}/config.sh"
# source "${BIVALVIA_PATH}/require.sh"


# Allowed message level:
# 0: emerg
# 1: alert
# 2: crit
# 3: err
# 4: warning
# 5: notice
# 6: info
# 7: debug
# 8: trace


MSG_MAX_LEVEL_NUM=6
MSG_PRINT_MSG_LEVEL=0


# PRIVATE
# Convert message level string to message level number.
function msg_level_str_to_number {
    local MSG_LEVEL="${1}"
    local MSG_LEVEL_NUM=255

    case "${MSG_LEVEL}" in
        emerg)
            MSG_LEVEL_NUM=0
            ;;
        alert)
            MSG_LEVEL_NUM=1
            ;;
        crit)
            MSG_LEVEL_NUM=2
            ;;
        err)
            MSG_LEVEL_NUM=3
            ;;
        warning)
            MSG_LEVEL_NUM=4
            ;;
        notice)
            MSG_LEVEL_NUM=5
            ;;
        info)
            MSG_LEVEL_NUM=6
            ;;
        debug)
            MSG_LEVEL_NUM=7
            ;;
        trace)
            MSG_LEVEL_NUM=8
            ;;
        *)
            msg err "Invalid message level string: ${MSG_LEVEL}. Print message as error message."
            MSG_LEVEL_NUM=3
            ;;
    esac

    echo ${MSG_LEVEL_NUM}
}


# Set message level as string. Each message with higher integer (lower
# priority) will be ignored.
function msg_set_level {
    local NEW_MSG_LEVEL_STR="${1}"
    MSG_MAX_LEVEL_NUM="$(msg_level_str_to_number ${NEW_MSG_LEVEL_STR})"
}


# Set if each message has the message level string as prefix. Allowed
# values: 0, 1.
function msg_set_opt_print_level_str {
    local VALUE="${1}"

    case "${VALUE}" in
        0|1)
            MSG_PRINT_MSG_LEVEL="${VALUE}"
        ;;
        *)
            msg err "Invalid option value: ${VALUE}"
        ;;
    esac
}


# Prints the message level with spaces added at the end so that all
# strings have the same length.
function msg_num_to_formated_msg_level_str {
    local MSG_LEVEL_NO="${1}"
    local FORMATED_STR=""

    if [ ${MSG_PRINT_MSG_LEVEL} -eq 1 ]; then
        case ${MSG_LEVEL_NO} in
            0)
                FORMATED_STR="EMERGENCY: "
                ;;
            1)
                FORMATED_STR="ALERT:     "
                ;;
            2)
                FORMATED_STR="CRITICAL:  "
                ;;
            3)
                FORMATED_STR="ERROR:     "
                ;;
            4)
                FORMATED_STR="WARNING:   "
                ;;
            5)
                FORMATED_STR="NOTICE:    "
                ;;
            6)
                FORMATED_STR="INFO:      "
                ;;
            7)
                FORMATED_STR="DEBUG:     "
                ;;
            8)
                FORMATED_STR="TRACE:     "
                ;;
        esac
    else
        FORMATED_STR=""
    fi
    echo "${FORMATED_STR}"
}


# Print message. First parameter is interpreted as message level
# string. Message levels include all that are defined by Syslog plus
# trace.
function msg {
    local MSG_LEVEL_STR="${1}"
    local MSG_LEVEL_NO="$(msg_level_str_to_number ${MSG_LEVEL_STR})"
    local MSG_MIN_LEVEL_NUM
    shift
    local MSG="${*}"

    if [ ${MSG_LEVEL_NO} -le ${MSG_MAX_LEVEL_NUM} ]; then
        case ${MSG_LEVEL_NO} in
            0)
                echo "$(msg_num_to_formated_msg_level_str ${MSG_LEVEL_NO})${MSG_LEVEL_STR}"
                ;;
            1|2|3)
                echo "$(msg_num_to_formated_msg_level_str ${MSG_LEVEL_NO})${MSG_LEVEL_STR}"
                ;;
            4|5|6|7|8)
                echo "$(msg_num_to_formated_msg_level_str ${MSG_LEVEL_NO})${MSG_LEVEL_STR}"
                ;;
            *)
                msg err "Invalid message level no: ${MSG_LEVEL_NO}"
                ;;
        esac
    fi
}
