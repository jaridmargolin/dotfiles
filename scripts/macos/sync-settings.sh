#!/bin/sh

# ##############################################################################
#
# sync settings
#
# This is used to set macOS settings. It is possible that these configurations
# may move or change over time as macOS updates. To update settings and/or find
# new settings, you can follow these steps:
#
# 1. Navigate to a directory where you can write files to. Ex: `cd ~/Dcouments`
# 2. Run `defaults read > settings-before.txt`
# 3. Make the desired changes to the settings
# 4. Run `defaults read > settings-after.txt`
# 5. Run `delta settings-before.txt settings-after.txt`
#
# You will also want to check the current host settings. To do this, the same
# commands but with `defaults -currentHost read` instead of `defaults read`.
#
# ##############################################################################

# ##############################################################################
# setup
# ref: https://mths.be/macos
# ##############################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# ##############################################################################
# computer name
# ##############################################################################

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "$CONFIG_COMPUTER_NAME"
sudo scutil --set HostName "$CONFIG_COMPUTER_NAME"
sudo scutil --set LocalHostName "$CONFIG_COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$CONFIG_COMPUTER_NAME"

# ##############################################################################
# developer quality of life
# ref: https://mths.be/macos
# ##############################################################################

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ##############################################################################
# Finder quality of life
# ref: https://mths.be/macos
# ##############################################################################

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Set $HOME as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# NOTE: THIS IS COMMENTED OUT BECAUSE IT DOES NOT WORK - WOULD BE NICE TO FIX
# Show the ~/Library folder
# chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Finder: show hidden files by default
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Display full POSIX path as Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# ##############################################################################
# mouse
# ##############################################################################

# Support right click when using a Magic Mouse
defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string "TwoButton"
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode -string "TwoButton"

# Set mouse tracking speed
defaults write .GlobalPreferences com.apple.mouse.scaling 2

# ##############################################################################
# trackpad
# ##############################################################################

# Set trackpad tracking/scrolling speed
defaults write .GlobalPreferences com.apple.trackpad.scaling 1.5
defaults write .GlobalPreferences com.apple.trackpad.scrolling 0.3125

# ##############################################################################
# control center modules
#
# # NOTE: It appears the values here have changed over time. If you find this is
# not working, use the GUI to toggle the values and read the diff of both the
# user and host defaults.
# $ defaults read | grep "com.apple.controlcenter" -C 10
# $ defaults read -currentHost | grep "com.apple.controlcenter" -C 10
#
# int values
# 2 = show when active
# 8 = never show
# 18 = always show
# ##############################################################################

# Add bluetooth to the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults -currentHost write com.apple.controlcenter Bluetooth -int 2
# defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool false
# defaults -currentHost write com.apple.controlcenter Bluetooth -int 8

# Add sound to the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true
defaults -currentHost write com.apple.controlcenter Sound -int 18
# defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool false
# defaults -currentHost write com.apple.controlcenter Sound -int 8

# Add focus modes to the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool true
defaults -currentHost write com.apple.controlcenter FocusModes -int 18
# defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false
# defaults -currentHost write com.apple.controlcenter FocusModes -int 8

# Remove "Now Playing" from the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false
defaults -currentHost write com.apple.controlcenter NowPlaying -int 8
# defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false
# defaults -currentHost write com.apple.controlcenter NowPlaying -int 2

# Remove "AirDrop" from the menu bar
defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool false
defaults -currentHost write com.apple.controlcenter AirDrop -int 8
# defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool true
# defaults -currentHost write com.apple.controlcenter AirDrop -int 18

# Sort the menubar items (Not sure how durable this will be)
defaults write com.apple.controlcenter "NSStatusItem Preferred Position BentoBox" -int 139
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Battery" -int 173
defaults write com.apple.controlcenter "NSStatusItem Preferred Position FocusModes" -int 215
defaults write com.apple.controlcenter "NSStatusItem Preferred Position WiFi" -int 253
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Bluetooth" -int 291
defaults write com.apple.controlcenter "NSStatusItem Preferred Position Sound" -int 323

# ##############################################################################
# menu bar only
# ##############################################################################

# Remove spotlight from the menubar (prefer to use keyboard)
defaults delete com.apple.Spotlight "NSStatusItem Visible Item-0"
defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool true
# defaults write com.apple.Spotlight "NSStatusItem Visible Item-0" -bool true
# defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool false

# ##############################################################################
# dock
# ##############################################################################

# remove recent apps from the dock
defaults write com.apple.dock show-recents -bool false
# defaults delete com.apple.dock show-recents

# configure hot corners
defaults write com.apple.dock "wvous-bl-corner" -int 5 # Start Screen Saver
defaults write com.apple.dock "wvous-bl-modifier" -int 0
defaults write com.apple.dock "wvous-br-corner" -int 10 # Put Display to Sleep
defaults write com.apple.dock "wvous-br-modifier" -int 0
defaults write com.apple.dock "wvous-tl-corner" -int 2 # Mission Control
defaults write com.apple.dock "wvous-tl-modifier" -int 0
defaults write com.apple.dock "wvous-tr-corner" -int 4 # Desktop
defaults write com.apple.dock "wvous-tr-modifier" -int 0

# configure spaces to stop rearranging based on usage
defaults write com.apple.dock mru-spaces -bool false

################################################################################
# Kill affected applications
################################################################################

for app in "cfprefsd" \
    "Dock" \
    "Finder" \
    "ControlCenter" \
    "Spotlight" \
    "SystemUIServer"; do
    killall "${app}" &
    >/dev/null
done
