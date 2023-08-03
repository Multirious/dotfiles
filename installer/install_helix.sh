# find latest release and install
curl -s https://api.github.com/repos/helix-editor/helix/releases/latest \
| grep "browser_download_url.*-x86_64.AppImage" \
| grep -v "zsync" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - -O ~/.local/bin/hx

# make it executable
chmod a+x ~/.local/bin/hx

# download the whole repo for a single runtime folder
git clone https://github.com/helix-editor/helix /tmp/helix

# put runtime folder in config
[ ! -d ~/.config/helix ] && mkdir --verbose -p ~/.config/helix
cp /tmp/helix/runtime ~/.config/helix
