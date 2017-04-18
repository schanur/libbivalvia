#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"


source ${BIVALVIA_PATH}/software_testing.sh
# source ${BIVALVIA_PATH}/git.sh


DATA_PATH="${BIVALVIA_PATH}/../test/data/git"
CONFIG_PATH="${DATA_PATH}/config"
WORKING_PATH_DELETE_PATTERN="/tmp/libbivalvia_test/git_*"
WORKING_PATH="/tmp/libbivalvia_test/git_$$"


function prepare_working_directory {
    mkdir -p ${WORKING_PATH}"
    cp -r ${DATA_PATH}/git_local ${WORKING_PATH}"
}

function clear_working_directory {
    echo "rm -rf ${WORKING_PATH}"
}

exit 0

########################################################################
# git_github
########################################################################

########################################################################
# git_gitlab
########################################################################

########################################################################
# git_ssh
########################################################################

########################################################################
# git_local
########################################################################

# Prepare test data layout in a temporary directory outside of the
# repository.
echo ${WORKING_PATH}
if [ $(test ${WORKING_PATH_DELETE_PATTERN} ]; then
    echo "test"
    clear_working_directory
fi
prepare_working_directory

clear_working_directory

set_config_path ${CONFIG_PATH}


# test_function_stdout csv_get_field    '0'    1 'a,b,cd,ef'


