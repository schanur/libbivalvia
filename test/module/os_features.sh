#!/bin/bash
set -o errexit -o nounset -o pipefail
BIVALVIA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../bivalvia"

source "${BIVALVIA_PATH}/software_testing.sh"
source "${BIVALVIA_PATH}/os_features.sh"

source "${BIVALVIA_PATH}/distribution.sh"


HAS_SYSTEMD=1

case "$(distribution_pretty_name)" in
    "Debian GNU/Linux buster/sid")
        true
        ;;
    *)
        echo "Unknown distribution. Cannot test os_features module." >&2
        exit 1
        ;;
esac


test_function_stdout os_has_systemd     ${HAS_SYSTEMD}
