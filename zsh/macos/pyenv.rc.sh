#!/bin/bash

# ##############################################################################
#
# pyenv.rc.sh
#
# ##############################################################################

# Enable shims, without shell integration
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init --path)"
fi
