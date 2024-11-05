{ pkgs, ... }:
let
  configs = pkgs.callPackage ./configs.nix {};
in
derivation {
  name = "dotconfig-git";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  args = [ ./build.sh ];
  inherit (pkgs) coreutils;
  config = configs.config;
}
