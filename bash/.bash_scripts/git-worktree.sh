#!/usr/bin/env bash


function wt-list() {
    WT_LIST=`git worktree list --verbose`
    exit=$?
    [[ $exit -ne 0 ]] && return $exit

    SELECTED_WORKTREE=$(
        echo "$WT_LIST" \
        | fzf --prompt="Switch Worktree: " --height 40% --margin 0,2% --reverse --cycle --border=bold --color=16 \
        | awk '{print $1}'
    )

    [[ "$SELECTED_WORKTREE" ]] && cd "$SELECTED_WORKTREE";
}