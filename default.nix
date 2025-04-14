{ pkgs ? import <nixpkgs> {}, }: 
let
  mkFiles = (callPackage ./lib/make-files.nix {}).mkFiles;
  callFilePackages = filePackages:
    let
      filesList =
        (builtins.map
          (filePackage:
            (callPackage filePackage {}).files
          )
          filePackages
        );
    in
    builtins.foldl'
      (allFiles: files: allFiles // files)
      {}
      filesList;
  inherit (pkgs) callPackage;
in
mkFiles (callFilePackages [
  ./bash
  ./helix
  ./shell
  ./tmux
  ./git
  ./home-manager
  ./sh
  ./starship
  ./zsh
  ./kitty
  ./sway
  ./swaylock-effects
  ./waybar
  ./misc
  ./hypr
  ./mako
])
