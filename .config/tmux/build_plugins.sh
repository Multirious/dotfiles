export PATH="$coreutils"
mkdir $out
for path in $plugins_store_path; do
  ln -s "$path" "$out/$(basename "$path")"
done
