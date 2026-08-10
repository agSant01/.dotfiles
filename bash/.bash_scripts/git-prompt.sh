#!/usr/bin/env bash

BOLD=$(tput bold)
RESET_COLOR='\033[00m'

RED='\033[01;31m'
GREEN="\033[01;32m"
YELLOW='\033[01;33m'
BLUE='\033[01;34m'
MAGENTA='\033[01;35m'

THEME_GIT_PROMPT_PREFIX='git:('
THEME_GIT_PROMPT_SUFFIX=')'
THEME_GIT_PROMPT_SEPARATOR='|'
THEME_GIT_PROMPT_BRANCH="$BOLD$YELLOW"
THEME_GIT_PROMPT_STAGED="$RED●"
THEME_GIT_PROMPT_CONFLICTS="$RED✖"
THEME_GIT_PROMPT_CHANGED="$BLUE✚"
THEME_GIT_PROMPT_BEHIND="↓"
THEME_GIT_PROMPT_AHEAD="↑"
THEME_GIT_PROMPT_UNTRACKED="…"
THEME_GIT_PROMPT_CLEAN="$BOLD$GREEN✔ "

update_git_vars() {
    _GIT_PARSER_DIRECTORY="$HOME/.bash_scripts"
    _GIT_STATUS=`git status --porcelain --branch | perl $_GIT_PARSER_DIRECTORY/git.pl`
    _GIT_CURRENT_STATUS=(${=_GIT_STATUS})

    GIT_CHANGED=${_GIT_CURRENT_STATUS[1]}
    GIT_CONFLICTS=${_GIT_CURRENT_STATUS[2]}
    GIT_STAGED=${_GIT_CURRENT_STATUS[3]}
    GIT_UNTRACKED=${_GIT_CURRENT_STATUS[4]}
    GIT_AHEAD=${_GIT_CURRENT_STATUS[5]}
    GIT_BEHIND=${_GIT_CURRENT_STATUS[6]}
}

_shorten_branch_name() {
    local branch_name="$1"
    local max_length="${2:-20}"

    # If branch name is short enough, return as-is
    if [ ${#branch_name} -le "$max_length" ]; then
        echo "$branch_name"
        return
    fi

    local shortened_name=""

    # Check if it starts with a date pattern (XX-XX-)
    if [[ $branch_name =~ ^[0-9]{2}-[0-9]{2}- ]]; then
        # Extract the date prefix
        local date_prefix=$(echo "$branch_name" | grep -o '^[0-9]\{2\}-[0-9]\{2\}-')
        # Get the rest of the branch name
        local rest_of_name=$(echo "$branch_name" | sed "s/^$date_prefix//")

        # Create initials from the rest (take first letter of each word separated by _ or -)
        local initials=$(echo "$rest_of_name" | sed 's/[_-]/\n/g' | sed 's/^\(.\).*/\1/' | tr -d '\n' | tr '[:upper:]' '[:lower:]')

        # Create a short hash from the full rest_of_name for uniqueness
        local hash=$(echo "$rest_of_name" | shasum -a 256 | cut -c1-4)
        local commit_hash=$(git rev-parse --short HEAD)

        # Combine: date + initials + hash
        shortened_name="${date_prefix}${initials}-${hash}-${commit_hash}"
    else
        # No date prefix, just create initials + hash
        local initials=$(echo "$branch_name" | sed 's/[_-]/\n/g' | sed 's/^\(.\).*/\1/' | tr -d '\n' | tr '[:upper:]' '[:lower:]')
        local hash=$(echo "$branch_name" | shasum -a 256 | cut -c1-6)
        shortened_name="${initials}-${hash}"
    fi

    echo "$shortened_name"
}

git_super_status() {
    # extract just the repo directory name
    REPO_DIR=$(git rev-parse --show-toplevel --quiet 2> /dev/null | sed 's!.*/!!' | tr -d '\n')

    if [[ -z $REPO_DIR && "$(git config --local --get core.bare 2> /dev/null)" = true ]]; then
        PROMPT="${THEME_GIT_PROMPT_PREFIX}${THEME_GIT_PROMPT_BRANCH}bare.git${RESET_COLOR}${THEME_GIT_PROMPT_SUFFIX}"
        echo -ne "$PROMPT"
        return 0;
    fi

    if [ $REPO_DIR ]; then
        update_git_vars
        GIT_BRANCH=$(git branch --show-current 2> /dev/null)
        if [[ -z "$GIT_BRANCH" ]]; then
            DETACHED_HEAD=$(git rev-parse --short HEAD)
            GIT_BRANCH="detached at $DETACHED_HEAD"
        else
            GIT_BRANCH=$(_shorten_branch_name "$GIT_BRANCH" 20)
        fi

        PROMPT="${THEME_GIT_PROMPT_PREFIX}${THEME_GIT_PROMPT_BRANCH}${GIT_BRANCH}${RESET_COLOR}"

        # Behind indicator
        if [ "$GIT_BEHIND" -ne "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_BEHIND}${GIT_BEHIND}${RESET_COLOR}"
        fi

        # Ahead indicator
        if [ "$GIT_AHEAD" -ne "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_AHEAD}${GIT_AHEAD}${RESET_COLOR}"
        fi

        # Add separator
        PROMPT="${PROMPT}${THEME_GIT_PROMPT_SEPARATOR}${RESET_COLOR}"

        # STAGED
        if [ "$GIT_STAGED" -ne "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_STAGED}${GIT_STAGED}${RESET_COLOR}"
        fi

        # Conflicts
        if [ "$GIT_CONFLICTS" -ne "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_CONFLICTS}${GIT_CONFLICTS}${RESET_COLOR}"
        fi

        # Changed
        if [ "$GIT_CHANGED" -ne "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_CHANGED}${GIT_CHANGED}${RESET_COLOR}"
        fi

        # Untracked
        if [ "$GIT_UNTRACKED" -ne "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_UNTRACKED}${GIT_UNTRACKED}${RESET_COLOR}"
        fi

        # Clean Workdir indicator
        if [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
            PROMPT="${PROMPT}${THEME_GIT_PROMPT_CLEAN}"
        fi

        PROMPT="${PROMPT}${RESET_COLOR}${THEME_GIT_PROMPT_SUFFIX}"

        echo -en "$PROMPT "
    fi
}

