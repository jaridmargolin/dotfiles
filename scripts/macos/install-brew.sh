#!/bin/sh

# ##############################################################################
#
# install brew
#
# ##############################################################################

if ! command -v brew &> /dev/null; then
    echo "Brew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
