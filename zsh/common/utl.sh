#!/bin/bash

# ##############################################################################
#
# utl.sh
#
# Common helpers/aliases for working with bash.
#
# ##############################################################################


alias cp="cp -r"                          # Recursive by default
alias mkdir="mkdir -pv"                   # Create required and log
alias ls="ls -G"                          # Of course I want color!

alias lc='colorls --sd'
alias ll="lc -lA --sd"                    # Better list implementation

alias path='echo -e ${PATH//:/\\n}'       # Echo all executable Paths

mcd() { mkdir -p "$1" && cd "$1"; }       # Makes new Dir and jumps inside
cpwd() { pwd | xargs echo -n | pbcopy; }  # Copy the current working directory
kpop() { lsof -ti:"$1" | xargs kill; }    # Kill process on specified port


# While there is no way the api is identical, this suffices from my need to
# pipe stdout from a command to the macos system clipboard.
alias xclip='pbcopy'

set-title(){
  DISABLE_AUTO_TITLE="true"
  echo -en "\e]2;$@\a"
}