{ pkgs, names, patchedFiles, unpatchedFiles }:
let 
  cachedLinkScript= /* bash */ ''
    #!/bin/bash
    files_dir="$(dirname $(realpath "$0"))"

    ${commonLinkScript}
  '';
  nixLinkScript= /* bash */ ''
    #!${pkgs.bash}/bin/bash
    export PATH="${pkgs.coreutils}/bin"
    files_dir="${patchedFiles}"

    ${commonLinkScript}
  '';
  commonLinkScript = /* bash */ ''
    names="${names}"

    if [ -z ''${HOME+x} ]; then
      echo "HOME variable is unsetted"
      exit 1
    fi

    if [[ $1 == "-f" ]]; then
      force="true"
    fi

    unavailable_paths=""
    if [[ $force != "true" ]]; then
      for name in $names; do
        path="$HOME/$name"

        if \
          [ ! -e "$path" ] \
          || { [ -L "$path" ] && [[ "$(readlink -f "$path")" =~ /nix/store* ]]; } \
          || { [ -L "$path" ] && [[ "$(readlink -f "$path")" == "$(readlink -f "$files_dir/$name")" ]]; } \
        then
          :
        else
          unavailable_paths="$path $unavailable_paths"
        fi
      done
    fi

    if [[ $unavailable_paths != "" ]]; then
      echo "These paths are not available for linking."
      echo "Please either remove, back them up, or use the -f flag to replace the files."
      echo "''${unavailable_paths// /$'\n'}"
      exit 1
    fi

    linked="false"
    for name in $names; do
      if [[ "$(readlink -f "$files_dir/$name")" != "$(readlink -f "$HOME/$name")" ]]; then
        if [ -e "$HOME/$name" ] || [ -L "$HOME/$name" ]; then
          rm "$HOME/$name"
          ln -s "$files_dir/$name" "$HOME/$name"
          nix-store --add-root "$HOME/$name" --realise
          echo "Replaced ~/$name"
        else
          ln -s "$files_dir/$name" "$HOME/$name"
          nix-store --add-root "$HOME/$name" --realise
          echo "Created ~/$name"
        fi
        linked="true"
      fi
    done

    if [[ $linked == "false" ]]; then
      echo "No new links were created"
    fi
  '';
  updateCacheScript= /* bash */ ''
    #!${pkgs.bash}/bin/bash
    export PATH="${pkgs.coreutils}/bin"

    if [[ $# != 1 ]]; then
      echo "Expects one directory as an argument"
      exit 1
    fi

    files="${unpatchedFiles}"
    dir="$1"

    shopt -s extglob

    if [ -d "$dir/cached" ]; then
      rm -rf "$dir/cached"
    else
      mkdir "$dir/cached"
    fi
    
    cp -Lr --preserve=mode "$files/." "$dir/cached"
    chmod -R +w "$dir/cached"
    cp -L "$(dirname $(realpath "$0"))/link_cached" "$dir/cached"
    chmod +wx "$dir/cached/link_cached"
  '';
in
{
  inherit cachedLinkScript;
  inherit nixLinkScript;
  inherit updateCacheScript;
}
