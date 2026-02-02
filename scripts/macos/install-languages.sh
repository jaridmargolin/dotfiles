#!/bin/sh

# ##############################################################################
#
# install languages
#
# All languages are opt-in via chezmoi config (~/.config/chezmoi/chezmoi.toml).
# Set languages.node = true, languages.python = true, etc. to install.
#
# ##############################################################################

nodejs_version="20.17.0"
yarn_version="1.22.19"
python_version="3.12.0"
ruby_version="3.3.0"
go_version="1.23.1"
java_version="zulu-17"

# Setup mise for usage within this installation script. Normally, mise is setup
# in the .zshrc file, but that file is not sourced when running this script.
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh --shims)"

    # install nodejs
    if [ "$INSTALL_NODE" = "true" ]; then
        if ! mise list node | grep -q "$nodejs_version"; then
            mise use -g node@$nodejs_version
        fi
    fi

    # install python
    if [ "$INSTALL_PYTHON" = "true" ]; then
        if ! mise list python | grep -q "$python_version"; then
            mise use -g python@$python_version
        fi
    fi

    # install ruby
    if [ "$INSTALL_RUBY" = "true" ]; then
        if ! mise list ruby | grep -q "$ruby_version"; then
            mise use -g ruby@$ruby_version 
        fi
    fi

    # install go
    if [ "$INSTALL_GO" = "true" ]; then
        if ! mise list go | grep -q "$go_version"; then
            mise use -g go@$go_version
        fi
    fi

    # install yarn
    if [ "$INSTALL_YARN" = "true" ]; then
        if ! mise plugins list | grep -q "yarn"; then
            mise plugins install yarn
        fi
        if ! mise list yarn | grep -q "$yarn_version"; then
            mise use -g yarn@$yarn_version
        fi
    fi

    # install java
    if [ "$INSTALL_JAVA" = "true" ]; then
        if ! mise list java | grep -q "$java_version"; then
            mise use -g java@$java_version
        fi
    fi
fi
