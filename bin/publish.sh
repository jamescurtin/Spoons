#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=bin/install.sh
source "${SCRIPT_DIR}/install.sh"
# shellcheck source=bin/_build_docs.sh
source "${SCRIPT_DIR}/_build_docs.sh"
# shellcheck source=bin/_build_zips.sh
source "${SCRIPT_DIR}/_build_zips.sh"
