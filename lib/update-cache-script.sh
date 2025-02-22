if [[ $# != 2 ]]; then
  echo "Expected directory of the files and the resulting cache directory"
  exit 1
fi

files_dir="$1"
result_cache_dir="$2"

if [[ ! -f "$files_dir/names" ]]; then
  echo "$files_dir/names does not exists"
  exit 1
fi

shopt -s extglob

if [ -d "$result_cache_dir" ]; then
  if [[ ! -f "$result_cache_dir/.dotfiles-cache" ]]; then
    echo "WARNING: $result_cache_dir/.dotfiles-cache not found"
    echo "This script checks for that file to prevent accidental rm -rf on an unsuspecting directory"
    exit 1
  fi
  rm -rf "$result_cache_dir"
else
  mkdir "$result_cache_dir"
  touch "$result_cache_dir/.dotfiles-cache"
fi

cp -Lr --preserve=mode "$files_dir/." "$result_cache_dir"
chmod -R +w "$result_cache_dir"
