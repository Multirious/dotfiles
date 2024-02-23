#!/bin/bash

# === [ zsh ]
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# === [ helix ]
alias shx="sudo /home/peach/.local/bin/hx --config $XDG_CONFIG_HOME/helix/config.toml"

# # === [ edit ]
# alias edit="$EDITOR"
# alias file_aliases="$XDG_CONFIG_HOME/aliases/aliases.sh"
# alias file_rc="$XDG_CONFIG_HOME/zsh/.zshrc"
# alias file_env="~/.zshenv"
# alias file_zplug="$XDG_CONFIG_HOME/zsh/zplug.zsh"
# alias file_script="$XDG_CONFIG_HOME/zsh/scripts.zsh"

# === [ ls ]
alias ls='ls --color=auto'
alias l='ls -l'
alias ll='ls -lahF'
alias la='ls -A'
alias lc='ls -CF'

# === [ grep ]
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# === [ git ]
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gph='git push'
alias gpl='git pull'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias glo='git log --pretty="oneline"'
alias glol='git log --graph --oneline --decorate'
alias gsw='git switch'
alias gb='git branch'

# === [ tmux ]
alias tma='tmux_no_nest_attach'
alias tmls='tmux ls'
alias texit='tmux kill-session -t'
# quickly open up a project in mulgram with tmux

alias pq='
  find ~/my_files/projects/programming/current -maxdepth 2 -mindepth 2 |
    cut --characters=51- |
    fzf |
    xargs -I path zsh -c "
      cd ~/my_files/projects/programming/current/path &&
      tmux new-session -d -s path -n \"Edit n stuff\" &&
      tmux split-window -t path -h &&
      tmux select-pane -t 0 &&
      tmux send-keys -t path:0.0 \"hx .\" Enter &&
      tmux new-window -t path:1 -n \"Other\" &&
      tmux select-window -t path:1 &&
      tmux select-window -t path:0 &&
      tmux select-pane -t 1
    " &&
  tma
'

# === [ cargo ]
alias cgr='cargo run'
alias cgb='cargo build'
alias cgt='cargo test'
alias cgd='cargo +nightly doc --open --all-features --no-deps'
alias cgbt_w='CARGO_BUILD_TARGET=x86_64-pc-windows-gnu'

# === [ others]
alias clear="clear -x"

# === [ notify ]
alias bell='tput bel' # ring system bell notification
alias ping='dc_notify ""'

# === [ wsl ]
alias wsl_compact_memory='echo 1 | sudo tee /proc/sys/vm/compact_memory'
alias wsl_drop_caches='echo 1 | sudo tee /proc/sys/vm/drop_caches'

