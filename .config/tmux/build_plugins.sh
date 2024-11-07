export PATH="$coreutils"
mkdir $out
for plugin_store_path in $plugins_store_path; do
  ln -s "$plugin_store_path" "$out/$(basename $plugin_store_path)"
done
