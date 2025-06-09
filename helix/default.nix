{ config, lib, ... }:
let
  cfg = config.helix;
in
{
  options.helix.enable = lib.mkEnableOption "Enable Helix configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/helix/config.toml" = ./config.toml;
    ".config/helix/languages.toml" = ./languages.toml;
  };
}
