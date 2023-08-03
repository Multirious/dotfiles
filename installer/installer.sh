# ================================================================================ #
echo "> Prerequisite"
echo ">     Initializing necessary directoies"
./prerequisite_dirs.sh

echo "> Installing apps with apt"
./apt_installs.sh

echo "> Installing apps without a package manager"
echo ">     Installing helix"
./install_helix.sh
echo ">     Installing tpm"
./install_tpm.sh
echo ">     Installing rust"
./install_rust.sh
echo ">     Installing more rust env"
./install_rust_env.sh

echo ">     Installing oh my zsh"
echo "      Remember to exit zsh to continue!"
./install_ohmyzsh.sh

echo "> Apps Prerequisite"
echo ">     Installing fonts"
./install_fonts.sh
echo ">     Generating SSH key"
./generate_ssh_key.sh

echo "> Linkin' dot files"
./link_dotfiles.sh
