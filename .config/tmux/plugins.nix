{ pkgs, lib, plugins, dontPatch ? false }:
let
  isPackage = lib.types.package.check;
  pluginPname = p: if isPackage p then p.pname else p.plugin.pname;
  pluginName = p: if isPackage p then p.pluginName else p.plugin.pluginName;
  pluginRtp = p: if isPackage p then p.rtp else p.plugin.rtp;
  pluginOutPath = p: if isPackage p then p.outPath else p.plugin.outPath;
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
      (p: pluginOutPath p)
      (if dontPatch then unpatchedPlugins else plugins)
  );
} // (
  let
    pluginsText = lib.concatMapStringsSep
      "\n"
      (p:
        let 
          pluginRtpPath = lib.removePrefix "/nix/store/" (pluginRtp p);
          pluginDir = lib.removePrefix "/nix/store/" (pluginOutPath p);
          runPlugin = "run-shell '#{d:current_file}/plugins/${pluginRtpPath}'";
          pre = if builtins.hasAttr "pre" p
            then "${lib.trim p.pre}\n"
            else "";
          post = if builtins.hasAttr "post" p
            then if builtins.isFunction p.post
              then "\n${lib.trim (p.post "/home/peach/.config/tmux/plugins/${pluginDir}/share/tmux-plugins/${lib.removePrefix "tmux-plugin" (pluginName p.plugin)}")}" 
              else "\n${lib.trim p.post}"
            else "";
        in
        ''
          # ${pluginPname p}
          # ---------------------
          ${pre}${runPlugin}${post}
        ''
      )
      (if dontPatch then unpatchedPlugins else plugins);
  in
  {
    configText = ''
      ${pluginsText}
      # ============================================= #
    '';
  }
)

