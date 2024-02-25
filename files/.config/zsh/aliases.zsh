# === [ zsh ]
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# === [ helix ]
alias shx="sudo /home/peach/.local/bin/hx --config $XDG_CONFIG_HOME/helix/config.toml"

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

alias gcc="gcm \"Commit from $(hostname)\""
alias gccc="gcm \"Continue from $(hostname)\""
alias ggcc="gaa; gcm \"Commit from $(hostname)\"; gph"
alias ggccc="gaa; gcm \"Continue from $(hostname)\"; gph"

# === [ tmux ]
alias tma='tmux attach'
alias tmls='tmux ls'
alias texit='tmux kill-session -t'

alias pg='program'

# === [ others]
alias clear="clear -x"

# === [ notify ]
alias bell='tput bel' # ring system bell notification
alias ping='dc_notify ""'

# === [ wsl ]
alias wsl_compact_memory='echo 1 | sudo tee /proc/sys/vm/compact_memory'
alias wsl_drop_caches='echo 1 | sudo tee /proc/sys/vm/drop_caches'

