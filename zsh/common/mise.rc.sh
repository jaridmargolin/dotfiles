#!/bin/zsh

# ##############################################################################
#
# mise.rc.sh
# Active mise for zsh if it exists.
#
# ##############################################################################

if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi
