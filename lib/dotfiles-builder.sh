export PATH="$coreutils/bin"

mkdir $out
ln -s $patchedFiles $out/patched_files
ln -s $unpatchedFiles $out/unpatched_files
echo "$nixLinkScript" > $out/link
echo "$cachedLinkScript" > $out/link_cached
echo "$updateCacheScript" > $out/update_cache
chmod +x $out/link
chmod +x $out/update_cache
