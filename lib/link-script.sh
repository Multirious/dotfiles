files_dir=$1

if [[ -z "files_dir" ]]; then
  echo "Requires dotfiles directory"
  exit 1
fi

names="$( < "$files_dir/names")"

if [ -z ${HOME+x} ]; then
  echo "HOME variable is unsetted"
  exit 1
fi

if [[ $2 == "-f" ]]; then
  force="true"
fi

unavailable_paths=""
if [[ $force != "true" ]]; then
  IFS=$'\n'
  for name in $names; do
    path="$HOME/$name"

    # path is available if
    # - path does not exists
    # - or path is a symlink but it's a link to the /nix/store
    # - or path is a symlink but it's a link to our dotfiles
    if [ ! -e "$path" ] \
      || { [ -L "$path" ] && [[ "$(readlink -f "$path")" =~ /nix/store* ]]; } \
      || { [ -L "$path" ] && [[ "$(readlink -f "$path")" == "$(readlink -f "$files_dir/$name")" ]]; } \
    then
      :
    else
      unavailable_paths="$unavailable_paths"$'\n'"$path"
    fi
  done
fi

if [[ $unavailable_paths != "" ]]; then
  echo "These paths are not available for linking."
  echo "Please either remove, back them up, or use the -f flag to replace the files."
  echo "${unavailable_paths}"
  exit 1
fi

linked="false"
IFS=$'\n'
for name in $names; do
  if [[ "$(readlink -f "$files_dir/$name")" != "$(readlink -f "$HOME/$name")" ]]; then
    if [ -e "$HOME/$name" ] || [ -L "$HOME/$name" ]; then
      rm "$HOME/$name"
      ln -s "$files_dir/$name" "$HOME/$name"
      echo "Replaced ~/$name"
    else
      if [[ ! -d "$(dirname "$HOME/$name")" ]]; then
        mkdir -p "$(dirname "$HOME/$name")"
      fi
      ln -s "$files_dir/$name" "$HOME/$name"
      echo "Created ~/$name"
    fi
    linked="true"
  fi
done

if [[ $linked == "false" ]]; then
  echo "No new links were created"
fi
