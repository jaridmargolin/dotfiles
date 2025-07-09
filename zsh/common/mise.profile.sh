#!/bin/zsh

# ##############################################################################
#
# mise.rc.sh
# Add mise shims - this ensures mise is available for tooling like IDEs.
#
# ##############################################################################

if command -v mise &> /dev/null; then
    eval "$(mise activate zsh --shims)"
fi
