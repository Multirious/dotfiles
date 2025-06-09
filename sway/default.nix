{ config, lib, ... }:
let
  cfg = config.sway;
in
{
  options.sway.enable = lib.mkEnableOption "Enable Sway configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/sway/config" = ./config;
  };
}
