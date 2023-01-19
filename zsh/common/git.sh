#!/bin/bash

# ##############################################################################
#
# git.sh
#
# Common shortcuts and helpers for more efficiently working with git.
#
# ##############################################################################


# ------------------------------------------------------------------------------
# Shortcuts
# ------------------------------------------------------------------------------

# general
alias gs="git status"
alias gd="git diff -- ':!package-lock.json' ':!yarn.lock'"
alias gpo="git push origin"
alias gro="git fetch origin; git rebase"

# commit
alias gac="git commit -a -m"
alias gca="git add -A; git commit --amend"

# checkout
alias gcb="git checkout -b"
gcrb () { git fetch; git checkout -b "$1" origin/"$1"; }

# delete (branch or tag)
alias gdb="git branch -d"
gdrb () { git push origin :"$1"; }

# log
alias gl="git log --pretty=format:'%C(bold yellow)%h%x09%C(reset)%C(bold cyan)%ad: %an%n%s%n' --date=local"
alias gls="git log --pretty=format:'%C(bold yellow)%h%x09%C(reset)%s'"
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold yellow)%h %d%n  %C(bold)%ad: %an%n''  %C(white)%s%C(reset) %C(dim white)%n' --date=local --all"
