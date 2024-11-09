# currently extremely basic because i don't know shit
autoload -U compinit; compinit

_comp_options+=(globdots) # With hidden files

# menu style
zstyle ':completion:*' menu select
