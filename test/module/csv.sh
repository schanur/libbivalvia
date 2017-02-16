#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../../bivalvia"


source ${BIVALVIA_PATH}/software_testing.sh
source ${BIVALVIA_PATH}/csv.sh


test_function_stdout csv_get_field 'a'  1 'a,b,cd,ef'
test_function_stdout csv_get_field 'b'  2 'a,b,cd,ef'
test_function_stdout csv_get_field 'cd' 3 'a,b,cd,ef'
test_function_stdout csv_get_field 'ef' 4 'a,b,cd,ef'
