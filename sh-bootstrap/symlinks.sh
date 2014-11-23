#!/bin/bash

symlink() {
	rm $HOME/$2
	ln -fsv $HOME/dotfiles/$1 $HOME/$2
}

symlink gnus         .gnus
symlink emacs.d      .emacs.d
symlink gitconfig    .gitconfig
symlink gitignore_global .gitignore_global
symlink inputrc      .inputrc
symlink bashrc        .bashrc
symlink bash_profile .bash_profile
symlink mbsyncrc     .mbsyncrc
symlink Library/KeyBindings/DefaultKeyBinding.dict Library/KeyBindings/DefaultKeyBinding.dict
symlink emacs.d/News  News
