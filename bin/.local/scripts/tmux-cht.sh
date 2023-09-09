#!/usr/bin/env bash
SELECTED=`cat ~/.tmux-cht-languages ~/.tmux-cht-commands \
            | sort \
            | fzf --print-query --header "Enter tool/command/language" \
            | tail -n 1`

if [[ -z $SELECTED ]]; then
    exit 0
fi

echo "Selected: $SELECTED"

read -p "Enter Query: " query

if [[ $(which cht.sh) ]]; then
    cht.sh $SELECTED $query | less -R
else
    curl -s cht.sh/$SELECTED~$query | less -R
fi
