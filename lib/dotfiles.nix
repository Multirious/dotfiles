{ pkgs }:
let
  mkFiles = (pkgs.callPackage ./make-files.nix {}).mkFiles;
  dotfiles = modules:
    let
      module = (pkgs.lib.evalModules {
        specialArgs = {
          inherit pkgs;
        };
        modules = [
          ./dotfiles-module.nix
        ] ++ modules;
      });
    in
    mkFiles module.config.files;
in
{ inherit dotfiles; }
