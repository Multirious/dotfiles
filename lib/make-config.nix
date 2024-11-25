{ callPackage, pkgs, lib }:
let
  inherit (lib.lists) foldl;
  mkConfig =
    { name,
      files,
      buildPhase ? null,
      dontPatch ? false
    }:
    let
      fileArgs = foldl
        (list: name:
          let
            value = files."${name}";
            type = builtins.typeOf value;
          in
          if !(type == "string" || type == "path")
          then throw "Expected `string` or `path` type, found `${type}` for `${name}`"
          else
          list ++ ( [ name value ] )
        )
        []
        (builtins.attrNames files);
    in
    derivation {
      inherit name;
      system = builtins.currentSystem;
      builder = "${pkgs.bash}/bin/bash";
      args = [ ./config-builder.sh ] ++ fileArgs;
      coreutils = pkgs.coreutils;
    };
in
{ inherit mkConfig; }
