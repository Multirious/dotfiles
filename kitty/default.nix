{ config, lib, ... }:
let
  cfg = config.kitty;
in
{
  options.kitty.enable = lib.mkEnableOption "Enable Kitty configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/kitty/kitty.conf" = ./kitty.conf;
  };
}
