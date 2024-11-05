export PATH="$coreutils/bin"

mkdir $out
ln -s $files $out/files
echo "$link_script" > $out/link
chmod +x $out/link
