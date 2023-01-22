#!/bin/bash

# ##############################################################################
#
# editor
#
# ##############################################################################

# make sure installed diff-so-fancy is available in path
if command -v vi > /dev/null; then
  export EDITOR=vi
  export VISUAL=$EDITOR
fi

