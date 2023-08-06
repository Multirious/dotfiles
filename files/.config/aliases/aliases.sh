#!/usr/bin/env bash

# === [ zsh ]
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# === [ helix ]
alias shx="sudo hx --config $XDG_CONFIG_HOME/helix/config.toml"

# === [ edit ]
alias edal="$EDITOR $XDG_CONFIG_HOME/aliases/aliases.sh"
alias edrc="$EDITOR $XDG_CONFIG_HOME/zsh/.zshrc"
alias edenv="$EDITOR ~/.zshenv"
alias edplug="$EDITOR $XDG_CONFIG_HOME/zsh/zplug.zsh"
alias edscpt="$EDITOR $XDG_CONFIG_HOME/zsh/scripts.zsh"

# === [ ls ]
alias ls='ls --color=auto'
alias l='ls -l'
alias ll='ls -lahF'
alias lls='ls -lahFtr'
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
alias tma='tmux a -t'

# === [ cargo ]
alias cgr='cargo run'
alias cgb='cargo build'
alias cgt='cargo test'
alias cgd='cargo +nightly doc --open --all-features --no-deps'
