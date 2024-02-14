# Apps install guide 
This is mostlikely not a full installation but more like a quick guide.
> [!NOTE]
> Symlinks should be already installed before installing app. (i'm not sure if there are gonna be any problem)

## Install with apt
```sh
sudo apt install tmux zsh curl git man wget fuse tldr fzf xclip
```

## Programming Environment
```sh
sudo apt install mingw-w64 gcc clang python3 python3-pip
```

## Manual ones

### zsh
If you've already installed zsh,
set zsh as the default shell by: 
```sh
chsh -s $(which zsh)
```

### zplug
See [repo](https://github.com/zplug/zplug).
If you've already installed zsh,
install zplug by:
```sh
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
```

### Helix
See [docs](https://docs.helix-editor.com/install.html) or quick guide below.
1. Find the prefered [release](https://github.com/helix-editor/helix/releases/).
2. Copy the link.
3. Installing Helix:
   ```sh
   curl -L <link> > ~/.local/bin/hx
   chmod a+x ~/.local/bin/hx # make it executable
   ```
4. Installing runtime folder.
   ```sh
   git clone --depth=1 https://github.com/helix-editor/helix /tmp/helix
   cp -r /tmp/helix/runtime ~/.config/helix
   ```

### Rust
See [homepage](https://www.rust-lang.org/tools/install).
```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### tpm
See [repo](https://www.rust-lang.org/tools/install)
```sh
# Instal tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins through some trickery
tmux start-server
tmux new-session -d
~/.tmux/plugins/tpm/scripts/install_plugins.sh
tmux kill-server
```

### ssh keys for github
See [this guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
```sh
ssh-keygen -t ed25519 -C "multirious@outlook.com"
clip < ~/.ssh/id_ed25519.pub
```

## WSL Utils
Stuff you may need for WSL

### wslu
extra functionality
[`wslu`](https://github.com/wslutilities/wslu)

### usbipd-win
usb support for WSL2
[`usbipd-win`](https://github.com/dorssel/usbipd-win)
