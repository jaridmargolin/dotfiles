#!/bin/bash

# ##############################################################################
#
# osx.rc.sh
# Common helpers/aliases for working with bash on MacOSX.
#
# ##############################################################################

# manage display of hidden files
# # source: http://natelandau.com/my-mac-osx-bash_profile/
# ---
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

# Moves a file to the MacOS trash
# source: http://natelandau.com/my-mac-osx-bash_profile/
# ---
trash () {
  command mv "$@" ~/.Trash ;
}

# Opens any file in MacOS Quicklook Preview
# source: http://natelandau.com/my-mac-osx-bash_profile/
# ---
ql () {
  qlmanage -p "$*" >& /dev/null;
}

# `cd`s to frontmost window of MacOS Finder
# source: http://natelandau.com/my-mac-osx-bash_profile/
# ---
cdf () {
  currFolderPath=$( /usr/bin/osascript <<EOT
    tell application "Finder"
      try
    set currFolder to (folder of the front window as alias)
      on error
    set currFolder to (path to desktop folder as alias)
      end try
      POSIX path of currFolder
    end tell
EOT
  )
  echo "cd to \"$currFolderPath\""
  cd "$currFolderPath"
}
