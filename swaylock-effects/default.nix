{ config, lib, ... }:
let
  cfg = config.swaylock-effects;
in
{
  options.swaylock-effects.enable = lib.mkEnableOption "Enable swaylock-effects configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/swaylock/config" = ./config;
  };
}
