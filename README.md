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
sudo apt-get -qqy install git
```
then
```sh
#!/bin/bash

echo "Github token, please"
read gh_token
if [ -z "$gh_token" ]; then
    echo "No dotfiles for you"
    exit 1
fi

git clone "https://$gh_token@github.com/Multirious/dotfiles" ~/.dotfiles
~/.dotfiles/installer/install_dotfile_symlinks.sh
```
