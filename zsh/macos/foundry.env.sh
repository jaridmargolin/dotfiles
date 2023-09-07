#!/bin/bash

# ##############################################################################
#
# foundry.env.sh
# ref: https://foundry.paradigm.xyz
# ref: https://github.com/foundry-rs/foundry
#
# ##############################################################################

export FOUNDRY_DIR=${FOUNDRY_DIR-"$HOME/.foundry"}
export FOUNDRY_BIN_DIR="$FOUNDRY_DIR/bin"
export FOUNDRY_MAN_DIR="$FOUNDRY_DIR/share/man/man1"
export PATH="$PATH:$FOUNDRY_BIN_DIR"
