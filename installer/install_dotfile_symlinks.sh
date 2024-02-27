#!/bin/sh

script_dir="$(realpath .)"
files="$script_dir"/files

# In $HOME, default be ~
HOME=~
ln -sv $DOTFILES/.zshenv $HOME

# In $XDG_CONFIG_HOME, default be ~/.config
df_xdg_config_home=$dotfiles/.config
XDG_CONFIG_HOME=~/.config
[ ! -d ~/.config ] && mkdir -vp $XDG_CONFIG_HOME
ln -sv $df_xdg_config_home/helix $XDG_CONFIG_HOME
ln -sv $df_xdg_config_home/tmux $XDG_CONFIG_HOME
ln -sv $df_xdg_config_home/zsh $XDG_CONFIG_HOME
ln -sv $df_xdg_config_home/git $XDG_CONFIG_HOME
ln -sv $df_xdg_config_home/systemd $XDG_CONFIG_HOME

# Specialized config locations (none yet)
