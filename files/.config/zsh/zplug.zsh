source ~/.zplug/init.zsh

# === [ plugins ]

zplug "romkatv/powerlevel10k", as:theme, depth:1

# ===============

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
