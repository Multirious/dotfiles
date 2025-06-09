{ config, lib, ... }:
let
  cfg = config.starship;
in
{
  options.starship.enable = lib.mkEnableOption "Enable Starhip configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/starship.toml" = ./starship.toml;
  };
}
