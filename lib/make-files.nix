{ pkgs, dontPatch ? false }:
let
  attrsToKv = attrs:
    pkgs.lib.concatStringsSep ":"
    (map
      (k: "${k}=${attrs.${k}}")
      (builtins.attrNames attrs)
    );
  mkFiles = names: derivation {
    name = "files";
    builder = "${pkgs.bash}/bin/bash";
    args = [ ./files-builder.sh ];
    coreutils = pkgs.coreutils;
    system = builtins.currentSystem;
    paths = attrsToKv names;
  } // {
    inherit names;
  };
in
{ inherit mkFiles; }
