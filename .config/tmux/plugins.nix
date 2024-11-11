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
} // (
  let
    pluginsText = lib.concatMapStringsSep
      "\n"
      (p:
        let 
          preConfig = if builtins.hasAttr "preConfig" p
            then "${lib.trim p.preConfig}\n"
            else "";
          postConfig = if builtins.hasAttr "postConfig" p
            then "\n${lib.trim p.postConfig}"
            else "";
          runPlugin = "run-shell '#{d:current_file}/plugins/${lib.removePrefix "/nix/store/" (pluginRtp p)}'";
        in
        ''
          # ${pluginName p}
          # ---------------------
          ${preConfig}${runPlugin}${postConfig}
        ''
      )
      (if dontpatch then unpatchedPlugins else plugins);
  in
  {
    configText = ''
      ${pluginsText}
      # ============================================= #
    '';
  }
)

