# In $HOME
ln -s ~/.dotfiles/files/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/files/.zshrc ~/.zshrc
ln -s ~/.dotfiles/files/.zshenv ~/.zshenv

# In $XDG_CONFIG_HOME
[ & -d ~/.config ] && mkdir --verbose ~/.config
ln -s ~/.dotfiles/files/.config/helix ~/.config/helix
ln -s ~/.dotfiles/files/.config/tmux ~/.config/tmux

# Specialized config locations
[ & -d ~/.cargo ] && mkdir --verbose ~/.cargo
ln -s ~/.dotfiles/files/.cargo/cargo.toml ~/.cargo/cargo.toml
