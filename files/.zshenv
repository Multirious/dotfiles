#!/usr/bin/env zsh

# === [ terminal ]
# export TERM='rxvt-256color' # what is this cfg?
export COLORTERM=truecolor
export LANG=en_US.UTF-8

# === [ xdg ]
# see https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="$HOME/.local/share"    # at default
export XDG_CONFIG_HOME="$HOME/.config"       # at default
export XDG_STATE_HOME="$HOME/.local/state"   # at default
# export XDG_DATA_DIRS=""                    # list of colon seperated paths
# export XDG_CONFIG_DIRS=""                  # list of colon seperated paths
export XDG_CACHE_HOME="$HOME/.cache"         # at default
# export XDG_RUNTIME_DIR="/var/run/user/$USER" # https://serverfault.com/questions/388840/good-default-for-xdg-runtime-dir

# === [ zsh ]
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"   # move zsh to xdg config
export HISTFILE="$ZDOTDIR/zsh_history" # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

# === [ zplug ]
export ZPLUG_HOME="$XDG_CONFIG_HOME/zplug"

# === [ editor ]
export EDITOR="hx"
export VISUAL="hx"

# === [ languages ]

#    --- [ rust ]
export CARGO_HOME="$HOME/.cargo"
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# === [ other ]
export GIT_REPOS=$(readlink -f ~/git_repositories)

# === [ path ]
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
