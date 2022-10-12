#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/message.sh"


msg_set_opt_print_level_str 0

# test_function_stdout msg ""      trace   trace
# test_function_stdout msg ""      debug   debug
# test_function_stdout msg info    info    info
# test_function_stdout msg notice  notice  notice
# test_function_stdout msg warning warning warning
# test_function_stdout msg err     err     err
# test_function_stdout msg crit    crit    crit
# test_function_stdout msg alert   alert   alert
# test_function_stdout msg emerg   emerg   emerg

msg_set_level trace
msg_set_opt_print_level_str 1

# test_function_stdout msg "TRACE:     trace"   trace   trace
# test_function_stdout msg "DEBUG:     debug"   debug   debug
# test_function_stdout msg "INFO:      info"    info    info
# test_function_stdout msg "NOTICE:    notice"  notice  notice
# test_function_stdout msg "WARNING:   warning" warning warning
# test_function_stdout msg "ERROR:     err"     err     err
# test_function_stdout msg "CRITICAL:  crit"    crit    crit
# test_function_stdout msg "ALERT:     alert"   alert   alert
# test_function_stdout msg "EMERGENCY: emerg"   emerg   emerg
