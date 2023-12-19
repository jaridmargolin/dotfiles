# Dotfiles

These dotfiles are intended to speed up provisioning and using a new machine, whether that be a vm, a devcontainer, or a macOS computer.

## Dependencies

Your setup instructions will vary slightly depending on where you are intending to use these dotfiles. Generally, you'll want to have the following installed:

- curl
- git

If you are using macOS, ensure you have installed brew:

```
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### macOS

To setup macOS, you'll need to install the command line tools:

1. `$ git --version`.
2. Follow on screen instructions to install command line tools and accepts the terms and conditions.

## Install

To install, open your terminal and run the following:

- `$ BINDIR=~/.local/bin sh -c "$(curl -fsLS get.chezmoi.io)" -- init --ssh --apply jaridmargolin`
