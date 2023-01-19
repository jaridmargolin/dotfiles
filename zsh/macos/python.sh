#!/bin/bash

# ##############################################################################
#
# python.sh
#
# Common helpers/aliases for working with python on MacOSX.
#
# ##############################################################################

eval "$(pyenv init --path)"
eval "$(pyenv init -)";
eval "$(pyenv virtualenv-init -)";
pyenv global 2.7.16;
