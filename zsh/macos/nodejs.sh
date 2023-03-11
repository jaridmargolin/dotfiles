#!/bin/bash

# ##############################################################################
#
# nodejs.sh
#
# ##############################################################################

plugin="nodejs"
version="16.13.0"

if type "asdf" > /dev/null; then
    if ! asdf plugin list | grep -q "$plugin"; then
        asdf plugin add $plugin
    fi
    if ! asdf list $plugin | grep -q "$version"; then
        asdf install $plugin $version
    fi

    asdf global $plugin $version
fi
