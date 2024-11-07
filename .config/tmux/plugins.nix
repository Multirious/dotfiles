{ pkgs, lib, plugins, dontpatch ? false }:
let
  isPackage = lib.types.package.check;
  pluginName = p: if isPackage p then p.pname else p.plugin.pname;
  pluginRtp = p: if isPackage p then p.rtp else p.plugin.rtp;
  pluginOut = p: if isPackage p then p.outPath else p.plugin.outPath;
  unpatchedPlugins = builtins.map
    (p: if isPackage p
      then p.overrideAttrs (attrs: { dontPatchShebangs = true; })
      else p // { plugin = p.plugin.overrideAttrs (attrs: { dontPatchShebangs = true; }); }
    )
    plugins;
in
derivation {
  name = "dotconfig-tmux-plugins";
  system = builtins.currentSystem;
  builder = [ "${pkgs.bash}/bin/bash" ];
  args = [ ./build_plugins.sh ];
  coreutils = "${pkgs.coreutils}/bin";
  plugins_store_path = builtins.toString (
    map
      (p: pluginOut p)
      (if dontpatch then unpatchedPlugins else plugins)
  );
} // {
  configText = ''
    ${
      lib.concatMapStringsSep
        "\n\n"
        (p: ''
          # ${pluginName p}
          # ---------------------
          ${p.config or ""}
          run-shell '#{d:current_file}/plugins/${lib.removePrefix "/nix/store/" (pluginRtp p)}''\'''
        )
        (if dontpatch then unpatchedPlugins else plugins)
    }
    # ============================================= #
  '';
}
