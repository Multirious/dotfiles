export PATH="$coreutils/bin"

mkdir $out
ln -s $files $out/files
echo "$nix_link_script" > $out/link
echo "$cached_link_script" > $out/link_cached
echo "$update_cache_script" > $out/update_cache
chmod +x $out/link
chmod +x $out/update_cache
