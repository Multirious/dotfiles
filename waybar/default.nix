{ config, lib, ... }:
let
  cfg = config.waybar;
in
{
  options.waybar.enable = lib.mkEnableOption "Enable Waybar configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/waybar/config.jsonc" = ./config.jsonc;
    ".config/waybar/style.css" = ./style.css;
    ".config/waybar/mediaplayer.py" = ./mediaplayer.py;
    ".config/waybar/power_menu.xml" = ./power_menu.xml;
  };
}
