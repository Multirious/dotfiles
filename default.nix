{
  pkgs ? import <nixpkgs> {
    overlays = [
      (final: prev: {
        lib = prev.lib.extend (libFinal: libPrev: {
          inherit  (prev.callPackage ./mylib.nix {}) attrsToKv;
        });
      })
    ];
    config = {};
  }
}: 
let
  files = pkgs.callPackage ./files.nix {};
  link_script = /* bash */ ''
    #!${pkgs.bash}/bin/bash

    export PATH="${pkgs.coreutils}/bin"

    files_dir="${files}"

    paths="${ builtins.toString (builtins.attrNames files.names) }"

    if [ -z ''${HOME+x} ]; then
      echo "HOME variable is unsetted"
      exit 1
    fi

    unavailable_paths=""
    for path in $paths; do
      path="$HOME/$path"

      if [ ! -e "$path" ] || { [ -L "$path" ] && [[ $(readlink -f "$path") =~ /nix/store* ]]; }; then
        :
      else
        unavailable_paths="$path $unavailable_paths"
      fi
    done

    if [[ $unavailable_paths != "" ]]; then
      echo "These paths are not available for linking. Please either remove or back them up."
      echo "''${unavailable_paths// /$'\n'}"
      exit 1
    fi

    linked="false"
    for path in $paths; do
      [ $(readlink -f "$files_dir/$path") -nt $(readlink -f "$HOME/$path") ]
      if [[ "$(readlink -f "$files_dir/$path")" != "$(readlink -f "$HOME/$path")" ]]; then
        if [ -e "$HOME/$path" ]; then
          rm "$HOME/$path"
          ln -s "$files_dir/$path" "$HOME/$path"
          echo "Replaced ~/$path"
        else
          ln -s "$files_dir/$path" "$HOME/$path"
          echo "Created ~/$path"
        fi
        linked="true"
      fi
    done

    if [[ $linked == "false" ]]; then
      echo "No new links were created"
    fi
  '';
in
derivation {
  name = "dotfiles";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  coreutils = pkgs.coreutils;
  args = [ ./build.sh ];
  inherit link_script;
  inherit files;
}
