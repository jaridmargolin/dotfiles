#!/bin/sh

# ##############################################################################
#
# install languages
#
# ##############################################################################

nodejs_version="16.13.0"
python_version="3.9.7"
ruby_version="3.0.2"

# Setup asdf for usage within this installation script. Normally, asdf is setup
# in the .zshrc file, but that file is not sourced when running this script.
if command -v brew &> /dev/null; then
    ASDF_DIR="$(brew --prefix asdf)/libexec"

    if [[ -f "$ASDF_DIR/asdf.sh" ]]; then
        . "$ASDF_DIR/asdf.sh"

        # install nodejs
        if ! asdf plugin list | grep -q "nodejs"; then
            asdf plugin add nodejs
        fi
        if ! asdf list nodejs | grep -q "$nodejs_version"; then
            asdf install nodejs $nodejs_version
        fi

        # install python
        if ! asdf plugin list | grep -q "python"; then
            asdf plugin add python
        fi
        if ! asdf list python | grep -q "$python_version"; then
            asdf install python $python_version
        fi

        # install ruby
        if ! asdf plugin list | grep -q "ruby"; then
            asdf plugin add ruby
        fi
        if ! asdf list ruby | grep -q "$ruby_version"; then
            asdf install ruby $ruby_version
        fi

        # set default language versions
        asdf global nodejs $nodejs_version
        asdf global python $python_version
        asdf global ruby $ruby_version
    fi
fi
