{ config, lib, ... }:
let
  cfg = config.hypr;
in
{
  options.hypr.enable = lib.mkEnableOption "Enable Hyprland and plugins";
  config.files = lib.mkIf cfg.enable {
    ".config/hypr/hyprland.conf" = ./hyprland.conf;
    ".config/hypr/hyprpaper.conf" = ./hyprpaper.conf;
    ".config/hypr/hypridle.conf" = ./hypridle.conf;
    ".config/hypr/scripts" = ./scripts;
  };
}
