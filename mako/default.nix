{ config, lib, ... }:
let
  cfg = config.mako;
in
{
  options.mako.enable = lib.mkEnableOption "Enable Mako configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/mako/config" = ./config;
  };
}
