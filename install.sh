#!/usr/bin/env bash

STOW_FOLDERS="bash,git,scripts,yarn"

for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -D $folder
    stow $folder
done