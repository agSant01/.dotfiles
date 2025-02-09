print_git_branch() {
  local working_dir=$(tmux display-message -p "#{pane_current_path}")

  local branch
  if [ "$(cd $working_dir && git config --get core.bare)" = "true" ]; then
    branch="bare.git"
  else
    branch=$(cd "$working_dir" && git symbolic-ref --short HEAD)
  fi

  if [ $branch ]; then
    echo "git:($branch) "
  fi
}

print_git_branch
