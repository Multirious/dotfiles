{ callPackage }:
let
  mkConfig = callPackage ./make-config.nix {};
  mkDotfiles = callPackage ./make-dotfiles.nix {};
  mkFiles = callPackage ./make-files.nix {};
in
{
  inherit (mkConfig) mkConfig;
  inherit (mkDotfiles) mkDotfiles;
  inherit (mkFiles) mkFiles;
}
