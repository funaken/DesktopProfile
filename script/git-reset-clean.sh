#!/bin/sh

read -p "Are you sure to clear all? " -n 1 -r
echo # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

# Undo changes in tracked files
git reset --hard HEAD

# Remove untracked files
git clean -df

