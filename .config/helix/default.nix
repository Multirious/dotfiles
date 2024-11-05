{ pkgs }:
let
  configs = pkgs.callPackage ./configs.nix {};
in
derivation {
  name = "dotconfig-helix";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./build.sh ];
  inherit (pkgs) coreutils;
  config_editor = configs.editor;
  config_languages = configs.languages;
}
