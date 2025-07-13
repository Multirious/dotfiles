{ config, pkgs, lib, ... }:
let
  cfg = config.myModules.game;
in
{
  options.myModules.game.enable = lib.mkEnableOption "Enable";
  config = lib.mkIf cfg.enable
  
  {
    home.packages =
      let
        steam = pkgs.steam.override {
          extraEnv.HOME = "${config.home.homeDirectory}/.local/share/steam";
        };
      in
      [
        steam
        pkgs.prismlauncher
      ];
  };
}
