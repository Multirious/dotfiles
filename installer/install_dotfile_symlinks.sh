# These variables must be the same with .zshenv
# except this one
DOTFILES=~/.dotfiles/files

# In $HOME, default be ~
HOME=~
ln -sv $DOTFILES/.zshenv $HOME
ln -sv $DOTFILES/.aliases $HOME

# In $XDG_CONFIG_HOME, default be ~/.config
DOTFILES_XDG_CONFIG_HOME=$DOTFILES/.config
XDG_CONFIG_HOME=~/.config
[ ! -d ~/.config ] && mkdir -vp $XDG_CONFIG_HOME
ln -sv $DOTFILES_XDG_CONFIG_HOME/helix $XDG_CONFIG_HOME
ln -sv $DOTFILES_XDG_CONFIG_HOME/tmux $XDG_CONFIG_HOME
ln -sv $DOTFILES_XDG_CONFIG_HOME/zsh $XDG_CONFIG_HOME
ln -sv $DOTFILES_XDG_CONFIG_HOME/git $XDG_CONFIG_HOME

# Specialized config locations (none yet)
