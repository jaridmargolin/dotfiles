#!/bin/bash

# ##############################################################################
#
# go.env.sh
# Setup go to work as expected
#
# ##############################################################################

# Ref: https://github.com/asdf-community/asdf-golang#version-selection
export ASDF_GOLANG_MOD_VERSION_ENABLED=true

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin