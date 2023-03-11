#!/bin/bash

# ##############################################################################
#
# python.sh
#
# ##############################################################################

plugin="python"
version="3.9.7"
#version="2.7.16"

if type "asdf" > /dev/null; then
    if ! asdf plugin list | grep -q "$plugin"; then
        asdf plugin add $plugin
    fi
    if ! asdf list $plugin | grep -q "$version"; then
        asdf install $plugin $version
    fi

    asdf global $plugin $version
fi
