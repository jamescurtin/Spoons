#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="${SCRIPT_DIR}/.."
# shellcheck source=bin/_find_hammerspoon.sh
source "${SCRIPT_DIR}/_find_hammerspoon.sh"

python -m venv "${ROOT_DIR}/venv"
# shellcheck source=/dev/null
source "${ROOT_DIR}/venv/bin/activate"
pip install -qr "${HAMMERSPOON_PATH}/requirements.txt"
pip install -qr "${ROOT_DIR}/requirements.txt"
