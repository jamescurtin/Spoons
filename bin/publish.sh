#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${SCRIPT_DIR}/install.sh"
source "${SCRIPT_DIR}/_build_docs.sh"
source "${SCRIPT_DIR}/_build_zips.sh"
