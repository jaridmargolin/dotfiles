#!/bin/zsh

# ##############################################################################
#
# mise.rc.sh
# Active mise for zsh if it exists.
#
# ##############################################################################

if command -v mise &> /dev/null; then
    if [[ $VSCODE_RESOLVING_ENVIRONMENT != "1" ]]; then
        eval "$(mise activate zsh)"
    fi
fi
