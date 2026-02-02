#!/bin/zsh

# ##############################################################################
#
# java.env.sh
#
# Setup java environment on macos
#
# ##############################################################################

# Use system-registered JDK if available (mise-installed Java registers here)
if /usr/libexec/java_home &>/dev/null; then
  export JAVA_HOME=$(/usr/libexec/java_home)
fi
