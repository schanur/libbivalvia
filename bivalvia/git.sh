BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"

source "${BIVALVIA_PATH}/cache.sh"
source "${BIVALVIA_PATH}/config.sh"
source "${BIVALVIA_PATH}/debug.sh"
source "${BIVALVIA_PATH}/error.sh"
source "${BIVALVIA_PATH}/require.sh"


function github_git_prerequirements {
    if [ ! $(config_file_exists github) ]; then
        critical_error "No github credentials found"
    fi
    load_config_file github
    require_variable GITHUB__USERNAME
}

function github_repos_by_user {
    local USERNAME="${1}"
    local CACHE_OBJ_NAME="github_repos_by_user.${USERNAME}"
    local CURL_CMD_STR="curl -s 'https://api.github.com/users/${USERNAME}/repos?page=1&per_page=100'"
    local GITHUB_REPO_LIST_RAW
    local GITHUB_REPO_LIST
    # local API_RESPONSE_VALID=1
    local EXIT_CODE

    print_var CURL_CMD_STR

    if [ $(cache__is_available "${CACHE_OBJ_NAME}") -eq 1 ]; then
        echo "Load cached version"
        GITHUB_REPO_LIST="$(cache__load ${CACHE_OBJ_NAME})"
    else
        echo "Load from internet"
        echo "${CURL_CMD_STR}"
        echo "$(eval ${CURL_CMD_STR})"
        # GITHUB_REPO_LIST_RAW=$(${CURL_CMD_STR})
        # GITHUB_REPO_LIST_RAW="$(curl -s 'https://api.github.com/users/${USERNAME}/repos?page=1&per_page=100')"
        # GITHUB_REPO_LIST_RAW="$(cat temp)"
        # echo ${GITHUB_REPO_LIST_RAW}
        exit 0
        if [ $(echo "${GITHUB_REPO_LIST_RAW}" | (grep -c '"message": "Not Found",' || true)) -eq 1 ]; then
            # Github API returned "Not found" message.
            critical_error "GitHub API error. Not found: ${GITHUB_REPO_LIST_RAW}"
        fi
        if [ $(echo "${GITHUB_REPO_LIST_RAW}" | wc -c) -le 100 ]; then
            critical_error "GitHub API error. Message too short: ${GITHUB_REPO_LIST_RAW}"
        fi
        GITHUB_REPO_LIST="$(echo "${GITHUB_REPO_LIST_RAW}" \
                          | grep 'html_url' \
                          | grep "${USERNAME}/" \
                          | sed -e 's|.*'"${USERNAME}"'/||g' \
                          | sed -e \"s|\',||g\")"
        echo "${GITHUB_REPO_LIST_RAW}"
        echo "${GITHUB_REPO_LIST_URL}"
        # dbg_msg ${GITHUB_REPO_LIST_RAW}
        # dbg_msg ${GITHUB_REPO_LIST_URL}
        exit 1
        if [ ${EXIT_CODE} -eq 0 ]; then
            echo "Update cache"
            cache__update "${CACHE_OBJ_NAME}" "${GITHUB_REPO_LIST}"
        fi
    fi
}

function github_repo_exists {
    local REPO_NAME="${1}"

    github_repos_by_user
}

function create_github_repo {
    not_implemented_error

    # Manually add new repo to cache file
}

function gitlab_git_prerequirements {
    not_implemented_error
}

function gitlab_repos_by_user {
    not_implemented_error
}

function gitlab_repo_exists {
    not_implemented_error
}

function create_gitlab_repo {
    not_implemented_error
}

function ssh_git_prerequirements {
    not_implemented_error
}

function ssh_repos_by_user {
    not_implemented_error
}

function ssh_repo_exists {
    not_implemented_error
}

function create_ssh_repo {
    not_implemented_error
}

function local_git_prerequirements {
    not_implemented_error
}

function local_repos_by_user {
    not_implemented_error
}

function local_repo_exists {
    not_implemented_error
}

function create_local_repo {
    not_implemented_error
}

function git_repo_exists {
    local REMOTE_URL="${1}"
    local REPO_NAME="$(basename "${REMOTE_URL}")"
    local REPO_NAME_WITHOUT_EXT=$(echo "${REPO_NAME}" | sed -e 's/\.git$//g')
    local REPO_EXISTS=0

    print_var_list REMOTE_URL REPO_NAME REPO_NAME_WITHOUT_EXT

    case ${REMOTE_URL} in
        https://github.com/*)
            github_git_prerequirements
            if [ $(github_repos_by_user "${GITHUB__USERNAME}" | egrep -c "^${REPO_NAME_WITHOUT_EXT}\$") -eq 1 ]; then
                REPO_EXISTS=1
            fi
            ;;
        https://gitlab.com/*)
            not_implemented_error
            ;;
        ssh://*)
            local REMOTE_HOST_REPO_PATH="${HOME}/$(echo ${REMOTE_URL} | sed -e 's|ssh://||g' | sed -e 's|^[^/]*/||g')"

            print_var_list REMOTE_HOST_REPO_PATH
            if [ -d "${REMOTE_HOST_REPO_PATH}" ]; then
                # Match regular and bare git repositories.
                if [ -d "${REMOTE_HOST_REPO_PATH}/.git" -o -d "${REMOTE_HOST_REPO_PATH}/refs" ]; then
                    REPO_EXISTS=1
                fi
            fi
            ;;
        *)
            local LOCAL_PATH
            local REPO_BASE_PATH
            not_implemented_error
            ;;
    esac

    echo ${REPO_EXISTS}
}

function create_git_repo {
    local REMOTE_URL="${1}"

    case "${REMOTE_URL}" in
        https://github.com/*)
            create_github_repo
            ;;
        https://gitlab.com/*)
            create_gitlab_repo
            ;;
        ssh://*)
            create_ssh_repo
            ;;
        *)
            create_fs_repo
            ;;

    esac
}
