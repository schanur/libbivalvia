BIVALVIA_PATH="$(dirname ${BASH_SOURCE})/../bivalvia"


# echo ${BIVALVIA_PATH}

source ${BIVALVIA_PATH}/software_testing.sh


function print_abc {
    echo "abc"
}

# function expect_2_params {
#     true
# }

test_function print_abc 0 "abc" ""
