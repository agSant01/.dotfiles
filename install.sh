#!/usr/bin/env bash

STOW_FOLDERS="bin,nvm,yarn,bash,fzf,git"

for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -S $folder -t $HOME
done