ssh-keygen -t ed25519 -C "multirious@outlook.com"
clip < ~/.ssh/id_ed25519.pub
echo "Now me, put that ssh key in my github"
read -p "Press enter to continue"
