{ pkgs, dontpatch ? false }:
let 
  configs = pkgs.callPackage ./configs.nix {};
  plugins = pkgs.callPackage ./plugins.nix {
    inherit (configs) plugins;
    inherit dontpatch;
  };
in
derivation {
  name = "dotconfig-tmux";
  system = builtins.currentSystem;
  builder = [ "${pkgs.bash}/bin/bash" ];
  args = [ ./build.sh ];
  coreutils = "${pkgs.coreutils}/bin";
  inherit (configs) config;
  plugins_config = plugins.configText;
  plugins = "${plugins}";
}
