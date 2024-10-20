#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR="${SCRIPT_DIR}/.."

source "${SCRIPT_DIR}/_find_hammerspoon.sh"
source "${ROOT_DIR}/venv/bin/activate"

mkdir -p "${ROOT_DIR}/.docs_tmp"

spoons=( "$ROOT_DIR"/Source/*/ )
spoons=( "${spoons[@]#"$ROOT_DIR/Source/"}" )
spoons=( "${spoons[@]%/}" )

for spoon in "${spoons[@]}"; do
    python "${HAMMERSPOON_PATH}/scripts/docs/bin/build_docs.py" \
        --templates "${HAMMERSPOON_PATH}/scripts/docs/templates/" \
        --output_dir "${ROOT_DIR}/Source/${spoon}" \
        --json --validate --standalone \
        "${ROOT_DIR}/Source/${spoon}"

    rm -f "${ROOT_DIR}/Source/${spoon}/docs_index.json"
done

python "${HAMMERSPOON_PATH}/scripts/docs/bin/build_docs.py" \
    --templates "${HAMMERSPOON_PATH}/scripts/docs/templates/" \
    --output_dir "${ROOT_DIR}/.docs_tmp" \
    --standalone --json --html --validate \
    "${ROOT_DIR}/Source"

cp "${HAMMERSPOON_PATH}/scripts/docs/templates/docs.css" "${ROOT_DIR}/.docs_tmp/html/"
cp "${HAMMERSPOON_PATH}/scripts/docs/templates/jquery.js" "${ROOT_DIR}/.docs_tmp/html/"
cp "${ROOT_DIR}"/.docs_tmp/html/* "${ROOT_DIR}/docs/"
cp "${ROOT_DIR}"/.docs_tmp/docs{,_index}.json "${ROOT_DIR}/docs/"
