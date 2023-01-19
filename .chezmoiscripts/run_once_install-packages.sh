#!/bin/sh

# ##############################################################################
#
# install dependencies
#
# ##############################################################################

if ! command -v git &> /dev/null
then
    # TODO: install if not found
    echo "git could not be found"
    exit
fi

# ##############################################################################
#
# install
#
# ##############################################################################

git clone https://github.com/zsh-users/antigen.git ~/antigen
