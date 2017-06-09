BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")"


source ${BIVALVIA_PATH}/file_search_replace.sh


# Print all function declarations of the forms:
#   function test_function {
#   function TestFunction {
#   function TestFunction() {
#   function TestFunction()
#   function TestFunction ()
#   function TestFunction
function list_functions {
    local MODULE_FILENAME=${1}

    cat ${MODULE_FILENAME} |grep -e "^function[a-zA-Z0-9_]*" | cut -f 2 -d ' '
}

function function_decl_line_no {
    local MODULE_FILENAME=${1}
    local FUNCTION_NAME=${2}

    # cat ${MODULE_FILENAME} |grep -e "^${FUNCTION_NAME}.*"
    cat ${MODULE_FILENAME} |grep -ne "^function ${FUNCTION_NAME}" | cut -f 1 -d ':'
}

function function_description {
    true
}
