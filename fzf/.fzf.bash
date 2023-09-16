# Setup fzf
# ---------
if [[ ! "$PATH" == */home/gbrl18/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/gbrl18/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/gbrl18/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/gbrl18/.fzf/shell/key-bindings.bash"

export FZF_DEFAULT_COMMAND="fd -H --color=always"
export FZF_CTRL_T_COMMAND="$FZF_CTRL_T_COMMAND"
export FZF_DEFAULT_OPTS="--ansi --color=always"

# export FZF_DEFAULT_OPTS='--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
# export FZF_DEFAULT_OPTS='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
