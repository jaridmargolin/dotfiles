#!/bin/sh

# ##############################################################################
#
# install
#
# ##############################################################################

if [ ! -d "$HOME/antigen" ]
then
    git clone https://github.com/zsh-users/antigen.git ~/antigen
fi

if [ ! -d "$HOME/diff-so-fancy" ]
then
    git clone https://github.com/so-fancy/diff-so-fancy ~/diff-so-fancy
fi
