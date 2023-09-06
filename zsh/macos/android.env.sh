#!/bin/bash

# ##############################################################################
#
# android.env.sh
# Setup macos for android development.
#
# ##############################################################################

# DEVELOPMENT REQUIREMENTS
export ANDROID_HOME=${HOME}/Library/Android/sdk

# ADD TO PATH
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
