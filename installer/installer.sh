chmod +x ~/.dotfiles/installer/*

echo "> Linkin' dot files"
~/.dotfiles/installer/link_dotfiles.sh

echo "> Installing apps with apt"
~/.dotfiles/installer/apt_installs.sh

echo "> Installing apps without a package manager"
echo ">     Installing helix"
~/.dotfiles/installer/install_helix.sh
echo ">     Installing tpm"
~/.dotfiles/installer/install_tpm.sh
echo ">     Installing rust"
~/.dotfiles/installer/install_rust.sh

echo ">     Installing oh my zsh"
echo "      Exit zsh to continue app installation!"
~/.dotfiles/installer/install_ohmyzsh.sh

echo "> Apps Prerequisite"
echo ">     Installing fonts"
~/.dotfiles/installer/install_fonts.sh
echo ">     Generating SSH key"
~/.dotfiles/installer/generate_ssh_key.sh

echo "> Done!"
