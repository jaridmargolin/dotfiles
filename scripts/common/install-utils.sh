#!/bin/sh

# ##############################################################################
#
# install utils
#
# NOTE: This is primarily for small cross platform utilities. Larger
# dependencies like programming languages etc. should be the responsibility
# of the host.
#
# ##############################################################################

# Make sure the environment is prepared for installation
mkdir -p ~/.local/bin
mkdir -p ~/.local/share

# ##############################################################################
# starship
# ##############################################################################

if ! command -v starship &> /dev/null; then
    echo "Starship not found. Installing..."
    curl -sS https://starship.rs/install.sh | sh -s -- -f -b ~/.local/bin
fi

# ##############################################################################
# lsd
# ##############################################################################

if ! command -v lsd &> /dev/null; then
    curl -sS https://webi.sh/lsd@0.23.1 | sh
fi

# ##############################################################################
# delta
# ##############################################################################

if ! command -v delta &> /dev/null; then
    curl -sS https://webi.sh/delta | sh
fi

# ##############################################################################
# antigen
# NOTE: antigen is sourced directly from the zshrc - it does not need to be
# added to the path.
# ##############################################################################

if [ ! -d "$HOME/antigen" ]; then
    git clone https://github.com/zsh-users/antigen.git ~/antigen
fi
