#!/bin/bash

# ##############################################################################
#
# nodejs.env.sh
#
# ##############################################################################

# fixes npm global install permissions by moving npm global location
export NPM_CONFIG_PREFIX=~/.npm-global
export PATH=~/.npm-global/bin:$PATH
