autoload -U compinit
compinit -d "$XDG_STATE_HOME/zsh/compdump"

_comp_options+=(globdots) # With hidden files

zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' menu select search

