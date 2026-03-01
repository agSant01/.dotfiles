#!/usr/bin/env bash

# Load colors first so early messages can use them
source "$HOME/.dotfiles/colors.sh" 2>/dev/null || true

# Pre-config: refuse to overwrite existing backups unless user opts in
BACKUPS_EXIST=
[[ -e ~/.bashrc.bk ]] || [[ -e ~/.profile.bk ]] && BACKUPS_EXIST=1

if [[ -n "$BACKUPS_EXIST" ]]; then
    printf "%s\n" ".dotfiles: init error: Backup files (.bashrc.bk / .profile.bk) already exist." >&2
    printf "%s\n" "  Use --force to re-run (existing .bk will be rotated to .bk.old)." >&2
    if [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
        echo -e "${GREEN}[WARNING]${RESET_COLOR} Rotating existing backups to .bk.old and proceeding."
        [[ -e ~/.bashrc.bk ]] && mv -f ~/.bashrc.bk ~/.bashrc.bk.old
        [[ -e ~/.profile.bk ]] && mv -f ~/.profile.bk ~/.profile.bk.old
    else
        exit 1
    fi
fi

STOW_FOLDERS=(common vim tmux bin nvm yarn bash zsh gh fzf git fdfind)
STOW_DIR="$HOME"

# Pre-create ~/.local dirs so stow --no-folding creates real dirs and only symlinks package files.
mkdir -p "$HOME/.local/bin" "$HOME/.local/scripts" "$HOME/.local/share/man/man1"

cp -L ~/.bashrc ~/.bashrc.bk
rm $HOME/.bashrc
cp -L ~/.profile ~/.profile.bk
rm $HOME/.profile
rm -f ~/.bash_logout

echo -e "$GREEN[SETUP]$RESET_COLOR Start...\n"

pushd ~/.dotfiles

# Tier 1: public packages
for folder in ${STOW_FOLDERS[@]}
do
    if [[ ! -d "./$folder" ]]; then
        continue
    fi
    if [[ -z "$(ls -A ./$folder 2>/dev/null)" ]]; then
        echo -e "$BLUE[STOW]$RESET_COLOR skipping empty package: $folder\n"
        continue
    fi
    echo -e "$BLUE[STOW]$RESET_COLOR $folder stowed to $STOW_DIR\n"

    if [ -n "$(ls ./$folder/install 2> /dev/null)" ]; then
        bash $HOME/.dotfiles/$folder/install
    else
        stow -S $folder -t $STOW_DIR --ignore="\.git" --no-folding
    fi
done

# Tier 2: overlay packages (e.g. overlay/work as submodule)
if [[ -d ./overlay ]]; then
    for dir in ./overlay/*/; do
        [[ -d "$dir" ]] || continue
        pkg=$(basename "$dir")
        [[ "$pkg" != _* ]] || continue
        if [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]; then
            echo -e "$BLUE[STOW]$RESET_COLOR skipping empty overlay: $pkg\n"
            continue
        fi
        echo -e "$BLUE[STOW]$RESET_COLOR overlay/$pkg stowed to $STOW_DIR\n"
        if [ -n "$(ls "$dir/install" 2> /dev/null)" ]; then
            bash "$HOME/.dotfiles/overlay/$pkg/install"
        else
            stow -d ./overlay -S "$pkg" -t "$STOW_DIR" --ignore="\.git" --no-folding
        fi
    done
fi

popd

echo -e "$GREEN[SUCCESS]$RESET_COLOR Completed Stow setup.\n"
echo -e "=>  Run $BOLD\"source ~/.bashrc\"$RESET_COLOR or $BOLD\"source ~/.zshrc\"$RESET_COLOR to load changes to current shell"
