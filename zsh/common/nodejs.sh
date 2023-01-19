#!/bin/bash

# ##############################################################################
#
# nodejs.sh
#
# ##############################################################################

# fixes npm global install permissions by moving npm global location
export NPM_CONFIG_PREFIX=~/.npm-global
export PATH=~/.npm-global/bin:$PATH

eval "$(nodenv init -)"
nodenv global 16.13.0
