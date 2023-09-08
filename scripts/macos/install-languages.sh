#!/bin/sh

# ##############################################################################
#
# install languages
#
# ##############################################################################

nodejs_version="16.13.0"
yarn_version="1.22.19"
python_version="3.9.7"
ruby_version="3.0.2"
rust_version="1.71.1"
golang_version="1.21.1"

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

        # install yarn
        if ! asdf plugin list | grep -q "yarn"; then
            asdf plugin add yarn
        fi
        if ! asdf list yarn | grep -q "$yarn_version"; then
            asdf install yarn $yarn_version
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

        # install rust
        if ! asdf plugin list | grep -q "rust"; then
            asdf plugin add rust https://github.com/asdf-community/asdf-rust.git
        fi
        if ! asdf list rust | grep -q "$rust_version"; then
            asdf install rust $rust_version
        fi

        # install golang
        if ! asdf plugin list | grep -q "golang"; then
            asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
        fi
        if ! asdf list golang | grep -q "$golang_version"; then
            asdf install golang $golang_version
        fi

        # TODO: Look into installing poetry. There appears to be a few issues
        # which is why we are not installing it here.
        # Ref: https://github.com/asdf-community/asdf-poetry/issues/10

        # set default language versions
        asdf global nodejs $nodejs_version
        asdf global yarn $yarn_version
        asdf global python $python_version
        asdf global ruby $ruby_version
        asdf global rust $rust_version
        asdf global golang $golang_version
    fi
fi
