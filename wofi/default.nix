{ config, lib, ... }:
let
  cfg = config.wofi;
in
{
  options.wofi.enable = lib.mkEnableOption "Enable Wofi configuration";
  config = lib.mkIf cfg.enable {
    files = {
      ".config/wofi/config" = ./config;
      ".config/wofi/style.css" = ./style.css;
    };
  };
}

