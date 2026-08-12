#!/usr/bin/env bash


function wt-list() {
    # Selection logic lives in the shared `worktree` script (also used by tmux).
    local selected
    selected=$(worktree --cd) || return
    [[ "$selected" ]] && cd "$selected"
}