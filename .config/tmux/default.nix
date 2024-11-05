{ pkgs }:
let 
  configs = pkgs.callPackage ./configs.nix {};
  plugins_config = pkgs.callPackage ./plugins.nix { inherit (configs) plugins; };
in
derivation {
  name = "dotconfig-tmux";
  system = builtins.currentSystem;
  builder = [ "${pkgs.bash}/bin/bash" ];
  args = [ ./build.sh ];
  coreutils = "${pkgs.coreutils}/bin";
  inherit (configs) config;
  inherit plugins_config;
}
