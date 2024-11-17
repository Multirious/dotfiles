{ pkgs, dontpatch ? false }:
let 
  configs = pkgs.callPackage ./configs.nix {};
  plugins = pkgs.callPackage ./plugins.nix {
    inherit (configs) plugins;
    inherit dontpatch;
  };
  keyBindings = pkgs.callPackage ./modal_keymap.nix {
    inherit (configs) keymap;
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
  key_bindings = "${keyBindings}";
}
