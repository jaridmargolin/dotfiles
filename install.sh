#!/bin/sh

# ##############################################################################
#
# install
#
# This is primarily used to install and execute the dotfiles if pulled onto an
# existing machine. For example, this will run in devcontainers which can be
# configured to pull dotfiles from a specified repo and automatically execute
# any `install.sh` file found at the root of the repo.
#
# If you are looking to setup these dotfiles on a new host MacOS machine, you
# can use this chezmoi one-liner which will install chezmoi and sync the
# specified repo:
# $ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jaridmargolin
#
# ##############################################################################

# This allows us to skip the install if we are in a devcontainer and explicitly
# want to skip the dotfiles install by setting the DOTFILES_INSTALL environment
# variable to 0.
if [ "${DOTFILES_INSTALL:-1}" != "1" ]; then
  echo "Dotfiles install skipped (DOTFILES_INSTALL=$DOTFILES_INSTALL)"
  exit 0
fi

# -e: exit on error
# -u: exit on unset variables
set -eu

if ! chezmoi="$(command -v chezmoi)"; then
  bin_dir="${HOME}/.local/bin"
  chezmoi="${bin_dir}/chezmoi"
  echo "Installing chezmoi to '${chezmoi}'" >&2
  if command -v curl >/dev/null; then
    chezmoi_install_script="$(curl -fsSL get.chezmoi.io)"
  elif command -v wget >/dev/null; then
    chezmoi_install_script="$(wget -qO- get.chezmoi.io)"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
  sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
  unset chezmoi_install_script bin_dir
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

set -- init --apply --source="${script_dir}"

echo "Running 'chezmoi $*'" >&2
# exec: replace current process with chezmoi
exec "$chezmoi" "$@"
