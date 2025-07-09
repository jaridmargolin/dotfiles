#!/bin/sh

# ##############################################################################
#
# install languages
#
# ##############################################################################

nodejs_version="20.17.0"
yarn_version="1.22.19"
python_version="3.12.0"
ruby_version="3.3.0"
go_version="1.23.1"

# Setup asdf for usage within this installation script. Normally, asdf is setup
# in the .zshrc file, but that file is not sourced when running this script.
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh --shims)"

    # install nodejs
    if ! mise list node | grep -q "$nodejs_version"; then
        mise use -g node@$nodejs_version
    fi

    # install python
    if ! mise list python | grep -q "$python_version"; then
        mise use -g python@$python_version
    fi

    # install ruby
    if ! mise list ruby | grep -q "$ruby_version"; then
        mise use -g ruby@$ruby_version 
    fi

    # install go
    if ! mise list go | grep -q "$go_version"; then
        mise use -g go@$go_version
    fi

    # install yarn
    if ! mise plugins list | grep -q "yarn"; then
        mise plugins install yarn
    fi
    if ! mise list yarn | grep -q "$yarn_version"; then
        mise use -g yarn@$yarn_version
    fi
fi
