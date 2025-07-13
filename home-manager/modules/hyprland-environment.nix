{ config, pkgs, lib, externalPkgs, ... }:
let
  cfg = config.myModules.hyprlandEnvironment;
  Hyprspace = externalPkgs.Hyprspace.packages.${pkgs.system}.Hyprspace;
  hypr-dynamic-cursors = externalPkgs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors;
in
{
  options.myModules.hyprlandEnvironment.enable = lib.mkEnableOption "Enable configuration and applications for using Hyprland";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        wl-clipboard
        wofi
        waybar
        hyprpaper
        swaylock-effects
        hypridle
        mako
        hyprpolkitagent
        zenity
      ];
      home.file.".local/state/hyprland/plugins.conf".text = ''
        # plugin = ${Hyprspace}/lib/lib${Hyprspace.pname}.so
        # plugin = ${hypr-dynamic-cursors}/lib/libhypr-dynamic-cursors.so
      '';
  };
}
