#!/usr/bin/env bash

if [[ -e ~/.bashrc.bk ]] || [[ -e ~/.profile.bk ]]; then
    printf "%s\n" ".dotfiles: init error: Already have .bk files. Make sure you are not overriding previous backups." >&2;
    exit 1;
fi

source $HOME/.dotfiles/colors.sh

STOW_FOLDERS=(vim tmux bin nvm yarn bash gh fzf git fdfind perl)
STOW_DIR="$HOME"

cp -L ~/.bashrc ~/.bashrc.bk
cp -L ~/.profile ~/.profile.bk

echo -e "$GREEN[SETUP]$RESET_COLOR Start...\n"

pushd ~/.dotfiles

for folder in ${STOW_FOLDERS[@]}
do
    echo -e "$BLUE[STOW]$RESET_COLOR $folder stowed to $STOW_DIR\n"

    if [ -n "$(ls ./$folder/install 2> /dev/null)" ]; then
        bash $HOME/.dotfiles/$folder/install
    else
        stow -S $folder -t $STOW_DIR --ignore="\.git"
    fi
done

popd

echo -e "$GREEN[SUCCESS]$RESET_COLOR Completed Stow setup.\n"
echo -e "=>  Run $BOLD\"source ~/.bashrc\"$RESET_COLOR to load changes to current shell"