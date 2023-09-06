#!/bin/bash

# ##############################################################################
#
# pyenv.sh
#
# ##############################################################################

# NOTE: This is the default root, but included here to be more explicit.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# NOTE: This the default installation location. We add $HOME/.local/bin to our
# path elsewhere so we don't need to add it here. Comment and code left in for
# reference.
# export PATH="$HOME/.local/bin:$PATH"

# Enable shims, without shell integration
eval "$(pyenv init --path)"
