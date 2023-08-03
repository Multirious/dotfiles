curl -s https://api.github.com/repos/helix-editor/helix/releases/latest \
| grep "browser_download_url.*-x86_64.AppImage" \
| grep -v "zsync" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi - -O ~/.local/bin/hx
chmod a+x ~/.local/bin/hx

git clone https://github.com/helix-editor/helix /tmp/helix
cp /tmp/helix/runtime ~/.config/helix

