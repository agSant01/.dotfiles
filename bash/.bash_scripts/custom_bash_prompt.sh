custom_prompt() {
    local exit_code="$?"
    term_width=$(tput cols)

    current_dir="$(pwd)"

    # check if current is $HOME
    current_dir=${current_dir/"$HOME"/'~'}
    cwd_len="${#current_dir}"

    user_host_prompt="$(whoami)@$(hostname)"
    user_host_prompt_len=$((${#user_host_prompt}+$cwd_len+1))

    git_status_msg=$(git_super_status)
    git_status_len=$(echo "$git_status_len" | sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g')
    git_status_len=${#git_status_len}

    user_path_divider=""
    git_path_divider=""

    if [ $(($user_host_prompt_len+$git_status_len)) -gt $term_width ]; then
        user_path_divider="\n\e"
        if [ $(($cwd_len+$git_status_len)) -gt $term_width ]; then
            git_path_divider="\n\e"
        fi
    fi

    # other options: ○ ● ◌ ◎ • ◦
    local STATUS_COLOR="$OK_PS1●"
    if [ "$exit_code" -ne 0 ]; then
        STATUS_COLOR="$ERROR_PS1○"
    fi

    if [ "$exit_code" -ne 0 ]; then
        EXIT_CODE="$ERROR_PS1($exit_code)${RESET_COLOR}"
    else
        EXIT_CODE=""
    fi

    HOST_PATH="${STATUS_COLOR}${RESET_COLOR} $GREEN${user_host_prompt}${RESET_COLOR} $user_path_divider$BLUE$current_dir${RESET_COLOR} "
    EXTENSIONS="$git_path_divider$git_status_msg${RESET_COLOR}$YELLOW$(python_virtualenv)\e[01;32m$(node_version)${RESET_COLOR}"

    echo -en "${HOST_PATH}${EXTENSIONS}${EXIT_CODE}"
}