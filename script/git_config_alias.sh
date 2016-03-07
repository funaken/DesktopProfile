#!/bin/sh

if ! type git > /dev/null; then
  echo "git not found"
  exit 1
fi

git config --global alias.co checkout
git config --global alias.st 'status'
git config --global alias.br 'branch'
git config --global alias.pul 'pull --rebase'
git config --global alias.fet 'fetch'
git config --global alias.sta 'stash --include-untracked'
git config --global alias.stap 'stash pop'
git config --global alias.rom 'rebase origin/master'
git config --global alias.set-track 'branch -u'

