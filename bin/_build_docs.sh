#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="${SCRIPT_DIR}/.."

# shellcheck source=bin/_find_hammerspoon.sh
source "${SCRIPT_DIR}/_find_hammerspoon.sh"
# shellcheck source=/dev/null
source "${ROOT_DIR}/venv/bin/activate"

# Ensure a fresh temporary docs directory so copies never fail due to leftover files
rm -rf "${ROOT_DIR}/.docs_tmp"
mkdir -p "${ROOT_DIR}/.docs_tmp"

spoons=( "$ROOT_DIR"/Source/*/ )
spoons=( "${spoons[@]#"$ROOT_DIR/Source/"}" )
spoons=( "${spoons[@]%/}" )

for spoon in "${spoons[@]}"; do
    python "${HAMMERSPOON_PATH}/scripts/docs/bin/build_docs.py" \
        --templates "${HAMMERSPOON_PATH}/scripts/docs/templates/" \
        --output_dir "${ROOT_DIR}/Source/${spoon}" \
        --json --validate --standalone \
        "Source/${spoon}"

    rm -f "${ROOT_DIR}/Source/${spoon}/docs_index.json"
done

python "${HAMMERSPOON_PATH}/scripts/docs/bin/build_docs.py" \
    --templates "${HAMMERSPOON_PATH}/scripts/docs/templates/" \
    --output_dir "${ROOT_DIR}/.docs_tmp" \
    --standalone --json --html --validate \
    "Source"

# Ensure html dir exists, then copy template assets, forcing overwrite if present
mkdir -p "${ROOT_DIR}/.docs_tmp/html"
cp -f "${HAMMERSPOON_PATH}/scripts/docs/templates/docs.css" "${ROOT_DIR}/.docs_tmp/html/"
cp -f "${HAMMERSPOON_PATH}/scripts/docs/templates/jquery.js" "${ROOT_DIR}/.docs_tmp/html/"

# Ensure destination docs dir exists, then copy artifacts
mkdir -p "${ROOT_DIR}/docs"
cp -a "${ROOT_DIR}"/.docs_tmp/html/* "${ROOT_DIR}/docs/"
cp -a "${ROOT_DIR}"/.docs_tmp/docs{,_index}.json "${ROOT_DIR}/docs/"
