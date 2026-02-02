#!/bin/zsh

# ##############################################################################
#
# editor.env.sh
#
# ##############################################################################

if command -v vi > /dev/null; then
  export EDITOR=vi
  export VISUAL=$EDITOR
  export GIT_EDITOR=$EDITOR
fi

