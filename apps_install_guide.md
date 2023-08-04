# Apps install guide 
This is mostlikely not a full installation but more like a quick guide.
> ℹ️ **_Note_**: Symlinks should be already installed before installing app. (i'm not sure if there are gonna be any problem)

## Install with apt
```sh
sudo apt install tmux zsh curl git man wget fuse
```

## Manual ones

### zsh
If you already installed zsh,
run 
```sh
chsh -s $(which zsh)
```
to set zsh as the default shell.

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
   cp /tmp/helix/runtime ~/.config/helix
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
