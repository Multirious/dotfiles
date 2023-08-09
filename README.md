# My dotfiles

This repository contains configuration files for the following applications:
- tmux, tpm
- helix
- zsh, zplug
- git
- cargo

See this [guide](apps_install_guide.md) for installing them.

# Symlink Installation
for freshly just installed system if not you can skip:
```sh
sudo apt-get -qqy update
sudo apt-get -qqy upgrade
sudo aptget -qqy install git
```
then
```sh
git clone https://<pat>@github.com/Multirious/dotfiles ~/.dotfiles
~/.dotfiles/installer/install_dotfile_symlinks.sh
```
