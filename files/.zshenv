export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# source cargo env
# if there is one
[ -f "$HOME/.cargo/env"  ] && . "$HOME/.cargo/env"
