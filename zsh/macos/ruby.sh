#!/bin/bash

# ##############################################################################
#
# ruby.sh
#
# ##############################################################################

plugin="ruby"
version="3.0.2"

if type "asdf" > /dev/null; then
    if ! asdf plugin list | grep -q "$plugin"; then
        asdf plugin add $plugin
    fi
    if ! asdf list $plugin | grep -q "$version"; then
        asdf install $plugin $version
    fi

    asdf global $plugin $version
fi
