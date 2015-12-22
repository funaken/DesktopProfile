#!/usr/bin/env bash

DIR=${1:-~/DesktopProfile}

if [[ ! -d $DIR ]]; then
  echo "${DIR} not found"
  exit 1
fi

[[ -e ~/.zshrc ]] || ln -s $DIR/.zshrc ~/.zshrc
[[ -e ~/.zshrc.osx ]] || ln -s $DIR/.zshrc.osx ~/.zshrc.osx
[[ -e ~/.zsh_profile ]] || ln -s $DIR/.zsh_profile ~/.zsh_profile
[[ -e ~/.exrc ]] || ln -s $DIR/.exrc ~/.exrc
[[ -e ~/.vimrc ]] || ln -s $DIR/.vimrc ~/.vimrc
[[ -e ~/.gvimrc ]] || ln -s $DIR/.gvimrc ~/.gvimrc
[[ -e ~/.vim ]] || ln -s $DIR/vimfiles ~/.vim
#[[ -e ~/.vimperatorrc ]] || ln -s $DIR/.vimperatorrc ~/.vimperatorrc
#[[ -e ~/.vimperator ]] || ln -s $DIR/vimperator ~/.vimperator

