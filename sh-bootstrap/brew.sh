#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/screen

# Install gettext and link it
brew install gettext
brew link --force gettext

# Install other useful binaries.
brew install git
brew install ack
brew install lynx
brew install rename
brew install tree
brew install pass

# Install Emacs
# To have launchd start emacs at login:
#    ln -sfv /usr/local/opt/emacs/*.plist ~/Library/LaunchAgents
# Then to load emacs now:
#    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.emacs.plist
# Run `brew linkapps` to create /Applications/Emacs.app symlink.
brew install --cocoa --srgb emacs

# Install stuff used with Emacs
brew install mu
brew install isync
brew install ledger

# Remove outdated versions from the cellar.
brew cleanup
