# === [ some zsh configs ]
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="dd/mm/yyyy"

# === [ navigation ]
setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd .

# === [ completion ]
source $XDG_CONFIG_HOME/zsh/completion.zsh

# === [ aliases ]
source $XDG_CONFIG_HOME/aliases/aliases.sh

# === [ scripts ]
source $XDG_CONFIG_HOME/zsh/scripts.zsh

# === [ zplug ]
source $XDG_CONFIG_HOME/zsh/zplug.zsh

# === [ p10k theme ]
# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# === [ tmux on startup]
# See https://unix.stackexchange.com/questions/43601/how-can-i-set-my-default-shell-to-start-up-tmux 
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  read "reply?Run tmux? (y)"$'\n'"> "
  if [[ "$reply" =~ ^[Yy]$ ]]; then
    tmux new-session -A -s main
  fi
fi

