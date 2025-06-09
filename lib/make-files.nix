{ pkgs }:
let
  attrsToKv = attrs:
    pkgs.lib.concatStringsSep "\n"
    (map
      (k: "${k}=${attrs.${k}}")
      (builtins.attrNames attrs)
    );
  mkFiles = names: derivation {
    name = "dotfiles";
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./files-builder.sh ];
    coreutils = pkgs.coreutils;
    system = builtins.currentSystem;
    paths = attrsToKv names;
    linkNixed= /* bash */ ''
      #!${pkgs.bash}/bin/bash
      export PATH="${pkgs.coreutils}/bin"

      ${ builtins.readFile ./link-script.sh }
    '';
    updateCache= /* bash */ ''
      #!${pkgs.bash}/bin/bash
      export PATH="${pkgs.coreutils}/bin"

      ${ builtins.readFile ./update-cache-script.sh }
    '';
  };
in
{ inherit mkFiles; }
