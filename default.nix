{
  pkgs ? import <nixpkgs> {
    overlays = [
      (final: prev:
        let
          keyMappings = import ./keyMappings;
        in
        {
          inherit keyMappings;
        }
      )
    ];
    config = {};
  },
}: 
let
  mkFiles = (callPackage ./lib/make-files.nix {}).mkFiles;
  inherit (pkgs) callPackage;
in
mkFiles (
     (callPackage ./bash         {}).files
  // (callPackage ./helix        {}).files
  // (callPackage ./shell        {}).files
  // (callPackage ./tmux         {}).files
  // (callPackage ./git          {}).files
  // (callPackage ./home-manager {}).files
  // (callPackage ./sh           {}).files
  // (callPackage ./starship     {}).files
  // (callPackage ./zsh          {}).files
)
