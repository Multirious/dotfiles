# In $HOME
ln -sv ~/.dotfiles/files/.gitconfig ~/.gitconfig
ln -sv ~/.dotfiles/files/.zshrc ~/.zshrc
ln -sv ~/.dotfiles/files/.zshenv ~/.zshenv

# In $XDG_CONFIG_HOME
[ ! -d ~/.config ] && mkdir -v ~/.config
ln -sv ~/.dotfiles/files/.config/helix ~/.config/helix
ln -sv ~/.dotfiles/files/.config/tmux ~/.config/tmux

# Specialized config locations
[ ! -d ~/.cargo ] && mkdir -v ~/.cargo
ln -sv ~/.dotfiles/files/.cargo/cargo.toml ~/.cargo/cargo.toml
