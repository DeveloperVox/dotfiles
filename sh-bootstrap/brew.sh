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

# ----------------------------------------
# Install Homebrew
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
 
# Tap Repos
brew tap homebrew/dupes
brew tap homebrew/versions
brew tap homebrew/homebrew-php
brew tap homebrew/apache
 
# Verify
brew update && brew upgrade
 
# Macintosh
brew install git
brew install openssl
ssh-keygen -t rsa -C “email@address.invalid”
ssh-add ~/.ssh/id_rsa
 
# Apache
sudo apachectl stop
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
brew install httpd24 --with-privileged-ports --with-brewed-ssl
sudo cp -v /usr/local/Cellar/httpd24/2.4.10/homebrew.mxcl.httpd24.plist /Library/LaunchDaemons
sudo chown -v root:wheel /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo chmod -v 644 /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.httpd24.plist
sudo httpd -k start
 
# MySQL
brew install mysql
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
mysqladmin -u root password “NEWPASSWORD”
 
# PHP
brew install php56 --homebrew-apxs --with-apache --with-homebrew-curl --with-homebrew-openssl --with-phpdbg --with-tidy --without-snmp
chmod -R ug+w /usr/local/Cellar/php56/5.6.2/lib/php
pear config-set php_ini /usr/local/etc/php/5.6/php.ini
printf '\nAddHandler php5-script .php\nAddType text/html .php' >> /usr/local/etc/apache2/2.4/httpd.conf
perl -p -i -e 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/g' /usr/local/etc/apache2/2.4/httpd.conf
printf '\nexport PATH="$(brew --prefix homebrew/php/php56)/bin:$PATH"' >> ~/.profile
 
# Dev Stuff
brew install composer
brew install behat
brew install node
npm -g install grunt
npm -g install shifter
brew tap danpoltawski/homebrew-mdk
brew install moodle-sdk

# ---------------------------------

# Remove outdated versions from the cellar.
brew cleanup
