#!/bin/bash

source ./interface.sh

VERSION="1.0.2"

function banner() {
  echo "                                                                     ,,,,,                ,,        "
  echo "    ▀▓▓███Q           ▓██▓▓▀¬                                    ,φ▒╩╙└└└└╙╩▒╦,       »@╚╙╙╙╚╠╠φ    "
  echo "       ╫███─         ▐███                                      ,▒╠╩         ^╠╠▒     ╠╠⌐      ╠╠    "
  echo "       ╫███▓        ]████                                     )╠╠╙            ╚╠╠⌐  ╔╠╠       ²╚    "
  echo "       ▓▓╚██▌       █▌╫██      ,▄▓▀▀██▓      .▄▓▓▀▀██▓o      ,╠╠╠              ╠╠╠  ╚╠╠╦            "
  echo "       █▌ ╫██µ     ▓█ ╫██⌐    ╣█▌   ╙██▌    ▄█▓─    ╙█▌      ╠╠╠∩              ╚╠╠ε  ╚╠╠╠▒╦╓        "
  echo "       █▌  ███    ║█─ ╫██⌐   ╟██    j██▌   ▓██       └       ╠╠╠⌐              ╞╠╠Γ    ╙╚╠╠╠╠▒╔     "
  echo "       █▌  └██▌  ╓█╜  ╫██⌐         ╓▄██▌  ▐██▒               ╠╠╠o              ╚╠╠∩        └╚╠╠╠ε   "
  echo "      j█▒   ╟██▄.█▌   ╫██⌐     ,▄▓▓▀╙██▌  ╫██▒               ╘╠╠▒              ╠╠╠            ╠╠╠   "
  echo "      ▐█b    ▓██▓█    ╫██⌐   ,▓█▀   ]██▌  ╙██▌                ╚╠╠ε            ╔╠╠┘  ╠⌐        ╞╠╠   "
  echo "      ╟█µ     ███     ╫██µ   ███   ,▓██▌ , ▓██▄       ,        ╚╠╠ε          φ╠╩    ╠▒        ╠╠┘   "
  echo "   ,▄▄██▓▄▄   ╙█╜   ▄▄███▓▄▄ ███▓▓▓█▀███▓█  ▀██▓▄╓,╓▄▓▀         ^╚╠▒╓     ,╔╠╩┘     ╠╠╠╓,  ,╔╠╩     "
  echo "    ╙└└└└└╙         └└└└└└└└  ╙╙╙╙   └╙╙└     └╙▀▀▀╙╙               ╙╙╙╚╙╙╙└          └╙╙╙╙╙└       "  
  echo "   "                                                                                                   
}

function setup() {

  infoblock "Require SuperUser access to set some of the configuration."
  sudo -v

  # Keep-alive: update existing `sudo` time stamp until `.osx` has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  infoblock "Setup computer name, hostname and local hostname."
  #sudo scutil --set ComputerName "Bozhidar's Macbook Air"
  sudo scutil --set HostName "bdryanovski"
  #sudo scutil --set LocalHostName "Bozhidar-MacBook-Air"
  #sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "bdryanovski"

  infoblock "Disabling OSX Gate Keeper"
  sudo spctl --master-disable
  sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  infoblock "Standby time set to 24hours instead of 1hour"
  sudo pmset -a standbydelay 86400

  infoblock "Increase window resize speed for Cocoa applications"
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

  infoblock "Save to disk (not to iCloud) by default"
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

  infoblock "Disable resume system wide"
  defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

  infoblock "Disable crash reports"
  defaults write com.apple.CrashReporter DialogType -string "none"

  infoblock "Show IP Address, Hostname, OS Version - when clicking the clock in the login window"
  sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

  infoblock "Restart automatially when computer freezes"
  sudo systemsetup -setrestartfreeze on

  infoblock "Disabled smart quotes and dashes"
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  infoblock "Disable TimeMachine local backups"
  sudo tmutil disablelocal

  infoblock "Disable hybernation - speedup entering sleep mode"
  sudo pmset -a hibernatemode 0

  infoblock "Clear some files to free space"
  sudo rm -rf /Private/var/vm/sleepimage
  sudo touch /Private/var/vm/sleepimage
  sudo chflags uchg /Private/var/vm/sleepimage

  infoblock "Disable motion sensor - SSD reasons"
  sudo pmset -a sms 0

  infoblock "Setup trackpad"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  infoblock "Increase sound quality for Bluetooth headphones/headsets"
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

  infoblock "Disable press-and-hold for keys in favor of key repeat"
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

  infoblock "Fast keyboard"
  defaults write NSGlobalDomain KeyRepeat -int 0

  infoblock "Stop iTunes from responding to the keyboard media keys"
  launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null


  infoblock "Require password immediately after sleep or screen saver begins"
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  infoblock "Keep all Screenshots into the Deskop"
  defaults write com.apple.screencapture location -string "${HOME}/Documents/Screenshots"

  infoblock "Screenshots are not PNG"
  defaults write com.apple.screencapture type -string "png"

  infoblock "No Shadows in the screenshots"
  defaults write com.apple.screencapture disable-shadow -bool true

  infoblock "Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
  defaults write com.apple.finder QuitMenuItem -bool true

  infoblock "Finder: disable window animations and Get Info animations"
  defaults write com.apple.finder DisableAllAnimations -bool true

  infoblock "Finder: Desktop is the default location to start"
  defaults write com.apple.finder NewWindowTarget -string "PfDe"
  defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

  infoblock "Finder: show some additional icons like harddrivers and network devices"
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  infoblock "Finder: show hidden icons"
  defaults write com.apple.finder AppleShowAllFiles -bool true

  infoblock "Finder: show path bar"
  defaults write com.apple.finder ShowPathbar -bool true

  infoblock "Finder: Search in current folder"
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  infoblock "Finder: Don't show warning when changing extension"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  infoblock "Finder: Remove the spring loading delay for directories"
  defaults write NSGlobalDomain com.apple.springing.delay -float 0

  infoblock "Finder: don't create .DS_Store for network drives"
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

  infoblock "Disable disk image verifications"
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

  infoblock "Finder: open when new drive is mounted"
  defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

  infoblock "Enable snap-to-grid for icons on the desktop and in other icon views"
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  infoblock "Disable asking before emptying the Trash "
  defaults write com.apple.finder WarnOnEmptyTrash -bool false

  infoblock "Empty Trash securely by default"
  defaults write com.apple.finder EmptyTrashSecurely -bool true

  infoblock "Enable the MacBook Air SuperDrive on any Mac"
  sudo nvram boot-args="mbasd=1"

  infoblock "Show ~/Library"
  chflags nohidden ~/Library

  infoblock "Dock: icon size set to 36"
  defaults write com.apple.dock tilesize -int 36

  infoblock "Dock: Change minimize/maximize window effect"
  defaults write com.apple.dock mineffect -string "scale"

  infoblock "Dock: clear all default apps"
  defaults write com.apple.dock persistent-apps -array

  infoblock "Dock: dont animate application starting"
  defaults write com.apple.dock launchanim -bool false

  infoblock "Dock: disabled dashboard"
  defaults write com.apple.dashboard mcx-disabled -bool true

  infoblock "Dock: remove the delay for auto-hide"
  defaults write com.apple.dock autohide-delay -float 0

  infoblock "Dock: remove the animation for show-hide dock"
  defaults write com.apple.dock autohide-time-modifier -float 0.15

  infoblock "Dock: auto hide the dock"
  defaults write com.apple.dock autohide -bool true

  infoblock "Safari: don't send anything to Apple"
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions -bool true

  infoblock "Safari: show url into the bar"
  defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

  infoblock "Safari: default page is about:blank"
  defaults write com.apple.Safari HomePage -string "about:blank"

  infoblock "Safari: hide bookmarks"
  defaults write com.apple.Safari ShowFavoritesBar -bool false

  infoblock "Safari: disable thumbnail cache"
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

  infoblock "Safari: enable debugmode"
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

  infoblock "Safari: remove usless icons"
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"

  infoblock "Safari: enable developer mode"
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

  infoblock "Terminal: UTF-8"
  defaults write com.apple.terminal StringEncodings -array 4

  infoblock "Use a modified version of the Solarized Dark theme by default in Terminal.app"
  TERM_PROFILE='Solarized Dark xterm-256color';
  CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
  if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "${HOME}/init/${TERM_PROFILE}.terminal";
    sleep 1; # Wait a bit to make sure the theme is loaded
    defaults write com.apple.terminal 'Default Window Settings' -string "${TERM_PROFILE}";
    defaults write com.apple.terminal 'Startup Window Settings' -string "${TERM_PROFILE}";
  fi;

  infoblock "iTerm: disable stupid prompt when quiting"
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false

  infoblock "TimeMachine: stop asking to backup"
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  infoblock "ActivityMonitor: setup"
  defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
  defaults write com.apple.ActivityMonitor IconType -int 5
  defaults write com.apple.ActivityMonitor ShowCategory -int 0
  defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
  defaults write com.apple.ActivityMonitor SortDirection -int 0

  infoblock "iMessage: setup"
  defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

  echo "  "

  updateVersion 'osx' $VERSION  

  packagedone "MacOS is setup and ready"
}


function help() {
  helptext " "
  helptext "Description:"
  helptext "This package will configure MacOS by setting and modify system settings"
  helptext "From system settings, env, and more"
  helptext " "
  helptext " --help    - provide this information"
  helptext " --version - package version"
  helptext " "
}

function version() {
  echo $VERSION
}


function infoblock() {
  echo "  ⚙️   $1"
}


if ! isMacOS; then
  if [ "$1" == "--help" ]; then
    banner
    help
    exit;
  fi

  if [ "$1" == "--version" ]; then
    version
    exit;
  fi

  banner
  setup
fi

