#!/bin/bash

echo "Github token, please"
read gh_token
if [ -z "$gh_token" ]; then
    echo "No dotfiles for you"
    exit 1
fi

git clone "https://$gh_token@github.com/Multirious/dotfiles" ~/.dotfiles
~/.dotfiles/installer/install_dotfile_symlinks.sh
