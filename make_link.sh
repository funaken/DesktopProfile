#!/usr/bin/env bash

DIR=${1:-~/DesktopProfile}

if [[ ! -d $DIR ]]; then
  echo "${DIR} not found"
  exit 1
fi

ln -s $DIR/.zshrc ~/.zshrc
ln -s $DIR/.zshrc.osx ~/.zshrc.osx
ln -s $DIR/.zsh_profile ~/.zsh_profile
ln -s $DIR/.exrc ~/.exrc
ln -s $DIR/.vimrc ~/.vimrc
ln -s $DIR/.gvimrc ~/.gvimrc
ln -s $DIR/vimfiles ~/.vim
ln -s $DIR/.vimperatorrc ~/.vimperatorrc
ln -s $DIR/vimperator ~/.vimperator

