{ config, lib, ... }:
let
  cfg = config.home-manager;
in
{
  options.home-manager.enable = lib.mkEnableOption "Enable Home-manager configuration";
  config.files = lib.mkIf cfg.enable {
    ".config/home-manager" = ./.;
  };
}
