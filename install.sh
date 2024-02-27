#!/bin/sh

script_dir="$(realpath .)"
files="$script_dir"/files

# In $HOME, default be ~
HOME=~
ln -sv $DOTFILES/.zshenv "$HOME"

# In $XDG_CONFIG_HOME, default be ~/.config
df_xdg_config_home="$files"/.config
XDG_CONFIG_HOME=~/.config
[ ! -d "$XDG_CONFIG_HOME" ] && mkdir -vp "$XDG_CONFIG_HOME"
for dir in "$df_xdg_config_home"/*; do
  ln -sv "$dir" "$XDG_CONFIG_HOME"
done

# Specialized config locations (none yet)
