# ================================================================================ #
echo "> Prerequisite"

echo ">     Initializing necessary directoies"
if [ ! -d ~/.local/bin ]; then
  mkdir --verbose -p ~/.local/bin
fi
if [ ! -d ~/.local/share ]; then
  mkdir --verbose -p ~/.local/share
fi
if [ ! -d ~/.local/share/font ]; then
  mkdir --verbose -p ~/.local/share/font
fi
if [ ! -d ~/.config ]; then
  mkdir --verbose -p ~/.config
fi

# ================================================================================ #
echo "> Updating and upgrading apt"

sudo apt -qq update
sudo apt -qq upgrade

# ================================================================================ #
echo "> Installing apt stuffs"

echo "(tmux, zsh, curl, git, man, wget, fuse)"
sudo apt -qq install tmux zsh curl git man wget fuse fontconfig

# ================================================================================ #
echo "> Installing more harder to install stuffs"

echo ">     Installing Helix editor"

curl -s https://api.github.com/repos/helix-editor/helix/releases/latest \
| grep "browser_download_url.*-x86_64.AppImage" \
| grep -v "zsync" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - -O ~/.local/bin/hx
chmod a+x ~/.local/bin/hx

echo ">     Downloading Rust installer and run"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo ">         Rust cross-compilation to Windows"
sudo apt-get -qq install mingw-w64
rustup target add x86_64-pc-windows-gnu

echo ">     Downloading ohmyzsh installer and run"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ================================================================================ #
echo "> Apps Prerequisite"

echo ">     Installing fonts"
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o ~/.local/share/MesloLGS_NF_Regular.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o ~/.local/share/MesloLGS_NF_Bold.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o ~/.local/share/MesloLGS_NF_Italic.ttf
curl -L https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o ~/.local/share/MesloLGS_NF_Bold Italic.ttf
fc-cache -f

echo ">     Generating SSH key"
ssh-keygen -t ed25519 -C "multirious@outlook.com"
clip < ~/.ssh/id_ed25519.pub

echo "Now me, put that ssh key in my github"
read -p "Press enter to continue"

# ================================================================================ #
echo "> Configurin' dot files"
