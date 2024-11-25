{ callPackage, pkgs }:
let
  mkDotfiles = callFiles: 
    let
      patchedFiles = callFiles { dontPatch = false; };
      unpatchedFiles = callFiles { dontPatch = true; };
      names = builtins.toString (builtins.attrNames patchedFiles.names);
      scripts = callPackage ./scripts.nix {
        inherit names;
        inherit patchedFiles;
        inherit unpatchedFiles;
      };
    in
    derivation {
      name = "dotfiles";
      system = builtins.currentSystem;
      builder = "${pkgs.bash}/bin/bash";
      coreutils = pkgs.coreutils;
      args = [ ./dotfiles-builder.sh ];
      inherit (scripts) nixLinkScript;
      inherit (scripts) cachedLinkScript;
      inherit (scripts) updateCacheScript;
      inherit patchedFiles;
      inherit unpatchedFiles;
    };
in
{ inherit mkDotfiles; }
