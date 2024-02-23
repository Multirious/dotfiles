source $XDG_CONFIG_HOME/zplug/init.zsh

# === [ plugins ]

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zsh-users/zsh-autosuggestions", use:"zsh-autosuggestions.zsh", depth:1
zplug "jeffreytse/zsh-vi-mode"

# === [ configurations ]

#    --- [ "jeffreytse/zsh-vi-mode" ]
function zvm_config() {
    ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}

# === [ loading plugins ]

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
