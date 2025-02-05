#!/usr/bin/env bash

STOW_FOLDERS="vim,tmux,bin,nvm,yarn,bash,gh,fzf,git,fdfind"
STOW_DIR="$HOME"

if [[ -e ~/.bashrc.bk ]] || [[ -e ~/.profile.bk ]]; then
    printf "%s\n" ".dotfiles: init error: Already have .bk files. Make sure you are not overriding previous backups." >&2;
    exit 1;
fi

cp -L ~/.bashrc ~/.bashrc.bk
cp -L ~/.profile ~/.profile.bk

pushd ~/.dotfiles

for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo ".dotfiles: $folder stowed to $STOW_DIR"
    stow -S $folder -t $STOW_DIR
done

popd

echo ".dotfiles: success: Run \"source ~/.bashrc\" to load changes"