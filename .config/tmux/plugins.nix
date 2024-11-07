{ pkgs, lib, plugins, ... }:
let
  pluginName = p: if lib.types.package.check p then p.pname else p.plugin.pname;
  pluginRtp = p: if lib.types.package.check p then p.rtp else p.plugin.rtp;
  pluginOut = p: if lib.types.package.check p then p.outPath else p.plugin.outPath;
in
derivation {
  name = "dotconfig-tmux-plugins";
  system = builtins.currentSystem;
  builder = [ "${pkgs.bash}/bin/bash" ];
  args = [ ./build_plugins.sh ];
  coreutils = "${pkgs.coreutils}/bin";
  plugins_store_path = "${builtins.toString (map (p: pluginOut p) plugins)}";
} // {
  config_text = ''
    ${
      lib.concatMapStringsSep
        "\n\n"
        (p: ''
          # ${pluginName p}
          # ---------------------
          ${p.config or ""}
          run-shell '#{d:current_file}/plugins/${lib.removePrefix "/nix/store/" (pluginRtp p)}''\'''
        )
        plugins
    }
    # ============================================= #
  '';
}
