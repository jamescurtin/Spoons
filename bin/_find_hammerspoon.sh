#!/bin/bash
set -euo pipefail

if [ -d ../hammerspoon ]; then
    HAMMERSPOON_PATH="../hammerspoon"
elif [ -d ./hammerspoon ]; then
    HAMMERSPOON_PATH="./hammerspoon"
else
    echo "Unable to find Hammerspoon"
    exit 1
fi

export HAMMERSPOON_PATH
